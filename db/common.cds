//Common.cds file for AssetManagement
namespace AssetManagement.common;

//defineing types to reuse in schema.cds multiple times
type str20 : String(20);
type str50 : String(50);
type str30 : String(30);
type str10 : String(10);
type str100: String(100);
type dec10 : Decimal(10, 2);

//enum for employee status attribute in employee entity
type employee_status : String(20) enum {
    active = 'Active';
    offboarding= 'Off-Boarding';
    resigned= 'Resigned'
};

//enum for asset status attribute in asset entity
type asset_status : String(20) enum {
    in_stock = 'In stock';
    assigned= 'Assigned';
    in_repair= 'In Repair';
    retired='Retired';
    archived= 'Archived';
};

//enum for ledger action attribute in OwnershipLedger entity
type ledger_action : String(20) enum {
    assign = 'Assign';
    reassign= 'Re-assign';
    return= 'Return';
    loan= 'Loan';
    retire= 'Retire';
    maintenance='Maintenance';
    archive= 'Archive';
};

//enum for disposal method attribute in Archive entity

type disposal_method : String(20) enum {
    recycle = 'Recycle';
    donate= 'Donate';
    sell= 'Sell';
    destroy= 'Destroy';
};

//enum for archive reason attribute in Archive entity

type  archive_reason : String(20) enum {
    end_of_life = 'End of Life';
    obsolete= 'Obsolete';
    beyond_repair= 'Beyond Repair';
    lost= 'Lost';
};

//enum for maintenance type attribute in MaintenanceRecord entity

type  maintenance_type : String(20) enum {
    repair = 'Repair';
    preventive= 'Preventive';
    upgrade= 'Upgrade';
    warranty_claim ='Warranty Claim';
    inspection= 'Inspection';
};

//enum for maintenance status attribute in MaintenanceRecord entity
type  maintenance_status : String(20) enum {
    open = 'Open';
    in_progress= 'In Progress';
    completed= 'Completed';
    cancelled= 'Cancelled';
};

//enum for maintenance outcome attribute in MaintenanceRecord entity
type  maintenance_outcome: String(20) enum {
    fixed = 'Fixed';
    part_replaced= 'Part Replaced';
    beyond_repair= 'Beyond Repair'
};

//createdAt aspect to reuse in any entity where createdAt attribute is required
aspect creation{
    createdAt: Timestamp;
}





