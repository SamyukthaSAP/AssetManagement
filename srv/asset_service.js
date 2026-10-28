//service.js for handling actions and functions
module.exports=cds.service.impl(async function () {
    const {
        EmployeeSrv,
        VendorSrv,
        AssetCategorySrv,  
        DepartmentSrv,  
        AssetSrv,
        OwnershipLedgerSrv,
        MaintenanceRecordSrv,
        ArchiveRecordSrv,
        AssetAssignmentSrv
    }=this.entities

    // this.on('whoAmI', req => {
    // return {
    //     user: req.user.id,
    //     roles: [...req.user.roles]
    // }
    // })

//     this.before('*', req => {
//   console.log('USER:', req.user.id);
//   console.log('ROLES:', req.user.roles);
// });

    //handler for KPI's
    this.on('getDashboardKPIs', async () => {

        const totalAssets = await SELECT.one.from(AssetSrv)
            .columns`count(*) as count`;

        const assignedAssets = await SELECT.one.from(AssetSrv)
            .where({ status: 'assigned' })
            .columns`count(*) as count`;

        const repairAssets = await SELECT.one.from(AssetSrv)
            .where({ status: 'in_repair' })
            .columns`count(*) as count`;

        const retiredAssets = await SELECT.one.from(AssetSrv)
            .where({ status: 'retired' })
            .columns`count(*) as count`;

        const archivedAssets = await SELECT.one.from(AssetSrv)
            .where({ status: 'archived' })
            .columns`count(*) as count`;

        const employees = await SELECT.one.from(EmployeeSrv).where({status: 'active'})
            .columns`count(*) as count`;

        const vendors = await SELECT.one.from(VendorSrv)
            .columns`count(*) as count`;
        const departments = await SELECT.one
    .from(DepartmentSrv)
    .columns`count(*) as count`;

        return {
            totalAssets: totalAssets.count,
            assignedAssets: assignedAssets.count,
            repairAssets: repairAssets.count,
            retiredAssets: retiredAssets.count,
            archivedAssets: archivedAssets.count,
            employees: employees.count,
            vendors: vendors.count,
            departments: departments.count
        };
    });

    //handler for department-asset chart
    //is in admindashboard.controller.js

    //calculating status critcality
    this.after('READ', AssetSrv, (data) => {

            const assets = Array.isArray(data) ? data : [data];

            for (const asset of assets) {

                switch (asset.status) {

                    case 'in_stock':
                        asset.statusCriticality = 3;
                        break;

                    case 'assigned':
                        asset.statusCriticality = 5;
                        break;

                    case 'in_repair':
                        asset.statusCriticality = 2;
                        break;

                    case 'retired':
                        asset.statusCriticality = 1;
                        break;

                    case 'archived':
                        asset.statusCriticality = 0;
                        break;
                }
            }
    });

    //Functional Requirement 01
    this.before('createAsset', async (req) => {

        const {
            asset_tag,
            serial_number,
            purchase_date,
            asset_category_asset_category_id
        } = req.data;

        // Mandatory fields
        if (!asset_tag) 
            req.error('Asset Tag is mandatory');

        if (!serial_number) 
            req.error('Serial Number is mandatory');

        if (!purchase_date)
            req.error('Purchase Date is mandatory');

        if (!asset_category_asset_category_id)
             req.error('Asset Category is mandatory');

        // Unique Asset Tag
        const assetTagExists = await SELECT.one.from(AssetSrv)
            .where({ asset_tag });

        if (assetTagExists)
            req.error('Asset Tag already exists');

        // Unique Serial Number
        const serialExists = await SELECT.one.from(AssetSrv)
            .where({ serial_number });

        if (serialExists)
            req.error('Serial Number already exists');

        // Initial Status
        req.data.status = 'in_stock';
    });

    //FR-003 and FR-004
    this.before('assignAsset', async (req) => {

        const { asset_asset_id, employee_employee_id ,
            assigned_date
        } = req.data;

        const asset = await SELECT.one.from(AssetSrv)
            .where({ asset_id: asset_asset_id });

        if (!asset)
            req.error('Asset not found');

        if (asset.status !== 'in_stock')
            req.error('Asset is not available');

        const employee = await SELECT.one.from(EmployeeSrv)
            .where({ employee_id: employee_employee_id });

        if (!employee)
            req.error('Employee not found');

        if (employee.status !== 'active')
            req.error('Employee is not active');

        if (assigned_date && asset.purchase_date) {

            const purchaseDate = new Date(asset.purchase_date);
            const assignedDate = new Date(assigned_date);

            if (assignedDate < purchaseDate) {
                req.error(
                    'Distribution Date cannot be earlier than Procurement Date'
                );
            }
        }
    });

    //what happens after assigning an asset
    this.after('assignAsset', async (data) => {

        await UPDATE(AssetSrv)
            .set({
                status: 'assigned',
                current_holder_id_employee_id: data.employee_employee_id
            })
            .where({ asset_id: data.asset_asset_id });

        await INSERT.into(OwnershipLedgerSrv).entries({
        asset_asset_id: data.asset_asset_id,
        action: 'assign',
        from_employee_id: null,
        to_employee_id: data.employee_employee_id,
        transition_date: data.assigned_date,
        notes: "The assest is Assigned to the Mentioned Employee"
        });

    });

    //FR-005
    this.on('transferAsset', async (req) => {

        const tx = cds.transaction(req);
        const { assetId, newEmployeeId, transferDate } = req.data;

        // Find active assignment
        const activeAssignment = await tx.run(SELECT.one
            .from(AssetAssignmentSrv)
            .where({
                asset_asset_id: assetId,
                assignment_status: 'Active'
            }));

        if (!activeAssignment) {
            req.error('No active assignment found');
        }

        // Close old assignment
        await tx.run( UPDATE(AssetAssignmentSrv)
            .set({
                assignment_status: 'Transferred',
                actual_return_date: transferDate
            })
            .where({ assignment_id: activeAssignment.assignment_id }));

        // Create new assignment
        await tx.run(
            INSERT.into(AssetAssignmentSrv).entries({
            asset_asset_id: assetId,
            employee_employee_id: newEmployeeId,
            assigned_date: transferDate,
            assignment_status: 'Active'
        }))

        // Update asset owner
        await tx.run(UPDATE(AssetSrv)
            .set({
                current_holder_id_employee_id: newEmployeeId
            })
            .where({ asset_id: assetId }));

        await tx.run( INSERT.into(OwnershipLedgerSrv)
        .entries({
            asset_asset_id: assetId,
            from_employee_id_employee_id: activeAssignment.employee_employee_id,
            to_employee_id_employee_id: newEmployeeId,
            action: 'reassign',
            transition_date: transferDate
        }));

    });

    //FR-006
    this.on('returnAsset', async (req) => {

        const { assetID, returnDate, remarks } = req.data;

        const tx = cds.transaction(req);

        // Find active assignment
        const assignment = await tx.run(
            SELECT.one.from(AssetAssignmentSrv)
                .where({
                    asset_asset_id: assetID,
                    assignment_status: 'Active'
                })
        );

        if (!assignment) {
            req.error('No active assignment found');
        }

        // Close assignment
        await tx.run(
            UPDATE(AssetAssignmentSrv)
                .set({
                    actual_return_date: returnDate,
                    assignment_status: 'Returned',
                    remarks: "The asset has been Returned"
                })
                .where({ assignment_id: assignment.assignment_id })
        );

        // Update asset
        await tx.run(
            UPDATE(AssetSrv)
                .set({
                    status: 'in_stock',
                    current_holder_id_employee_id: null
                })
                .where({ asset_id: assetID })
        );

        // Create ledger entry
        await tx.run(
            INSERT.into(OwnershipLedgerSrv).entries({
                asset_asset_id: assetID,
                from_employee_id_employee_id: assignment.employee_employee_id,
                to_employee_id_employee_id: null,
                action: 'return',
                transition_date: returnDate
            })
        );

        return {
            message: 'Asset returned successfully'
        };
    });

    //FR-007
    this.before('UPDATE', OwnershipLedgerSrv, req => {
        req.error('Ownership Ledger entries cannot be modified');
    });

    this.before('DELETE', OwnershipLedgerSrv, req => {
        req.error('Ownership Ledger entries cannot be deleted');
    });

    //FR-008
    this.before('createMaintenance', async (req) => {

        const asset = await SELECT.one
            .from(AssetSrv)
            .where({ asset_id: req.data.asset_asset_id });

        if (!asset) {
            return req.error('Asset not found');
        }

        if (asset.status === 'retired') {
            return req.error(
                'Retired assets cannot be sent for maintenance'
            );
        }

        if (asset.status === 'archived') {
            return req.error(
                'Archived assets cannot be sent for maintenance'
            );
        }

        if (asset.status === 'in_repair') {
            return req.error(
                'Asset is already under maintenance'
            );
        }
    });

    //after creating maintenance
    this.after('createMaintenance', async (data) => {

        await UPDATE(AssetSrv)
            .set({
                status: 'in_repair'
            })
            .where({
                asset_id: data.asset_asset_id
            });

        await INSERT.into(OwnershipLedgerSrv).entries({
            asset_asset_id: data.asset_asset_id,
            action: 'maintenance',
            transition_date: new Date()
        });
    });

    //FR-009
    this.after('updateMaintenance', async (req) => {

        if (req.data.status !== 'completed') {
            return;
        }

        const maintenance = await SELECT.one
            .from(MaintenanceRecordsSrv)
            .where({ maintenance_id: req.data.maintenance_id });

        if (!maintenance) {
            return req.error('Maintenance record not found');
        }

        await UPDATE(AssetSrv)
            .set({
                status: 'in_stock'
            })
            .where({
                asset_id: maintenance.asset_asset_id
            });
    });

    //FR-010
    this.on('retireAsset', async (req) => {

    const {
        assetId,
        reason,
        retirementDate
    } = req.data;

    const asset = await SELECT.one
        .from(AssetSrv)
        .where({ asset_id: assetId });

    if (!asset) {
        return req.error('Asset not found');
    }

    // FR-010
        if (asset.status === 'assigned' || asset.status === 'in_repair') {
            return req.error(
                'Assigned assets cannot be retired. Return the asset first.'
            );
        }

        if (asset.status === 'retired') {
            return req.error(
                'Asset is already retired'
            );
        }

        if (asset.status === 'archived') {
            return req.error(
                'Archived asset cannot be retired'
            );
        }

        if (!reason) {
            return req.error(
                'Retirement reason is mandatory'
            );
        }

        if (!retirementDate) {
            return req.error(
                'Retirement date is mandatory'
            );
        }

        await UPDATE(AssetSrv)
            .set({
                status: 'retired'
            })
            .where({
                asset_id: assetId
            });

        await INSERT.into(OwnershipLedgerSrv).entries({
            asset_asset_id: assetId,
            action: 'retire',
            transition_date: retirementDate,
            notes: 'Asset has been retired'
        });

        return 'Asset retired successfully';
    });

    //FR-011
    this.before('createArchive', async (req) => {
        const asset = await SELECT.one
            .from(AssetSrv)
            .where({ asset_id: req.data.asset_asset_id });

        if (!asset) {
            return req.error('Asset not found');
        }

        // FR-012
        if (asset.status === 'assigned') {
            return req.error(
                'Assigned assets cannot be archived. Return asset first.'
            );
        }

        // FR-011
        if (asset.status !== 'retired') {
            return req.error(
                'Only retired assets can be archived'
            );
        }
    });

    //after creating an archive
    this.after('createArchive', async (data) => {
        await UPDATE(AssetSrv)
            .set({
                status: 'archived'
            })
            .where({
                asset_id: data.asset_asset_id
            });

        await INSERT.into(OwnershipLedgerSrv).entries({
            asset_asset_id: data.asset_asset_id,
            action: 'archive',
            transition_date: new Date()
        });
    });

    //Validation for deleting Departments
    this.before("deleteDepartment",async(request,response)=>{
        const { dept_id } = request.data;
        const employees = await SELECT.one
                    .from(EmployeeSrv)
                    .where({dept_dept_id: dept_id});

        if(employees){
        request.error(
            'Department assigned to employees'
        );
        }
    })

    //Employee CRUD
    this.on("addEmployee",async (request,response)=>{
        const data=request.data;
        const objtxn=cds.tx(request);
        const returndata=await objtxn.run([
            INSERT.into(EmployeeSrv).entries(data)
        ]).then((resolve,reject)=>{
            if(typeof(resolve!==undefined))
            {
                return request.data;
            }
            else{
                request.error("Error in inserting data");
            }
        }).catch((err)=>{
            request.error("There is an error:",err.toString());
        });
        return returndata;
    })

    this.on('editEmployee',async(request,response)=>{
        const {
            employee_id,
        full_name,
        email,
        phone,
        location,
        status,
        dept_dept_id
        } = request.data;
        try {
            const objTransaction=cds.tx(request);
            await objTransaction.update(EmployeeSrv).with({
                full_name: full_name,
        email: email,
        phone: phone,
        location: location,
        status: status,
        dept_dept_id: dept_dept_id
            }).where({
                employee_id:  employee_id
            })
            return "Successfully updated";
        } catch(error){
            request.error("Error:",error)
        }
    })

    this.on("deleteEmployee",async (request,response)=>{
        const {employee_id}=request.data;
        try{
            const objtx=cds.tx(request);
            await objtx.delete(EmployeeSrv).where({
                employee_id: employee_id
            });
            return "Successfully Deleted";
        }
        catch(error){
            request.error("there is error",error);
        }
    })

    //Asset CRUD
    this.on("createAsset",async (request,response)=>{
        const data=request.data;
        const objtxn=cds.tx(request);
        const returndata=await objtxn.run([
            INSERT.into(AssetSrv).entries(data)
        ]).then((resolve,reject)=>{
            if(typeof(resolve!==undefined))
            {
                return request.data;
            }
            else{
                request.error("Error in inserting data");
            }
        }).catch((err)=>{
            request.error("There is an error:",err.toString());
        });
        return returndata;
    })

    this.on('updateAsset',async(request,response)=>{
        const {
            asset_id ,
        asset_tag,
        serial_number,
        model,
        purchase_date,
        purchase_cost,
        warranty_expiry,
        first_distribution_date,
        status,
        asset_category_asset_category_id,
        vendor_vendor_id,
        current_holder_id_employee_id
        } = request.data;
        try {
            const objTransaction=cds.tx(request);
            await objTransaction.update(AssetSrv).with({
                asset_id : asset_id,
                asset_tag: asset_tag ,
                serial_number: serial_number,
                model: model,
                purchase_date: purchase_date,
        purchase_cost: purchase_cost,
        warranty_expiry: warranty_expiry,
        first_distribution_date: first_distribution_date,
        status: status,
        asset_category_asset_category_id: asset_category_asset_category_id,
        vendor_vendor_id: vendor_vendor_id,
        current_holder_id_employee_id: current_holder_id_employee_id
            }).where({
                asset_id:  asset_id
            })
            return "Successfully updated";
        } catch(error){
            request.error("Error:",error)
        }
    })

    this.on("deleteAsset",async (request,response)=>{
        const {asset_id}=request.data;
        try{
            const objtx=cds.tx(request);
            await objtx.delete(AssetSrv).where({
                asset_id: asset_id
            });
            return "Successfully Deleted";
        }
        catch(error){
            request.error("there is error",error);
        }
    })

    //Vendors CRUD
    this.on("addVendor",async (request,response)=>{
        const data=request.data;
        const objtxn=cds.tx(request);
        const returndata=await objtxn.run([
            INSERT.into(VendorSrv).entries(data)
        ]).then((resolve,reject)=>{
            if(typeof(resolve!==undefined))
            {
                return request.data;
            }
            else{
                request.error("Error in inserting data");
            }
        }).catch((err)=>{
            request.error("There is an error:",err.toString());
        });
        return returndata;
    })

    this.on('updateVendor',async(request,response)=>{
        const {
            vendor_id,
        name,
        email,
        phone
        } = request.data;
        try {
            const objTransaction=cds.tx(request);
            await objTransaction.update(VendorSrv).with({
        name: name ,
        email: email,
        phone: phone
            }).where({
               vendor_id: vendor_id,
            })
            return "Successfully updated";
        } catch(error){
            request.error("Error:",error)
        }
    })

    this.on("deleteVendor",async (request,response)=>{
        const {vendor_id}=request.data;
        try{
            const objtx=cds.tx(request);
            await objtx.delete(VendorSrv).where({
                vendor_id: vendor_id
            });
            return "Successfully Deleted";
        }
        catch(error){
            request.error("there is error",error);
        }
    })

    //AssetCategory CRUD
    this.on("addAssetCategory",async (request,response)=>{
        const data=request.data;
        const objtxn=cds.tx(request);
        const returndata=await objtxn.run([
            INSERT.into(AssetCategorySrv).entries(data)
        ]).then((resolve,reject)=>{
            if(typeof(resolve!==undefined))
            {
                return request.data;
            }
            else{
                request.error("Error in inserting data");
            }
        }).catch((err)=>{
            request.error("There is an error:",err.toString());
        });
        return returndata;
    })

    this.on('updateAssetCategory',async(request,response)=>{
        const {
            asset_category_id,
        name,
        lifespan_months
        } = request.data;
        try {
            const objTransaction=cds.tx(request);
            await objTransaction.update(AssetCategorySrv).with({
                asset_category_id: asset_category_id,
        name: name,
        lifespan_months: lifespan_months,
            }).where({
               asset_category_id: asset_category_id
            })
            return "Successfully updated";
        } catch(error){
            request.error("Error:",error)
        }
    })

    this.on("deleteAssetCategory",async (request,response)=>{
        const {asset_category_id}=request.data;
        try{
            const objtx=cds.tx(request);
            await objtx.delete(AssetCategorySrv).where({
                asset_category_id: asset_category_id
            });
            return "Successfully Deleted";
        }
        catch(error){
            request.error("there is error",error);
        }
    })

    //Department CRUD
    this.on("addDepartment",async (request,response)=>{
        const data=request.data;
        const objtxn=cds.tx(request);
        const returndata=await objtxn.run([
            INSERT.into(DepartmentSrv).entries(data)
        ]).then((resolve,reject)=>{
            if(typeof(resolve!==undefined))
            {
                return request.data;
            }
            else{
                request.error("Error in inserting data");
            }
        }).catch((err)=>{
            request.error("There is an error:",err.toString());
        });
        return returndata;
    })

    this.on('updateDepartment',async(request,response)=>{
        const {
            dept_id,
        name,
        cost_center
        } = request.data;
        try {
            const objTransaction=cds.tx(request);
            await objTransaction.update(DepartmentSrv).with({
                dept_id: dept_id,
        name: name,
        cost_center: cost_center
            }).where({
               dept_id: dept_id
            })
            return "Successfully updated";
        } catch(error){
            request.error("Error:",error)
        }
    })

    this.on("deleteDepartment",async (request,response)=>{
        const {dept_id}=request.data;
        try{
            const objtx=cds.tx(request);
            await objtx.delete(DepartmentSrv).where({
                dept_id: dept_id
            });
            return "Successfully Deleted";
        }
        catch(error){
            request.error("there is error",error);
        }
    })

    //Crud for Asset Assignment
    this.on("assignAsset",async (request,response)=>{
        const data=request.data;
        const objtxn=cds.tx(request);
        const returndata=await objtxn.run([
            INSERT.into(AssetAssignmentSrv).entries(data)
        ]).then((resolve,reject)=>{
            if(typeof(resolve!==undefined))
            {
                return request.data;
            }
            else{
                request.error("Error in inserting data");
            }
        }).catch((err)=>{
            request.error("There is an error:",err.toString());
        });
        return returndata;
    })

    //CRUD for Maintenance
    this.on("createMaintenance",async (request,response)=>{
        const data=request.data;
        const objtxn=cds.tx(request);
        const returndata=await objtxn.run([
            INSERT.into(MaintenanceRecordsSrv).entries(data)
        ]).then((resolve,reject)=>{
            if(typeof(resolve!==undefined))
            {
                return request.data;
            }
            else{
                request.error("Error in inserting data");
            }
        }).catch((err)=>{
            request.error("There is an error:",err.toString());
        });
        return returndata;
    })
    this.on('updateMaintenance',async(request,response)=>{
        const {
            maintenance_id,
            type,
            reported_date,
            completed_date,
            status,
            outcome,
            cost,
            covered_by_warranty,
            next_due_date,
            description,
            asset_asset_id,
            reported_by_employee_id,
            service_vendor_id
        } = request.data;
        try {
            const objTransaction=cds.tx(request);
            await objTransaction.update(MaintenanceRecordsSrv).with({
                type: type,
                reported_date: reported_date,
                completed_date: completed_date,
                status: status,
                outcome: outcome,
                cost: cost,
                covered_by_warranty: covered_by_warranty,
                next_due_date: next_due_date,
                description: description,
                asset_asset_id: asset_asset_id,
                reported_by_employee_id: reported_by_employee_id,
                service_vendor_id: service_vendor_id
            }).where({
               maintenance_id: maintenance_id
            })
            return "Successfully updated";
        } catch(error){
            request.error("Error:",error)
        }
    })

    //CRUD for archive
    this.on("createArchive",async (request,response)=>{
        const data=request.data;
        const objtxn=cds.tx(request);
        const returndata=await objtxn.run([
            INSERT.into(ArchiveRecordsSrv).entries(data)
        ]).then((resolve,reject)=>{
            if(typeof(resolve!==undefined))
            {
                return request.data;
            }
            else{
                request.error("Error in inserting data");
            }
        }).catch((err)=>{
            request.error("There is an error:",err.toString());
        });
        return returndata;
    })
})