using AssetAdminService as service from '../../srv/asset_service';
annotate AssetAdminService.MaintenanceRecordSrv with {
    asset @Common.Label : 'Asset ID';
    reported_by @Common.Label : 'Reported By';
    service @Common.Label : 'Vendor';
    type @Common.Label : 'Maintenance Type';
    status @Common.Label : 'Maintenance Status';
    reported_date @Common.Label : 'Reported Date';
};
annotate service.MaintenanceRecordSrv with @(
    UI.HeaderInfo : {
        TypeName : 'Maintenance Record',
        TypeNamePlural : 'Maintenance Records',
        Title : {
            Value : asset.asset_tag
        },
        Description : {
            Value : status
        }
    },
    UI.SelectionFields : [
        asset_asset_id,
        reported_by_employee_id,
        service_vendor_id,
        type,
        status,
        reported_date
    ],
    UI.FieldGroup #GeneratedGroup : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
            $Type : 'UI.DataField',
            Value : asset.asset_tag,
            Label : 'Asset'
        },
        {
            $Type : 'UI.DataField',
            Value : status,
            Label : 'Status'
        },
            {
                $Type : 'UI.DataField',
                Label : 'Maintenance Type',
                Value : type,
            },
            {
            $Type : 'UI.DataField',
            Value : service.name,
            Label : 'Vendor'
        },
            {
                $Type : 'UI.DataField',
                Label : 'Reported Date',
                Value : reported_date,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Completed Date',
                Value : completed_date,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Maintenance Status',
                Value : status,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Maintenance Outcome',
                Value : outcome,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Cost',
                Value : cost,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Warranty',
                Value : covered_by_warranty,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Next Due Date',
                Value : next_due_date,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Description',
                Value : description,
            },
        ],
    },
    UI.FieldGroup #AssetInfo : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : asset.asset_tag,
                Label : 'Asset Tag'
            },
            {
                $Type : 'UI.DataField',
                Value : asset.serial_number,
                Label : 'Serial Number'
            },
            {
                $Type : 'UI.DataField',
                Value : asset.model,
                Label : 'Model'
            }
        ]
    },
    UI.FieldGroup #PeopleInfo : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : reported_by.full_name,
                Label : 'Reported By'
            },
            {
                $Type : 'UI.DataField',
                Value : service.name,
                Label : 'Service Vendor'
            }
        ]
    },
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'GeneratedFacet1',
            Label : 'General Information',
            Target : '@UI.FieldGroup#GeneratedGroup',
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'AssetInfo',
            Label : 'Asset Information',
            Target : '@UI.FieldGroup#AssetInfo'
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'PeopleInfo',
            Label : 'Vendor & Reporter',
            Target : '@UI.FieldGroup#PeopleInfo'
        }
    ],
    UI.PresentationVariant : {
        SortOrder : [
            {
                Property : reported_date,
                Descending : true
            }
        ]
    }
);
annotate service.MaintenanceRecordSrv with {
    status @UI.Criticality : maintenanceCriticality;
};
annotate service.MaintenanceRecordSrv with {

    asset @Common.Text : asset.asset_tag;

    reported_by @Common.Text : reported_by.full_name;

    service @Common.Text : service.name;

};

annotate service.MaintenanceRecordSrv with {
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

annotate service.MaintenanceRecordSrv with {
    reported_by @Common.ValueList : {
        $Type : 'Common.ValueListType',
        CollectionPath : 'EmployeeSrv',
        Parameters : [
            {
                $Type : 'Common.ValueListParameterInOut',
                LocalDataProperty : reported_by_employee_id,
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

annotate service.MaintenanceRecordSrv with {
    service @Common.ValueList : {
        $Type : 'Common.ValueListType',
        CollectionPath : 'VendorSrv',
        Parameters : [
            {
                $Type : 'Common.ValueListParameterInOut',
                LocalDataProperty : service_vendor_id,
                ValueListProperty : 'vendor_id',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'name',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'email',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'phone',
            },
        ],
    }
};

