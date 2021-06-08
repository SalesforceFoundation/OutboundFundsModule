import { createElement } from "lwc";
import DataTableWrapper from "c/dataTableWrapper";

//jest.mock("lightning/datatable");

describe("c/dataTableWrapper", () => {
    let component;

    beforeEach(() => {
        component = createElement("c-data-table-wrapper", {
            is: DataTableWrapper,
        });
        document.body.appendChild(component);
    });

    afterEach(() => {
        document.body.removeChild(component);
        component = null;
    });

    it("FIXME should get code coverage for handleRowChange", () => {
        // Fires lightning-datatable cellchange event.
        const draftValueChangedHandler = jest.fn();
        component.addEventListener("draftvaluechange", draftValueChangedHandler);

        // Get lightning-datatable.
        const datatable = component.shadowRoot.querySelector("lightning-datatable");
        expect(datatable).not.toBeNull();

        // Set draftValues and fire cellchange event.
        const draftValues = [jest.fn(), jest.fn()];
        datatable.dispatchEvent(
            new CustomEvent("cellchange", {
                detail: {
                    draftValues: draftValues,
                },
            })
        );

        expect(draftValueChangedHandler).toHaveBeenCalledTimes(1);
        expect(draftValueChangedHandler.mock.calls[0][0]).toHaveProperty(
            "detail",
            draftValues[0]
        );
    });

    it("should be accessible", async () => {
        await expect(component).toBeAccessible();
    });
});
