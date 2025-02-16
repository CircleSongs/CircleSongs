//import "./styles.css";
import * as vexchords from "vexchords";

document.addEventListener("DOMContentLoaded", function () {
  var elements = document.getElementsByClassName("chord-form");
  Array.from(elements).forEach((chord_form, index) => {
    let chord = chord_form.dataset.fingering;
    if (typeof chord === "string") chord = JSON.parse(chord);
    vexchords.draw(chord_form, chord);
  });
});
