sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"assetcategorylistreport/test/integration/pages/AssetCategorySrvList.gen",
	"assetcategorylistreport/test/integration/pages/AssetCategorySrvObjectPage.gen",
	"assetcategorylistreport/test/integration/pages/AssetSrvObjectPage.gen"
], function (JourneyRunner, AssetCategorySrvListGenerated, AssetCategorySrvObjectPageGenerated, AssetSrvObjectPageGenerated) {
    'use strict';

    const runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('assetcategorylistreport') + '/test/flp.html#app-preview',
        pages: {
			onTheAssetCategorySrvListGenerated: AssetCategorySrvListGenerated,
			onTheAssetCategorySrvObjectPageGenerated: AssetCategorySrvObjectPageGenerated,
			onTheAssetSrvObjectPageGenerated: AssetSrvObjectPageGenerated
        },
        async: true
    });

    return runner;
});

