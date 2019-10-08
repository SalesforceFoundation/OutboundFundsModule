({
    DEFAULT_MODEL: {
        request: null,
        formData: {
            paymentCount: 1,
            paymentTotal: 0,
            firstDate: null,
            intervalCount: 1,
            intervalType: 'Month',
        },
        formDefaults: {
            intervalTypes: ['Week','Month','Year'],
            columns: [
                {   label: 'Amount',
                    fieldName: 'amount',
                    type: 'currency',
                    editable: true,
                    cellAttributes: {
                        alignment: 'left'
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
                        alignment: 'left'
                    }
                }
            ],
        },
        disbursements:[],
        uiMessages: [],
    },

    VIEW_MODEL: {},

    init: function (cmp) {

        // reset VM every load
        this.VIEW_MODEL = this.DEFAULT_MODEL;

        // Set the view model
        cmp.set('v.model', this.VIEW_MODEL);

        // Get the data from the database using the record id from force:hasRecordId
        var recordId = cmp.get("v.recordId");
        if(recordId != null) {
            this.getRequestData(cmp);
        }

        cmp.set('v.model.formData.firstDate', $A.localizationService.formatDate(new Date(), "yyyy-MM-dd"));
    },

    getRequestData: function (cmp) {
        var params = { reqId: cmp.get("v.recordId") };
        var parent = this;
        this.callServer(cmp,'c.getFundRequest',params, function (r) {
            cmp.set('v.model.request',r);

            // After the model is loaded set the default total
            cmp.set('v.model.formData.paymentTotal', cmp.get('v.model.request.totalRemaining'));

            parent.validate(cmp);
        });
    },

    calcDisp: function (cmp) {

        var m = cmp.get('v.model');
        var d = m.formData;

        var paymentCount = d.paymentCount;
        var intervalType = d.intervalType;

        var startDate = new Date( d.firstDate );

        var intervalNum = d.intervalCount;

        // Payment Calculating and remainder handling
        var totalAmount = d.paymentTotal;
        var paymentAmt = d.paymentTotal / paymentCount;
        var paymentRounded = Math.floor(paymentAmt * 100) / 100;
        var remainder = Math.round((totalAmount - (paymentRounded * paymentCount))*100);

        var disbursements = [];

        for (var i = 0; i < paymentCount; i++) {
            var thisPayment = paymentRounded;
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

            if(this.countDecimals(paymentAmt) > 2 ) {
                // Round down to the nearest decimal
                thisPayment = Math.floor(thisPayment * 100) / 100;

                // If there was a remainder, add it here to distribute
                if(i < remainder){
                    thisPayment += 0.01;
                }

                thisPayment = Math.round(thisPayment * 100) / 100;
            }

            disbursements.push({
                // Calculated Properties
                id: ''+i, // A workaround to force the datatable to see this id as a string
                amount: thisPayment,
                scheduleDate: dateObject,
                requestId: m.request.recordId
            });
        }

        cmp.set('v.model.disbursements',disbursements);
    },

    countDecimals: function(value) {
        if(Math.floor(value) === value) return 0;
        return value.toString().split(".")[1].length || 0;
    },

    setDispursementProperty: function(cmp, changedField) {
        var disps = cmp.get('v.model.disbursements');

        disps.forEach(function(el) {
            if(el.id == changedField.id) {

                // the order of objects passed into assign matters
                var updatedDisbursement = Object.assign(el, changedField);

                // Put the newly updated disbursement into the datamodel
                disps.splice(parseInt(el.id),1,updatedDisbursement)

                cmp.set('v.model.disbursements', disps);
            }
        });
    },

    saveDisps: function(cmp) {
        var dsps = cmp.get("v.model.disbursements");
        var dspsString =  JSON.stringify( this.processDatesForAex(dsps) );
        var params = { dispListString: dspsString  };
        var that = this;
        this.callServer(cmp,'c.saveDisbursements',params, function () {
            that.showToast('Disbursements successfully saved.','success', cmp);
            // Clear these out after saved
            cmp.set('v.model.disbursements',null);

            // Refresh Record Page
            $A.get("e.force:refreshView").fire();

            $A.get("e.force:closeQuickAction").fire();
        });
    },

    processDatesForAex: function(disbursements) {
        disbursements.forEach(function(d) {
            // Using a pre-determined date format that the APEX JSON parser will be able to understand,
            d.scheduleDate = $A.localizationService.formatDate(d.scheduleDate, "yyyy-MM-dd");
        });

        return disbursements;
    },

    addMonths: function(date, count) {
        if (date && count) {
            var m, d = (date = new Date(+date)).getUTCDate()

            date.setUTCMonth(date.getUTCMonth() + count, 1)
            m = date.getUTCMonth()
            date.setUTCDate(d)
            if (date.getUTCMonth() !== m) date.setUTCDate(0)
        }
        return date
    },

    inputBlur: function(cmp) {
        this.validateTotal(cmp);
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

    validate: function(cmp){

        // Reset the messages each time we validate
        cmp.set('v.model.uiMessages', []);

        // Verify Amount remaining
        this.validateAmountRemaining(cmp);

        this.validateTotal(cmp);
    },

    validateAmountRemaining: function(cmp){
        var r = cmp.get('v.model.request');

        if(r.totalRemaining <= 0) {
            this.addMessage(cmp, 'Error','error', 'There are not enough funds remaining to create disbursements');
        }
    },

    validateTotal: function(cmp){
        var m = cmp.get('v.model');
        var remaining = m.request.totalRemaining;
        var total = m.formData.paymentTotal;

        if(total > remaining) {
            this.addMessage(cmp, 'Error','error', 'The amount of payments cannot exceed available funds.', true);
        }
    },

    addMessage: function(cmp, title, severity, message, closeable) {
        var m = cmp.get('v.model');
        m.uiMessages.push({
            title: title,
            severity: severity,
            message: message,
            closeable: closeable || false,
        });

        cmp.set('v.model', m);
    },
})