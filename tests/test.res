(
  async () => {
    open TreeSitter
    await Parser.init(~moduleOptions=None)
    let parser = Parser.make()
    let rescript = await Parser.Language.load("file.wasm")

    parser->Parser.setLanguage(#Some(rescript))
    let code = "let a = 1\n"
    let tree = parser->Parser.parse(~input=#Str(code), ~previousTree=None, ~options=None)

    tree.rootNode->Parser.SyntaxNode.toString->Js.log
  }
)()->ignore
