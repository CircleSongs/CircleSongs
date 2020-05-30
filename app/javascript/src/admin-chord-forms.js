//import "./styles.css";
import * as vexchords from "vexchords";

$(function () {
  $(".chord-form").each((index, chord_form) => {
    chord_form = $(chord_form);
    let sel = chord_form[0];
    let chord = chord_form.data("fingering");
    if (typeof chord === "string") chord = JSON.parse(chord);
    vexchords.draw(sel, chord);
  });
});
