sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"assetassignment/test/integration/pages/AssetAssignmentSrvList.gen",
	"assetassignment/test/integration/pages/AssetAssignmentSrvObjectPage.gen"
], function (JourneyRunner, AssetAssignmentSrvListGenerated, AssetAssignmentSrvObjectPageGenerated) {
    'use strict';

    const runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('assetassignment') + '/test/flp.html#app-preview',
        pages: {
			onTheAssetAssignmentSrvListGenerated: AssetAssignmentSrvListGenerated,
			onTheAssetAssignmentSrvObjectPageGenerated: AssetAssignmentSrvObjectPageGenerated
        },
        async: true
    });

    return runner;
});

