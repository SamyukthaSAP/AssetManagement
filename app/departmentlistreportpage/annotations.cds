using AssetAdminService as service from '../../srv/asset_service';
annotate AssetAdminService.DepartmentSrv with {
    dept_id @Common.Label : 'Department ID';
    name @Common.Label : 'Deaprtment Name';
    cost_center @Common.Label : 'Cost Center';
};
annotate service.DepartmentSrv with @(
    UI.HeaderInfo : {
    TypeName : 'Department',
    TypeNamePlural : 'Departments',
    Title : {
        Value : name
    },
    Description : {
        Value : cost_center
    }
},
UI.SelectionFields : [
    dept_id,
    name,
    cost_center
],
    
UI.FieldGroup #GeneralInformation : {
    $Type : 'UI.FieldGroupType',
    Data : [

        {
            $Type : 'UI.DataField',
            Label : 'Department ID',
            Value : dept_id
        },

        {
            $Type : 'UI.DataField',
            Label : 'Department Name',
            Value : name
        },

        {
            $Type : 'UI.DataField',
            Label : 'Cost Center',
            Value : cost_center
        }
    ]
},
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'GeneralInformation',
            Label : 'General Information',
            Target : '@UI.FieldGroup#GeneralInformation',
        },
        {
        $Type : 'UI.ReferenceFacet',
        ID : 'Employees',
        Label : 'Employees',
        Target : 'employee/@UI.LineItem'
    }
    ],
    UI.LineItem : [
       {
        $Type : 'UI.DataField',
        Label : 'Department ID',
        Value : dept_id,
    },
    {
        $Type : 'UI.DataField',
        Label : 'Department Name',
        Value : name,
    },
    {
        $Type : 'UI.DataField',
        Label : 'Cost Center',
        Value : cost_center,
    },
    {
        $Type : 'UI.DataFieldForAction',
        Label : 'Add Department',
        Action : 'AssetAdminService.EntityContainer/addDepartment'
    },
    {
        $Type : 'UI.DataFieldForAction',
        Label : 'Edit Department',
        Action : 'AssetAdminService.EntityContainer/updateDepartment'
    }
    ]
);

annotate service.DepartmentSrv with {

    dept_id @Search.defaultSearchElement;

    name @Search.defaultSearchElement;

    cost_center @Search.defaultSearchElement;

};
// annotate service.EmployeeSrv with @(
//     UI.HeaderInfo : {
//     TypeName : 'Employee',
//     TypeNamePlural : 'Employees',

//     Title : {
//         Value : full_name
//     },

//     Description : {
//         Value : dept.name
//     }
// },

//     UI.Facets : [

//     {
//         $Type : 'UI.ReferenceFacet',
//         ID : 'General',
//         Label : 'General Information',
//         Target : '@UI.FieldGroup#General'
//     },

//     {
//         $Type : 'UI.ReferenceFacet',
//         ID : 'Assets',
//         Label : 'Assets',
//         Target : 'asset/@UI.LineItem'
//     },

//     {
//         $Type : 'UI.ReferenceFacet',
//         ID : 'Assignments',
//         Label : 'Assignments',
//         Target : 'assignments/@UI.LineItem'
//     }
// ],
//     UI.FieldGroup #General : {

//         $Type : 'UI.FieldGroupType',

//         Data : [

//             {
//                 $Type : 'UI.DataField',
//                 Label : 'Employee Name',
//                 Value : full_name
//             },

//             {
//                 $Type : 'UI.DataField',
//                 Label : 'Email',
//                 Value : email
//             },

//             {
//                 $Type : 'UI.DataField',
//                 Label : 'Phone',
//                 Value : phone
//             },

//             {
//                 $Type : 'UI.DataField',
//                 Label : 'Location',
//                 Value : location
//             },

//             {
//                 $Type : 'UI.DataField',
//                 Label : 'Status',
//                 Value : status
//             }
//         ]
//     },

//     UI.LineItem : [

//         {
//             $Type : 'UI.DataField',
//             Label : 'Employee Name',
//             Value : full_name
//         },

//         {
//             $Type : 'UI.DataField',
//             Label : 'Email',
//             Value : email
//         },

//         {
//             $Type : 'UI.DataField',
//             Label : 'Phone',
//             Value : phone
//         },

//         {
//             $Type : 'UI.DataField',
//             Label : 'Location',
//             Value : location
//         },

//         {
//             $Type : 'UI.DataField',
//             Label : 'Status',
//             Value : status
//         }
//     ]
// );



