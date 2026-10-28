using AssetAdminService as service from '../../srv/asset_service';
annotate AssetAdminService.EmployeeSrv with {
    employee_id @Common.Label : 'Employee ID';
    full_name @Common.Label : 'Name';
    dept @Common.Label : 'Department ID';
    location @Common.Label : 'Location';
    status @Common.Label : 'Employee Status'; 
};

annotate service.EmployeeSrv with @(

    UI.HeaderInfo : {
        TypeName : 'Employee',
        TypeNamePlural : 'Employees',

        Title : {
            Value : full_name
        },

        Description : {
            Value : location
        }
    },

    UI.SelectionFields : [
        employee_id,
        full_name,
        dept_dept_id,
        location,
        status
    ],

    UI.LineItem : [

        {
            $Type : 'UI.DataField',
            Label : 'Employee ID',
            Value : employee_id
        },

        {
            $Type : 'UI.DataField',
            Label : 'Employee Name',
            Value : full_name
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
            $Type : 'UI.DataField',
            Label : 'Department',
            Value : dept.name
        },

        {
            $Type : 'UI.DataField',
            Label : 'Location',
            Value : location
        },

        {
            $Type : 'UI.DataField',
            Label : 'Employee Status',
            Value : status
        },
        {
            $Type : 'UI.DataFieldForAction',
            Label : 'Add Employee',
            Action : 'AssetAdminService.EntityContainer/addEmployee'
        },
        {
            $Type : 'UI.DataFieldForAction',
            Label : 'Edit Employee',
            Action : 'AssetAdminService.EntityContainer/editEmployee'
        }
    ],

    UI.FieldGroup #GeneralInformation : {

        $Type : 'UI.FieldGroupType',

        Data : [

            {
                $Type : 'UI.DataField',
                Label : 'Employee ID',
                Value : employee_id
            },

            {
                $Type : 'UI.DataField',
                Label : 'Employee Name',
                Value : full_name
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
                $Type : 'UI.DataField',
                Label : 'Department',
                Value : dept.name
            },

            {
                $Type : 'UI.DataField',
                Label : 'Location',
                Value : location
            },

            {
                $Type : 'UI.DataField',
                Label : 'Employee Status',
                Value : status
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
            ID : 'Assignments',
            Label : 'Assignment History',
            Target : 'assignments/@UI.LineItem'
        }
    ]
);
annotate service.EmployeeSrv with {
    dept @Common.ValueList : {
        $Type : 'Common.ValueListType',
        CollectionPath : 'DepartmentSrv',
        Parameters : [
            {
                $Type : 'Common.ValueListParameterInOut',
                LocalDataProperty : dept_dept_id,
                ValueListProperty : 'dept_id'
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'name'
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'cost_center'
            }
        ]
    }
};
annotate service.EmployeeSrv with {

    employee_id @Search.defaultSearchElement;

    full_name @Search.defaultSearchElement;

    email @Search.defaultSearchElement;

    location @Search.defaultSearchElement;

};

