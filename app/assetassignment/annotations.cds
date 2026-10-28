using AssetAdminService as service from '../../srv/asset_service';
annotate AssetAdminService.AssetAssignmentSrv with {
    asset @Common.Label : 'Asset ID';
    employee @Common.Label : 'Employee Name';
    assignment_status @Common.Label : 'Status';
    assigned_date @Common.Label : 'Assigned Date'
};
annotate service.AssetAssignmentSrv with {
    asset @Common.Text : asset.asset_tag;
    employee @Common.Text : employee.full_name;
    assigned_by @Common.Text : assigned_by.full_name;
};
annotate service.AssetAssignmentSrv with @(
    UI.SelectionFields : [
        asset_asset_id,
        employee_employee_id,
        assignment_status,
        assigned_date
    ],
    UI.HeaderInfo : {
        TypeName : 'Asset Assignment',
        TypeNamePlural : 'Asset Assignments',
        Title : {
            Value : employee.full_name
        },
        Description : {
            Value : asset.asset_tag
        }
    },
    UI.FieldGroup #GeneratedGroup : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Label : 'Assigned Date',
                Value : assigned_date,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Expected Return Date',
                Value : expected_return_date,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Actual Return Date',
                Value : actual_return_date,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Assignment Status',
                Value : assignment_status,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Remarks',
                Value : remarks,
            },
        ],
    },
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'GeneratedFacet1',
            Label : 'General Information',
            Target : '@UI.FieldGroup#GeneratedGroup',
        },
    ],
);

annotate service.AssetAssignmentSrv with {
    assignment_status @UI.Criticality : assignmentCriticality;
};
annotate service.AssetAssignmentSrv with {
    asset @Common.ValueList : {
        $Type : 'Common.ValueListType',
        CollectionPath : 'AssetSrv',
        Parameters : [
            {
                $Type : 'Common.ValueListParameterInOut',
                LocalDataProperty : asset_asset_id,
                ValueListProperty : 'asset_id',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'asset_tag',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'serial_number',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'model',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'purchase_date',
            },
        ],
    }
};

annotate service.AssetAssignmentSrv with {
    employee @Common.ValueList : {
        $Type : 'Common.ValueListType',
        CollectionPath : 'EmployeeSrv',
        Parameters : [
            {
                $Type : 'Common.ValueListParameterInOut',
                LocalDataProperty : employee_employee_id,
                ValueListProperty : 'employee_id',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'full_name',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'email',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'phone',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'location',
            },
        ],
    }
};

annotate service.AssetAssignmentSrv with {
    assigned_by @Common.ValueList : {
        $Type : 'Common.ValueListType',
        CollectionPath : 'EmployeeSrv',
        Parameters : [
            {
                $Type : 'Common.ValueListParameterInOut',
                LocalDataProperty : assigned_by_employee_id,
                ValueListProperty : 'employee_id',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'full_name',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'email',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'phone',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'location',
            },
        ],
    }
};

