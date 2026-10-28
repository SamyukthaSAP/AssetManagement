//Using data models from schema.cds and common.cds 
using { AssetManagement.db as database } from '/home/user/projects/AssetManagement/db/schema.cds';
using { AssetManagement.common as common } from '../db/common';

//Services for Admin specific roles
service AssetAdminService @(requires:'Admin') {

    entity EmployeeSrv as projection on database.master.Employees;
    entity VendorSrv as projection on database.master.Vendors;
    entity AssetCategorySrv as projection on database.master.AssetCategories;
    entity DepartmentSrv as projection on database.master.Departments;
    entity AssetSrv as projection on database.master.Assets;

    entity OwnershipLedgerSrv as projection on database.transactional.OwnershipLedgers;
    entity MaintenanceRecordSrv as projection on database.transactional.MaintenanceRecords;
    entity ArchiveRecordSrv as projection on database.transactional.ArchiveRecords;
    entity AssetAssignmentSrv as projection on database.transactional.AssetAssignments;

    //Dashboard kpi's
    type DashboardKPI {
    totalAssets      : Integer;
    assignedAssets   : Integer;
    repairAssets     : Integer;
    retiredAssets    : Integer;
    archivedAssets   : Integer;
    employees        : Integer;
    vendors          : Integer;
    departments      :  Integer;
}
    //KPI - actions
    action getDashboardKPIs() returns DashboardKPI;
    
    //Department chart vs Asset
    type DepartmentChart {
    department : String;
    count      : Integer;
}

//action to fetch assets by dept
action getAssetsByDepartment() returns array of DepartmentChart;

//action whoAmI() returns String;

//Downloading and emailing options
    action exportReportToPDF(
        reportType : String,
        filters : String
    )
    returns LargeString;

    action emailReport(
        reportType : String,
        recipients : String,
        filters : String
    )
    returns String;

    // lifecycle actions

    //AssigningAsset
    action assignAsset(
        assignment_id: UUID,
        assigned_date: Timestamp,
        expected_return_date: Date,
        actual_return_date: Date,
        assignment_status: common.str20,
        remarks: String(255),
        asset_asset_id: UUID,
        employee_employee_id: UUID,
        assigned_by_employee_id: UUID
    )returns array of AssetAssignmentSrv;

    //To transfer Assets
    action transferAsset(
        assetId : UUID,
        newEmployeeId : UUID,
        transferDate : Date
    )returns String;

    //to return Asset
    action returnAsset(
        assetID : UUID,
        returnDate : Date,
        remarks : String
    )returns String;

    //To retire asset
    action retireAsset(
        assetId : UUID,
        reason  : String,
        retirementDate : Date
    ) returns String;


    // master data actions

    //employee actions
    action addEmployee(
        employee_id: UUID,
        full_name: common.str100,
        email: common.str100,
        phone: common.str20,
        location: common.str100,
        status: common.employee_status,
        dept_dept_id: UUID
    )returns array of EmployeeSrv;

    action editEmployee(
        employee_id: UUID,
        full_name: common.str100,
        email: common.str100,
        phone: common.str20,
        location: common.str100,
        status: common.employee_status,
        dept_dept_id: UUID
    )returns String;

    action deleteEmployee(
        employee_id: UUID
    )returns String;

    //Asset Actions
    action createAsset(
        asset_id : UUID,
        asset_tag: common.str20,
        serial_number: common.str50,
        model: common.str100,
        purchase_date: Date,
        purchase_cost: common.dec10,
        warranty_expiry: Date,
        first_distribution_date: Date,
        status: common.asset_status,
        asset_category_asset_category_id: UUID,
        vendor_vendor_id: UUID,
        current_holder_id_employee_id: UUID
    )returns array of AssetSrv;

    action updateAsset(
        asset_id : UUID,
        asset_tag: common.str20,
        serial_number: common.str50,
        model: common.str100,
        purchase_date: Date,
        purchase_cost: common.dec10,
        warranty_expiry: Date,
        first_distribution_date: Date,
        status: common.asset_status,
        asset_category_asset_category_id: UUID,
        vendor_vendor_id: UUID,
        current_holder_id_employee_id: UUID
    )returns String;

    action deleteAsset(
        asset_id : UUID
    )returns String;

    //Vendors Actions
    action addVendor(
        vendor_id: UUID,
        name: common.str100,
        email: common.str100,
        phone: common.str20
    )returns array of VendorSrv;

    action updateVendor(
        vendor_id: UUID,
        name: common.str100,
        email: common.str100,
        phone: common.str20
    )returns String;

    action deleteVendor(
        vendor_id : UUID
    )returns String;

    //AssetCategory Actions
    action addAssetCategory(
        asset_category_id: UUID,
        name: common.str50,
        lifespan_months: Int64
    )returns array of AssetCategorySrv;

    action updateAssetCategory(
        asset_category_id: UUID,
        name: common.str50,
        lifespan_months: Int64
    )returns String;

    action deleteAssetCategory(
        asset_category_id: UUID
    )returns String;

    //Department Actions
    action addDepartment(
        dept_id: UUID,
        name: String(80),
        cost_center: common.str20
    )returns array of DepartmentSrv;

    action updateDepartment(
        dept_id: UUID,
        name: String(80),
        cost_center: common.str20
    )returns String;

    action deleteDepartment(
        dept_id: UUID
    )returns String;

    //Maintenance Actions
    action createMaintenance(
        maintenance_id: UUID,
        type: common.maintenance_type,
        reported_date: Date,
        completed_date: Date,
        status:  common.maintenance_status,
        outcome: common.maintenance_outcome,
        cost: common.dec10,
        covered_by_warranty: Boolean,
        next_due_date: Date,
        description: String(255),
        asset_asset_id: UUID,
        reported_by_employee_id:  UUID,
        service_vendor_id: UUID
    )returns array of MaintenanceRecordSrv;

    action updateMaintenance(
        maintenance_id: UUID,
        type: common.maintenance_type,
        reported_date: Date,
        completed_date: Date,
        status:  common.maintenance_status,
        outcome: common.maintenance_outcome,
        cost: common.dec10,
        covered_by_warranty: Boolean,
        next_due_date: Date,
        description: String(255),
        asset_asset_id: UUID,
        reported_by_employee_id:  UUID,
        service_vendor_id: UUID
    )returns array of MaintenanceRecordSrv;

    //Archive Actions
    action createArchive(
        archive_id: UUID,
        archived_at: Timestamp,
        reason: common.archive_reason,
        disposal_method: common.disposal_method,
        disposal_cert_no: String(40),
        archived_by_employee_id: UUID,
        asset_asset_id: UUID
    )returns array of ArchiveRecordSrv;
}

//Services for User specific roles(Mostly read only)
service AssetUserService @(requires:'User') {

    entity AssetSrv as projection on database.master.Assets;
    entity AssetAssignmentSrv as projection on database.transactional.AssetAssignments;
    entity OwnershipLedgerSrv as projection on database.transactional.OwnershipLedgers;
}

//Services for Manager specific roles
service AssetManagerService @(requires:'Manager') {

    entity AssetSrv as projection on database.master.Assets;
    entity EmployeeSrv as projection on database.master.Employees;
    entity DepartmentSrv as projection on database.master.Departments;

    entity AssetAssignmentSrv as projection on database.transactional.AssetAssignments;
    entity OwnershipLedgerSrv as projection on database.transactional.OwnershipLedgers;
    entity MaintenanceRecordSrv as projection on database.transactional.MaintenanceRecords;

    //Kpi's
    action getDashboardKPIs() returns String;

    action exportReportToPDF(
        reportType : String,
        filters : String
    ) returns LargeString;

    action emailReport(
        reportType : String,
        recipients : String,
        filters : String
    ) returns String;
}