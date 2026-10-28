sap.ui.define([
    "sap/ui/core/mvc/Controller",
    "sap/ui/model/json/JSONModel",
    "sap/ui/model/Filter",
    "sap/ui/model/FilterOperator"
], function (Controller, JSONModel) {
    "use strict";

    const SERVICE = "/odata/v4/asset-manager/";
    const DEPT_NAME = "IT";

    const norm = (s) => (s || "").toLowerCase().replace(/[\s_]+/g, "");

    return Controller.extend("admindashboard.controller.ManagerDashboard", {

        onInit: function () {
            this.getView().setModel(new JSONModel({
                totalAssets: 0, assignedAssets: 0, repairAssets: 0,
                retiredAssets: 0, archivedAssets: 0,
                employees: 0, vendors: 0, departments: 1
            }), "kpi");
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

        _fetchList: async function (sPath) {
            const response = await fetch(SERVICE + sPath);
            if (!response.ok) {
                throw new Error(sPath + " failed with status " + response.status);
            }
            const result = await response.json();
            return result.value || [];
        },

        _loadKPIs: async function () {
            try {
                const [assets, employees] = await Promise.all([
                    this._fetchList("AssetSrv?$expand=current_holder_id($expand=dept),asset_category"),
                    this._fetchList("EmployeeSrv?$expand=dept")
                ]);

                const itAssets = assets.filter(a =>
                    a.current_holder_id?.dept?.name === DEPT_NAME);
                const itEmployees = employees.filter(e => e.dept?.name === DEPT_NAME);

                const count = (s) => itAssets.filter(a => norm(a.status) === s).length;

                this.getView().getModel("kpi").setData({
                    totalAssets: itAssets.length,
                    assignedAssets: count("assigned"),
                    repairAssets: count("inrepair"),
                    retiredAssets: count("retired"),
                    archivedAssets: count("archived"),
                    employees: itEmployees.length,
                    vendors: 0,
                    departments: 1
                });

                this.getView().setModel(new JSONModel({
                    items: [
                        { Status: "Assigned", Count: count("assigned") },
                        { Status: "Repair", Count: count("inrepair") },
                        { Status: "Retired", Count: count("retired") },
                        { Status: "Archived", Count: count("archived") }
                    ]
                }), "chart");

                const catMap = {};
                itAssets.forEach(a => {
                    const name = a.asset_category?.name || "Unknown";
                    catMap[name] = (catMap[name] || 0) + 1;
                });
                this.getView().setModel(new JSONModel({
                    items: Object.keys(catMap).map(k => ({ label: k, count: catMap[k] }))
                }), "deptChart");
                this.getView().setModel(new JSONModel({
            items: itEmployees
        }), "empModel");

            } catch (e) {
                console.error("Manager KPI error:", e);
            }
        },
        onEmployeeSearch: function (oEvent) {
    const sQuery = oEvent.getParameter("newValue");
    const aFilters = sQuery
        ? [new Filter("full_name", FilterOperator.Contains, sQuery)]
        : [];
    this.byId("employeeTable").getBinding("items").filter(aFilters);
},
onRaiseTicket: async function (oEvent) {
    const emp = oEvent.getSource().getBindingContext("empModel").getObject();

    this.getView().setModel(new JSONModel({
        employeeId: emp.employee_id,
        employeeName: emp.full_name,
        categoryId: "",
        remarks: ""
    }), "ticket");

    if (!this._oDialog) {
        this._oDialog = await Fragment.load({
            id: this.getView().getId(),
            name: "admindashboard.view.RaiseTicketDialog",
            controller: this
        });
        this.getView().addDependent(this._oDialog);
    }

    try {
        const cats = await this._fetchList("AssetCategorySrv");
        this.getView().setModel(new JSONModel({ items: cats }), "catModel");
    } catch (e) {
        console.error("Category load error:", e);
    }

    this._oDialog.open();
},

onCancelTicket: function () {
    this._oDialog.close();
},

onSubmitTicket: async function () {
    const t = this.getView().getModel("ticket").getData();

    if (!t.categoryId) {
        sap.m.MessageToast.show("Please select an asset category");
        return;
    }

    try {
        const response = await fetch(SERVICE + "AssetRequestSrv", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({
                employee_employee_id: t.employeeId,
                asset_category_asset_category_id: t.categoryId,
                remarks: t.remarks
            })
        });
        if (!response.ok) {
            throw new Error("Create failed with status " + response.status);
        }
        sap.m.MessageToast.show("Ticket sent to admin");
        this._oDialog.close();
    } catch (e) {
        console.error("Ticket error:", e);
        sap.m.MessageToast.show("Could not raise ticket");
    }
},

    });
});