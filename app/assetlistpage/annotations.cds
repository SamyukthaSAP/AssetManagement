using AssetAdminService as service from '../../srv/asset_service';
annotate AssetAdminService.AssetSrv with {
    asset_id         @Common.Label : 'Asset ID';
    asset_tag         @Common.Label : 'Asset Tag';
    serial_number     @Common.Label : 'Serial Number';
    model             @Common.Label : 'Model';
    status            @Common.Label : 'Status';
    vendor            @Common.Label : 'Vendor';
    asset_category    @Common.Label : 'Category';
    current_holder_id @Common.Label : 'Assigned To';
};
annotate service.AssetSrv with {
    status @UI.Criticality : statusCriticality;
};
annotate service.AssetSrv with @(

    UI.HeaderInfo : {
        TypeName : 'Asset Details',
        TypeNamePlural : 'Assets Details',
        Title : {
            Value : asset_tag
        },
        Description : {
            Value : model
        }
    },

    UI.HeaderFacets : [
    {
        $Type  : 'UI.ReferenceFacet',
        Label  : 'Asset Status',
        Target : '@UI.FieldGroup#StatusInfo'
    }
    ],

    UI.SelectionFields : [
        asset_id,
        asset_tag,
        status,
        asset_category_asset_category_id,
        vendor_vendor_id,
        current_holder_id_employee_id,
    ],

    UI.LineItem : [

        {
            $Type : 'UI.DataField',
            Label : 'Asset ID',
            Value : asset_id
        },
        {
            $Type : 'UI.DataField',
            Label : 'Asset Tag',
            Value : asset_tag
        },

        {
            $Type : 'UI.DataField',
            Label : 'Serial Number',
            Value : serial_number
        },

        {
            $Type : 'UI.DataField',
            Label : 'Model',
            Value : model
        },

        {
            $Type : 'UI.DataField',
            Label : 'Category',
            Value : asset_category.name
        },

        {
            $Type : 'UI.DataField',
            Label : 'Vendor',
            Value : vendor.name
        },

        {
            $Type : 'UI.DataField',
            Label : 'Current Holder',
            Value : current_holder_id.full_name
        },

        {
            $Type : 'UI.DataField',
            Label : 'Status',
            Value : status,
            Criticality : statusCriticality
        },

        {
            $Type : 'UI.DataField',
            Label : 'Purchase Date',
            Value : purchase_date
        },
        {
            $Type : 'UI.DataFieldForAction',
            Label : 'Create Asset',
            Action: 'AssetAdminService.EntityContainer/assignAsset'
        }
    ],

    UI.FieldGroup #StatusInfo : {

    $Type : 'UI.FieldGroupType',

    Data : [
        {
            $Type : 'UI.DataField',
            Label : 'Asset Tag',
            Value : asset_id
        },
        {
            $Type : 'UI.DataField',
            Label : 'Asset Tag',
            Value : asset_tag
        },

        {
            $Type : 'UI.DataField',
            Label : 'Status',
            Value : status,
            Criticality : statusCriticality
        },

        {
            $Type : 'UI.DataField',
            Label : 'Current Holder',
            Value : current_holder_id.full_name
        }
    ]
},

    UI.FieldGroup #General : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Label : 'Asset Tag',
                Value : asset_id
            },
            {
                $Type : 'UI.DataField',
                Label : 'Asset Tag',
                Value : asset_tag
            },

            {
                $Type : 'UI.DataField',
                Label : 'Serial Number',
                Value : serial_number
            },

            {
                $Type : 'UI.DataField',
                Label : 'Model',
                Value : model
            },

            {
                $Type : 'UI.DataField',
                Label : 'Status',
                Value : status,
                Criticality : statusCriticality
            },

            {
                $Type : 'UI.DataField',
                Label : 'Current Holder',
                Value : current_holder_id.full_name
            }
        ]
    },

    UI.FieldGroup #Procurement : {
        $Type : 'UI.FieldGroupType',
        Data : [

            {
                $Type : 'UI.DataField',
                Label : 'Category',
                Value : asset_category.name
            },

            {
                $Type : 'UI.DataField',
                Label : 'Vendor',
                Value : vendor.name
            },

            {
                $Type : 'UI.DataField',
                Label : 'Purchase Date',
                Value : purchase_date
            },

            {
                $Type : 'UI.DataField',
                Label : 'Purchase Cost',
                Value : purchase_cost
            },

            {
                $Type : 'UI.DataField',
                Label : 'Warranty Expiry',
                Value : warranty_expiry
            },

            {
                $Type : 'UI.DataField',
                Label : 'First Distribution Date',
                Value : first_distribution_date
            }
        ]
    },

    UI.FieldGroup #Retirement : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Label : 'Status',
                Value : status,
                Criticality : statusCriticality
            }
        ]
    },

    UI.Identification : [
        {
            $Type : 'UI.DataFieldForAction',
            Label : 'Assign Asset',
            Action : 'AssetAdminService.EntityContainer/assignAsset'
        },

        {
            $Type : 'UI.DataFieldForAction',
            Label : 'Transfer Asset',
            Action : 'AssetAdminService.EntityContainer/transferAsset'
        },

        {
            $Type : 'UI.DataFieldForAction',
            Label : 'Return Asset',
            Action : 'AssetAdminService.EntityContainer/returnAsset'
        },

        {
            $Type : 'UI.DataFieldForAction',
            Label : 'Retire Asset',
            Action : 'AssetAdminService.EntityContainer/retireAsset'
        },

        {
            $Type : 'UI.DataFieldForAction',
            Label : 'Archive Asset',
            Action : 'AssetAdminService.EntityContainer/createArchive'
        }
    ],

    UI.Facets : [

        {
            $Type : 'UI.ReferenceFacet',
            ID : 'GeneralInfo',
            Label : 'General Information',
            Target : '@UI.FieldGroup#General'
        },

        {
            $Type : 'UI.ReferenceFacet',
            ID : 'ProcurementInfo',
            Label : 'Procurement Information',
            Target : '@UI.FieldGroup#Procurement'
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'Assignments',
            Label : 'Assignments',
            Target : 'assignments/@UI.LineItem'
        },

        {
            $Type : 'UI.ReferenceFacet',
            ID : 'Maintenance',
            Label : 'Maintenance',
            Target : 'maintenance/@UI.LineItem'
        },

        {
            $Type : 'UI.ReferenceFacet',
            ID : 'History',
            Label : 'Ownership History',
            Target : 'ownership/@UI.LineItem'
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'RetirementInfo',
            Label : 'Retirement',
            Target : '@UI.FieldGroup#Retirement'
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'ArchiveInfo',
            Label : 'Archive',
            Target : 'archive/@UI.LineItem'
        }
    ]
);

