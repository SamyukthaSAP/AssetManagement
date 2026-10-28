sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"userasset/test/integration/pages/AssetSrvList.gen",
	"userasset/test/integration/pages/AssetSrvObjectPage.gen",
	"userasset/test/integration/pages/AssetAssignmentSrvObjectPage.gen"
], function (JourneyRunner, AssetSrvListGenerated, AssetSrvObjectPageGenerated, AssetAssignmentSrvObjectPageGenerated) {
    'use strict';

    const runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('userasset') + '/test/flp.html#app-preview',
        pages: {
			onTheAssetSrvListGenerated: AssetSrvListGenerated,
			onTheAssetSrvObjectPageGenerated: AssetSrvObjectPageGenerated,
			onTheAssetAssignmentSrvObjectPageGenerated: AssetAssignmentSrvObjectPageGenerated
        },
        async: true
    });

    return runner;
});

