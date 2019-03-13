$ ->
  $(".new_broken_link_form").submit ->
    if confirm('Report Broken Link?')
      $this = $(this);
      $.ajax
        type: 'POST',
        url: $this.attr('action'),
        data: $this.serialize(),
        dataType: 'json',
        success: (json) ->
          $el = $this.find('.report-broken-link').first();
          $el.attr("disabled", "disabled");
          $el.addClass('disabled');
          $el.replaceWith('<small>Reported</small>');
        error: () ->
          alert 'Error.'

    return false;


