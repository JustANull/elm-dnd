"use strict";

// CSS
import "tailwind";

// Fonts
import "typeface-lato";

// Elm
import { Elm } from "./Main";

const content = document.createElement("div");
const app = Elm.Main.init({
  flags: JSON.parse(localStorage.getItem("settings")) || {},
  node: content
});
document.body.appendChild(content);

app.ports.saveSettings.subscribe(function(data) {
  localStorage.setItem("settings", JSON.stringify(data));
});
