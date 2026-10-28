sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"ownershipledger/test/integration/pages/OwnershipLedgerSrvList.gen",
	"ownershipledger/test/integration/pages/OwnershipLedgerSrvObjectPage.gen"
], function (JourneyRunner, OwnershipLedgerSrvListGenerated, OwnershipLedgerSrvObjectPageGenerated) {
    'use strict';

    const runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('ownershipledger') + '/test/flp.html#app-preview',
        pages: {
			onTheOwnershipLedgerSrvListGenerated: OwnershipLedgerSrvListGenerated,
			onTheOwnershipLedgerSrvObjectPageGenerated: OwnershipLedgerSrvObjectPageGenerated
        },
        async: true
    });

    return runner;
});

