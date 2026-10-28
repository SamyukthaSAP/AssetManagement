using AssetAdminService as service from '../../srv/asset_service';
annotate AssetAdminService.OwnershipLedgerSrv with {
    action @Common.Label : 'Action';
    transition_date @Common.Label : 'Transition Date';
    asset @Common.Label : 'Asset Tag';
    recorded_by @Common.Label : 'Recorded By';
};
annotate service.OwnershipLedgerSrv with @(
    UI.SelectionFields : [
        action,
        transition_date,
        asset_asset_id,
        recorded_by_employee_id
    ],
    UI.HeaderInfo : {
        TypeName : 'Ownership Ledger',
        TypeNamePlural : 'Ownership Ledgers',
        Title : {
            Value : asset.asset_tag
        },
        Description : {
            Value : action
        }
    },
    UI.FieldGroup #LedgerInfo : {
        Data : [
            {
                $Type : 'UI.DataField',
                Label : 'Action',
                Value : action
            },
            {
                $Type : 'UI.DataField',
                Label : 'Transition Date',
                Value : transition_date
            },
            {
                $Type : 'UI.DataField',
                Label : 'Notes',
                Value : notes
            },
            {
                $Type : 'UI.DataField',
                Label : 'Created At',
                Value : createdAt,
            },
        ]
    },
    UI.FieldGroup #EmployeeInfo : {
        Data : [
            {
                $Type : 'UI.DataField',
                Value : from_employee_id.full_name,
                Label : 'From Employee'
            },
            {
                $Type : 'UI.DataField',
                Label : 'To Employee',
                Value : to_employee_id.full_name
            },
            {
                $Type : 'UI.DataField',
                Label : 'Recorded By',
                Value : recorded_by.full_name
            }
        ]
    },
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Ledger Information',
            Target : '@UI.FieldGroup#LedgerInfo'
        },
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Employee Information',
            Target : '@UI.FieldGroup#EmployeeInfo'
        }
    ],
);

annotate service.OwnershipLedgerSrv with @(
    Capabilities.InsertRestrictions : {
        Insertable : false
    },
    Capabilities.UpdateRestrictions : {
        Updatable : false
    },
    Capabilities.DeleteRestrictions : {
        Deletable : false
    }
);

annotate service.OwnershipLedgerSrv with {
    from_employee_id @Common.ValueList : {
        $Type : 'Common.ValueListType',
        CollectionPath : 'EmployeeSrv',
        Parameters : [
            {
                $Type : 'Common.ValueListParameterInOut',
                LocalDataProperty : from_employee_id_employee_id,
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

annotate service.OwnershipLedgerSrv with {
    to_employee_id @Common.ValueList : {
        $Type : 'Common.ValueListType',
        CollectionPath : 'EmployeeSrv',
        Parameters : [
            {
                $Type : 'Common.ValueListParameterInOut',
                LocalDataProperty : to_employee_id_employee_id,
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

annotate service.OwnershipLedgerSrv with {
    recorded_by @Common.ValueList : {
        $Type : 'Common.ValueListType',
        CollectionPath : 'EmployeeSrv',
        Parameters : [
            {
                $Type : 'Common.ValueListParameterInOut',
                LocalDataProperty : recorded_by_employee_id,
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

annotate service.OwnershipLedgerSrv with {
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
annotate service.OwnershipLedgerSrv with @(
    UI.PresentationVariant : {
        SortOrder : [
            {
                Property : transition_date,
                Descending : true
            }
        ]
    }
);
annotate service.OwnershipLedgerSrv with {
    asset @Common.Text : asset.asset_tag;

    from_employee_id @Common.Text : from_employee_id.full_name;

    to_employee_id @Common.Text : to_employee_id.full_name;

    recorded_by @Common.Text : recorded_by.full_name;
};

