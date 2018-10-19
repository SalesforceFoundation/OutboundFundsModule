({
    INTERVAL_TYPES: ['Week','Month','Year'],
    COLUMN_DEF: [
        {   label: 'Amount',
            fieldName: 'amount',
            type: 'currency',
            editable: true,
            cellAttributes: {
                alignment: 'center'
            }
        },
        {   label: 'Scheduled Date',
            fieldName: 'scheduleDate',
            type: 'date-local',
            // type: 'date',
            typeAttributes: {
                year: 'numeric',
                month: 'numeric',
                day: 'numeric'
            },
            editable: true,
            cellAttributes: {
                alignment: 'center'
            }
        }
    ],

    init: function (cmp) {
        // Get the data from the database using the record id from force:hasRecordId
        var recordId = cmp.get("v.recordId");
        if(recordId!=null) {
            this.getModel(cmp);
        }
        cmp.set('v.data.formData.firstDate', new Date().toLocaleDateString());
        cmp.set('v.data.intervalTypes', this.INTERVAL_TYPES);
        cmp.set('v.data.columns', this.COLUMN_DEF);
    },

    getModel: function (cmp) {
        var params = { objectId: cmp.get("v.recordId") };
        this.callServer(cmp,'c.getViewModel',params, function (r) {
            cmp.set('v.model',r);

            // After the model is loaded set the default total
            cmp.set('v.data.formData.paymentTotal', cmp.get('v.model.fundingRequest.totalRemaining'));
        });
    },

    calcDisp: function (cmp) {

        var d = cmp.get('v.data').formData;
        var m = cmp.get('v.model');

        var paymentCount = d.paymentCount;

        var paymentAmt = d.paymentTotal / paymentCount;
        var intervalType = d.intervalType;

        var startDate = new Date( d.firstDate );

        var intervalNum = d.intervalCount;
        var remainder = (paymentAmt * 100) % paymentCount;

        var disbursements = [];

        for (var i = 0; i < paymentCount; i++) {
            var thisPayment = paymentAmt;
            var dateObject = new Date(startDate);

            if(i > 0){

                var interval = i*intervalNum;

                // Figure out what the date should be
                if(intervalType == 'Week'){
                    dateObject.setDate(dateObject.getDate() + interval * 7);
                } else if(intervalType == 'Month'){
                    dateObject = this.addMonths(dateObject, interval);
                } else if(intervalType == 'Year'){
                    dateObject.setFullYear(dateObject.getFullYear() + interval);
                }
            }

            if(this.countDecimals(thisPayment) > 2 ){
                // Round down to the nearest decimal
                thisPayment = Math.floor(thisPayment * 100) / 100;
                // If there was a remainder, add it here
                if(i < remainder){
                    thisPayment += 0.01;
                }
                thisPayment = Math.round(thisPayment * 100) / 100;
            }

            disbursements.push({
                // Calculated Properties
                id: ''+i,
                amount: thisPayment,
                scheduleDate: dateObject,
                requestId: m.fundingRequest.recordId
            });
        }
        cmp.set('v.data.disbursements',disbursements);
    },

    countDecimals: function(value) {
        if(Math.floor(value) === value) return 0;
        return value.toString().split(".")[1].length || 0;
    },

    setDispursementProperty: function(cmp, changedField) {
        var disps = cmp.get('v.data.disbursements');

        disps.forEach(function(el) {
            if(el.id == changedField.id) {

                // the order of objects passed into assign matters
                var updatedDisbursement = Object.assign(el, changedField);

                // Put the newly updated disbursement into the datamodel
                disps.splice(parseInt(el.id),1,updatedDisbursement)

                cmp.set('v.data.disbursements', disps);
            }
        });
    },

    saveDisps: function(cmp) {
        var dsps = cmp.get("v.data.disbursements");
        var dspsString =  JSON.stringify( this.processDatesForAex(dsps) );
        var params = { dispListString: dspsString  };
        this.callServer(cmp,'c.saveDisbursements',params, function (r) {
            $A.get("e.force:closeQuickAction").fire();
            this.showToast('Disbursements successfully saved.','success');
        });
    },

    processDatesForAex: function(disbursements) {
        disbursements.forEach(function(d) {
            // Using a pre-determined date format that the APEX JSON parser will be able to understand,
            d.scheduleDate = $A.localizationService.formatDate(d.scheduleDate, "yyyy-MM-dd");
        });

        return disbursements;
    },

    addMonths: function(date, months) {
        var d = date.getDate();
        date.setMonth(date.getMonth() + +months);
        if (date.getDate() != d) {
            date.setDate(0);
        }
        return date;
    },

    callServer: function (cmp, method, params, callback) {
        var action = cmp.get(method);
        if(params){
            action.setParams(params);
        }
        action.setCallback(this, function(a) {
            if (a.getState() === "SUCCESS") {
                if (typeof callback === 'function') {
                    callback( a.getReturnValue() );
                }
            } else {
                var errors = a.getError();
                var message = 'Unknown Error.';
                if (errors && Array.isArray(errors) && errors.length) {
                    message = errors[0].message;
                }

                this.showToast(message,'error',cmp);
            }
        });

        $A.enqueueAction(action);
    },

    // Types:  'error', 'warning', 'success', or 'info'
    showToast: function(message, type, cmp) {

        // Need this workaround because e.force:showToast toasts are hidden behind quick actions
        if(type=='error' && typeof cmp != "undefined"){

            cmp.find('notifLib').showNotice({
                "variant": 'error',
                "header": 'Error',
                "message": message
            });

        } else {

            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                type: type,
                message: message
            });
            toastEvent.fire();

        }
    },
})