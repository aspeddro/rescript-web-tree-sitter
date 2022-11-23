// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Fs from "fs";
import * as Path from "path";
import * as Process from "process";
import * as Child_process from "child_process";

var $$process = Process;

var folder = "artifact";

var dirname = Path.join($$process.cwd());

var artifact_dir = Path.join(dirname, folder);

if (Fs.existsSync(artifact_dir)) {
  console.log("Folder " + artifact_dir + " already exists");
} else {
  Child_process.execSync("mkdir -p " + artifact_dir + "");
  Child_process.execSync("git clone --depth 1 https://github.com/nkrkv/tree-sitter-rescript " + artifact_dir + "");
}

if (Fs.existsSync(Path.join(artifact_dir, "tree-sitter-rescript.wasm"))) {
  console.log("tree-sitter-rescript.wasm file already exists");
  $$process.exit();
}

$$process.chdir(artifact_dir);

console.log("Changed dir to " + $$process.cwd() + "");

if (Fs.existsSync("" + Path.join($$process.cwd(), "node_modules") + "")) {
  console.log("node_modules already exists");
} else {
  console.log("Running yarn install");
  Child_process.execSync("yarn");
}

var tree_sitter_cli = "" + Path.join($$process.cwd(), "node_modules", ".bin", "tree-sitter") + "";

Child_process.execSync("" + tree_sitter_cli + " generate");

Child_process.execSync("" + tree_sitter_cli + " build-wasm");

export {
  $$process ,
  folder ,
  dirname ,
  artifact_dir ,
  tree_sitter_cli ,
}
/* process Not a pure module */