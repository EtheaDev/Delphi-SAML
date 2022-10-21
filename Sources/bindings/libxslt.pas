{This file generated automatically from libxslt-api.xml}
{For libxslt version: 1.1.17}
Unit libxslt;

interface

{$ALIGN 8}
{$MINENUMSIZE 4}

uses libxml2;

const
{$IFDEF WIN32}
  LIBXSLT_SO = 'libxslt.dll';
{$ELSE}
  LIBXSLT_SO = 'libxslt.so';
{$ENDIF}

type


      xsltTemplatePtrPtr = ^xsltTemplatePtr;
      xsltStackElemPtrPtr = ^xsltStackElemPtr;

          xsltDebugStatusCodes = (
          XSLT_DEBUG_NONE = 0,
          XSLT_DEBUG_INIT = 1,
          XSLT_DEBUG_STEP = 2,
          XSLT_DEBUG_STEPOUT = 3,
          XSLT_DEBUG_NEXT = 4,
          XSLT_DEBUG_STOP = 5,
          XSLT_DEBUG_CONT = 6,
          XSLT_DEBUG_RUN = 7,
          XSLT_DEBUG_RUN_RESTART = 8,
          XSLT_DEBUG_QUIT = 9);

      xsltDebugTraceCodes = (
          XSLT_TRACE_ALL = -1,
          XSLT_TRACE_NONE = 0,
          XSLT_TRACE_COPY_TEXT = 1,
          XSLT_TRACE_PROCESS_NODE = 2,
          XSLT_TRACE_APPLY_TEMPLATE = 4,
          XSLT_TRACE_COPY = 8,
          XSLT_TRACE_COMMENT = 16,
          XSLT_TRACE_PI = 32,
          XSLT_TRACE_COPY_OF = 64,
          XSLT_TRACE_VALUE_OF = 128,
          XSLT_TRACE_CALL_TEMPLATE = 256,
          XSLT_TRACE_APPLY_TEMPLATES = 512,
          XSLT_TRACE_CHOOSE = 1024,
          XSLT_TRACE_IF = 2048,
          XSLT_TRACE_FOR_EACH = 4096,
          XSLT_TRACE_STRIP_SPACES = 8192,
          XSLT_TRACE_TEMPLATES = 16384,
          XSLT_TRACE_KEYS = 32768,
          XSLT_TRACE_VARIABLES = 65536);

      xsltLoadType = (
          XSLT_LOAD_START = 0,
          XSLT_LOAD_STYLESHEET = 1,
          XSLT_LOAD_DOCUMENT = 2);

      xsltOutputType = (
          XSLT_OUTPUT_XML = 0,
          XSLT_OUTPUT_HTML = 1,
          XSLT_OUTPUT_TEXT = 2);

      xsltSecurityOption = (
          XSLT_SECPREF_READ_FILE = 1,
          XSLT_SECPREF_WRITE_FILE = 2,
          XSLT_SECPREF_CREATE_DIRECTORY = 3,
          XSLT_SECPREF_READ_NETWORK = 4,
          XSLT_SECPREF_WRITE_NETWORK = 5);

      xsltStyleType = (
          XSLT_FUNC_COPY = 1,
          XSLT_FUNC_SORT = 2,
          XSLT_FUNC_TEXT = 3,
          XSLT_FUNC_ELEMENT = 4,
          XSLT_FUNC_ATTRIBUTE = 5,
          XSLT_FUNC_COMMENT = 6,
          XSLT_FUNC_PI = 7,
          XSLT_FUNC_COPYOF = 8,
          XSLT_FUNC_VALUEOF = 9,
          XSLT_FUNC_NUMBER = 10,
          XSLT_FUNC_APPLYIMPORTS = 11,
          XSLT_FUNC_CALLTEMPLATE = 12,
          XSLT_FUNC_APPLYTEMPLATES = 13,
          XSLT_FUNC_CHOOSE = 14,
          XSLT_FUNC_IF = 15,
          XSLT_FUNC_FOREACH = 16,
          XSLT_FUNC_DOCUMENT = 17,
          XSLT_FUNC_WITHPARAM = 18,
          XSLT_FUNC_PARAM = 19,
          XSLT_FUNC_VARIABLE = 20,
          XSLT_FUNC_WHEN = 21,
          XSLT_FUNC_EXTENSION = 22);

      xsltTransformState = (
          XSLT_STATE_OK = 0,
          XSLT_STATE_ERROR = 1,
          XSLT_STATE_STOPPED = 2);

       xsltCompMatchPtr = ^xsltCompMatch;
       xsltDecimalFormatPtr = ^xsltDecimalFormat;
       xsltDocumentPtr = ^xsltDocument;
       xsltElemPreCompPtr = ^xsltElemPreComp;
       xsltFormatNumberInfoPtr = ^xsltFormatNumberInfo;
       xsltNumberDataPtr = ^xsltNumberData;
       xsltRuntimeExtraPtr = ^xsltRuntimeExtra;
       xsltSecurityPrefsPtr = ^xsltSecurityPrefs;
       xsltStackElemPtr = ^xsltStackElem;
       xsltStylePreCompPtr = ^xsltStylePreComp;
       xsltStylesheetPtr = ^xsltStylesheet;
       xsltTemplatePtr = ^xsltTemplate;
       xsltTransformContextPtr = ^xsltTransformContext;
      xsltAddCallCallback = function  (templ: xsltTemplatePtr; source: xmlNodePtr) : Longint; cdecl;
        xsltAddCallCallbackPtr = ^xsltAddCallCallback;

      xsltDocLoaderFunc = function  (const URI: xmlCharPtr; dict: xmlDictPtr; options: Longint; ctxt: Pointer; type_: xsltLoadType) : xmlDocPtr; cdecl;
        xsltDocLoaderFuncPtr = ^xsltDocLoaderFunc;

      xsltDropCallCallback = procedure  (); cdecl;
        xsltDropCallCallbackPtr = ^xsltDropCallCallback;

      xsltElemPreCompDeallocator = procedure  (comp: xsltElemPreCompPtr); cdecl;
        xsltElemPreCompDeallocatorPtr = ^xsltElemPreCompDeallocator;

      xsltExtInitFunction = function  (ctxt: xsltTransformContextPtr; const URI: xmlCharPtr) : Pointer; cdecl;
        xsltExtInitFunctionPtr = ^xsltExtInitFunction;

      xsltExtShutdownFunction = procedure  (ctxt: xsltTransformContextPtr; const URI: xmlCharPtr; data: Pointer); cdecl;
        xsltExtShutdownFunctionPtr = ^xsltExtShutdownFunction;

      xsltHandleDebuggerCallback = procedure  (cur: xmlNodePtr; node: xmlNodePtr; templ: xsltTemplatePtr; ctxt: xsltTransformContextPtr); cdecl;
        xsltHandleDebuggerCallbackPtr = ^xsltHandleDebuggerCallback;

      xsltTransformFunction = procedure  (ctxt: xsltTransformContextPtr; node: xmlNodePtr; inst: xmlNodePtr; comp: xsltElemPreCompPtr); cdecl;
        xsltTransformFunctionPtr = ^xsltTransformFunction;

      xsltPreComputeFunction = function  (style: xsltStylesheetPtr; inst: xmlNodePtr; function_: xsltTransformFunction) : xsltElemPreCompPtr; cdecl;
        xsltPreComputeFunctionPtr = ^xsltPreComputeFunction;

      xsltSecurityCheck = function  (sec: xsltSecurityPrefsPtr; ctxt: xsltTransformContextPtr; const value: PChar) : Longint; cdecl;
        xsltSecurityCheckPtr = ^xsltSecurityCheck;

      xsltSortFunc = procedure  (ctxt: xsltTransformContextPtr; sorts: xmlNodePtrPtr; nbsorts: Longint); cdecl;
        xsltSortFuncPtr = ^xsltSortFunc;

      xsltStyleExtInitFunction = function  (style: xsltStylesheetPtr; const URI: xmlCharPtr) : Pointer; cdecl;
        xsltStyleExtInitFunctionPtr = ^xsltStyleExtInitFunction;

      xsltStyleExtShutdownFunction = procedure  (style: xsltStylesheetPtr; const URI: xmlCharPtr; data: Pointer); cdecl;
        xsltStyleExtShutdownFunctionPtr = ^xsltStyleExtShutdownFunction;

      xsltTopLevelFunction = procedure  (style: xsltStylesheetPtr; inst: xmlNodePtr); cdecl;
        xsltTopLevelFunctionPtr = ^xsltTopLevelFunction;

      xsltCompMatch = record
      end;

      xsltDecimalFormat = record
          next : xsltDecimalFormatPtr; { chained list}
          name : xmlCharPtr; { Used for interpretation of pattern}
          digit : xmlCharPtr; {}
          patternSeparator : xmlCharPtr; { May appear in result}
          minusSign : xmlCharPtr; {}
          infinity : xmlCharPtr; {}
          noNumber : xmlCharPtr; { Not-a-number Used for interpretation of pattern and may appear in result}
          decimalPoint : xmlCharPtr; {}
          grouping : xmlCharPtr; {}
          percent : xmlCharPtr; {}
          permille : xmlCharPtr; {}
          zeroDigit : xmlCharPtr; {}
      end;

      xsltDocument = record
          next : xsltDocumentPtr; { documents are kept in a chained list}
          main : Longint; { is this the main document}
          doc : xmlDocPtr; { the parsed document}
          keys : Pointer; { key tables storage}
          includes : xsltDocumentPtr; { subsidiary includes}
          preproc : Longint; { pre-processing already done}
      end;

      xsltElemPreComp = record
          next : xsltElemPreCompPtr; { chained list}
          type_ : xsltStyleType; { type of the element}
          func : xsltTransformFunction; { handling function}
          inst : xmlNodePtr; { the instruction end of common part}
          free : xsltElemPreCompDeallocator; { the deallocator}
      end;

      xsltFormatNumberInfo = record
          integer_hash : Longint; { Number of '#' in integer part}
          integer_digits : Longint; { Number of '0' in integer part}
          frac_digits : Longint; { Number of '0' in fractional part}
          frac_hash : Longint; { Number of '#' in fractional part}
          group : Longint; { Number of chars per display 'group'}
          multiplier : Longint; { Scaling for percent or permille}
          add_decimal : char; { Flag for whether decimal point appears in pattern}
          is_multiplier_set : char; { Flag to catch multiple occurences of percent/permille}
          is_negative_pattern : char; { Flag for processing -ve prefix/suffix}
      end;

      xsltNumberData = record
          level : xmlCharPtr; {}
          count : xmlCharPtr; {}
          from : xmlCharPtr; {}
          value : xmlCharPtr; {}
          format : xmlCharPtr; {}
          has_format : Longint; {}
          digitsPerGroup : Longint; {}
          groupingCharacter : Longint; {}
          groupingCharacterLen : Longint; {}
          doc : xmlDocPtr; {}
          node : xmlNodePtr; {* accelerators
*}
      end;

      xsltRuntimeExtra = record
          info : Pointer; { pointer to the extra data}
          deallocate : xmlFreeFunc; { pointer to the deallocation routine}
      end;

      xsltSecurityPrefs = record
      end;

      xsltStackElem = record
          next : xsltStackElemPtr; { chained list}
          comp : xsltStylePreCompPtr; { the compiled form}
          computed : Longint; { was the evaluation done}
          name : xmlCharPtr; { the local part of the name QName}
          nameURI : xmlCharPtr; { the URI part of the name QName}
          select : xmlCharPtr; { the eval string}
          tree : xmlNodePtr; { the tree if no eval string or the location}
          value : xmlXPathObjectPtr; { The value if computed}
      end;

      xsltStylePreComp = record
          next : xsltElemPreCompPtr; { chained list}
          type_ : xsltStyleType; { type of the element}
          func : xsltTransformFunction; { handling function}
          inst : xmlNodePtr; {* Pre computed values.
*}
          stype : xmlCharPtr; { sort}
          has_stype : Longint; { sort}
          number : Longint; { sort}
          order : xmlCharPtr; { sort}
          has_order : Longint; { sort}
          descending : Longint; { sort}
          lang : xmlCharPtr; { sort}
          has_lang : Longint; { sort}
          case_order : xmlCharPtr; { sort}
          lower_first : Longint; { sort}
          use : xmlCharPtr; { copy, element}
          has_use : Longint; { copy, element}
          noescape : Longint; { text}
          name : xmlCharPtr; { element, attribute, pi}
          has_name : Longint; { element, attribute, pi}
          ns : xmlCharPtr; { element}
          has_ns : Longint; { element}
          mode : xmlCharPtr; { apply-templates}
          modeURI : xmlCharPtr; { apply-templates}
          test : xmlCharPtr; { if}
          templ : xsltTemplatePtr; { call-template}
          select : xmlCharPtr; { sort, copy-of, value-of, apply-templates}
          ver11 : Longint; { document}
          filename : xmlCharPtr; { document URL}
          has_filename : Longint; { document}
          numdata : xsltNumberData; { number}
          comp : xmlXPathCompExprPtr; { a precompiled XPath expression}
          nsList : xmlNsPtrPtr; { the namespaces in scope}
          nsNr : Longint; { the number of namespaces in scope}
      end;

      xsltStylesheet = record
          parent : xsltStylesheetPtr; {}
          next : xsltStylesheetPtr; {}
          imports : xsltStylesheetPtr; {}
          docList : xsltDocumentPtr; {* General data on the style sheet document.
*}
          doc : xmlDocPtr; { the parsed XML stylesheet}
          stripSpaces : xmlHashTablePtr; { the hash table of the strip-space and
preserve space elements}
          stripAll : Longint; { strip-space * (1) preserve-space * (-1)}
          cdataSection : xmlHashTablePtr; {* Global variable or parameters.
*}
          variables : xsltStackElemPtr; {* Template descriptions.
*}
          templates : xsltTemplatePtr; { the ordered list of templates}
          templatesHash : Pointer; { hash table or wherever compiled templates
informations are stored}
          rootMatch : Pointer; { template based on /}
          keyMatch : Pointer; { template based on key()}
          elemMatch : Pointer; { template based on *}
          attrMatch : Pointer; { template based on @*}
          parentMatch : Pointer; { template based on ..}
          textMatch : Pointer; { template based on text()}
          piMatch : Pointer; { template based on processing-instruction()}
          commentMatch : Pointer; {* Namespace aliases.
*}
          nsAliases : xmlHashTablePtr; {* Attribute sets.
*}
          attributeSets : xmlHashTablePtr; {* Namespaces.
*}
          nsHash : xmlHashTablePtr; { the set of namespaces in use}
          nsDefs : Pointer; {* Key definitions.
*}
          keys : Pointer; {* Output related stuff.
*}
          method : xmlCharPtr; { the output method}
          methodURI : xmlCharPtr; { associated namespace if any}
          version : xmlCharPtr; { version string}
          encoding : xmlCharPtr; { encoding string}
          omitXmlDeclaration : Longint; {* Number formatting.
*}
          decimalFormat : xsltDecimalFormatPtr; {}
          standalone : Longint; { standalone = "yes" | "no"}
          doctypePublic : xmlCharPtr; { doctype-public string}
          doctypeSystem : xmlCharPtr; { doctype-system string}
          indent : Longint; { should output being indented}
          mediaType : xmlCharPtr; {* Precomputed blocks.
*}
          preComps : xsltElemPreCompPtr; { list of precomputed blocks}
          warnings : Longint; { number of warnings found at compilation}
          errors : Longint; { number of errors found at compilation}
          exclPrefix : xmlCharPtr; { last excluded prefixes}
          exclPrefixTab : xmlCharPtrPtr; { array of excluded prefixes}
          exclPrefixNr : Longint; { number of excluded prefixes in scope}
          exclPrefixMax : Longint; { size of the array}
          _private : Pointer; {* Extensions.
*}
          extInfos : xmlHashTablePtr; { the extension data}
          extrasNr : Longint; {* For keeping track of nested includes
*}
          includes : xsltDocumentPtr; {* dictionnary: shared between stylesheet, context and documents.
*}
          dict : xmlDictPtr; {* precompiled attribute value templates.
*}
          attVTs : Pointer; {* if namespace-alias has an alias for the default stylesheet prefix
*}
          defaultAlias : xmlCharPtr; {* bypass pre-processing (already done) (used in imports)
*}
          nopreproc : Longint; {* all document text strings were internalized
*}
          internalized : Longint; {* Literal Result Element as Stylesheet c.f. section 2.3
*}
          literal_result : Longint; {}
      end;

      xsltTemplate = record
          next : xsltTemplatePtr; { chained list sorted by priority}
          style : xsltStylesheetPtr; { the containing stylesheet}
          match : xmlCharPtr; { the matching string}
          priority : Single; { as given from the stylesheet, not computed}
          name : xmlCharPtr; { the local part of the name QName}
          nameURI : xmlCharPtr; { the URI part of the name QName}
          mode : xmlCharPtr; { the local part of the mode QName}
          modeURI : xmlCharPtr; { the URI part of the mode QName}
          content : xmlNodePtr; { the template replacement value}
          elem : xmlNodePtr; { the source element}
          inheritedNsNr : Longint; { number of inherited namespaces}
          inheritedNs : xmlNsPtrPtr; { inherited non-excluded namespaces Profiling informations}
          nbCalls : Longint; { the number of time the template was called}
          time : Cardinal; { the time spent in this template}
      end;

      xsltTransformContext = record
          style : xsltStylesheetPtr; { the stylesheet used}
          type_ : xsltOutputType; { the type of output}
          templ : xsltTemplatePtr; { the current template}
          templNr : Longint; { Nb of templates in the stack}
          templMax : Longint; { Size of the templtes stack}
          templTab : xsltTemplatePtrPtr; { the template stack}
          vars : xsltStackElemPtr; { the current variable list}
          varsNr : Longint; { Nb of variable list in the stack}
          varsMax : Longint; { Size of the variable list stack}
          varsTab : xsltStackElemPtrPtr; { the variable list stack}
          varsBase : Longint; {* Extensions
*}
          extFunctions : xmlHashTablePtr; { the extension functions}
          extElements : xmlHashTablePtr; { the extension elements}
          extInfos : xmlHashTablePtr; { the extension data}
          mode : xmlCharPtr; { the current mode}
          modeURI : xmlCharPtr; { the current mode URI}
          docList : xsltDocumentPtr; { the document list}
          document : xsltDocumentPtr; { the current document}
          node : xmlNodePtr; { the current node being processed}
          nodeList : xmlNodeSetPtr; { the current node list xmlNodePtr current;			the node}
          output : xmlDocPtr; { the resulting document}
          insert : xmlNodePtr; { the insertion node}
          xpathCtxt : xmlXPathContextPtr; { the XPath context}
          state : xsltTransformState; {* Global variables
*}
          globalVars : xmlHashTablePtr; { the global variables and params}
          inst : xmlNodePtr; { the instruction in the stylesheet}
          xinclude : Longint; { should XInclude be processed}
          outputFile : PChar; { the output URI if known}
          profile : Longint; { is this run profiled}
          prof : Longint; { the current profiled value}
          profNr : Longint; { Nb of templates in the stack}
          profMax : Longint; { Size of the templtaes stack}
          profTab : PLongInt; { the profile template stack}
          _private : Pointer; { user defined data}
          extrasNr : Longint; { the number of extras used}
          extrasMax : Longint; { the number of extras allocated}
          extras : xsltRuntimeExtraPtr; { extra per runtime informations}
          styleList : xsltDocumentPtr; { the stylesheet docs list}
          sec : Pointer; { the security preferences if any}
          error : xmlGenericErrorFunc; { a specific error handler}
          errctx : Pointer; { context for the error handler}
          sortfunc : xsltSortFunc; {* handling of temporary Result Value Tree
*}
          tmpRVT : xmlDocPtr; { list of RVT without persistance}
          persistRVT : xmlDocPtr; { list of persistant RVTs}
          ctxtflags : Longint; {* Speed optimization when coalescing text nodes
*}
          lasttext : xmlCharPtr; { last text node content}
          lasttsize : Cardinal; { last text node size}
          lasttuse : Cardinal; {* Per Context Debugging
*}
          debugStatus : Longint; { the context level debug status}
          traceCode : PCardinal; { pointer to the variable holding the mask}
          parserOptions : Longint; {* dictionnary: shared between stylesheet, context and documents.
*}
          dict : xmlDictPtr; {* temporary storage for doc ptr, currently only used for
* global var evaluation
*}
          tmpDoc : xmlDocPtr; {* all document text strings are internalized
*}
          internalized : Longint; {}
      end;


  function xslAddCall (templ: xsltTemplatePtr; source: xmlNodePtr) : Longint; cdecl; external LIBXSLT_SO;
  procedure xslDropCall (); cdecl; external LIBXSLT_SO;
  procedure xslHandleDebugger (cur: xmlNodePtr; node: xmlNodePtr; templ: xsltTemplatePtr; ctxt: xsltTransformContextPtr); cdecl; external LIBXSLT_SO;
  function xsltAddKey (style: xsltStylesheetPtr; const name: xmlCharPtr; const nameURI: xmlCharPtr; const match: xmlCharPtr; const use: xmlCharPtr; inst: xmlNodePtr) : Longint; cdecl; external LIBXSLT_SO;
  function xsltAddStackElemList (ctxt: xsltTransformContextPtr; elems: xsltStackElemPtr) : Longint; cdecl; external LIBXSLT_SO;
  function xsltAddTemplate (style: xsltStylesheetPtr; cur: xsltTemplatePtr; const mode: xmlCharPtr; const modeURI: xmlCharPtr) : Longint; cdecl; external LIBXSLT_SO;
  function xsltAllocateExtra (style: xsltStylesheetPtr) : Longint; cdecl; external LIBXSLT_SO;
  function xsltAllocateExtraCtxt (ctxt: xsltTransformContextPtr) : Longint; cdecl; external LIBXSLT_SO;
  procedure xsltApplyAttributeSet (ctxt: xsltTransformContextPtr; node: xmlNodePtr; inst: xmlNodePtr; const attributes: xmlCharPtr); cdecl; external LIBXSLT_SO;
  procedure xsltApplyImports (ctxt: xsltTransformContextPtr; node: xmlNodePtr; inst: xmlNodePtr; comp: xsltStylePreCompPtr); cdecl; external LIBXSLT_SO;
  procedure xsltApplyOneTemplate (ctxt: xsltTransformContextPtr; node: xmlNodePtr; list: xmlNodePtr; templ: xsltTemplatePtr; params: xsltStackElemPtr); cdecl; external LIBXSLT_SO;
  procedure xsltApplyStripSpaces (ctxt: xsltTransformContextPtr; node: xmlNodePtr); cdecl; external LIBXSLT_SO;
  function xsltApplyStylesheet (style: xsltStylesheetPtr; doc: xmlDocPtr; const params: PPChar) : xmlDocPtr; cdecl; external LIBXSLT_SO;
  function xsltApplyStylesheetUser (style: xsltStylesheetPtr; doc: xmlDocPtr; const params: PPChar; const output: PChar; profile: PFILE; userCtxt: xsltTransformContextPtr) : xmlDocPtr; cdecl; external LIBXSLT_SO;
  procedure xsltApplyTemplates (ctxt: xsltTransformContextPtr; node: xmlNodePtr; inst: xmlNodePtr; comp: xsltStylePreCompPtr); cdecl; external LIBXSLT_SO;
  function xsltAttrListTemplateProcess (ctxt: xsltTransformContextPtr; target: xmlNodePtr; cur: xmlAttrPtr) : xmlAttrPtr; cdecl; external LIBXSLT_SO;
  function xsltAttrTemplateProcess (ctxt: xsltTransformContextPtr; target: xmlNodePtr; cur: xmlAttrPtr) : xmlAttrPtr; cdecl; external LIBXSLT_SO;
  function xsltAttrTemplateValueProcess (ctxt: xsltTransformContextPtr; const str: xmlCharPtr) : xmlCharPtr; cdecl; external LIBXSLT_SO;
  function xsltAttrTemplateValueProcessNode (ctxt: xsltTransformContextPtr; const str: xmlCharPtr; node: xmlNodePtr) : xmlCharPtr; cdecl; external LIBXSLT_SO;
  procedure xsltAttribute (ctxt: xsltTransformContextPtr; node: xmlNodePtr; inst: xmlNodePtr; comp: xsltStylePreCompPtr); cdecl; external LIBXSLT_SO;
  procedure xsltCalibrateAdjust (delta: Longint); cdecl; external LIBXSLT_SO;
  procedure xsltCallTemplate (ctxt: xsltTransformContextPtr; node: xmlNodePtr; inst: xmlNodePtr; comp: xsltStylePreCompPtr); cdecl; external LIBXSLT_SO;
  function xsltCheckExtPrefix (style: xsltStylesheetPtr; const prefix: xmlCharPtr) : Longint; cdecl; external LIBXSLT_SO;
  function xsltCheckRead (sec: xsltSecurityPrefsPtr; ctxt: xsltTransformContextPtr; const URL: xmlCharPtr) : Longint; cdecl; external LIBXSLT_SO;
  function xsltCheckWrite (sec: xsltSecurityPrefsPtr; ctxt: xsltTransformContextPtr; const URL: xmlCharPtr) : Longint; cdecl; external LIBXSLT_SO;
  procedure xsltChoose (ctxt: xsltTransformContextPtr; node: xmlNodePtr; inst: xmlNodePtr; comp: xsltStylePreCompPtr); cdecl; external LIBXSLT_SO;
  procedure xsltCleanupGlobals (); cdecl; external LIBXSLT_SO;
  procedure xsltCleanupTemplates (style: xsltStylesheetPtr); cdecl; external LIBXSLT_SO;
  procedure xsltComment (ctxt: xsltTransformContextPtr; node: xmlNodePtr; inst: xmlNodePtr; comp: xsltStylePreCompPtr); cdecl; external LIBXSLT_SO;
  procedure xsltCompileAttr (style: xsltStylesheetPtr; attr: xmlAttrPtr); cdecl; external LIBXSLT_SO;
  function xsltCompilePattern (const pattern: xmlCharPtr; doc: xmlDocPtr; node: xmlNodePtr; style: xsltStylesheetPtr; runtime: xsltTransformContextPtr) : xsltCompMatchPtr; cdecl; external LIBXSLT_SO;
  function xsltComputeSortResult (ctxt: xsltTransformContextPtr; sort: xmlNodePtr) : xmlXPathObjectPtrPtr; cdecl; external LIBXSLT_SO;
  procedure xsltCopy (ctxt: xsltTransformContextPtr; node: xmlNodePtr; inst: xmlNodePtr; comp: xsltStylePreCompPtr); cdecl; external LIBXSLT_SO;
  function xsltCopyNamespace (ctxt: xsltTransformContextPtr; node: xmlNodePtr; cur: xmlNsPtr) : xmlNsPtr; cdecl; external LIBXSLT_SO;
  function xsltCopyNamespaceList (ctxt: xsltTransformContextPtr; node: xmlNodePtr; cur: xmlNsPtr) : xmlNsPtr; cdecl; external LIBXSLT_SO;
  procedure xsltCopyOf (ctxt: xsltTransformContextPtr; node: xmlNodePtr; inst: xmlNodePtr; comp: xsltStylePreCompPtr); cdecl; external LIBXSLT_SO;
  function xsltCopyTextString (ctxt: xsltTransformContextPtr; target: xmlNodePtr; const string_: xmlCharPtr; noescape: Longint) : xmlNodePtr; cdecl; external LIBXSLT_SO;
  function xsltCreateRVT (ctxt: xsltTransformContextPtr) : xmlDocPtr; cdecl; external LIBXSLT_SO;
  procedure xsltDebug (ctxt: xsltTransformContextPtr; node: xmlNodePtr; inst: xmlNodePtr; comp: xsltStylePreCompPtr); cdecl; external LIBXSLT_SO;
  procedure xsltDebugDumpExtensions (output: PFILE); cdecl; external LIBXSLT_SO;
  function xsltDebugGetDefaultTrace () : xsltDebugTraceCodes; cdecl; external LIBXSLT_SO;
  procedure xsltDebugSetDefaultTrace (val: xsltDebugTraceCodes); cdecl; external LIBXSLT_SO;
  function xsltDecimalFormatGetByName (sheet: xsltStylesheetPtr; name: xmlCharPtr) : xsltDecimalFormatPtr; cdecl; external LIBXSLT_SO;
  procedure xsltDefaultSortFunction (ctxt: xsltTransformContextPtr; sorts: xmlNodePtrPtr; nbsorts: Longint); cdecl; external LIBXSLT_SO;
  procedure xsltDoSortFunction (ctxt: xsltTransformContextPtr; sorts: xmlNodePtrPtr; nbsorts: Longint); cdecl; external LIBXSLT_SO;
  function xsltDocumentComp (style: xsltStylesheetPtr; inst: xmlNodePtr; function_: xsltTransformFunction) : xsltElemPreCompPtr; cdecl; external LIBXSLT_SO;
  procedure xsltDocumentElem (ctxt: xsltTransformContextPtr; node: xmlNodePtr; inst: xmlNodePtr; comp: xsltStylePreCompPtr); cdecl; external LIBXSLT_SO;
  procedure xsltDocumentFunction (ctxt: xmlXPathParserContextPtr; nargs: Longint); cdecl; external LIBXSLT_SO;
  procedure xsltDocumentSortFunction (list: xmlNodeSetPtr); cdecl; external LIBXSLT_SO;
  procedure xsltElement (ctxt: xsltTransformContextPtr; node: xmlNodePtr; inst: xmlNodePtr; comp: xsltStylePreCompPtr); cdecl; external LIBXSLT_SO;
  procedure xsltElementAvailableFunction (ctxt: xmlXPathParserContextPtr; nargs: Longint); cdecl; external LIBXSLT_SO;
  function xsltEvalAVT (ctxt: xsltTransformContextPtr; avt: Pointer; node: xmlNodePtr) : xmlCharPtr; cdecl; external LIBXSLT_SO;
  function xsltEvalAttrValueTemplate (ctxt: xsltTransformContextPtr; node: xmlNodePtr; const name: xmlCharPtr; const ns: xmlCharPtr) : xmlCharPtr; cdecl; external LIBXSLT_SO;
  function xsltEvalGlobalVariables (ctxt: xsltTransformContextPtr) : Longint; cdecl; external LIBXSLT_SO;
  function xsltEvalOneUserParam (ctxt: xsltTransformContextPtr; const name: xmlCharPtr; const value: xmlCharPtr) : Longint; cdecl; external LIBXSLT_SO;
  function xsltEvalStaticAttrValueTemplate (style: xsltStylesheetPtr; node: xmlNodePtr; const name: xmlCharPtr; const ns: xmlCharPtr; found: PInteger) : xmlCharPtr; cdecl; external LIBXSLT_SO;
  function xsltEvalTemplateString (ctxt: xsltTransformContextPtr; node: xmlNodePtr; parent: xmlNodePtr) : xmlCharPtr; cdecl; external LIBXSLT_SO;
  function xsltEvalUserParams (ctxt: xsltTransformContextPtr; const params: PPChar) : Longint; cdecl; external LIBXSLT_SO;
  function xsltEvalXPathPredicate (ctxt: xsltTransformContextPtr; comp: xmlXPathCompExprPtr; nsList: xmlNsPtrPtr; nsNr: Longint) : Longint; cdecl; external LIBXSLT_SO;
  function xsltEvalXPathString (ctxt: xsltTransformContextPtr; comp: xmlXPathCompExprPtr) : xmlCharPtr; cdecl; external LIBXSLT_SO;
  function xsltEvalXPathStringNs (ctxt: xsltTransformContextPtr; comp: xmlXPathCompExprPtr; nsNr: Longint; nsList: xmlNsPtrPtr) : xmlCharPtr; cdecl; external LIBXSLT_SO;
  function xsltExtElementLookup (ctxt: xsltTransformContextPtr; const name: xmlCharPtr; const URI: xmlCharPtr) : xsltTransformFunction; cdecl; external LIBXSLT_SO;
  function xsltExtFunctionLookup (ctxt: xsltTransformContextPtr; const name: xmlCharPtr; const URI: xmlCharPtr) : xmlXPathFunction; cdecl; external LIBXSLT_SO;
  function xsltExtModuleElementLookup (const name: xmlCharPtr; const URI: xmlCharPtr) : xsltTransformFunction; cdecl; external LIBXSLT_SO;
  function xsltExtModuleElementPreComputeLookup (const name: xmlCharPtr; const URI: xmlCharPtr) : xsltPreComputeFunction; cdecl; external LIBXSLT_SO;
  function xsltExtModuleFunctionLookup (const name: xmlCharPtr; const URI: xmlCharPtr) : xmlXPathFunction; cdecl; external LIBXSLT_SO;
  function xsltExtModuleTopLevelLookup (const name: xmlCharPtr; const URI: xmlCharPtr) : xsltTopLevelFunction; cdecl; external LIBXSLT_SO;
  function xsltFindDocument (ctxt: xsltTransformContextPtr; doc: xmlDocPtr) : xsltDocumentPtr; cdecl; external LIBXSLT_SO;
  function xsltFindElemSpaceHandling (ctxt: xsltTransformContextPtr; node: xmlNodePtr) : Longint; cdecl; external LIBXSLT_SO;
  function xsltFindTemplate (ctxt: xsltTransformContextPtr; const name: xmlCharPtr; const nameURI: xmlCharPtr) : xsltTemplatePtr; cdecl; external LIBXSLT_SO;
  procedure xsltForEach (ctxt: xsltTransformContextPtr; node: xmlNodePtr; inst: xmlNodePtr; comp: xsltStylePreCompPtr); cdecl; external LIBXSLT_SO;
  function xsltFormatNumberConversion (self: xsltDecimalFormatPtr; format: xmlCharPtr; number: double; result: xmlCharPtrPtr) : xmlXPathErrorEnum; cdecl; external LIBXSLT_SO;
  procedure xsltFormatNumberFunction (ctxt: xmlXPathParserContextPtr; nargs: Longint); cdecl; external LIBXSLT_SO;
  procedure xsltFreeAVTList (avt: Pointer); cdecl; external LIBXSLT_SO;
  procedure xsltFreeAttributeSetsHashes (style: xsltStylesheetPtr); cdecl; external LIBXSLT_SO;
  procedure xsltFreeCompMatchList (comp: xsltCompMatchPtr); cdecl; external LIBXSLT_SO;
  procedure xsltFreeCtxtExts (ctxt: xsltTransformContextPtr); cdecl; external LIBXSLT_SO;
  procedure xsltFreeDocumentKeys (doc: xsltDocumentPtr); cdecl; external LIBXSLT_SO;
  procedure xsltFreeDocuments (ctxt: xsltTransformContextPtr); cdecl; external LIBXSLT_SO;
  procedure xsltFreeExts (style: xsltStylesheetPtr); cdecl; external LIBXSLT_SO;
  procedure xsltFreeGlobalVariables (ctxt: xsltTransformContextPtr); cdecl; external LIBXSLT_SO;
  procedure xsltFreeKeys (style: xsltStylesheetPtr); cdecl; external LIBXSLT_SO;
  procedure xsltFreeNamespaceAliasHashes (style: xsltStylesheetPtr); cdecl; external LIBXSLT_SO;
  procedure xsltFreeRVTs (ctxt: xsltTransformContextPtr); cdecl; external LIBXSLT_SO;
  procedure xsltFreeSecurityPrefs (sec: xsltSecurityPrefsPtr); cdecl; external LIBXSLT_SO;
  procedure xsltFreeStackElemList (elem: xsltStackElemPtr); cdecl; external LIBXSLT_SO;
  procedure xsltFreeStyleDocuments (style: xsltStylesheetPtr); cdecl; external LIBXSLT_SO;
  procedure xsltFreeStylePreComps (style: xsltStylesheetPtr); cdecl; external LIBXSLT_SO;
  procedure xsltFreeStylesheet (sheet: xsltStylesheetPtr); cdecl; external LIBXSLT_SO;
  procedure xsltFreeTemplateHashes (style: xsltStylesheetPtr); cdecl; external LIBXSLT_SO;
  procedure xsltFreeTransformContext (ctxt: xsltTransformContextPtr); cdecl; external LIBXSLT_SO;
  procedure xsltFunctionAvailableFunction (ctxt: xmlXPathParserContextPtr; nargs: Longint); cdecl; external LIBXSLT_SO;
  procedure xsltFunctionNodeSet (ctxt: xmlXPathParserContextPtr; nargs: Longint); cdecl; external LIBXSLT_SO;
  procedure xsltGenerateIdFunction (ctxt: xmlXPathParserContextPtr; nargs: Longint); cdecl; external LIBXSLT_SO;
  function xsltGetCNsProp (style: xsltStylesheetPtr; node: xmlNodePtr; const name: xmlCharPtr; const nameSpace: xmlCharPtr) : xmlCharPtr; cdecl; external LIBXSLT_SO;
  function xsltGetDebuggerStatus () : Longint; cdecl; external LIBXSLT_SO;
  function xsltGetDefaultSecurityPrefs () : xsltSecurityPrefsPtr; cdecl; external LIBXSLT_SO;
  function xsltGetExtData (ctxt: xsltTransformContextPtr; const URI: xmlCharPtr) : Pointer; cdecl; external LIBXSLT_SO;
  function xsltGetExtInfo (style: xsltStylesheetPtr; const URI: xmlCharPtr) : xmlHashTablePtr; cdecl; external LIBXSLT_SO;
  function xsltGetKey (ctxt: xsltTransformContextPtr; const name: xmlCharPtr; const nameURI: xmlCharPtr; const value: xmlCharPtr) : xmlNodeSetPtr; cdecl; external LIBXSLT_SO;
  function xsltGetNamespace (ctxt: xsltTransformContextPtr; cur: xmlNodePtr; ns: xmlNsPtr; out_: xmlNodePtr) : xmlNsPtr; cdecl; external LIBXSLT_SO;
  function xsltGetNsProp (node: xmlNodePtr; const name: xmlCharPtr; const nameSpace: xmlCharPtr) : xmlCharPtr; cdecl; external LIBXSLT_SO;
  function xsltGetPlainNamespace (ctxt: xsltTransformContextPtr; cur: xmlNodePtr; ns: xmlNsPtr; out_: xmlNodePtr) : xmlNsPtr; cdecl; external LIBXSLT_SO;
  function xsltGetProfileInformation (ctxt: xsltTransformContextPtr) : xmlDocPtr; cdecl; external LIBXSLT_SO;
  function xsltGetQNameURI (node: xmlNodePtr; name: xmlCharPtrPtr) : xmlCharPtr; cdecl; external LIBXSLT_SO;
  function xsltGetQNameURI2 (style: xsltStylesheetPtr; node: xmlNodePtr; const name: xmlCharPtrPtr) : xmlCharPtr; cdecl; external LIBXSLT_SO;
  function xsltGetSecurityPrefs (sec: xsltSecurityPrefsPtr; option: xsltSecurityOption) : xsltSecurityCheck; cdecl; external LIBXSLT_SO;
  function xsltGetSpecialNamespace (ctxt: xsltTransformContextPtr; cur: xmlNodePtr; const URI: xmlCharPtr; const prefix: xmlCharPtr; out_: xmlNodePtr) : xmlNsPtr; cdecl; external LIBXSLT_SO;
  function xsltGetTemplate (ctxt: xsltTransformContextPtr; node: xmlNodePtr; style: xsltStylesheetPtr) : xsltTemplatePtr; cdecl; external LIBXSLT_SO;
  function xsltGetUTF8Char (const utf: PByte; len: PInteger) : Longint; cdecl; external LIBXSLT_SO;
  function xsltGetXIncludeDefault () : Longint; cdecl; external LIBXSLT_SO;
  procedure xsltIf (ctxt: xsltTransformContextPtr; node: xmlNodePtr; inst: xmlNodePtr; comp: xsltStylePreCompPtr); cdecl; external LIBXSLT_SO;
  function xsltInitCtxtExts (ctxt: xsltTransformContextPtr) : Longint; cdecl; external LIBXSLT_SO;
  procedure xsltInitCtxtKeys (ctxt: xsltTransformContextPtr; doc: xsltDocumentPtr); cdecl; external LIBXSLT_SO;
  procedure xsltInitElemPreComp (comp: xsltElemPreCompPtr; style: xsltStylesheetPtr; inst: xmlNodePtr; function_: xsltTransformFunction; freeFunc: xsltElemPreCompDeallocator); cdecl; external LIBXSLT_SO;
  function xsltIsBlank (str: xmlCharPtr) : Longint; cdecl; external LIBXSLT_SO;
  procedure xsltKeyFunction (ctxt: xmlXPathParserContextPtr; nargs: Longint); cdecl; external LIBXSLT_SO;
  function xsltLoadDocument (ctxt: xsltTransformContextPtr; const URI: xmlCharPtr) : xsltDocumentPtr; cdecl; external LIBXSLT_SO;
  function xsltLoadStyleDocument (style: xsltStylesheetPtr; const URI: xmlCharPtr) : xsltDocumentPtr; cdecl; external LIBXSLT_SO;
  function xsltLoadStylesheetPI (doc: xmlDocPtr) : xsltStylesheetPtr; cdecl; external LIBXSLT_SO;
  function xsltMatchPattern (ctxt: xsltTransformContextPtr; node: xmlNodePtr; const pattern: xmlCharPtr; ctxtdoc: xmlDocPtr; ctxtnode: xmlNodePtr) : Longint; cdecl; external LIBXSLT_SO;
  procedure xsltMessage (ctxt: xsltTransformContextPtr; node: xmlNodePtr; inst: xmlNodePtr); cdecl; external LIBXSLT_SO;
  procedure xsltNamespaceAlias (style: xsltStylesheetPtr; node: xmlNodePtr); cdecl; external LIBXSLT_SO;
  function xsltNeedElemSpaceHandling (ctxt: xsltTransformContextPtr) : Longint; cdecl; external LIBXSLT_SO;
  function xsltNewDocument (ctxt: xsltTransformContextPtr; doc: xmlDocPtr) : xsltDocumentPtr; cdecl; external LIBXSLT_SO;
  function xsltNewElemPreComp (style: xsltStylesheetPtr; inst: xmlNodePtr; function_: xsltTransformFunction) : xsltElemPreCompPtr; cdecl; external LIBXSLT_SO;
  function xsltNewSecurityPrefs () : xsltSecurityPrefsPtr; cdecl; external LIBXSLT_SO;
  function xsltNewStyleDocument (style: xsltStylesheetPtr; doc: xmlDocPtr) : xsltDocumentPtr; cdecl; external LIBXSLT_SO;
  function xsltNewStylesheet () : xsltStylesheetPtr; cdecl; external LIBXSLT_SO;
  function xsltNewTransformContext (style: xsltStylesheetPtr; doc: xmlDocPtr) : xsltTransformContextPtr; cdecl; external LIBXSLT_SO;
  function xsltNextImport (cur: xsltStylesheetPtr) : xsltStylesheetPtr; cdecl; external LIBXSLT_SO;
  procedure xsltNormalizeCompSteps (payload: Pointer; data: Pointer; const name: xmlCharPtr); cdecl; external LIBXSLT_SO;
  procedure xsltNumber (ctxt: xsltTransformContextPtr; node: xmlNodePtr; inst: xmlNodePtr; comp: xsltStylePreCompPtr); cdecl; external LIBXSLT_SO;
  procedure xsltNumberFormat (ctxt: xsltTransformContextPtr; data: xsltNumberDataPtr; node: xmlNodePtr); cdecl; external LIBXSLT_SO;
  procedure xsltParseGlobalParam (style: xsltStylesheetPtr; cur: xmlNodePtr); cdecl; external LIBXSLT_SO;
  procedure xsltParseGlobalVariable (style: xsltStylesheetPtr; cur: xmlNodePtr); cdecl; external LIBXSLT_SO;
  procedure xsltParseStylesheetAttributeSet (style: xsltStylesheetPtr; cur: xmlNodePtr); cdecl; external LIBXSLT_SO;
  function xsltParseStylesheetCallerParam (ctxt: xsltTransformContextPtr; cur: xmlNodePtr) : xsltStackElemPtr; cdecl; external LIBXSLT_SO;
  function xsltParseStylesheetDoc (doc: xmlDocPtr) : xsltStylesheetPtr; cdecl; external LIBXSLT_SO;
  function xsltParseStylesheetFile (const filename: xmlCharPtr) : xsltStylesheetPtr; cdecl; external LIBXSLT_SO;
  function xsltParseStylesheetImport (style: xsltStylesheetPtr; cur: xmlNodePtr) : Longint; cdecl; external LIBXSLT_SO;
  function xsltParseStylesheetImportedDoc (doc: xmlDocPtr; style: xsltStylesheetPtr) : xsltStylesheetPtr; cdecl; external LIBXSLT_SO;
  function xsltParseStylesheetInclude (style: xsltStylesheetPtr; cur: xmlNodePtr) : Longint; cdecl; external LIBXSLT_SO;
  procedure xsltParseStylesheetOutput (style: xsltStylesheetPtr; cur: xmlNodePtr); cdecl; external LIBXSLT_SO;
  procedure xsltParseStylesheetParam (ctxt: xsltTransformContextPtr; cur: xmlNodePtr); cdecl; external LIBXSLT_SO;
  function xsltParseStylesheetProcess (ret: xsltStylesheetPtr; doc: xmlDocPtr) : xsltStylesheetPtr; cdecl; external LIBXSLT_SO;
  procedure xsltParseStylesheetVariable (ctxt: xsltTransformContextPtr; cur: xmlNodePtr); cdecl; external LIBXSLT_SO;
  procedure xsltParseTemplateContent (style: xsltStylesheetPtr; templ: xmlNodePtr); cdecl; external LIBXSLT_SO;
  function xsltPreComputeExtModuleElement (style: xsltStylesheetPtr; inst: xmlNodePtr) : xsltElemPreCompPtr; cdecl; external LIBXSLT_SO;
  procedure xsltPrintErrorContext (ctxt: xsltTransformContextPtr; style: xsltStylesheetPtr; node: xmlNodePtr); cdecl; external LIBXSLT_SO;
  procedure xsltProcessingInstruction (ctxt: xsltTransformContextPtr; node: xmlNodePtr; inst: xmlNodePtr; comp: xsltStylePreCompPtr); cdecl; external LIBXSLT_SO;
  function xsltProfileStylesheet (style: xsltStylesheetPtr; doc: xmlDocPtr; const params: PPChar; output: PFILE) : xmlDocPtr; cdecl; external LIBXSLT_SO;
  function xsltQuoteOneUserParam (ctxt: xsltTransformContextPtr; const name: xmlCharPtr; const value: xmlCharPtr) : Longint; cdecl; external LIBXSLT_SO;
  function xsltQuoteUserParams (ctxt: xsltTransformContextPtr; const params: PPChar) : Longint; cdecl; external LIBXSLT_SO;
  procedure xsltRegisterAllElement (ctxt: xsltTransformContextPtr); cdecl; external LIBXSLT_SO;
  procedure xsltRegisterAllExtras (); cdecl; external LIBXSLT_SO;
  procedure xsltRegisterAllFunctions (ctxt: xmlXPathContextPtr); cdecl; external LIBXSLT_SO;
  function xsltRegisterExtElement (ctxt: xsltTransformContextPtr; const name: xmlCharPtr; const URI: xmlCharPtr; function_: xsltTransformFunction) : Longint; cdecl; external LIBXSLT_SO;
  function xsltRegisterExtFunction (ctxt: xsltTransformContextPtr; const name: xmlCharPtr; const URI: xmlCharPtr; function_: xmlXPathFunction) : Longint; cdecl; external LIBXSLT_SO;
  function xsltRegisterExtModule (const URI: xmlCharPtr; initFunc: xsltExtInitFunction; shutdownFunc: xsltExtShutdownFunction) : Longint; cdecl; external LIBXSLT_SO;
  function xsltRegisterExtModuleElement (const name: xmlCharPtr; const URI: xmlCharPtr; precomp: xsltPreComputeFunction; transform: xsltTransformFunction) : Longint; cdecl; external LIBXSLT_SO;
  function xsltRegisterExtModuleFull (const URI: xmlCharPtr; initFunc: xsltExtInitFunction; shutdownFunc: xsltExtShutdownFunction; styleInitFunc: xsltStyleExtInitFunction; styleShutdownFunc: xsltStyleExtShutdownFunction) : Longint; cdecl; external LIBXSLT_SO;
  function xsltRegisterExtModuleFunction (const name: xmlCharPtr; const URI: xmlCharPtr; function_: xmlXPathFunction) : Longint; cdecl; external LIBXSLT_SO;
  function xsltRegisterExtModuleTopLevel (const name: xmlCharPtr; const URI: xmlCharPtr; function_: xsltTopLevelFunction) : Longint; cdecl; external LIBXSLT_SO;
  function xsltRegisterExtPrefix (style: xsltStylesheetPtr; const prefix: xmlCharPtr; const URI: xmlCharPtr) : Longint; cdecl; external LIBXSLT_SO;
  procedure xsltRegisterExtras (ctxt: xsltTransformContextPtr); cdecl; external LIBXSLT_SO;
  function xsltRegisterPersistRVT (ctxt: xsltTransformContextPtr; RVT: xmlDocPtr) : Longint; cdecl; external LIBXSLT_SO;
  procedure xsltRegisterTestModule (); cdecl; external LIBXSLT_SO;
  function xsltRegisterTmpRVT (ctxt: xsltTransformContextPtr; RVT: xmlDocPtr) : Longint; cdecl; external LIBXSLT_SO;
  procedure xsltResolveStylesheetAttributeSet (style: xsltStylesheetPtr); cdecl; external LIBXSLT_SO;
  function xsltRunStylesheet (style: xsltStylesheetPtr; doc: xmlDocPtr; const params: PPChar; const output: PChar; SAX: xmlSAXHandlerPtr; IObuf: xmlOutputBufferPtr) : Longint; cdecl; external LIBXSLT_SO;
  function xsltRunStylesheetUser (style: xsltStylesheetPtr; doc: xmlDocPtr; const params: PPChar; const output: PChar; SAX: xmlSAXHandlerPtr; IObuf: xmlOutputBufferPtr; profile: PFILE; userCtxt: xsltTransformContextPtr) : Longint; cdecl; external LIBXSLT_SO;
  procedure xsltSaveProfiling (ctxt: xsltTransformContextPtr; output: PFILE); cdecl; external LIBXSLT_SO;
  function xsltSaveResultTo (buf: xmlOutputBufferPtr; result: xmlDocPtr; style: xsltStylesheetPtr) : Longint; cdecl; external LIBXSLT_SO;
  function xsltSaveResultToFd (fd: Longint; result: xmlDocPtr; style: xsltStylesheetPtr) : Longint; cdecl; external LIBXSLT_SO;
  function xsltSaveResultToFile (file_: PFILE; result: xmlDocPtr; style: xsltStylesheetPtr) : Longint; cdecl; external LIBXSLT_SO;
  function xsltSaveResultToFilename (const URL: PChar; result: xmlDocPtr; style: xsltStylesheetPtr; compression: Longint) : Longint; cdecl; external LIBXSLT_SO;
  function xsltSaveResultToString (doc_txt_ptr: xmlCharPtrPtr; doc_txt_len: PInteger; result: xmlDocPtr; style: xsltStylesheetPtr) : Longint; cdecl; external LIBXSLT_SO;
  function xsltSecurityAllow (sec: xsltSecurityPrefsPtr; ctxt: xsltTransformContextPtr; const value: PChar) : Longint; cdecl; external LIBXSLT_SO;
  function xsltSecurityForbid (sec: xsltSecurityPrefsPtr; ctxt: xsltTransformContextPtr; const value: PChar) : Longint; cdecl; external LIBXSLT_SO;
  function xsltSetCtxtParseOptions (ctxt: xsltTransformContextPtr; options: Longint) : Longint; cdecl; external LIBXSLT_SO;
  function xsltSetCtxtSecurityPrefs (sec: xsltSecurityPrefsPtr; ctxt: xsltTransformContextPtr) : Longint; cdecl; external LIBXSLT_SO;
  procedure xsltSetCtxtSortFunc (ctxt: xsltTransformContextPtr; handler: xsltSortFunc); cdecl; external LIBXSLT_SO;
  function xsltSetDebuggerCallbacks (no: Longint; block: Pointer) : Longint; cdecl; external LIBXSLT_SO;
  procedure xsltSetDebuggerStatus (value: Longint); cdecl; external LIBXSLT_SO;
  procedure xsltSetDefaultSecurityPrefs (sec: xsltSecurityPrefsPtr); cdecl; external LIBXSLT_SO;
  procedure xsltSetGenericDebugFunc (ctx: Pointer; handler: xmlGenericErrorFunc); cdecl; external LIBXSLT_SO;
  procedure xsltSetGenericErrorFunc (ctx: Pointer; handler: xmlGenericErrorFunc); cdecl; external LIBXSLT_SO;
  procedure xsltSetLoaderFunc (f: xsltDocLoaderFunc); cdecl; external LIBXSLT_SO;
  function xsltSetSecurityPrefs (sec: xsltSecurityPrefsPtr; option: xsltSecurityOption; func: xsltSecurityCheck) : Longint; cdecl; external LIBXSLT_SO;
  procedure xsltSetSortFunc (handler: xsltSortFunc); cdecl; external LIBXSLT_SO;
  procedure xsltSetTransformErrorFunc (ctxt: xsltTransformContextPtr; ctx: Pointer; handler: xmlGenericErrorFunc); cdecl; external LIBXSLT_SO;
  procedure xsltSetXIncludeDefault (xinclude: Longint); cdecl; external LIBXSLT_SO;
  procedure xsltShutdownCtxtExts (ctxt: xsltTransformContextPtr); cdecl; external LIBXSLT_SO;
  procedure xsltShutdownExts (style: xsltStylesheetPtr); cdecl; external LIBXSLT_SO;
  procedure xsltSort (ctxt: xsltTransformContextPtr; node: xmlNodePtr; inst: xmlNodePtr; comp: xsltStylePreCompPtr); cdecl; external LIBXSLT_SO;
  function xsltSplitQName (dict: xmlDictPtr; const name: xmlCharPtr; const prefix: xmlCharPtrPtr) : xmlCharPtr; cdecl; external LIBXSLT_SO;
  function xsltStyleGetExtData (style: xsltStylesheetPtr; const URI: xmlCharPtr) : Pointer; cdecl; external LIBXSLT_SO;
  procedure xsltStylePreCompute (style: xsltStylesheetPtr; inst: xmlNodePtr); cdecl; external LIBXSLT_SO;
  procedure xsltSystemPropertyFunction (ctxt: xmlXPathParserContextPtr; nargs: Longint); cdecl; external LIBXSLT_SO;
  function xsltTemplateProcess (ctxt: xsltTransformContextPtr; node: xmlNodePtr) : xmlNodePtrPtr; cdecl; external LIBXSLT_SO;
  function xsltTestCompMatchList (ctxt: xsltTransformContextPtr; node: xmlNodePtr; comp: xsltCompMatchPtr) : Longint; cdecl; external LIBXSLT_SO;
  procedure xsltText (ctxt: xsltTransformContextPtr; node: xmlNodePtr; inst: xmlNodePtr; comp: xsltStylePreCompPtr); cdecl; external LIBXSLT_SO;
  function xsltTimestamp () : Longint; cdecl; external LIBXSLT_SO;
  procedure xsltTransformError (ctxt: xsltTransformContextPtr; style: xsltStylesheetPtr; node: xmlNodePtr; const msg: PChar); cdecl; varargs; external LIBXSLT_SO;
  procedure xsltUnparsedEntityURIFunction (ctxt: xmlXPathParserContextPtr; nargs: Longint); cdecl; external LIBXSLT_SO;
  function xsltUnregisterExtModule (const URI: xmlCharPtr) : Longint; cdecl; external LIBXSLT_SO;
  function xsltUnregisterExtModuleElement (const name: xmlCharPtr; const URI: xmlCharPtr) : Longint; cdecl; external LIBXSLT_SO;
  function xsltUnregisterExtModuleFunction (const name: xmlCharPtr; const URI: xmlCharPtr) : Longint; cdecl; external LIBXSLT_SO;
  function xsltUnregisterExtModuleTopLevel (const name: xmlCharPtr; const URI: xmlCharPtr) : Longint; cdecl; external LIBXSLT_SO;
  procedure xsltValueOf (ctxt: xsltTransformContextPtr; node: xmlNodePtr; inst: xmlNodePtr; comp: xsltStylePreCompPtr); cdecl; external LIBXSLT_SO;
  function xsltVariableLookup (ctxt: xsltTransformContextPtr; const name: xmlCharPtr; const ns_uri: xmlCharPtr) : xmlXPathObjectPtr; cdecl; external LIBXSLT_SO;
  function xsltXPathCompile (style: xsltStylesheetPtr; const str: xmlCharPtr) : xmlXPathCompExprPtr; cdecl; external LIBXSLT_SO;
  function xsltXPathFunctionLookup (ctxt: xmlXPathContextPtr; const name: xmlCharPtr; const ns_uri: xmlCharPtr) : xmlXPathFunction; cdecl; external LIBXSLT_SO;
  function xsltXPathGetTransformContext (ctxt: xmlXPathParserContextPtr) : xsltTransformContextPtr; cdecl; external LIBXSLT_SO;
  function xsltXPathVariableLookup (ctxt: Pointer; const name: xmlCharPtr; const ns_uri: xmlCharPtr) : xmlXPathObjectPtr; cdecl; external LIBXSLT_SO;