// annotate service.AssetSrv with {
//     asset_category @(
//         Common.Text: asset_category,
//         ValueList :{
//         Label: 'asset_category',
//         CollectionPath : 'AssetCategorySrv',
//         SearchSupported: true,
//         Parameters : [
//             {
//                 $Type : 'Common.ValueListParameterInOut',
//                 LocalDataProperty : name,
//                 ValueListProperty : 'name',
//             }
//         ]
//         }
//         }
//     )
// };
annotate service.AssetSrv with {
    status @(
        Common : {
            Text : status,
            ValueList : {
                Label : 'Asset Status',
                CollectionPath : 'AssetStatusVH',
                SearchSupported : true,
                Parameters : [
                    {
                        $Type : 'Common.ValueListParameterOut',
                        LocalDataProperty : status,
                        ValueListProperty : 'code'
                    }
                ]
            }
        }
    );
};

annotate service.AssetSrv with {
    asset_category @(
        Common : {
            Text : asset_category.name,
            ValueList : {
                Label : 'Asset Category',
                CollectionPath : 'AssetCategorySrv',
                SearchSupported : true,
                Parameters : [
                    {
                        $Type : 'Common.ValueListParameterOut',
                        LocalDataProperty : asset_category_asset_category_id,
                        ValueListProperty : 'asset_category_id'
                    }
                ]
            }
        }
    );
};

