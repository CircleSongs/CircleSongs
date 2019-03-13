$ ->
  $(".new_broken_link_report").submit ->
    if confirm('Report Broken Link?')
      $this = $(this);
      $.ajax
        type: 'POST',
        url: $this.attr('action'),
        data: $this.serialize(),
        dataType: 'json',
        success: (json) ->
          $this.closest('.recording').replaceWith(json.recording.html);
        error: () ->
          alert 'Error.'

    return false;


