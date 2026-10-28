//schema.cds file for AssetManagement for designing data model
namespace AssetManagement.db;

//using types, enums and aspects from common.cds
using { AssetManagement.common as common } from './common';

//master data grouping
context master {

    //Employees Entity
    entity Employees {
        key employee_id: UUID;
        full_name: common.str100;
        email: common.str100;
        phone: common.str20;
        location: common.str100;
        status: common.employee_status; //enum
        
        //Associations to Departments, Assets, OwnershipLedger, Archive, Maintenace, AssetAssignment Entities
        dept: Association to one Departments;
        asset: Association to many Assets on asset.current_holder_id=$self;
        ownership_from: Association to many transactional.OwnershipLedgers on ownership_from.from_employee_id=$self;
        ownership_to: Association to many transactional.OwnershipLedgers on ownership_to.to_employee_id=$self;
        ownership_rec: Association to many transactional.OwnershipLedgers on ownership_rec.recorded_by=$self;
        archived: Association to many transactional.ArchiveRecords on archived.archived_by= $self;
        maintenance: Association to many transactional.MaintenanceRecords on maintenance.reported_by=$self;
        assignments : Association to many transactional.AssetAssignments on assignments.employee = $self;
    }

    //Vendors Entity
    entity Vendors {
        key vendor_id: UUID;
        name: common.str100;
        email: common.str100;
        phone: common.str20;

        //Associations to Asset and MaintenaceRecord Entity
        asset: Association to many Assets on asset.vendor=$self;
        maintenance: Association to many transactional.MaintenanceRecords on maintenance.service=$self;
    }

    //AssetCategory Entity
    entity AssetCategories{
        key asset_category_id: UUID;
        name: common.str50;
        lifespan_months: Int64;

        //Associations to Assets Entity
        asset: Association to many Assets on asset.asset_category=$self; 
    }

    //Assets Entity
    entity Assets {
        key asset_id : UUID;

        //Asset Tag must be unique
        @assert.unique
        asset_tag: common.str20;

        //Serial numbers must be unique
        @assert.unique
        serial_number: common.str50;

        model: common.str100;
        purchase_date: Date;
        purchase_cost: common.dec10;
        warranty_expiry: Date;
        first_distribution_date: Date;
        status: common.asset_status; //enum
        //color coding for staus crticality in Assets List/Object report page
        statusCriticality : Integer @Core.Computed;

        //Associations to AssetCategorys, Vendors, Employees
        asset_category: Association to one AssetCategories;
        vendor: Association to one Vendors;
        current_holder_id: Association to one Employees;

        //Associations to OwnershipLedger, Archive, Maintenace, AssetAssignment Entities
        ownership: Association to many transactional.OwnershipLedgers on ownership.asset=$self;
        archive : Association to one transactional.ArchiveRecords on archive.asset = $self;
        maintenance: Association to many transactional.MaintenanceRecords on maintenance.asset=$self;
        assignments : Association to many transactional.AssetAssignments on assignments.asset = $self;
    }

    //Departments Entity
    entity Departments {
        key dept_id: UUID;
        name: String(80);
        cost_center: common.str20;

        //Associations to Employees Entity
        employee: Association to many Employees on employee.dept=$self;
    }
}

//Transactional entities grouping
context transactional {
    //OwnershipLedgers Entity
    entity OwnershipLedgers : common.creation {
        key ledger_id: UUID;
        action: common.ledger_action; //enum
        transition_date: Date;
        notes: String(255);

        //Associations to Employees, Assets Entities
        from_employee_id: Association to one master.Employees;
        to_employee_id: Association to one master.Employees;
        recorded_by: Association to one master.Employees;
        asset: Association to one master.Assets; 
    }

    //ArchiveRecords Entity
    entity ArchiveRecords {
        key archive_id: UUID;
        archived_at: Timestamp;
        reason: common.archive_reason; //enum
        disposal_method: common.disposal_method; //enum
        disposal_cert_no: String(40);

        //Associations to Employees, Assets Entities
        archived_by: Association to one master.Employees;
        asset: Association to one master.Assets;
    }

    //MaintenanceRecords Entity
    entity MaintenanceRecords {
        key maintenance_id: UUID;
        type: common.maintenance_type; //enum
        reported_date: Date;
        completed_date: Date;
        status:  common.maintenance_status; //enum
        outcome: common.maintenance_outcome; //enum
        cost: common.dec10;
        covered_by_warranty: Boolean;
        next_due_date: Date;
        description: String(255);

        //color coding for staus crticality in Maintenance List/Object report page
        maintenanceCriticality : Integer @Core.Computed;

        //Associations to Employees, Assets,Vendors Entities
        asset: Association to one master.Assets;
        reported_by: Association to one master.Employees;
        service: Association to one master.Vendors;
    }

    //AssetAsignments Entity
    entity AssetAssignments {
        key assignment_id: UUID;
        assigned_date: Timestamp;
        expected_return_date: Date;
        actual_return_date: Date;
        assignment_status: common.str20;
        remarks: String(255);

        //color coding for staus crticality in AssetAssignment List/Object report page
        assignmentCriticality : Integer @Core.Computed;

        //Associations to Employees, Assets Entities
        asset: Association to one master.Assets;
        employee: Association to one master.Employees;
        assigned_by: Association to one master.Employees;
    }
}