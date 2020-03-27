$(document).on('turbolinks:load', function() {
  $(".broken_link_report").on(
    "ajax:success", (event) => {
      const $response = event.detail[0];
      const $recording = $(`#recording-${$response.recording.id}`);
      $recording.replaceWith($response.recording.html);
    }
   ).on(
    "ajax:error", (event) => {
      alert('There was an error with the broken link report...')
    }
   );
});
