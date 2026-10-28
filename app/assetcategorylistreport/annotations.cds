using AssetAdminService as service from '../../srv/asset_service';
annotate AssetAdminService.AssetCategorySrv with {
    asset_category_id         @Common.Label : 'Asset Category ID';
    name                        @Common.Label : 'Category Name';
    lifespan_months     @Common.Label : 'Lifespan in Months';
};
annotate service.AssetCategorySrv with @(

    UI.HeaderInfo : {
        TypeName : 'Asset Category',
        TypeNamePlural : 'Asset Categories',

        Title : {
            Value : name
        },

        Description : {
            Value : lifespan_months
        }
    },

    UI.SelectionFields : [
        asset_category_id,
        name
    ],

    UI.FieldGroup #GeneralInformation : {

        $Type : 'UI.FieldGroupType',

        Data : [

            {
                $Type : 'UI.DataField',
                Label : 'Category ID',
                Value : asset_category_id
            },

            {
                $Type : 'UI.DataField',
                Label : 'Category Name',
                Value : name
            },

            {
                $Type : 'UI.DataField',
                Label : 'Lifespan (Months)',
                Value : lifespan_months
            },
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
           Label : 'Assets',
           Target : 'asset/@UI.LineItem'
        },
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
            Label : 'Category ID',
            Value : asset_category_id
        },

        {
            $Type : 'UI.DataField',
            Label : 'Category Name',
            Value : name
        },

        {
            $Type : 'UI.DataField',
            Label : 'Lifespan (Months)',
            Value : lifespan_months
        },
        {
            $Type: 'UI.DataFieldForAction',
            Action: 'AssetAdminService.EntityContainer/addAssetCategory',
            Label: 'Add Category',
        },
        {
            $Type: 'UI.DataFieldForAction',
            Action: 'AssetAdminService.EntityContainer/updateAssetCategory',
            Label: 'Update Category',
        }
    ]
);

annotate service.AssetCategorySrv with {

    asset_category_id @Search.defaultSearchElement;

    name @Search.defaultSearchElement;

};