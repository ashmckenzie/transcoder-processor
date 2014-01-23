$(document).ready(function() {

  // Transcode
  //
  $('a.transcode').on('click', function(e) {
    url = "/transcode"
    file = $(e.target).parents('div').data('file');
    $.post(url, { file: file }).done(function() { window.location.reload() });
  });

  // Cancel transcode
  //
  $('a.cancel-transcode').on('click', function(e) {
    url = "/cancel-transcode"
    media_file_id = $(e.target).parents('div').data('media-file-id');
    $.post(url, { id: media_file_id }).done(function() { window.location.reload() });
  });
});
