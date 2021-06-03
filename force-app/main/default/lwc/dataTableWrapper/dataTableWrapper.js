import { LightningElement, api } from "lwc";

export default class DataTableWrapper extends LightningElement {
    @api keyField = "id";
    @api records = [];
    @api columns = [];

    handleRowChange(event) {
        const draftValue = event.detail.draftValues[0];
        const custEvent = new CustomEvent("draftvaluechange", {
            detail: draftValue,
        });
        this.dispatchEvent(custEvent);
    }
}
