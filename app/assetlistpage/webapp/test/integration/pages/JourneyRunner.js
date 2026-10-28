sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"assetlistpage/test/integration/pages/AssetSrvList.gen",
	"assetlistpage/test/integration/pages/AssetSrvObjectPage.gen",
	"assetlistpage/test/integration/pages/AssetAssignmentSrvObjectPage.gen"
], function (JourneyRunner, AssetSrvListGenerated, AssetSrvObjectPageGenerated, AssetAssignmentSrvObjectPageGenerated) {
    'use strict';

    const runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('assetlistpage') + '/test/flp.html#app-preview',
        pages: {
			onTheAssetSrvListGenerated: AssetSrvListGenerated,
			onTheAssetSrvObjectPageGenerated: AssetSrvObjectPageGenerated,
			onTheAssetAssignmentSrvObjectPageGenerated: AssetAssignmentSrvObjectPageGenerated
        },
        async: true
    });

    return runner;
});