annotate service.AssetSrv with {
    vendor @Common.ValueList : {
        $Type : 'Common.ValueListType',
        CollectionPath : 'VendorSrv',
        Parameters : [
            {
                $Type : 'Common.ValueListParameterInOut',
                LocalDataProperty : vendor_vendor_id,
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

annotate service.AssetSrv with {
    current_holder_id @Common.ValueList : {
        $Type : 'Common.ValueListType',
        CollectionPath : 'EmployeeSrv',
        Parameters : [
            {
                $Type : 'Common.ValueListParameterInOut',
                LocalDataProperty : current_holder_id_employee_id,
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

annotate service.AssetAssignmentSrv with @(

    UI.LineItem : [
         {
            $Type : 'UI.DataField',
            Value : assigned_by.full_name,
            Label : 'Assigned By'
        },
        {
            $Type : 'UI.DataField',
            Value : assigned_date,
            Label : 'Assigned Date'
        },
        {
            $Type : 'UI.DataField',
            Value : expected_return_date,
            Label : 'Expected Return'
        },
        {
            $Type : 'UI.DataField',
            Value : asset.asset_tag,
            ![@UI.Importance] : #High
        },
        {
            $Type : 'UI.DataField',
            Value : employee.full_name,
            Label: 'Employee Name',
            ![@UI.Importance] : #High
        },
        {
            $Type : 'UI.DataField',
            Value : assignment_status,
            ![@UI.Importance] : #High
        }
    ]
);

annotate service.MaintenanceRecordSrv with @(

    UI.LineItem : [
        {
                $Type : 'UI.DataFieldForAction',
                Action: 'AssetAdminService.EntityContainer/createMaintenance',
                Label : 'Create Maintenance'
        },
        {
                $Type : 'UI.DataFieldForAction',
                Action: 'AssetAdminService.EntityContainer/updateMaintenance',
                Label : 'Update Maintenance'
        },
        {
            $Type : 'UI.DataField',
            Label : 'Type',
            Value : type
        },

        {
            $Type : 'UI.DataField',
            Label : 'Status',
            Value : status
        },

        {
            $Type : 'UI.DataField',
            Label : 'Reported Date',
            Value : reported_date
        },

        {
            $Type : 'UI.DataField',
            Label : 'Completed Date',
            Value : completed_date
        },

        {
            $Type : 'UI.DataField',
            Label : 'Cost',
            Value : cost
        }
    ]
);
annotate service.OwnershipLedgerSrv with @(

    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Value : asset.asset_tag,
            Label : 'Asset'
        },
        {
            $Type : 'UI.DataField',
            Value : action,
            Label : 'Action'
        },
        {
            $Type : 'UI.DataField',
            Value : from_employee_id.full_name,
            Label : 'From Employee'
        },
        {
            $Type : 'UI.DataField',
            Value : to_employee_id.full_name,
            Label : 'To Employee'
        },
        {
            $Type : 'UI.DataField',
            Value : recorded_by.full_name,
            Label : 'Recorded By'
        },
        {
            $Type : 'UI.DataField',
            Value : transition_date,
            Label : 'Transition Date'
        }
    ]
);

annotate service.ArchiveRecordSrv with @(

    UI.LineItem : [
        {
        $Type  : 'UI.DataFieldForAction',
        Label  : 'Archive Asset',
        Action : 'AssetAdminService.EntityContainer/createArchive'
        },
        {
            $Type : 'UI.DataField',
            Label : 'Archive ID',
            Value : archive_id
        },
        {
            $Type : 'UI.DataField',
            Label : 'Asset',
            Value : asset_asset_id
        },
        {
            $Type : 'UI.DataField',
            Label : 'Asset',
            Value : asset.asset_tag
        },
        {
            $Type : 'UI.DataField',
            Label : 'Archived At',
            Value : archived_at
        },
        {
            $Type : 'UI.DataField',
            Label : 'Reason',
            Value : reason
        },
        {
            $Type : 'UI.DataField',
            Label : 'Disposal Method',
            Value : disposal_method
        },

        {
            $Type : 'UI.DataField',
            Label : 'Certificate No',
            Value : disposal_cert_no
        }

    ]
);
annotate service.AssetSrv with {

    asset_tag @Search.defaultSearchElement;

    serial_number @Search.defaultSearchElement;

    model @Search.defaultSearchElement;

};