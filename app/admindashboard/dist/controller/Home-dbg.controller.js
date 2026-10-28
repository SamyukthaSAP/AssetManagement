sap.ui.define([
    "sap/ui/core/mvc/Controller"
], function (Controller) {
    "use strict";

    return Controller.extend(
        "admindashboard.controller.Home",
        {

            onAdminPress: function () {
                this.getOwnerComponent()
                    .getRouter()
                    .navTo("RouteAdminDashboard");
            },

            onManagerPress: function () {
                this.getOwnerComponent()
                    .getRouter()
                    .navTo("RouteManagerDashboard");
            },

            onUserPress: function () {
                window.location.href =
                    "/userassets/index.html";
            }

        }
    );
});