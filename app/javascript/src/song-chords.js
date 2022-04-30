import ChordSheetJS from "chordsheetjs";

document.addEventListener("DOMContentLoaded", function () {
  const node = document.getElementById("song-chords");

  if (node) {
    const data = JSON.parse(node.getAttribute("data"));
    const chordSheet = data;

    const parser = new ChordSheetJS.ChordProParser();
    const song = parser.parse(chordSheet);
    const formatter = new ChordSheetJS.TextFormatter();
    const disp = formatter.format(song);

    node.replaceWith(disp);
  }
});
