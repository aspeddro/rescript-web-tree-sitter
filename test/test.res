let loadFile = async () => {
  NodeJs.Path.resolve(["artifact", "tree-sitter-rescript.wasm"])
}

(
  async () => {
    open TreeSitter
    await Parser.init(~moduleOptions=None)
    let parser = Parser.make()

    let wasm_file = await loadFile()

    let rescript = await Parser.Language.load(wasm_file)

    parser->Parser.setLanguage(#Some(rescript))
    let code = "let a = 1\n"
    let tree = parser->Parser.parse(~input=#Str(code), ~previousTree=None, ~options=None)

    tree.rootNode
    ->Parser.SyntaxNode.toString
    ->NodeJs.Assert.equal("source_file (let_binding (value_identifier) (number)))")
  }
)()->ignore
