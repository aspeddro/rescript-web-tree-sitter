import * as path from 'node:path'
import * as url from 'node:url'
import * as fs from 'node:fs'
import * as child_process from 'node:child_process'

const folder = `artifact`
const __dirname = path.join(path.dirname(url.fileURLToPath(import.meta.url)), '..')
const artifact_dir = path.join(__dirname, folder)

if (!fs.existsSync(artifact_dir)) {
  child_process.exec(`mkdir -p ${artifact_dir}`)
  child_process.exec(`git clone --depth 1 git@github.com:nkrkv/tree-sitter-rescript.git ${artifact_dir}`)
} else {
  console.warn(`Folder already exists`)
}

if (fs.existsSync(path.join(artifact_dir, 'tree-sitter-rescript.wasm'))) {
  console.log('tree-sitter-rescript.wasm file exists')
  process.exit(0)
}

process.chdir(artifact_dir)
console.log(`Changed dir to: ${process.cwd()}`)

if (!fs.existsSync(`${path.join(process.cwd(), 'node_modules')}`)) {
  console.log(`Running npm install`)
  child_process.exec(`npm install`)
} else {
  console.warn('node_modules already exists')
}

const tree_sitter_cli = `${path.join(process.cwd(), 'node_modules', '.bin', 'tree-sitter')}`

child_process.exec(`${tree_sitter_cli} generate`, (err, _, stderr) => {
  if (err || stderr) {
    console.error('Failed to generate tree-sitter', stderr)
  }
})
child_process.exec(`${tree_sitter_cli} build-wasm`, (err, _, stderr) => {
  if (err || stderr) {
    console.error('Failed to build wasm', stderr)
  }
})
