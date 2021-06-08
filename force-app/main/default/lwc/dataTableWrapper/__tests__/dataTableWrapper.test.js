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

    it("should have at least one test", () => {
        expect(true).toBeTruthy();
    });

    it("should be accessible", async () => {
        await expect(component).toBeAccessible();
    });
});
