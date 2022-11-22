// type rec tree = {
//   // TODO:
//   rootNode: syntaxNode,
//   copy: (. unit) => tree,
//   getLanguage: (. unit) => language,
// }
// and syntaxNode = {
//   id: int,
//   tree: tree,
//   text: string,
//   @as("type") type_: string,
//   startPosition: point,
//   endPosition: point,
//   startIndex: int,
//   endIndex: int,
//   parent: option<syntaxNode>,
//   children: array<syntaxNode>,
//   namedChildren: array<syntaxNode>,
//   childCount: int,
//   namedChildrenCount: int,
//   firstChild: option<syntaxNode>,
//   firstNameChild: option<syntaxNode>,
//   lastChild: option<syntaxNode>,
//   lastNamedChild: option<syntaxNode>,
//   nextSiblings: option<syntaxNode>,
//   nextNamedSibling: option<syntaxNode>,
//   previousSibling: option<syntaxNode>,
//   previousNamedSibling: option<syntaxNode>,
//   hasChanges: (. unit) => bool,
//   hasError: (. unit) => bool,
//   equals: (. syntaxNode) => bool,
//   isMissing: (. unit) => bool,
//   isNamed: (. unit) => bool,
//   toString: (. unit) => string,
//   child: (. int) => option<syntaxNode>,
//   walk: (. unit) => treeCursor,
// }
// and treeCursor = {
//   nodeType: string,
//   nodeTypeId: int,
//   nodeText: string,
//   nodeId: int,
//   nodeIsNamed: bool,
//   nodeIsMissing: bool,
//   startPosition: point,
//   endPosition: point,
//   startIndex: int,
//   endIndex: int,
// }
// and language = {
//   load: (. string) => promise<language>,
//   version: int,
//   fieldCount: int,
//   nodeTypeCount: int,
//   query: (. string) => query,
// }
// and queryCapture = {
//   name: string,
//   node: syntaxNode,
// }
// and queryMatch = {
//   pattern: int,
//   captures: array<queryCapture>,
// }
// and operand = {name: string, @as("type") type_: string}
// and predicateResult = {
//   operator: string,
//   operands: array<operand>,
// }
// and query = {
//   captureNames: array<string>,
//   delete: (. unit) => unit,
//   matches: (. syntaxNode, point, point) => array<queryMatch>,
//   captures: (. syntaxNode, point, point) => array<queryCapture>,
//   predicatesForPattern: (. int) => array<predicateResult>,
// }

module Parser = {
  type point = {row: int, column: int}
  type range = {
    startPosition: point,
    endPosition: point,
    startIndex: int,
    endIndex: int,
  }
  type options = {includeRanges?: array<range>}

  type edit = {
    startIndex: int,
    oldEndIndex: int,
    newEndIndex: int,
    startPosition: point,
    oldEndPosition: point,
    newEndPosition: point,
  }
  and logger = (string, {.}, string) => unit
  and input = String(string) | Input({startIndex: int, startPoint?: point, endIndex?: int})
  type treeCursor = {
    nodeType: string,
    nodeTypeId: int,
    nodeText: string,
    nodeId: int,
    nodeIsNamed: bool,
    nodeIsMissing: bool,
    startPosition: point,
    endPosition: point,
    startIndex: int,
    endIndex: int,
  }
  type operand = {name: string, @as("type") type_: string}

  type rec syntaxNode = {
    id: int,
    tree: tree,
    text: string,
    @as("type") type_: string,
    startPosition: point,
    endPosition: point,
    startIndex: int,
    endIndex: int,
    parent: option<syntaxNode>,
    children: array<syntaxNode>,
    namedChildren: array<syntaxNode>,
    childCount: int,
    namedChildrenCount: int,
    firstChild: option<syntaxNode>,
    firstNameChild: option<syntaxNode>,
    lastChild: option<syntaxNode>,
    lastNamedChild: option<syntaxNode>,
    nextSiblings: option<syntaxNode>,
    nextNamedSibling: option<syntaxNode>,
    previousSibling: option<syntaxNode>,
    previousNamedSibling: option<syntaxNode>,
    hasChanges: (. unit) => bool,
    hasError: (. unit) => bool,
    equals: (. syntaxNode) => bool,
    isMissing: (. unit) => bool,
    isNamed: (. unit) => bool,
    toString: (. unit) => string,
    child: (. int) => option<syntaxNode>,
    walk: (. unit) => treeCursor,
  }

  and tree = {
    // TODO:
    rootNode: syntaxNode,
    copy: (. unit) => tree,
    getLanguage: (. unit) => language,
  }

  and language = {
    load: (. string) => promise<language>,
    version: int,
    fieldCount: int,
    nodeTypeCount: int,
    query: (. string) => query,
  }
  and queryCapture = {
    name: string,
    node: syntaxNode,
  }
  and queryMatch = {
    pattern: int,
    captures: array<queryCapture>,
  }
  and predicateResult = {
    operator: string,
    operands: array<operand>,
  }
  and query = {
    captureNames: array<string>,
    delete: (. unit) => unit,
    matches: (. syntaxNode, point, point) => array<queryMatch>,
    captures: (. syntaxNode, point, point) => array<queryCapture>,
    predicatesForPattern: (. int) => array<predicateResult>,
  }

  type t = {
    // TODO: support moduleOptions
    init: (. unit) => promise<unit>,
    delete: (. unit) => unit,
    // TODO: add more params
    parse: (. string) => tree,
    reset: (. unit) => unit,
    getLanguage: (. unit) => language,
    setLanguage: (. language) => unit,
    getLogger: (. unit) => logger,
    // TODO: opt param
    setLogger: (. logger) => unit,
    setTimeoutMicros: (. int) => unit,
    getTimeoutMicros: (. unit) => int,
  }
}

module Language = {
  @module("web-tree-sitter") @scope("Language")
  external load: string => Parser.language = "load"
}

@module("web-tree-sitter") external init: unit => promise<unit> = "init"
@new @module("web-tree-sitter") external make: unit => Parser.t = "default"

@send external rootNode: Parser.tree => Parser.syntaxNode = "rootNode"
@send external toString: Parser.syntaxNode => string = "toString"
// @send external parse: (Parser.t, Parser.input) => Parser.tree = "parse"

let delete = (t: Parser.t) => t.delete(.)
let parse = (t: Parser.t, input: Parser.input) =>
  switch input {
  | String(s) => t.parse(. s)
  | _ => t.parse(. "Js.log")
  }
let reset = (t: Parser.t) => t.reset(.)
let getLanguage = (t: Parser.t) => t.getLanguage
let setLanguage = (t: Parser.t, language: Parser.language) => t.setLanguage(. language)
let getLogger = (t: Parser.t) => t.getLogger(.)
let setLogger = (t: Parser.t, params) => t.setLogger(. params)
let setTimeoutMicros = (t: Parser.t, value) => t.setTimeoutMicros(. value)
let getTimeoutMicros = (t: Parser.t) => t.getTimeoutMicros(.)


(
  async () => {
    await init()
    let parser = make()
    let rescript = Language.load("file")
    
    parser->setLanguage(rescript)
    let source = "let a = 1\n"
    let tree = parser->parse(String(source))
    // let tree = parser.parse(. Parser.String(source))

    tree.rootNode->toString->Js.log
  }
)()->ignore
