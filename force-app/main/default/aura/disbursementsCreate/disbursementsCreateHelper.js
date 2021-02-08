({
    DEFAULT_MODEL: {},
    VIEW_MODEL: {},

    init: function (cmp) {
        // Set Default Model Values
        this.setDefaultModel(cmp);
        // reset VM every load
        this.DEFAULT_MODEL = JSON.parse(JSON.stringify(cmp.get("v.defaultModel")));
        this.VIEW_MODEL = this.DEFAULT_MODEL;

        // Set the view model
        cmp.set("v.model", this.VIEW_MODEL);

        // Get the data from the database using the record id from force:hasRecordId
        var recordId = cmp.get("v.recordId");
        if (recordId != null) {
            this.getRequestData(cmp);
        }

        cmp.set(
            "v.model.formData.firstDate",
            $A.localizationService.formatDate(new Date(), "yyyy-MM-dd")
        );
    },

    getRequestData: function (cmp) {
        var params = { reqId: cmp.get("v.recordId") };
        var parent = this;
        this.callServer(cmp, "c.getFundRequest", params, function (r) {
            var model = cmp.get("v.model");

            model.request = r;

            // Update labels and options
            model.formDefaults.columns[0].label = r.disbursementLabels.Amount__c;
            model.formDefaults.columns[1].label = r.disbursementLabels.Scheduled_Date__c;
            model.formDefaults.intervalTypes.forEach(function (intervalType) {
                intervalType.label = r.intervalTypes[intervalType.value];
            });

            // After the model is loaded set the default total
            model.formData.paymentTotal = model.request.totalRemaining;

            cmp.set("v.model", model);

            parent.validate(cmp);
        });
    },

    calcDisp: function (cmp) {
        const WEEK = "Week";
        const MONTH = "Month";
        const YEAR = "Year";

        var m = cmp.get("v.model");
        var d = m.formData;

        var paymentCount = d.paymentCount;
        var intervalType = d.intervalType;

        var startDate = new Date(d.firstDate + "T00:00:00");

        var intervalNum = d.intervalCount;

        // Payment Calculating and remainder handling
        var totalAmount = d.paymentTotal;
        var paymentAmt = d.paymentTotal / paymentCount;
        var paymentRounded = Math.floor(paymentAmt * 100) / 100;
        var remainder = Math.round((totalAmount - paymentRounded * paymentCount) * 100);

        var disbursements = [];

        for (var i = 0; i < paymentCount; i++) {
            var thisPayment = paymentRounded;
            var dateObject = new Date(startDate);

            if (i > 0) {
                var interval = i * intervalNum;

                // Figure out what the date should be
                if (intervalType == WEEK) {
                    dateObject.setDate(dateObject.getDate() + interval * 7);
                } else if (intervalType == MONTH) {
                    dateObject = this.addMonths(dateObject, interval);
                } else if (intervalType == YEAR) {
                    dateObject.setFullYear(dateObject.getFullYear() + interval);
                }
            }

            if (this.countDecimals(paymentAmt) > 2) {
                // Round down to the nearest decimal
                thisPayment = Math.floor(thisPayment * 100) / 100;

                // If there was a remainder, add it here to distribute
                if (i < remainder) {
                    thisPayment += 0.01;
                }

                thisPayment = Math.round(thisPayment * 100) / 100;
            }

            disbursements.push({
                // Calculated Properties
                id: "" + i, // A workaround to force the datatable to see this id as a string
                amount: thisPayment,
                scheduleDate: dateObject,
                requestId: m.request.recordId
            });
        }

        cmp.set("v.model.disbursements", disbursements);
    },

    countDecimals: function (value) {
        if (Math.floor(value) === value) return 0;
        return value.toString().split(".")[1].length || 0;
    },

    setDispursementProperty: function (cmp, changedField) {
        var disbursements = cmp.get("v.model.disbursements");

        disbursements.forEach(function (el) {
            if (el.id == changedField.id) {
                // the order of objects passed into assign matters
                var updatedDisbursement = Object.assign(el, changedField);

                // Put the newly updated disbursement into the datamodel
                disbursements.splice(parseInt(el.id), 1, updatedDisbursement);

                cmp.set("v.model.disbursements", disbursements);
            }
        });
    },

    saveDisps: function (cmp) {
        var model = cmp.get("v.model");
        var disbursementsJson = JSON.stringify(
            this.processDatesForAex(model.disbursements)
        );
        var params = { dispListString: disbursementsJson };
        var that = this;
        this.callServer(cmp, "c.saveDisbursements", params, function () {
            that.showToast(model.request.uiMessages.SavedMessage, "success", cmp);
            // Clear these out after saved
            cmp.set("v.model.disbursements", null);

            // Refresh Record Page
            $A.get("e.force:refreshView").fire();

            $A.get("e.force:closeQuickAction").fire();
        });
    },

    processDatesForAex: function (disbursements) {
        disbursements.forEach(function (d) {
            // Using a pre-determined date format that the APEX JSON parser will be able to understand,
            d.scheduleDate = $A.localizationService.formatDate(
                d.scheduleDate,
                "yyyy-MM-dd"
            );
        });

        return disbursements;
    },

    addMonths: function (date, count) {
        if (date && count) {
            var m,
                d = (date = new Date(+date)).getUTCDate();

            date.setUTCMonth(date.getUTCMonth() + count, 1);
            m = date.getUTCMonth();
            date.setUTCDate(d);
            if (date.getUTCMonth() !== m) date.setUTCDate(0);
        }
        return date;
    },

    inputBlur: function (cmp) {
        this.validateTotal(cmp);
    },

    callServer: function (cmp, method, params, callback) {
        const UNKNOWN_ERROR = "Unknown Error.";
        var action = cmp.get(method);
        if (params) {
            action.setParams(params);
        }
        action.setCallback(this, function (a) {
            if (a.getState() === "SUCCESS") {
                if (typeof callback === "function") {
                    callback(a.getReturnValue());
                }
            } else {
                var errors = a.getError();
                var message = UNKNOWN_ERROR;
                if (errors && Array.isArray(errors) && errors.length) {
                    message = errors[0].message;
                }

                this.showToast(message, "error", cmp);
            }
        });

        $A.enqueueAction(action);
    },

    // Types:  'error', 'warning', 'success', or 'info'
    showToast: function (message, type, cmp) {
        const ERROR = "error";
        // Need this workaround because e.force:showToast toasts are hidden behind quick actions
        if (type == "error" && typeof cmp != "undefined") {
            cmp.find("notifLib").showNotice({
                variant: "error",
                header: ERROR,
                message: message
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

    validate: function (cmp) {
        // Reset the messages each time we validate
        cmp.set("v.model.uiMessages", []);

        // Verify Amount remaining
        this.validateAmountRemaining(cmp);

        this.validateTotal(cmp);
    },

    validateAmountRemaining: function (cmp) {
        var r = cmp.get("v.model.request");

        if (r.totalRemaining <= 0) {
            this.addMessage(
                cmp,
                r.uiMessages.Error,
                "error",
                r.uiMessages.NoFundsRemaining
            );
        }
    },

    validateTotal: function (cmp) {
        var m = cmp.get("v.model");
        var remaining = m.request.totalRemaining;
        var total = m.formData.paymentTotal;

        if (total > remaining) {
            this.addMessage(
                cmp,
                m.request.uiMessages.Error,
                "error",
                m.request.uiMessages.PaymentsExceedFunds,
                true
            );
        }
    },

    addMessage: function (cmp, title, severity, message, closeable) {
        var m = cmp.get("v.model");
        m.uiMessages.push({
            title: title,
            severity: severity,
            message: message,
            closeable: closeable || false
        });

        cmp.set("v.model", m);
    },

    setDefaultModel: function (cmp) {
        const WEEK = "Week";
        const MONTH = "Month";
        const YEAR = "Year";
        const AMOUNT = "Amount";
        const SCHEDULE_DATE = "Scheduled Date";

        let defaultModel = {
            request: null,
            formData: {
                paymentCount: 1,
                paymentTotal: 0,
                firstDate: null,
                intervalCount: 1,
                intervalType: MONTH
            },
            formDefaults: {
                intervalTypes: [
                    {
                        value: WEEK,
                        label: WEEK
                    },
                    {
                        value: MONTH,
                        label: MONTH
                    },
                    {
                        value: YEAR,
                        label: YEAR
                    }
                ],
                columns: [
                    {
                        label: AMOUNT,
                        fieldName: "amount",
                        type: "currency",
                        editable: true,
                        cellAttributes: {
                            alignment: "left"
                        }
                    },
                    {
                        label: SCHEDULE_DATE,
                        fieldName: "scheduleDate",
                        type: "date-local",
                        typeAttributes: {
                            year: "numeric",
                            month: "numeric",
                            day: "numeric"
                        },
                        editable: true,
                        cellAttributes: {
                            alignment: "left"
                        }
                    }
                ]
            },
            disbursements: [],
            uiMessages: []
        };
        cmp.set("v.defaultModel", defaultModel);
    }
});
