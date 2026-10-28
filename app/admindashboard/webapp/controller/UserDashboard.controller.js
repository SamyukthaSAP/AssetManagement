sap.ui.define([
    "sap/ui/core/mvc/Controller",
    "sap/ui/model/json/JSONModel"
], function (Controller, JSONModel) {
    "use strict";

    return Controller.extend(
        "admindashboard.controller.UserDashboard",
        {


            onInit: async function () {

                var oModel = this.getOwnerComponent().getModel();

                var oBinding = oModel.bindList("/EmployeeSrv");

                var aContexts = await oBinding.requestContexts(0, 10);

                console.log("CONTEXTS", aContexts);

                if (aContexts.length > 0) {

                    var oEmployee = aContexts[0].getObject();

                    console.log("EMPLOYEE", oEmployee);

                    this.getView().setModel(
                        new JSONModel(oEmployee),
                        "employee"
                    );
                    console.log(
                        this.getView().getModel("employee").getData()
                    );
                    var sDeptId = oEmployee.dept_dept_id;

                    var oDeptBinding = oModel.bindList("/DepartmentSrv");

                    var aDeptContexts = await oDeptBinding.requestContexts(0, 100);

                    var oDepartment = aDeptContexts
                        .map(c => c.getObject())
                        .find(d => d.dept_id === sDeptId);

                    this.getView().setModel(
                        new JSONModel(oDepartment),
                        "department"
                    );
                    var oAssignmentBinding =
                        oModel.bindList("/AssetAssignmentSrv");

                    var aAssignments =
                        await oAssignmentBinding.requestContexts(0, 100);

                    var aEmployeeAssignments =
                        aAssignments
                            .map(c => c.getObject())
                            .filter(a =>
                                a.employee_employee_id ===
                                oEmployee.employee_id
                            );

                    this.getView().setModel(
                        new JSONModel({
                            assets: aEmployeeAssignments
                        }),
                        "assets"
                    );
                    console.log(
                        aAssignments[0].getObject()
                    );

                }
                var oAssetBinding =
    oModel.bindList("/AssetSrv");

var aAssetContexts =
    await oAssetBinding.requestContexts(0, 100);

var aAssets =
    aAssetContexts.map(c => c.getObject());

console.log(aAssets);
var aAssetData = aEmployeeAssignments.map(function (oAssignment) {

    var oAsset = aAssets.find(function (a) {
        return a.asset_id === oAssignment.asset_asset_id;
    });

    return {
        asset_tag: oAsset?.asset_tag || "",
        model: oAsset?.model || "",
        status: oAsset?.status || "",
        assigned_date: oAssignment.assigned_date
    };
});
this.getView().setModel(
    new JSONModel({
        assets: aAssetData
    }),
    "assets"
);
this.getView().setModel(
    new JSONModel({
        history: aEmployeeAssignments
    }),
    "history"
);
this.getView().setModel(
    new JSONModel({
        assetCount: aAssetData.length
    }),
    "kpi"
);



            }

        });
}
);