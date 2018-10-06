"use strict";

// CSS
import "tailwind";

// Fonts
import "typeface-lato";

// Elm
import { Elm } from "./Main";

var content = document.createElement("div");
const app = Elm.Main.init({
  flags: 0,
  node: content
});
document.body.appendChild(content);
