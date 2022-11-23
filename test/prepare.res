open NodeJs

let process = Process.process
let folder = `artifact`
let dirname = Path.join([Process.cwd(process)])
let artifact_dir = Path.join2(dirname, folder)

if !Fs.existsSync(artifact_dir) {
  ChildProcess.execSync(`mkdir -p ${artifact_dir}`)->ignore
  ChildProcess.execSync(
    `git clone --depth 1 https://github.com/nkrkv/tree-sitter-rescript ${artifact_dir}`,
  )->ignore
} else {
  Js.log(`Folder ${artifact_dir} already exists`)
}

if Fs.existsSync(Path.join2(artifact_dir, "tree-sitter-rescript.wasm")) {
  Js.log("tree-sitter-rescript.wasm file already exists")
  process->Process.exit()->ignore
}

process->Process.chdir(artifact_dir)
Js.log(`Changed dir to ${process->Process.cwd}`)

if !Fs.existsSync(`${Path.join2(process->Process.cwd, "node_modules")}`) {
  Js.log(`Running yarn install`)
  ChildProcess.execSync(`yarn`)->ignore
} else {
  Js.log(`node_modules already exists`)
}

let tree_sitter_cli = `${Path.join([Process.cwd(process), "node_modules", ".bin", "tree-sitter"])}`

ChildProcess.execSync(`${tree_sitter_cli} generate`)->ignore
ChildProcess.execSync(`${tree_sitter_cli} build-wasm`)->ignore