var
  __xslDebugStatus: PInteger;
var
  __xsltDocDefaultLoader: xsltDocLoaderFuncPtr;
  function xsltEngineVersion(): PChar; cdecl;
  function xsltExtMarker(): xmlCharPtr; cdecl;
var
  __xsltGenericDebug: xmlGenericErrorFuncPtr;
var
  __xsltGenericDebugContext: PPointer;
var
  __xsltGenericError: xmlGenericErrorFuncPtr;
var
  __xsltGenericErrorContext: PPointer;
  function xsltLibxmlVersion(): Longint; cdecl;
  function xsltLibxsltVersion(): Longint; cdecl;
var
  __xsltMaxDepth: PInteger;

implementation
uses
{$IFDEF WIN32}
  Windows,
{$ENDIF}
  SysUtils;

var
  libHandle: THandle;

// Utility function to make sure procedure entry points are not null

procedure CheckForNil(ptr: Pointer; name:string);
begin
  if not Assigned(ptr) then
    raise Exception.Create('"' + name + '" could not be loaded from the dynamic library ' + LIBXSLT_SO);
end;

var
   pxsltEngineVersion: PPChar;

function xsltEngineVersion: PChar;
begin
  CheckForNil(pxsltEngineVersion, 'xsltEngineVersion');
  Result := pxsltEngineVersion^;
