console.log("✅ time_entries.js loaded");

$(document).on('turbo:load', function () {
    console.log("🚀 turbo:load fired for time-entry-select");

    const $el = $('.time-entry-select');
    if ($el.length === 0) {
        console.warn("⚠️ No .time-entry-select found");
        return;
    }

    $el.select2({
        placeholder: "Search time entries...",
        minimumInputLength: 2,
        ajax: {
            url: $el.data('url'),
            dataType: 'json',
            delay: 250,
            data: function (params) {
                return { q: params.term };
            },
            processResults: function (data) {
                return {
                    results: data.map(function (entry) {
                        return { id: entry.id, text: `${entry.name} (${entry.duration}s)` };
                    })
                };
            }
        }
    });
});
