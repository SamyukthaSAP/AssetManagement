sap.ui.define([
    "sap/ui/core/mvc/Controller",
    "sap/ui/model/json/JSONModel"
], function (Controller, JSONModel) {
    "use strict";

    return Controller.extend("admindashboard.controller.AdminDashboard", {

        onInit: function () {

            var oKPIModel = new JSONModel({
                totalAssets: 0,
                assignedAssets: 0,
                repairAssets: 0,
                retiredAssets: 0,
                archivedAssets: 0,
                employees: 0,
                vendors: 0,
                departments: 0
            });

            this.getView().setModel(oKPIModel, "kpi");

            this._loadKPIs();
        },

        onExportPDF: function () {
            sap.m.MessageToast.show("Export PDF");
        },

        onDownloadReport: function () {
            sap.m.MessageToast.show("Download Report");
        },

        onEmailReport: function () {
            sap.m.MessageToast.show("Email Report");
        },

        _loadKPIs: async function () {

            try {

                const response = await fetch(
                    "/odata/v4/asset-admin/getDashboardKPIs",
                    {
                        method: "POST",
                        headers: {
                            "Content-Type": "application/json"
                        }
                    }
                );

                const result = await response.json();

                this.getView()
                    .getModel("kpi")
                    .setData(result);


                var oChartModel = new JSONModel({
            items: [
                {
                    Status: "Assigned",
                    Count: result.assignedAssets
                },
                {
                    Status: "Repair",
                    Count: result.repairAssets
                },
                {
                    Status: "Retired",
                    Count: result.retiredAssets
                },
                {
                    Status: "Archived",
                    Count: result.archivedAssets
                }
            ]
        });

        this.getView().setModel(oChartModel, "chart");

        var oDepartmentModel = new JSONModel({
    items: [
        {
            Department: "IT",
            Assets: 5
        },
        {
            Department: "Finance",
            Assets: 3
        },
        {
            Department: "HR",
            Assets: 2
        }
    ]
});

this.getView().setModel(oDepartmentModel, "dept");
var oVizFrame = this.byId("departmentChart");

var oDataset =
    new sap.viz.ui5.data.FlattenedDataset({

        dimensions: [{
            name: "Department",
            value: "{dept>Department}"
        }],

        measures: [{
            name: "Assets",
            value: "{dept>Assets}"
        }],

        data: {
            path: "dept>/items"
        }
    });

oVizFrame.setDataset(oDataset);
oVizFrame.setModel(
    this.getView().getModel("dept"),
    "dept"
);
oVizFrame.addFeed(
    new sap.viz.ui5.controls.common.feeds.FeedItem({
        uid: "valueAxis",
        type: "Measure",
        values: ["Assets"]
    })
);

oVizFrame.addFeed(
    new sap.viz.ui5.controls.common.feeds.FeedItem({
        uid: "categoryAxis",
        type: "Dimension",
        values: ["Department"]
    })
);
var oCategoryModel = new JSONModel({
    items: [
        {
            Category: "Laptop",
            Assets: 8
        },
        {
            Category: "Desktop",
            Assets: 3
        },
        {
            Category: "Printer",
            Assets: 2
        }
    ]
});


this.getView().setModel(oCategoryModel, "category");
var oMaintenanceModel = new JSONModel({
    items: [
        {
            Status: "Open",
            Count: 4
        },
        {
            Status: "In Progress",
            Count: 2
        },
        {
            Status: "Completed",
            Count: 10
        }
    ]
});

this.getView().setModel(oMaintenanceModel, "maintenance");



            } catch (error) {
                console.error(error);
            }
        }
    });
});