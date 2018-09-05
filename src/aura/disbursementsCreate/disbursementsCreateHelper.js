({
    INTERVAL_TYPES: ['Month','Year'],
    init: function (component) {
        // Get the data from the database
        var recordId = component.get("v.recordId");
        if(recordId!=null) {
            this.getModel(component);
        }

        component.set('v.data.formData.firstDate', new Date().toISOString());
        component.set('v.data.intervalTypes', this.INTERVAL_TYPES);

        debugger;
    },
    getModel: function (component) {
        var params = { objectId: component.get("v.recordId") };
        var helper = this;
        this.callServer(component,'c.getViewModel',params, function (r) {
            component.set('v.model',r);
        });
    },

    calcDisp: function (component) {

        var dat = component.get('v.data');
        // console.log( JSON.stringify(dat) );

        var count = dat.paymentCount;
        var type = dat.intervalType;
        var date = new Date( dat.firstDate );

        var disps = [];

        for (var i = 1; i < count; i++) {

            if(type=='') {
                // something
            }

            // disps.push()
        }

        console.log(count);
        console.log(type);
        console.log(date);

        // {"paymentCount":1,"intervalCount":1,"intervalType":"Month","intervalTypes":["Month","Year"],"firstDate":"2018-08-01T21:33:11.531Z"}
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