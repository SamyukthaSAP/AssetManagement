sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"vendorlistreportpage/test/integration/pages/VendorSrvList.gen",
	"vendorlistreportpage/test/integration/pages/VendorSrvObjectPage.gen",
	"vendorlistreportpage/test/integration/pages/AssetSrvObjectPage.gen"
], function (JourneyRunner, VendorSrvListGenerated, VendorSrvObjectPageGenerated, AssetSrvObjectPageGenerated) {
    'use strict';

    const runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('vendorlistreportpage') + '/test/flp.html#app-preview',
        pages: {
			onTheVendorSrvListGenerated: VendorSrvListGenerated,
			onTheVendorSrvObjectPageGenerated: VendorSrvObjectPageGenerated,
			onTheAssetSrvObjectPageGenerated: AssetSrvObjectPageGenerated
        },
        async: true
    });

    return runner;
});

