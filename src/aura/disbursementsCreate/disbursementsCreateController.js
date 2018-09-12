({
    doInit: function (component, event, helper) {
        helper.init(component);
    },
    calculate: function (component, event, helper) {
        helper.calcDisp(component);
    },
    disbursementsChange: function (component, event, helper) {
        var columnsDef = [
            { label: 'Amount', fieldName: 'amount', type: 'currency', cellAttributes: { alignment: 'center' }},
            { label: 'Disbursement Date', fieldName: 'dispDate', type: 'date-local', editable: true, cellAttributes: { alignment: 'center' }},
            { label: 'Scheduled Date', fieldName: 'scheduleDate', type: 'date-local', editable: true, cellAttributes: { alignment: 'center' }}
        ];
        component.set('v.data.columns', columnsDef);
        console.log( JSON.stringify( component.get('v.data.disbursements') )  );
    },
    handleRowChange: function (component, event, helper) {
        var draftValues = event.getParam('draftValues');

        console.log( draftValues );

        // We want any edits to be saved immediately to the in-memory disbursement
        helper.setDispursementProperty(component, draftValues[0]);

        debugger;

        // Since we live edit the pending disbursements, we'll clear the drafts
        component.find('disbursementTable').set('v.draftValues', null);
    },
    handleCancel: function () {
        $A.get("e.force:closeQuickAction").fire();
    }
})