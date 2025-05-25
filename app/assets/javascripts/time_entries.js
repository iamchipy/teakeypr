$(document).on('turbo:load', function () {
    $('.time-entry-select').select2({
        placeholder: "Search time entries...",
        minimumInputLength: 2,
        ajax: {
            url: $('.time-entry-select').data('url'),
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