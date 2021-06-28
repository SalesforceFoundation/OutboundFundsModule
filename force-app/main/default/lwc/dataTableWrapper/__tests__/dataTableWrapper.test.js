import { createElement } from "lwc";
import DataTableWrapper from "c/dataTableWrapper";

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

    it("should dispatch draftvaluechange on row change", () => {
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
    it("should display the lightning-datatable", () => {
        const checksTable = component.shadowRoot.querySelector("lightning-datatable");
        let expectedEmptyColumns = [];
        expect(checksTable.columns).not.toBe(null);
        expect(checksTable.columns).toStrictEqual(expectedEmptyColumns);
        expect(checksTable.records).not.toBe(null);
        expect(checksTable.keyField).toBe("id");
        //set columns
        let expectedColumns = ["Name", "Phone"];
        checksTable.columns = expectedColumns;
        expect(checksTable.columns).toStrictEqual(expectedColumns);
    });
    it("should be accessible", async () => {
        await expect(component).toBeAccessible();
    });
});
