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
                vendors: 0
            });

            this.getView().setModel(oKPIModel, "kpi");

            this._loadKPIs();
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


            } catch (error) {
                console.error(error);
            }
        }
    });
});