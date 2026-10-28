using AssetAdminService as service from '../../srv/asset_service';

annotate service.ArchiveRecordSrv with {
    asset @Common.Label: 'Asset ID';
    archive_id      @Common.Label : 'Archive ID';
    disposal_method  @Common.Label : 'Disposal Method';
    disposal_cert_no  @Common.Label : 'Certificate Number';
    archived_by @Common.Label : 'Archived By'
};
annotate service.ArchiveRecordSrv with @(
    UI.SelectionFields:[
        asset.asset_id,
        disposal_method,
        disposal_cert_no,
        archived_by_employee_id
    ],
    UI.HeaderInfo : {
        TypeName       : 'Archive Record',
        TypeNamePlural : 'Archive Records',
        Title          : {
            Value : archive_id
        },
        Description    : {
            Value : disposal_method
        }
    },
    UI.FieldGroup #GeneralInfo : {
        $Type : 'UI.FieldGroupType',
        Data : [

            {
                $Type : 'UI.DataField',
                Label : 'Archive ID',
                Value : archive_id
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
                Label : 'Certificate Number',
                Value : disposal_cert_no
            }
        ]
    },
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'GeneratedFacet1',
            Label : 'General Information',
            Target : '@UI.FieldGroup#GeneralInfo',
        },
    ],
    UI.Identification : [
    {
        $Type  : 'UI.DataFieldForAction',
        Label  : 'Download Certificate',
        Action : 'AssetAdminService.downloadCertificate'
    },
    {
        $Type  : 'UI.DataFieldForAction',
        Label  : 'Asset History',
        Action : 'AssetAdminService.viewAssetHistory'
    }
]
);

annotate service.ArchiveRecordSrv with {
    archived_by @Common.ValueList : {
        $Type : 'Common.ValueListType',
        CollectionPath : 'EmployeeSrv',
        Parameters : [
            {
                $Type : 'Common.ValueListParameterInOut',
                LocalDataProperty : archived_by_employee_id,
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

annotate service.ArchiveRecordSrv with {
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


