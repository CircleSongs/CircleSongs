$(function() {
  $('form.new_broken_link_report').on('keypress', e => {
    if (e.keyCode == 13) {
      return false;
    }
  });

  $(".new_broken_link_report").on(
    "ajax:success", (event) => {
      [data, status, xhr] = event.detail;
      $html = JSON.parse(xhr.responseText).recording.html;
      console.log($(event.target).closest('.recording'))
      $(event.target).closest('.recording').replaceWith($html);
    }
   ).on(
    "ajax:error", (event) => {
      console.log('There was an error with the broken link report...')
    }
   );
});
