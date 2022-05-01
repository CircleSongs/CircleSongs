document.addEventListener("DOMContentLoaded", function () {
  var elements = document.getElementsByClassName("broken_link_report");
  Array.from(elements).forEach((elm) => {
    elm.addEventListener("click", function (event) {
      var target = event.target;
      console.log(target);
      // fetch("https://httpbin.org/get").then((data) => {
      //   console.log(data);
      // });
    });

    // .addEventListener("ajax:success", (event) => {
    //   const $response = event.detail[0];
    //   const $recording = document.getElementsByClassName(
    //     `#recording-${$response.recording.id}`
    //   );
    //   $recording.replaceWith($response.recording.html);
    // })
    // .addEventListener("ajax:error", (event) => {
    //   alert("There was an error with the broken link report...");
  });
});
