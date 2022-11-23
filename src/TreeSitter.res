// API: https://github.com/tree-sitter/tree-sitter/blob/870fb8772f3e47b5aef4c7000a78d61f3aa2b005/lib/binding_web/tree-sitter-web.d.ts
module Parser = {
  type t
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
  and logger = (string, {.}, [#parse | #lex]) => unit
  and input = (. int, option<point>, option<int>) => option<string>
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
  }

  and tree = {rootNode: syntaxNode}

  and language = {
    version: int,
    fieldCount: int,
    nodeTypeCount: int,
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
  and query = {captureNames: array<string>}

  @module("web-tree-sitter") @scope("default") external init: (~moduleOptions: option<{..}>) => promise<unit> = "init"
  @new @module("web-tree-sitter") external make: unit => t = "default"
  @send
  external parse: (
    t,
    ~input: @unwrap [#Str(string) | #Input(input)],
    ~previousTree: option<tree>,
    ~options: option<options>,
  ) => tree = "parse"
  @send external delete: t => unit = "delete"
  @send external reset: t => unit = "reset"
  @send external getLanguage: t => language = "getLanguage"
  @send external setLanguage: (t, @unwrap [#Some(language) | #None(unit)]) => unit = "setLanguage"
  @send external getLogger: t => logger = "getLogger"
  @send external setLogger: (t, @unwrap [#Some(logger) | #None(unit)]) => unit = "setLogger"
  @send external setTimeoutMicros: (t, int) => unit = "setTimeoutMicros"
  @send external getTimeoutMicros: t => unit = "getTimeoutMicros"

  module Language = {
    @module("web-tree-sitter") @scope(("default", "Language"))
    external load: string => promise<language> = "load"
    @send @return(nullable)
    external fieldNameForId: (language, int) => option<string> = "fieldNameForId"
    @send @return(nullable)
    external fieldIdForName: (language, string) => option<string> = "fieldIdForName"
    @send external idForNodeType: (language, string, bool) => int = "idForNodeType"
    @send @return(nullable)
    external nodeTypeForId: (language, int) => option<string> = "nodeTypeForId"
    @send external nodeTypeIsNamed: (language, int) => bool = "nodeTypeIsNamed"
    @send external nodeTypeIsVisible: (language, int) => bool = "nodeTypeIsVisible"
    @send external query: (language, string) => query = "query"
  }

  module SyntaxNode = {
    @send external hasChanges: syntaxNode => bool = "hasChanges"
    @send external hasError: syntaxNode => bool = "hasError"
    @send external equals: syntaxNode => bool = "equals"
    @send external isMissing: syntaxNode => bool = "isMissing"
    @send external isNamed: syntaxNode => bool = "isNamed"
    @send external toString: syntaxNode => string = "toString"
    @send @return(nullable) external child: (syntaxNode, int) => option<syntaxNode> = "child"
    @send @return(nullable)
    external namedChild: (syntaxNode, int) => option<syntaxNode> = "namedChild"
    @send @return(nullable)
    external childForFieldID: (syntaxNode, int) => option<syntaxNode> = "childForFieldID"
    @send @return(nullable)
    external childForFieldName: (syntaxNode, string) => option<syntaxNode> = "childForFieldName"

    @send
    external descendantForIndex: (
      syntaxNode,
      ~startIndex: int,
      ~endIndex: option<int>,
    ) => syntaxNode = "descendantForIndex"
    @send
    external descendantOfType: (
      syntaxNode,
      @unwrap [#Type(string) | #Types(array<string>)],
      ~startPosition: option<point>,
      ~endPosition: option<point>,
    ) => array<syntaxNode> = "descendantOfType"
    @send
    external namedDescendantForIndex: (
      syntaxNode,
      ~startIndex: int,
      ~endIndex: option<int>,
    ) => syntaxNode = "namedDescendantForIndex"

    @send
    external descendantForPosition: (
      syntaxNode,
      ~startPosition: point,
      ~endPosition: option<point>,
    ) => syntaxNode = "descendantForPosition"

    @send
    external namedDescendantForPosition: (
      syntaxNode,
      ~startPosition: point,
      ~endPosition: option<point>,
    ) => syntaxNode = "namedDescendantForPosition"

    @send external walk: syntaxNode => treeCursor = "walk"
  }

  module TreeCursor = {
    @send external reset: (treeCursor, syntaxNode) => unit = "reset"
    @send external delete: treeCursor => unit = "delete"
    @send external currentNode: treeCursor => syntaxNode = "currentNode"
    @send external currentFieldId: treeCursor => int = "currentFieldId"
    @send external currentFieldName: treeCursor => string = "currentFieldName"
    @send external gotoParent: treeCursor => bool = "gotoParent"
    @send external gotoFirstChild: treeCursor => bool = "gotoFirstChild"
    @send external gotoFirstChildForIndex: (treeCursor, int) => bool = "gotoFirstChildForIndex"
    @send external gotoNextSibling: treeCursor => bool = "gotoNextSibling"
  }

  module Tree = {
    @send external copy: tree => tree = "copy"
    @send external delete: tree => unit = "delete"
    @send external edit: (tree, edit) => tree = "edit"
    @send external walk: tree => treeCursor = "walk"
    @send external getChangedRanges: (tree, tree) => array<range> = "getChangedRanges"
    @send external getEditedRange: (tree, tree) => range = "getEditedRange"
    @send external getLanguage: tree => language = "getLanguage"
  }

  module Query = {
    @send external delete: query => unit = "delete"
    @send
    external matches: (
      query,
      syntaxNode,
      ~startPosition: option<point>,
      ~endPosition: option<point>,
    ) => array<queryMatch> = "matches"
    @send
    external captures: (
      query,
      syntaxNode,
      ~startPosition: option<point>,
      ~endPosition: option<point>,
    ) => array<queryCapture> = "captures"
    @send
    external predicatesForPattern: (query, syntaxNode, int) => array<predicateResult> =
      "predicatesForPattern"
  }
}
