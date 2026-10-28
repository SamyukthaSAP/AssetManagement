sap.ui.define([
    "sap/ui/core/mvc/Controller",
    "sap/ui/model/json/JSONModel"
], function (Controller, JSONModel) {
    "use strict";

    return Controller.extend("admindashboard.controller.AdminDashboard", {

        onInit: function () {
            // 1. Initialize KPI Model
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

            // 2. Initialize Empty Models for Tables to prevent binding errors
            this.getView().setModel(new JSONModel({ Assets: [] }), "assetsModel");
            this.getView().setModel(new JSONModel({ Maintenance: [] }), "maintenanceModel");

            // 3. Load Data
            this._loadKPIs();
            this._loadAssetList();
            this._loadMaintenanceList();
            this._loadWarrantyAlerts();
            this._loadMaintenanceSummary();
    this._loadCategoryChart();
    this._loadDepartmentChart();
    this._loadAssetsPerDepartment();
        },

        // Sidebar Navigation Handler
        onNavSelectionChange: function (oEvent) {
    var oItem = oEvent.getParameter("listItem");
    var sTitle = oItem.getTitle();
    var oNavContainer = this.byId("adminNavContainer");

    if (sTitle === "Dashboard Overview") {
        oNavContainer.to(this.byId("dashboardOverviewPage"));
    }
    else if (sTitle === "Asset Details") {
        window.location.assign("/assetlistpage/index.html");
}
else if (sTitle === "Asset Category Details") {
        window.location.assign("/assetcategorylistreport/index.html");
}
else if (sTitle === "Vendors Details") {
        window.location.assign("/vendorlistreportpage/index.html");
}
    else if (sTitle === "Asset Assignment Details") {
        window.location.assign("/assetassignment/index.html");
    }
     else if (sTitle === "Maintenance Details") {
        window.location.assign("/maintenance/index.html");
    }
     else if (sTitle === "Employee Details") {
        window.location.assign("/employeelistreportpage/index.html");
    }
     else if (sTitle === "Department Details") {
        window.location.assign("/departmentlistreportpage/index.html");
    }
    else if (sTitle === "Ownership Ledger") {
        window.location.assign("/ownershipledger/index.html");
    }
    else if (sTitle === "Archive") {
        window.location.assign("/archive/index.html");
    }
},
_fetchList: async function (sPath) {
    const response = await fetch("/odata/v4/asset-admin/" + sPath);
    if (!response.ok) {
        throw new Error(sPath + " failed with status " + response.status);
    }
    const result = await response.json();
    return result.value || [];
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
                        { Status: "Assigned", Count: result.assignedAssets },
                        { Status: "Repair", Count: result.repairAssets },
                        { Status: "Retired", Count: result.retiredAssets },
                        { Status: "Archived", Count: result.archivedAssets }
                    ]
                });

                this.getView().setModel(oChartModel, "chart");

            } catch (error) {
                console.error("Error loading KPIs:", error);
            }
        },

        _loadAssetList: async function () {
            try {
                const response = await fetch("/odata/v4/asset-admin/AssetSrv"); // Update with your actual OData entity endpoint
                const result = await response.json();
                this.getView().getModel("assetsModel").setData({ Assets: result.value || result });
            } catch (error) {
                console.error("Error loading asset list:", error);
            }
        },

        _loadMaintenanceList: async function () {
            try {
                const response = await fetch("/odata/v4/asset-admin/MaintenanceRecordSrv"); // Update with your actual OData entity endpoint
                const result = await response.json();
                this.getView().getModel("maintenanceModel").setData({ Maintenance: result.value || result });
            } catch (error) {
                console.error("Error loading maintenance list:", error);
            }
        },
        formatStatus: function(status) {
    const map = {
        in_stock: "In Stock",
        assigned: "Assigned",
        in_repair: "In Repair",
        retired: "Retired",
        archived: "Archived"
    };
    return map[status] || status;
},
        formatStatusState: function (sStatus) {
    switch (sStatus) {
        case "AVAILABLE":
            return "Success";
        case "ASSIGNED":
            return "Information";
        case "MAINTENANCE":
            return "Warning";
        case "RETIRED":
        case "ARCHIVED":
            return "Error";
        default:
            return "None";
    }
},
formatPriorityState: function(priority){
    switch(priority){
        case "High":
            return "Error";
        case "Medium":
            return "Warning";
        case "Low":
            return "Success";
        default:
            return "None";
    }
},
_loadWarrantyAlerts: async function () {

    try {

        const response = await fetch(
            "/odata/v4/asset-admin/AssetSrv"
        );

        const result = await response.json();

        const assets = result.value || [];

        const today = new Date();

        const next30Days = new Date();
        next30Days.setDate(today.getDate() + 30);

        let expired = 0;
        let expiringSoon = 0;

        assets.forEach(asset => {

            if (!asset.warranty_expiry) {
                return;
            }

            const warrantyDate =
                new Date(asset.warranty_expiry);

            if (warrantyDate < today) {

                expired++;

            } else if (
                warrantyDate >= today &&
                warrantyDate <= next30Days
            ) {

                expiringSoon++;

            }

        });

        this.getView().setModel(
            new JSONModel({
                expired: expired,
                expiringSoon: expiringSoon
            }),
            "warranty"
        );

    } catch (err) {

        console.error(
            "Warranty Alert Error",
            err
        );

    }

},
_loadMaintenanceSummary: async function () {
    try {
        const records = await this._fetchList("MaintenanceRecordSrv");
        const norm = (s) => (s || "").toLowerCase().replace(/[\s_]+/g, "");
        const count = (s) => records.filter(r => norm(r.status) === s).length;

        this.getView().setModel(new JSONModel({
            open: count("open"),
            inProgress: count("inprogress"),
            completed: count("completed")
        }), "maintenance");
    } catch (e) {
        console.error("Maintenance summary error:", e);
    }
},
_loadCategoryChart: async function () {

    const oModel = this.getView().getModel();

    const contexts = await oModel
        .bindList("/odata/v4/asset-admin/AssetSrv")
        .requestContexts();

    const assets = contexts.map(
        ctx => ctx.getObject()
    );

    const categoryMap = {};

    assets.forEach(asset => {

        const category =
            asset.assetCategory?.name ||
            "Unknown";

        categoryMap[category] =
            (categoryMap[category] || 0) + 1;

    });

    const chartData = [];

    Object.keys(categoryMap).forEach(key => {

        chartData.push({
            category: key,
            count: categoryMap[key]
        });

    });

    const oChartModel =
        new sap.ui.model.json.JSONModel({
            data: chartData
        });

    this.getView().setModel(
        oChartModel,
        "categoryChart"
    );

},
onAfterRendering: function () {

    const oChart =
        this.byId("idCategoryChart");

    if (oChart) {

        oChart.setVizProperties({

            title: {
                visible: true,
                text: "Assets by Category"
            },

            plotArea: {
                dataLabel: {
                    visible: true
                }
            },

            valueAxis: {
                title: {
                    visible: true
                }
            }

        });

    }

},
_loadDepartmentChart: async function () {

    const oModel = this.getView().getModel();

    const contexts =
        await oModel.bindList("/odata/v4/asset-admin/EmployeeSrv")
        .requestContexts();

    const employees =
        contexts.map(c => c.getObject());

    const deptMap = {};

    employees.forEach(emp => {

        const dept = emp.department || "Unknown";

        deptMap[dept] =
            (deptMap[dept] || 0) + 1;

    });

    const items = Object.keys(deptMap).map(key => ({
        Department: key,
        Count: deptMap[key]
    }));

    this.getView().setModel(
        new sap.ui.model.json.JSONModel({
            items: items
        }),
        "departmentChart"
    );

},
_loadAssetsPerDepartment: async function () {
    try {
        const response = await fetch(
            "/odata/v4/asset-admin/AssetSrv?$expand=current_holder_id($expand=dept)"
        );
        const result = await response.json();
        const aAssets = result.value || [];

        const mDepartments = {};
        aAssets.forEach(asset => {
            const holder = asset.current_holder_id;
            if (!holder) { return; }
            const deptName = holder.dept?.name || "Unknown";
            mDepartments[deptName] = (mDepartments[deptName] || 0) + 1;
        });

        const aChartData = Object.keys(mDepartments).map(key => ({
            department: key,
            count: mDepartments[key]
        }));

        this.getView().setModel(new JSONModel(aChartData), "deptChart");
    } catch (error) {
        console.error("Error loading department chart:", error);
    }
},
_loadRequests: async function () {
    try {
        const items = await this._fetchList(
            "AssetRequestSrv?$expand=employee,asset_category&$filter=status eq 'pending'"
        );
        this.getView().setModel(new JSONModel({ items }), "requests");
    } catch (e) {
        console.error("Requests load error:", e);
    }
},

_decide: async function (oEvent, sStatus) {
    const req = oEvent.getSource().getBindingContext("requests").getObject();
    try {
        const response = await fetch(
            "/odata/v4/asset-admin/AssetRequestSrv(" + req.request_id + ")",
            {
                method: "PATCH",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ status: sStatus })
            }
        );
        if (!response.ok) {
            throw new Error("Update failed with status " + response.status);
        }
        sap.m.MessageToast.show("Request " + sStatus);
        this._loadRequests();
    } catch (e) {
        console.error("Decision error:", e);
    }
},

onApprove: function (oEvent) { this._decide(oEvent, "approved"); },
onReject:  function (oEvent) { this._decide(oEvent, "rejected"); },


    });
});