// document.addEventListener("DOMContentLoaded", function () {
//   document
//     .getElementsByClassName(".broken_link_report")
//     .addEventListener("ajax:success", (event) => {
//       const $response = event.detail[0];
//       const $recording = document.getElementsByClassName(
//         `#recording-${$response.recording.id}`
//       );
//       $recording.replaceWith($response.recording.html);
//     })
//     .addEventListener("ajax:error", (event) => {
//       alert("There was an error with the broken link report...");
//     });
// });
