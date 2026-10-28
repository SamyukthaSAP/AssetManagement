using AssetAdminService as service from '../../srv/asset_service';
annotate AssetUserService.AssetSrv with @(
    UI.HeaderInfo : {
        TypeName       : 'Asset',
        TypeNamePlural : 'Assets',
        Title : {
            Value : asset_tag
        }
    },
    UI.FieldGroup #General : {
        Data : [
            { Value : asset_tag },
            { Value : serial_number },
            { Value : model },
            { Value : status }
        ]
    },
     UI.FieldGroup #Assignment : {
        Data : [
            { Value : current_holder_id },
            { Value : status }
        ]
    },
    UI.Facets : [
    {
        $Type  : 'UI.ReferenceFacet',
        Label  : 'General Information',
        Target : '@UI.FieldGroup#General'
    },
    {
        $Type  : 'UI.ReferenceFacet',
        Label  : 'Assignment Details',
        Target : '@UI.FieldGroup#Assignment'
    },
    {
        $Type  : 'UI.ReferenceFacet',
        Label  : 'Maintenance',
        Target : '@UI.FieldGroup#Maintenance'
    },
    {
    $Type  : 'UI.ReferenceFacet',
    Label  : 'History',
    Target : '@UI.FieldGroup#History'
}
],
UI.FieldGroup #Maintenance : {
        Data : [
            { Value : status },
            { Value : warranty_expiry }
        ]
    },
     UI.FieldGroup #History : {
        Data : [
            { Value : asset_tag },
            { Value : status },
            { Value : current_holder_id }
        ]
    }
);
