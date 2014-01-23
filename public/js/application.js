$(document).ready(function() {
  $('a.transcode').on('click', function(e) {
    url = "/transcode"
    file = $(e.target).parents('div').data('file');

    $.post(url, { file: file });
  });
});
