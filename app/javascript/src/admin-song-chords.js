import ChordSheetJS from "chordsheetjs";

document.addEventListener("DOMContentLoaded", function () {
  const node = $("#song-chords");

  if (node.length > 0) {
    const data = JSON.parse(node.attr("data"));
    const chordSheet = data;

    const parser = new ChordSheetJS.ChordProParser();
    const song = parser.parse(chordSheet);
    const formatter = new ChordSheetJS.TextFormatter();
    const disp = formatter.format(song);

    node.html(disp);
  }
});
