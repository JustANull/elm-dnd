"use strict";

import { Elm } from "Main";
import css from "styles";

var content = document.createElement("div");
const app = Elm.Main.init({
  flags: 0,
  node: content
});
document.body.appendChild(content);
