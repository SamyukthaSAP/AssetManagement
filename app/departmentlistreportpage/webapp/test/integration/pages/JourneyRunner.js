sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"departmentlistreportpage/test/integration/pages/DepartmentSrvList.gen",
	"departmentlistreportpage/test/integration/pages/DepartmentSrvObjectPage.gen",
	"departmentlistreportpage/test/integration/pages/EmployeeSrvObjectPage.gen"
], function (JourneyRunner, DepartmentSrvListGenerated, DepartmentSrvObjectPageGenerated, EmployeeSrvObjectPageGenerated) {
    'use strict';

    const runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('departmentlistreportpage') + '/test/flp.html#app-preview',
        pages: {
			onTheDepartmentSrvListGenerated: DepartmentSrvListGenerated,
			onTheDepartmentSrvObjectPageGenerated: DepartmentSrvObjectPageGenerated,
			onTheEmployeeSrvObjectPageGenerated: EmployeeSrvObjectPageGenerated
        },
        async: true
    });

    return runner;
});

