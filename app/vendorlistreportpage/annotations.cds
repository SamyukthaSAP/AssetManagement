using AssetAdminService as service from '../../srv/asset_service';
annotate AssetAdminService.VendorSrv with {
    vendor_id @Common.Label : 'Vendor ID';
    name @Common.Label : 'Vendor Name';
    email  @Common.Label : 'Email';
    phone @Common.Label : 'Asset Tag';
};
annotate service.VendorSrv with @(

    UI.HeaderInfo : {
        TypeName : 'Vendor',
        TypeNamePlural : 'Vendors',

        Title : {
            Value : name
        },

        Description : {
            Value : email
        }
    },

    UI.SelectionFields : [
        vendor_id,
        name,
        email
    ],

    UI.FieldGroup #GeneralInformation : {

        $Type : 'UI.FieldGroupType',

        Data : [

            {
                $Type : 'UI.DataField',
                Label : 'Vendor ID',
                Value : vendor_id
            },

            {
                $Type : 'UI.DataField',
                Label : 'Vendor Name',
                Value : name
            },

            {
                $Type : 'UI.DataField',
                Label : 'Email',
                Value : email
            },

            {
                $Type : 'UI.DataField',
                Label : 'Phone',
                Value : phone
            }
        ]
    },

    UI.Facets : [

        {
            $Type : 'UI.ReferenceFacet',
            ID : 'GeneralInformation',
            Label : 'General Information',
            Target : '@UI.FieldGroup#GeneralInformation'
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'Assets',
            Label : 'Assets Supplied',
            Target : 'asset/@UI.LineItem'
        }
    ],
    UI.Identification:[
        {
                $Type : 'UI.DataFieldForAction',
                Action: 'AssetAdminService.EntityContainer/createAsset',
                Label : 'Create Asset'
            }
    ],
    UI.LineItem : [

        {
            $Type : 'UI.DataField',
            Label : 'Vendor ID',
            Value : vendor_id
        },

        {
            $Type : 'UI.DataField',
            Label : 'Vendor Name',
            Value : name
        },

        {
            $Type : 'UI.DataField',
            Label : 'Email',
            Value : email
        },
        {
            $Type : 'UI.DataField',
            Label : 'Phone',
            Value : phone
        },
        {
                $Type : 'UI.DataFieldForAction',
                Action: 'AssetAdminService.EntityContainer/addVendor',
                Label : 'Add Vendor'
        },
        {
                $Type : 'UI.DataFieldForAction',
                Action: 'AssetAdminService.EntityContainer/updateVendor',
                Label : 'Edit Vendor'
        }  
    ],
    
    
);
annotate service.VendorSrv with {

    vendor_id @Search.defaultSearchElement;

    name @Search.defaultSearchElement;

    email @Search.defaultSearchElement;

};
