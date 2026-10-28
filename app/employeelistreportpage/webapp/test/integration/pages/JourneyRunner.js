sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"employeelistreportpage/test/integration/pages/EmployeeSrvList.gen",
	"employeelistreportpage/test/integration/pages/EmployeeSrvObjectPage.gen",
	"employeelistreportpage/test/integration/pages/AssetSrvObjectPage.gen"
], function (JourneyRunner, EmployeeSrvListGenerated, EmployeeSrvObjectPageGenerated, AssetSrvObjectPageGenerated) {
    'use strict';

    const runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('employeelistreportpage') + '/test/flp.html#app-preview',
        pages: {
			onTheEmployeeSrvListGenerated: EmployeeSrvListGenerated,
			onTheEmployeeSrvObjectPageGenerated: EmployeeSrvObjectPageGenerated,
			onTheAssetSrvObjectPageGenerated: AssetSrvObjectPageGenerated
        },
        async: true
    });

    return runner;
});