end;

var
   pxsltExtMarker: xmlCharPtrPtr;

function xsltExtMarker: xmlCharPtr;
begin
  CheckForNil(pxsltExtMarker, 'xsltExtMarker');
  Result := pxsltExtMarker^;
end;

var
   pxsltLibxmlVersion: PInteger;

function xsltLibxmlVersion: Longint;
begin
  CheckForNil(pxsltLibxmlVersion, 'xsltLibxmlVersion');
  Result := pxsltLibxmlVersion^;
end;

var
   pxsltLibxsltVersion: PInteger;

function xsltLibxsltVersion: Longint;
begin
  CheckForNil(pxsltLibxsltVersion, 'xsltLibxsltVersion');
  Result := pxsltLibxsltVersion^;
end;



initialization
  // The Delphi 'external' directive can be used for functions and procedures,
  // but here we need to obtain the addresses of POINTERS to functions. We can
  // get to these addresses (and also those of other data values exported from
  // the DLL) by using GetProcAddress.
  libHandle := LoadLibrary(LIBXSLT_SO);
  if libHandle <> 0 then 
  begin
    __xslDebugStatus := PInteger(GetProcAddress(libHandle, 'xslDebugStatus'));
    __xsltDocDefaultLoader := xsltDocLoaderFuncPtr(GetProcAddress(libHandle, 'xsltDocDefaultLoader'));
    pxsltEngineVersion := PPChar(GetProcAddress(libHandle, 'xsltEngineVersion'));
    pxsltExtMarker := xmlCharPtrPtr(GetProcAddress(libHandle, 'xsltExtMarker'));
    __xsltGenericDebug := xmlGenericErrorFuncPtr(GetProcAddress(libHandle, 'xsltGenericDebug'));
    __xsltGenericDebugContext := PPointer(GetProcAddress(libHandle, 'xsltGenericDebugContext'));
    __xsltGenericError := xmlGenericErrorFuncPtr(GetProcAddress(libHandle, 'xsltGenericError'));
    __xsltGenericErrorContext := PPointer(GetProcAddress(libHandle, 'xsltGenericErrorContext'));
    pxsltLibxmlVersion := PInteger(GetProcAddress(libHandle, 'xsltLibxmlVersion'));
    pxsltLibxsltVersion := PInteger(GetProcAddress(libHandle, 'xsltLibxsltVersion'));
    __xsltMaxDepth := PInteger(GetProcAddress(libHandle, 'xsltMaxDepth'));

    FreeLibrary(libHandle);
  end;

end.
