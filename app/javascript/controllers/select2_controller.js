// app/javascript/controllers/select2_controller.js


import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static values = {
        url: String,
        preselectedIds: String
    }
    connect() {
        const url = this.urlValue;                     // Automatically provided by Stimulus
        const saved_element_ref = this.element

        console.log("🟢 Select2 controller connected");
        console.log(`Select2 detected url: ${url}`);

        $(this.element).select2({
            ajax: {
                url: url,
                dataType: 'json',
                delay: 250,
                data: function (params) {
                    const currentSelectedIds = $(saved_element_ref).val() || [];
                    console.log("currently Selected IDs:", currentSelectedIds)
                    return {
                        q: params.term,
                        exclude_ids: currentSelectedIds  // Now no function call needed cause alrdy array
                    };
                },
                processResults: function (data) {
                    return {
                        results: data.map(entry => ({
                            id: entry.id,
                            text: entry.text  // your controller returns { id, text }
                        }))
                    };
                }
            },
            placeholder: 'Search time entries',
            allowClear: true,
            width: '100%'
        })
    }
}

