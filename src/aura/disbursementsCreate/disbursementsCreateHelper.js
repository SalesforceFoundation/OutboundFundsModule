({
    INTERVAL_TYPES: ['Week','Month','Year'],
    init: function (component) {
        // Get the data from the database
        var recordId = component.get("v.recordId");
        if(recordId!=null) {
            this.getModel(component);
        }

        component.set('v.data.formData.firstDate', new Date().toISOString());
        component.set('v.data.intervalTypes', this.INTERVAL_TYPES);

        // debugger;
    },
    getModel: function (component) {
        var params = { objectId: component.get("v.recordId") };
        var helper = this;
        this.callServer(component,'c.getViewModel',params, function (r) {
            component.set('v.model',r);
        });
    },

    calcDisp: function (component) {

        var d = component.get('v.data').formData;
        var m = component.get('v.model');

        // console.log( JSON.stringify(d) );

        var paymentCount = d.paymentCount;

        var paymentAmt = m.fundingRequest.awardedAmount / paymentCount;
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
                    dateObject.setMonth(dateObject.getMonth() + interval);
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
                dispDate: dateObject.toISOString(),

                scheduleDate: new Date().toISOString(),
                requestId: m.fundingRequest.recordId
            });
        }

        // debugger;
        component.set('v.data.disbursements',disbursements);

        // {"paymentCount":1,"intervalCount":1,"intervalType":"Month","intervalTypes":["Month","Year"],"firstDate":"2018-08-01T21:33:11.531Z"}
    },

    countDecimals: function(value) {
        if(Math.floor(value) === value) return 0;
        return value.toString().split(".")[1].length || 0;
    },

    setDispursementProperty: function(component, changedField) {
        let disps = component.get('v.data.disbursements');

        disps.forEach(function(el) {
            if(el.id == changedField.id) {

                // the order of objects passed into assign matters
                let updatedDisbursement = Object.assign(el, changedField);

                // Put the newly updated disbursement into the datamodel
                disps.splice(parseInt(el.id),1,updatedDisbursement)

                component.set('v.data.disbursements', disps);

            }
        });
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
                var message = 'Unknown error';
                if (errors && Array.isArray(errors) && errors.length) {
                    message = errors[0].message;
                }

                this.showToastError(message);
            }
        });

        $A.enqueueAction(action);
    },

    showToastError : function (errorMessage) {
        var showToast = $A.get('e.force:showToast');
        showToast.setParams(
            {
                'title': 'Error: ',
                'message': errorMessage,
                'type': 'error'
            }
        );
        showToast.fire();

    },
})