namespace AssetManagement.db;

using { AssetManagement.common as common } from './common';


context master {
    entity Employees {
        key employee_id: UUID;
        full_name: common.str100;
        email: common.str100;
        phone: common.str20;
        location: common.str100;
        status: common.employee_status;
        
        dept: Association to one Departments;
        asset: Association to many Assets on asset.current_holder_id=$self;
        ownership_from: Association to many transactional.OwnershipLedgers on ownership_from.from_employee_id=$self;
        ownership_to: Association to many transactional.OwnershipLedgers on ownership_to.to_employee_id=$self;
        ownership_rec: Association to many transactional.OwnershipLedgers on ownership_rec.recorded_by=$self;
        archived: Association to many transactional.ArchiveRecords on archived.archived_by= $self;
        maintenance: Association to many transactional.MaintenanceRecords on maintenance.reported_by=$self;
        assignments : Association to many transactional.AssetAssignments on assignments.employee = $self;
    }

    entity Vendors {
        key vendor_id: UUID;
        name: common.str100;
        email: common.str100;
        phone: common.str20;

        asset: Association to many Assets on asset.vendor=$self;
        maintenance: Association to many transactional.MaintenanceRecords on maintenance.service=$self;
    }

    entity AssetCategories{
        key asset_category_id: UUID;
        name: common.str50;
        lifespan_months: Int64;

        asset: Association to many Assets on asset.asset_category=$self; 
    }
    entity Assets {
        key asset_id : UUID;
        
        @assert.unique
        asset_tag: common.str20;

        @assert.unique
        serial_number: common.str50;

        model: common.str100;
        purchase_date: Date;
        purchase_cost: common.dec10;
        warranty_expiry: Date;
        first_distribution_date: Date;
        status: common.asset_status;
        asset_category: Association to one AssetCategories;
        vendor: Association to one Vendors;
        current_holder_id: Association to one Employees;
        statusCriticality : Integer @Core.Computed;

        ownership: Association to many transactional.OwnershipLedgers on ownership.asset=$self;
        archive : Association to one transactional.ArchiveRecords on archive.asset = $self;
        maintenance: Association to many transactional.MaintenanceRecords on maintenance.asset=$self;
        assignments : Association to many transactional.AssetAssignments on assignments.asset = $self;
    }

    entity Departments {
        key dept_id: UUID;
        name: String(80);
        cost_center: common.str20;

        employee: Association to many Employees on employee.dept=$self;
    }
}

context transactional {
    entity OwnershipLedgers : common.creation {
        key ledger_id: UUID;
        action: common.ledger_action;
        transition_date: Date;
        notes: String(255);

        from_employee_id: Association to one master.Employees;
        to_employee_id: Association to one master.Employees;
        recorded_by: Association to one master.Employees;
        asset: Association to one master.Assets; 
    }
    entity ArchiveRecords {
        key archive_id: UUID;
        archived_at: Timestamp;
        reason: common.archive_reason;
        disposal_method: common.disposal_method;
        disposal_cert_no: String(40);

        archived_by: Association to one master.Employees;
        asset: Association to one master.Assets;
    }

    entity MaintenanceRecords {
        key maintenance_id: UUID;
        type: common.maintenance_type;
        reported_date: Date;
        completed_date: Date;
        status:  common.maintenance_status;
        outcome: common.maintenance_outcome;
        cost: common.dec10;
        covered_by_warranty: Boolean;
        next_due_date: Date;
        description: String(255);

        maintenanceCriticality : Integer @Core.Computed;

        asset: Association to one master.Assets;
        reported_by: Association to one master.Employees;
        service: Association to one master.Vendors;
    }

    entity AssetAssignments {
        key assignment_id: UUID;
        assigned_date: Timestamp;
        expected_return_date: Date;
        actual_return_date: Date;
        assignment_status: common.str20;
        remarks: String(255);

        assignmentCriticality : Integer @Core.Computed;

        asset: Association to one master.Assets;
        employee: Association to one master.Employees;
        assigned_by: Association to one master.Employees;
    }
}