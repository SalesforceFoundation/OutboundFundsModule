({
    doInit: function (cmp, event, helper) {
        helper.init(cmp);
    },

    calculate: function (cmp, event, helper) {
        helper.calcDisp(cmp);
    },

    handleLWCRowChange: function (cmp, event, helper) {
        var draftValue = event.getParams();

        // Edits to be saved immediately to the in-memory disbursement
        helper.setDisbursementProperty(cmp, draftValue);
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
