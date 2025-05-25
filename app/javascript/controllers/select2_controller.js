import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    connect() {
        console.log("🟢 Select2 controller connected");

        if (typeof window.$ === "undefined" || typeof window.$.fn.select2 === "undefined") {
            console.warn("Select2 not loaded yet. Retrying...");
            setTimeout(() => this.connect(), 100);
            return;
        }

        console.log("🟢 Initializing Select2 on:", this.element);
        $(this.element).select2();
    }
}
