import ChordSheetJS from "chordsheetjs";
const node = document.getElementById("song-chords");
const data = JSON.parse(node.getAttribute("data"));
const chordSheet = data;

const parser = new ChordSheetJS.ChordProParser();
const song = parser.parse(chordSheet);
const formatter = new ChordSheetJS.TextFormatter();
const disp = formatter.format(song);

node.innerHTML = disp


const SongChords = {
  initialize() {
  }
}

export default SongChords;
