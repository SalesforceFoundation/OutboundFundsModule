({
    doInit: function (cmp, event, helper) {
        helper.init(cmp);
    },

    calculate: function (cmp, event, helper) {
        helper.calcDisp(cmp);
    },

    handleRowChange: function (cmp, event, helper) {
        var draftValues = event.getParam("draftValues");

        // Edits to be saved immediately to the in-memory disbursement
        helper.setDispursementProperty(cmp, draftValues[0]);

        // Since we live edit the pending disbursements, we'll clear the drafts
        cmp.find("disbursementTable").set("v.draftValues", null);
    },

    handleSave: function (cmp, event, helper) {
        helper.saveDisps(cmp, event);
    },

    inputBlur: function (cmp, event, helper) {
        helper.validate(cmp);
    },

    handleCancel: function () {
        $A.get("e.force:closeQuickAction").fire();
    }
});
