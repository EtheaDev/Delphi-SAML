{******************************************************************************}
{                                                                              }
{  Delphi SAML                                                                 }
{  Copyright (c) 2022-2023 Ethea S.r.l.                                        }
{  Author: Luca Minuti                                                         }
{  https://github.com/EtheaDev/Delphi-SAML                                     }
{                                                                              }
{******************************************************************************}
{                                                                              }
{  Licensed under the Apache License, Version 2.0 (the "License");             }
{  you may not use this file except in compliance with the License.            }
{  You may obtain a copy of the License at                                     }
{                                                                              }
{      http://www.apache.org/licenses/LICENSE-2.0                              }
{                                                                              }
{  Unless required by applicable law or agreed to in writing, software         }
{  distributed under the License is distributed on an "AS IS" BASIS,           }
{  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    }
{  See the License for the specific language governing permissions and         }
{  limitations under the License.                                              }
{                                                                              }
{******************************************************************************}
unit SAML.XML.Utils;

interface

uses
  System.Classes, System.SysUtils, System.SyncObjs,
  libxml2, libxmlsec;

type
  EXMLError = class(Exception);

  ESAMLNotImplemented = class(EXMLError);

  {$SCOPEDENUMS ON}
  TTemplateOption = (InjectCertificate);

  TKeyDataFormat = (
    Unknown = 0,
    Binary = 1,
    Pem = 2,
    Der = 3,
    Pkcs8Pem = 4,
    Pkcs8Der = 5,
    Pkcs12 = 6,
    CertPem = 7,
    CertDer = 8
  );
  {$SCOPEDENUMS OFF}

  TTemplateOptions = set of TTemplateOption;

  IXMLSecDocument = interface;

  IXMLSecNode = interface
    ['{3E25268B-1BA8-4055-B5A6-CF8949F6E439}']
    function GetNodeName: string;
    function GetNamespace: string;
    function GetText: string;
    function GetID: string;
    function GetDocument: IXMLSecDocument;
    function FindNode(const ANodeName, ANodeNameSpace: string): IXMLSecNode;
    function TryFindNode(const ANodeName, ANodeNameSpace: string; out ANode: IXMLSecNode): Boolean;

    property NodeName: string read GetNodeName;
    property Namespace: string read GetNamespace;
    property Document: IXMLSecDocument read GetDocument;
    property Text: string read GetText;
    property ID: string read GetID;
  end;

  IXMLSecDocument = interface
    ['{8C7E8120-AD30-4E7D-9725-0439625D9145}']
    function Root: IXMLSecNode;
    function FindNode(const ANodeName, ANodeNameSpace: string): IXMLSecNode;
    function TryFindNode(const ANodeName, ANodeNameSpace: string; out ANode: IXMLSecNode): Boolean;
    procedure CheckSignatureTemplate(const AId: string; AOptions: TTemplateOptions);
    procedure AddIDAttr(const AAttributeName, ANodeName, ANameSpace: string);
    procedure SetRootElement(ANode: IXMLSecNode);
    function ToXML: string;
    procedure SaveToFile(const AFileName: string);
  end;

  ISignatureContext = interface
    ['{14110BA5-ACEA-4F22-9D52-1A31E4327A96}']
    procedure LoadKey(AStream: TStream; AFormat: TKeyDataFormat; AOwnsStream: Boolean);
    procedure LoadCeriticate(AStream: TStream; AFormat: TKeyDataFormat; AOwnsStream: Boolean);
    function DumpKey: string;
    procedure Sign(AXMLDocument: IXMLSecDocument);
    function Verify(AXMLNode: IXMLSecNode): Boolean; overload;
    function Verify(AXMLDocument: IXMLSecDocument): Boolean; overload;
  end;

  IEncryptionContext = interface
    ['{F7BD8FA6-7626-440D-82A1-1D67DB735FFF}']
    procedure LoadKey(AStream: TStream; AFormat: TKeyDataFormat; AOwnsStream: Boolean);
    function IsEncrypted(AXMLDocument: IXMLSecDocument): Boolean;
    procedure Encrypt(AXMLDocument: IXMLSecDocument);
    procedure Decrypt(AXMLDocument: IXMLSecDocument);
  end;

  IXMLSchemaValidContext = interface
    ['{F6728880-4098-48E2-B564-41C5996F2D14}']
    procedure ValidateOneElement(ANode: IXMLSecNode);
  end;

  TSignatureContext = class(TInterfacedObject, ISignatureContext)
  private
    FStream: TStream;
    FOwnsStream: Boolean;
    dsigCtx: xmlSecDSigCtxPtr;
  public
    { ISignatureContext }
    procedure LoadKey(AStream: TStream; AFormat: TKeyDataFormat; AOwnsStream: Boolean);
    procedure LoadCeriticate(AStream: TStream; AFormat: TKeyDataFormat; AOwnsStream: Boolean);
    procedure Sign(AXMLDocument: IXMLSecDocument);
    function DumpKey: string;
    function Verify(AXMLNode: IXMLSecNode): Boolean; overload;
    function Verify(AXMLDocument: IXMLSecDocument): Boolean; overload;

    constructor Create;
    destructor Destroy; override;
  end;

  TEncryptionContext = class(TInterfacedObject, IEncryptionContext)
  private
    encCtx: xmlSecEncCtxPtr;
    keysMngr: xmlSecKeysMngrPtr;
    FStream: TStream;
    FOwnsStream: Boolean;
  public
    { IEncryptionContext }
    procedure LoadKey(AStream: TStream; AFormat: TKeyDataFormat; AOwnsStream: Boolean);
    function IsEncrypted(AXMLDocument: IXMLSecDocument): Boolean;
    procedure Encrypt(AXMLDocument: IXMLSecDocument);
    procedure Decrypt(AXMLDocument: IXMLSecDocument);

    constructor Create;
    destructor Destroy; override;
  end;

  TXMLSecDocument = class(TInterfacedObject, IXMLSecDocument)
  private
    FDocPtr: xmlDocPtr;
    FStream: TStream;
    FOwnsStream: Boolean;
    procedure ParseXMLStream;
  public
    function Root: IXMLSecNode;
    function FindNode(const ANodeName, ANodeNameSpace: string): IXMLSecNode;
    function TryFindNode(const ANodeName, ANodeNameSpace: string; out ANode: IXMLSecNode): Boolean;
    procedure AddIDAttr(const AAttributeName, ANodeName, ANameSpace: string);
    procedure SetRootElement(ANode: IXMLSecNode);
    procedure AddSignatureTemplate(const AId: string; AOptions: TTemplateOptions);
    procedure CheckSignatureTemplate(const AId: string; AOptions: TTemplateOptions);
    function ToXML: string;
    procedure SaveToFile(const AFileName: string);

    constructor Create(AStream: TStream; AOwnsStream: Boolean);
    destructor Destroy; override;
  end;

  TXMLSecNode = class(TInterfacedObject, IXMLSecNode)
  private
    FNode: xmlNodePtr;
    FDocument: IXMLSecDocument;
  public
    { IXMLSecNode }
    function GetNodeName: string;
    function GetNamespace: string;
    function GetText: string;
    function GetID: string;
    function GetDocument: IXMLSecDocument;
    function FindNode(const ANodeName, ANodeNameSpace: string): IXMLSecNode;
    function TryFindNode(const ANodeName, ANodeNameSpace: string; out ANode: IXMLSecNode): Boolean;

    constructor Create(ADocument: IXMLSecDocument; ANode: xmlNodePtr);
  end;

  TXMLSchemaValidContext = class(TInterfacedObject, IXMLSchemaValidContext)
  private
    FSchemaPtr: xmlSchemaPtr;
    FSchemaParserCtxt :xmlSchemaParserCtxtPtr;
    FSchemaValidCtxt :xmlSchemaValidCtxtPtr;

    FStream: TStream;
    FOwnsStream: Boolean;
    procedure ParseSchemaStream;
  public
    {IXMLSchema}
    procedure ValidateOneElement(ANode: IXMLSecNode);

    constructor Create(AStream: TStream; AOwnsStream: Boolean);
    destructor Destroy; override;
  end;

  TXMLCatalog = class
  public
    class procedure LoadFromFile(const AFileName: string); static;
  end;

  TXMLSecError = record
    ErrorMessage: string;
    Func, Name: string;
    Line: Integer;
    ErrorObject, Subject: string;
    ErrorNo: Integer;
    ErrorString1, ErrorString2: string
  end;

  TErrorProc = reference to procedure (const ASecError: TXMLSecError);

  TXMLSec = class
  private
    class var FErrorProc: TErrorProc;
    class procedure ErrorNotify(const AMessage: string; const AFunc, AName: string; ALine: Integer; const AObject, ASubject: string; AErrorNo: Integer; const AErrorString1, AErrorString2: string);  public
  public
    class procedure RegisterErrorCallback(AErrorProc: TErrorProc); static;
  end;

const
  xmlSecKeyDataTypeUnknown = $0000;
  xmlSecKeyDataTypeNone = xmlSecKeyDataTypeUnknown;
  xmlSecKeyDataTypePublic = $0001;
  xmlSecKeyDataTypePrivate = $0002;
  xmlSecKeyDataTypeSymmetric = $0004;
  xmlSecKeyDataTypeSession = $0008;
  xmlSecKeyDataTypePermanent = $0010;
  xmlSecKeyDataTypeTrusted = $0100;
  xmlSecKeyDataTypeAny = $ffff;

implementation

{$DEFINE ENABLE_ERROR_CALLBACK}

uses
  libxslt;

var
  XmlCryptInitialized: Boolean = False;
  XmlCryptInitLock: TCriticalSection;

procedure LibXMLRaiseLastError(const AMessage: String = '');
var
  err :xmlErrorPtr;
begin
  err := xmlGetLastError();
  raise Exception.Create(AMessage + ' ' + string(err.message){, err.line});
end;

procedure LibXMLCheck(retCode: Integer);
begin
  if retCode <> 0 then
    LibXMLRaiseLastError();
end;

// 'func=%s:file=%s:line=%d:obj=%s:subj=%s:error=%d:%s:%s'#$A
{$IFDEF ENABLE_ERROR_CALLBACK}
procedure ErrorCallback(ctx: Pointer; const msg: PAnsiChar; const func, fname: PAnsiChar; line: Integer; const obj, sub: PAnsiChar; error_n: Integer; const error_s1, error_s2: PAnsiChar); cdecl;
var
  LMessage: string;
begin
  LMessage := Format(string(msg), [func, fname, line, obj, sub, error_n, error_s1, error_s2]);
  TXMLSec.ErrorNotify(LMessage, string(func), string(fname), line, string(obj), string(sub), error_n, string(error_s1), string(error_s2));
end;
{$ENDIF}

procedure XmlCryptInit;
var
  xsltSecPrefs: xsltSecurityPrefsPtr;
//  xmlLoadExtDtdDefaultValue: LIBXML_TEST_VERSION;
begin
  if XmlCryptInitialized then
    Exit;

  XmlCryptInitLock.Acquire;
  try
    // Double check in case of concurent threads
    if XmlCryptInitialized then
      Exit;

    {$IFDEF ENABLE_ERROR_CALLBACK}
    xmlSetGenericErrorFunc(nil, ErrorCallback);
    {$ENDIF}

   // Init libxml and libxslt libraries */
    xmlInitParser();
  //  xmlLoadExtDtdDefaultValue := XML_DETECT_IDS or XML_COMPLETE_ATTRS;
    xmlSubstituteEntitiesDefault(1);
    {$IFDEF XMLSEC_NO_XSLT}
      xmlIndentTreeOutput = 1;
    {$ENDIF}

      xsltSecPrefs := xsltNewSecurityPrefs();
      xsltSetSecurityPrefs(xsltSecPrefs,  XSLT_SECPREF_READ_FILE,        xsltSecurityForbid);
      xsltSetSecurityPrefs(xsltSecPrefs,  XSLT_SECPREF_WRITE_FILE,       xsltSecurityForbid);
      xsltSetSecurityPrefs(xsltSecPrefs,  XSLT_SECPREF_CREATE_DIRECTORY, xsltSecurityForbid);
      xsltSetSecurityPrefs(xsltSecPrefs,  XSLT_SECPREF_READ_NETWORK,     xsltSecurityForbid);
      xsltSetSecurityPrefs(xsltSecPrefs,  XSLT_SECPREF_WRITE_NETWORK,    xsltSecurityForbid);
      xsltSetDefaultSecurityPrefs(xsltSecPrefs);

    // Init xmlsec library */
    if xmlSecInit() < 0 then
    begin
      raise EXMLError.Create('Error: xmlsec initialization failed');
    end;

    // Check loaded library version */
  //  if xmlSecCheckVersion() <> 1)
  //  begin
  //	  raise ESignError.Create('Error: loaded xmlsec library version is not compatible');
  //  end;

  //   Load default crypto engine if we are supporting dynamic
  //   loading for xmlsec-crypto libraries. Use the crypto library
  //   name ("openssl", "nss", etc.) to load corresponding
  //   xmlsec-crypto library.

    if xmlSecCryptoDLLoadLibrary('openssl') < 0 then
    begin
      raise EXMLError.Create('Error: unable to load default xmlsec-crypto library');
    end;

    // Init crypto library */
    if xmlSecCryptoAppInit(nil) < 0 then
    begin
      raise EXMLError.Create('Error: crypto initialization failed');
    end;

    // Init xmlsec-crypto library */
    if xmlSecCryptoInit() < 0  then
    begin
      raise EXMLError.Create('Error: xmlsec-crypto initialization failed');
    end;
  finally
    XmlCryptInitLock.Release;
  end;
  XmlCryptInitialized := True;
end;

procedure XmlCryptShutdown;
begin
  // TODO: to be thread safe probably this code should be
  // run in the finalization section

  if not XmlCryptInitialized then
    Exit;

  // Shutdown xmlsec-crypto library */
  xmlSecCryptoShutdown();

  // Shutdown crypto library */
  xmlSecCryptoAppShutdown();

  // Shutdown xmlsec library */
  xmlSecShutdown();

  // Shutdown libxslt/libxml */
  {$IFDEF XMLSEC_NO_XSLT}
    xsltCleanupGlobals();
  {$ENDIF}
    xmlCleanupParser();
end;

procedure xmlSecAppAddIDAttr(node: xmlNodePtr; const attrName, nodeName, nsHref: PAnsiChar);
var
  attr, tmpAttr: xmlAttrPtr;
  cur: xmlNodePtr;
  id: PAnsiChar;
begin

  id := nil;
  try
    Assert(node <> nil);
    Assert(attrName <> nil);
    Assert(nodeName <> nil);

    (* process children first because it does not matter much but does simplify code *)
    cur := xmlSecGetNextElementNode(node.children);
    while cur <> nil do
    begin
      xmlSecAppAddIDAttr(cur, attrName, nodeName, nsHref);
      cur := xmlSecGetNextElementNode(cur.next);
    end;

    (* node name must match *)
    if not xmlStrEqual(node.name, nodeName) then
    begin
      Exit;
    end;

    (* if nsHref is set then it also should match *)
    if ((nsHref <> nil) and (node.ns <> nil) and (not xmlStrEqual(nsHref, node.ns.href))) then
    begin
      Exit;
    end;

    (* the attribute with name equal to attrName should exist *)
    attr := node.properties;
    while attr <> nil do
    begin
      if xmlStrEqual(attr.name, attrName) then
      begin
        Break;
      end;
      attr := attr.next;
    end;

    if attr = nil then
    begin
      Exit;
    end;

    (* and this attr should have a value *)
    id := xmlNodeListGetString(node.doc, attr.children, 1);
    if id = nil then
    begin
      Exit;
    end;

    (* check that we don't have same ID already *)
    tmpAttr := xmlGetID(node.doc, id);
    if tmpAttr = nil then
    begin
      xmlAddID(nil, node.doc, id, attr);
    end
    else if tmpAttr <> attr then
    begin
      raise EXMLError.CreateFmt('Error: duplicate ID attribute "%s"', [id]);
    end;
  finally
    if id <> nil then
      xmlFree(id);
  end;
end;


{ TXMLDocumentWrapper }

procedure TXMLSecDocument.AddIDAttr(const AAttributeName, ANodeName,
  ANameSpace: string);
var
  doc: xmlNodePtr;
begin
  doc := xmlSecGetNextElementNode(FDocPtr.children);

  xmlSecAppAddIDAttr(doc,
    PAnsiChar(AnsiString(AAttributeName)),
    PAnsiChar(AnsiString(ANodeName)),
    PAnsiChar(AnsiString(ANameSpace))
  );
end;

procedure TXMLSecDocument.AddSignatureTemplate(const AId: string; AOptions: TTemplateOptions);
const
  SiblingNodeName = 'Issuer';
  SiblingNodeNS = 'urn:oasis:names:tc:SAML:2.0:assertion';
var
  signNode: xmlNodePtr;
  refNode: xmlNodePtr;
  keyInfoNode: xmlNodePtr;
  X509DataNode: xmlNodePtr;
  SiblingNode: xmlNodePtr;
  ReferenceUri: AnsiString;
begin
  // create signature template for RSA-SHA1 enveloped signature */
  signNode := xmlSecTmplSignatureCreate(FDocPtr, xmlSecTransformExclC14NGetKlass(), xmlSecTransformRsaSha256GetKlass(), nil);
  if signNode = nil then
  begin
    raise EXMLError.Create('Error: failed to create signature template');
  end;

  SiblingNode := xmlSecFindNode(xmlDocGetRootElement(FDocPtr), PAnsiChar(AnsiString(SiblingNodeName)), PAnsiChar(AnsiString(SiblingNodeNS)));
  if SiblingNode = nil then
    xmlAddChild(xmlDocGetRootElement(FDocPtr), signNode)
  else
    xmlAddNextSibling(SiblingNode, signNode);

  ReferenceUri := AnsiString('#' + AId);

  // add reference
  refNode := xmlSecTmplSignatureAddReference(signNode, xmlSecTransformSha256GetKlass(), nil, PAnsiChar(ReferenceUri), nil);
  if refNode = nil then
  begin
    raise EXMLError.Create('Error: failed to add reference to signature template');
  end;

  // add enveloped transform
  if xmlSecTmplReferenceAddTransform(refNode, xmlSecTransformEnvelopedGetKlass()) = nil then
  begin
    raise EXMLError.Create('Error: failed to add enveloped transform to reference');
  end;

  if TTemplateOption.InjectCertificate in AOptions then
  begin
    // add <dsig:KeyInfo/> node to put key name in the signed document
    keyInfoNode := xmlSecTmplSignatureEnsureKeyInfo(signNode, nil);
    if keyInfoNode = nil then
    begin
      raise EXMLError.Create('Error: failed to add key info');
    end;

    (*
    if xmlSecTmplKeyInfoAddKeyName(keyInfoNode, nil) = nil then
    begin
      raise EXMLError.Create('Error: failed to add key name');
    end;
    *)

    X509DataNode := xmlSecTmplKeyInfoAddX509Data(keyInfoNode);
    if X509DataNode = nil then
    begin
      raise EXMLError.Create('Error: failed to add X509Data');
    end;

    if xmlSecTmplX509DataAddCertificate(X509DataNode) = nil then
    begin
      raise EXMLError.Create('Error: failed to add Certificate value');
    end;
  end;
end;

procedure TXMLSecDocument.CheckSignatureTemplate(const AId: string; AOptions: TTemplateOptions);
var
  ANode: IXMLSecNode;
begin
  if not TryFindNode(string(xmlSecNodeSignature), string(xmlSecDSigNs), ANode) then
    AddSignatureTemplate(AId, AOptions);
end;

constructor TXMLSecDocument.Create(AStream: TStream; AOwnsStream: Boolean);
begin
  inherited Create;
  XmlCryptInit;
  FStream := AStream;
  FOwnsStream := AOwnsStream;
  FDocPtr := nil;
  ParseXMLStream;
end;

destructor TXMLSecDocument.Destroy;
begin
  if FOwnsStream then
    FStream.Free;
  if FDocPtr <> nil then
    xmlFreeDoc(FDocPtr);
  inherited;
end;

procedure TXMLSecDocument.ParseXMLStream;
var
  LBuffer: AnsiString;
begin
  Assert(FStream <> nil);
  Assert(FStream.Size > 0);

  SetLength(LBuffer, FStream.Size);
  FStream.ReadBuffer(LBuffer[1], FStream.Size);
  FDocPtr := xmlParseMemory(PAnsiChar(LBuffer), FStream.Size);
  if (FDocPtr = nil) or (xmlDocGetRootElement(FDocPtr) = nil) then
    raise EXMLError.Create('Error: unable to parse XML');
end;

function TXMLSecDocument.Root: IXMLSecNode;
begin
  Result := TXMLSecNode.Create(Self, FDocPtr.children);
end;

procedure TXMLSecDocument.SaveToFile(const AFileName: string);
begin
  xmlSaveFile(PAnsiChar(AnsiString(AFileName)), FDocPtr);
end;

function TXMLSecDocument.FindNode(const ANodeName, ANodeNameSpace: string): IXMLSecNode;
begin
  if not TryFindNode(ANodeName, ANodeNameSpace, Result) then
    raise EXMLError.CreateFmt('Error: node "%s" not found (%s)', [ANodeName, ANodeNameSpace]);
end;

procedure TXMLSecDocument.SetRootElement(ANode: IXMLSecNode);
var
  LNodePtr: xmlNodePtr;
begin
  LNodePtr := (ANode as TXMLSecNode).FNode;
  xmlDocSetRootElement(FDocPtr, LNodePtr);
end;

function TXMLSecDocument.ToXML: string;
var
  PResult :xmlCharPtr;
  ResLength: Integer;
begin
  xmlDocDumpFormatMemoryEnc(FDocPtr, @PResult, @ResLength, 'UTF8', 0);
  Result := UTF8ToString(PResult);
end;

function TXMLSecDocument.TryFindNode(const ANodeName, ANodeNameSpace: string;
  out ANode: IXMLSecNode): Boolean;
var
  node: xmlNodePtr;
begin
  // find start node
  // xmlSecNodeSignature, xmlSecDSigNs
  node := xmlSecFindNode(xmlDocGetRootElement(FDocPtr), PAnsiChar(AnsiString(ANodeName)), PAnsiChar(AnsiString(ANodeNameSpace)));
  if node = nil then
  begin
    Exit(False);
  end;
  ANode := TXMLSecNode.Create(Self, node);
  Exit(True);
end;

{ TSignatureContext }

constructor TSignatureContext.Create;
begin
  inherited Create;
  FOwnsStream := False;
  XmlCryptInit;

  // create signature context, we don't need keys manager in this example */
  dsigCtx := xmlSecDSigCtxCreate(nil);
  if dsigCtx = nil then
  begin
    raise EXMLError.Create('Error: failed to create signature context');
  end;
end;

destructor TSignatureContext.Destroy;
begin
  if FOwnsStream then
    FStream.Free;
  if dsigCtx <> nil then
    xmlSecDSigCtxDestroy(dsigCtx);

  //XmlCryptShutdown;
  inherited;
end;

function TSignatureContext.DumpKey: string;
var
  LMethod: string;
  key: xmlSecKeyPtr;
begin
  // TODO: give some information about the key
  // see xmlSecKeyDebugDump implementation

  Assert(dsigCtx.signKey <> nil);

  key := dsigCtx.signKey;

  if key.value.id.dataNodeName <> nil then
    LMethod := string(AnsiString(key.value.id.dataNodeName))
  else
    LMethod := 'NULL';

  Result := 'KEY' + sLineBreak;
  Result := Result + LMethod + sLineBreak;

  Result := Result + '=== key type: ';
  if (xmlSecKeyGetType(key) and xmlSecKeyDataTypeSymmetric) <> 0 then
    Result := Result + 'Symmetric' + sLineBreak
  else if (xmlSecKeyGetType(key) and xmlSecKeyDataTypePrivate) <> 0 then
    Result := Result + 'Private' + sLineBreak
  else if (xmlSecKeyGetType(key) and xmlSecKeyDataTypePublic) <> 0 then
    Result := Result + 'Symmetric' + sLineBreak
  else
    Result := Result + 'Unknown' + sLineBreak;

  if key <> nil then
    Result := Result + '=== key name: ' + string(AnsiString(key.name) + sLineBreak);

  Result := Result + '=== key usage: ' + key.usage.ToString + sLineBreak;

  if key.notValidBefore < key.notValidAfter then
  begin
    Result := Result + Format('=== key not valid before: %.lf' + sLineBreak, [key.notValidBefore]);
    Result := Result + Format('=== key not valid after: %.lf' + sLineBreak, [key.notValidAfter]);
  end;


end;

procedure TSignatureContext.LoadCeriticate(AStream: TStream; AFormat: TKeyDataFormat; AOwnsStream: Boolean);
var
  data: xmlSecBytePtr;
  dataSize: NativeInt;
begin
  Assert(AStream <> nil);
  Assert(AStream.Size > 0);

  FStream := AStream;
  FOwnsStream := AOwnsStream;

  dataSize := AStream.Size;
  data := AllocMem(dataSize);
  try
    AStream.ReadBuffer(data^, dataSize);

    // load certificate and add to the key
    //dsigCtx.signKey := xmlSecCryptoAppKeyLoadMemory(data, dataSize, xmlSecKeyDataFormat(AFormat), nil, nil, nil);
    if xmlSecCryptoAppKeyCertLoadMemory(dsigCtx.signKey, data, dataSize, xmlSecKeyDataFormat(AFormat)) < 0 then
    begin
      raise EXMLError.Create('Error: failed to load key');
    end;
  finally
    FreeMem(data);
  end;
end;

procedure TSignatureContext.LoadKey(AStream: TStream; AFormat: TKeyDataFormat;
  AOwnsStream: Boolean);
var
  data: xmlSecBytePtr;
  dataSize: NativeInt;
begin
  Assert(AStream <> nil);
  Assert(AStream.Size > 0);

  FStream := AStream;
  FOwnsStream := AOwnsStream;

  dataSize := AStream.Size;
  data := AllocMem(dataSize);
  try
    AStream.ReadBuffer(data^, dataSize);

    // load private key, assuming that there is not password */
    //dsigCtx.signKey := xmlSecCryptoAppKeyLoad(key_file, xmlSecKeyDataFormatPem, nil, nil, nil);
    dsigCtx.signKey := xmlSecCryptoAppKeyLoadMemory(data, dataSize, xmlSecKeyDataFormat(AFormat), nil, nil, nil);
    if dsigCtx.signKey = nil then
    begin
      raise EXMLError.Create('Error: failed to load key');
    end;
  finally
    FreeMem(data);
  end;

//  // set key name to the file name, this is just an example! */
//  if xmlSecKeySetName(dsigCtx.signKey, PAnsiChar(key_file)) < 0 then
//  begin
//    raise ESignError.CreateFmt('Error: failed to set key name for key from "%s"', [key_file]);
//  end;
end;

procedure TSignatureContext.Sign(AXMLDocument: IXMLSecDocument);
var
  node: xmlNodePtr;
begin
  node := (AXMLDocument.FindNode(string(xmlSecNodeSignature), string(xmlSecDSigNs)) as TXMLSecNode).FNode;

  // sign the template
  if xmlSecDSigCtxSign(dsigCtx, node) < 0 then
  begin
    raise EXMLError.Create('Error: signature failed');
  end;

end;

function TSignatureContext.Verify(AXMLDocument: IXMLSecDocument): Boolean;
var
  LXMLNode: IXMLSecNode;
begin
  LXMLNode := AXMLDocument.Root;
  Result := Verify(LXMLNode);
end;

function TSignatureContext.Verify(AXMLNode: IXMLSecNode): Boolean;
var
  node: xmlNodePtr;
begin
  node := (AXMLNode.FindNode(string(xmlSecNodeSignature), string(xmlSecDSigNs)) as TXMLSecNode).FNode;

  // Verify signature
  if xmlSecDSigCtxVerify(dsigCtx, node) < 0 then
  begin
    raise EXMLError.Create('Error: signature verify');
  end;

  Result := dsigCtx.status = xmlSecDSigStatusSucceeded;
end;

{ TXMLSecNode }

constructor TXMLSecNode.Create(ADocument: IXMLSecDocument; ANode: xmlNodePtr);
begin
  inherited Create;
  FDocument := ADocument;
  FNode := ANode;
end;

function TXMLSecNode.FindNode(const ANodeName,
  ANodeNameSpace: string): IXMLSecNode;
begin
  if not TryFindNode(ANodeName, ANodeNameSpace, Result) then
    raise EXMLError.CreateFmt('Error: node "%s" not found (%s)', [ANodeName, ANodeNameSpace]);
end;

function TXMLSecNode.GetDocument: IXMLSecDocument;
begin
  Result := FDocument;
end;

function TXMLSecNode.GetID: string;
var
  LAttrib: xmlAttrPtr;
  LValue: xmlCharPtr;
begin
  LAttrib := FNode^.properties;
  while LAttrib <> nil do
  begin
    if AnsiString(LAttrib.name) = 'ID' then
    begin
      LValue := xmlNodeListGetString(FNode.doc, LAttrib^.children, 1);
      Result := string(LValue);
      xmlFree(LValue);
      Exit;
    end;
    LAttrib := LAttrib^.next;
  end;
end;

function TXMLSecNode.GetNamespace: string;
begin
  if FNode = nil then
    Exit('');
  if FNode.ns = nil then
    Exit('');
  Result := string(AnsiString(FNode.ns.href));
end;

function TXMLSecNode.GetNodeName: string;
begin
  if FNode = nil then
    Exit('');
  Result := string(AnsiString(FNode.name));
end;

function TXMLSecNode.GetText: string;
var
  LText: xmlCharPtr;
begin
  if FNode = nil then
    Exit('');
  LText := xmlNodeGetContent(FNode);
  if LText = nil then
    Exit('');
  Result := string(AnsiString(LText));
  xmlFree(LText);
end;

function TXMLSecNode.TryFindNode(const ANodeName, ANodeNameSpace: string;
  out ANode: IXMLSecNode): Boolean;
var
  node: xmlNodePtr;
begin
  // find start node
  // xmlSecNodeSignature, xmlSecDSigNs
  node := xmlSecFindNode(FNode, PAnsiChar(AnsiString(ANodeName)), PAnsiChar(AnsiString(ANodeNameSpace)));
  if node = nil then
  begin
    Exit(False);
  end;
  ANode := TXMLSecNode.Create(FDocument, node);
  Exit(True);
end;

{ TEncryptionContext }

constructor TEncryptionContext.Create;
begin
  inherited Create;
  XmlCryptInit;

  keysMngr := xmlSecKeysMngrCreate;
  if keysMngr = nil then
    raise EXMLError.Create('Error: failed to create keys manager');
  xmlSecCryptoAppDefaultKeysMngrInit(keysMngr);

  encCtx := xmlSecEncCtxCreate(keysMngr);
  if encCtx = nil then
    raise EXMLError.Create('Error: failed to create encryption context');

end;

procedure TEncryptionContext.Decrypt(AXMLDocument: IXMLSecDocument);
var
  node: xmlNodePtr;
begin
  node := (AXMLDocument.FindNode(string(xmlSecNodeEncryptedData), string(xmlSecEncNs)) as TXMLSecNode).FNode;

  // decrypt the data
  if (xmlSecEncCtxDecrypt(encCtx, node) < 0) or  (encCtx.result = nil) then
  begin
    raise EXMLError.Create('Error: decryption failed');
  end;
end;

destructor TEncryptionContext.Destroy;
begin
  if encCtx <> nil then
    xmlSecEncCtxDestroy(encCtx);

  if keysMngr <> nil then
    xmlSecKeysMngrDestroy(keysMngr);

  if FOwnsStream then
    FStream.Free;

  inherited;
end;

procedure TEncryptionContext.Encrypt(AXMLDocument: IXMLSecDocument);
begin
  raise ESAMLNotImplemented.Create('Error: encryption not yet implemented');
end;

function TEncryptionContext.IsEncrypted(AXMLDocument: IXMLSecDocument): Boolean;
var
  LNode: IXMLSecNode;
begin
  Result := AXMLDocument.TryFindNode(string(xmlSecNodeEncryptedData), string(xmlSecEncNs), LNode);
end;

procedure TEncryptionContext.LoadKey(AStream: TStream; AFormat: TKeyDataFormat;
  AOwnsStream: Boolean);
var
  data: xmlSecBytePtr;
  dataSize: xmlSecSize;
  key: xmlSecKeyPtr;
begin
  Assert(AStream <> nil);
  Assert(AStream.Size > 0);

  FStream := AStream;
  FOwnsStream := AOwnsStream;

  dataSize := AStream.Size;
  data := AllocMem(dataSize);
  try
    AStream.ReadBuffer(data^, dataSize);

    // load private key, assuming that there is not password */
    key := xmlSecCryptoAppKeyLoadMemory(data, dataSize, xmlSecKeyDataFormat(AFormat), nil, nil, nil);
    if key = nil then
    begin
      raise EXMLError.Create('Error: failed to load key');
    end;

    if xmlSecCryptoAppDefaultKeysMngrAdoptKey(keysMngr, key) < 0 then
    begin
      raise EXMLError.Create('Error: failed to add private key to keys manager');
    end;
  finally
    FreeMem(data);
  end;
//
//  // set key name to the file name, this is just an example! */
//  if xmlSecKeySetName(encCtx.encKey, PAnsiChar(key_file)) < 0 then
//  begin
//    raise ESignError.CreateFmt('Error: failed to set key name for key from "%s"', [key_file]);
//  end;
end;

{ TXMLCatalog }

class procedure TXMLCatalog.LoadFromFile(const AFileName: string);
var
  ret: Longint;
begin
  ret := xmlLoadCatalog(PAnsiChar(AnsiString(AFileName)));
  if ret <> 0 then
    raise EXMLError.CreateFmt('Cannot load file "%s"', [AFileName]);
end;

{ TXMLSchema }

constructor TXMLSchemaValidContext.Create(AStream: TStream; AOwnsStream: Boolean);
begin
  FStream := AStream;
  FOwnsStream := AOwnsStream;
  FSchemaPtr := nil;
  FSchemaParserCtxt := nil;
  FSchemaValidCtxt := nil;
  ParseSchemaStream;
end;

destructor TXMLSchemaValidContext.Destroy;
begin
  if FOwnsStream then
    FStream.Free;
  if FSchemaParserCtxt <> nil then
    xmlSchemaFreeParserCtxt(FSchemaParserCtxt);
  if FSchemaPtr <> nil then
    xmlSchemaFree(FSchemaPtr);
  if FSchemaValidCtxt <> nil then
    xmlSchemaFreeValidCtxt(FSchemaValidCtxt);
  inherited;
end;

procedure TXMLSchemaValidContext.ParseSchemaStream;
var
  LSchema: AnsiString;
begin
  SetLength(LSchema, FStream.Size);
  FStream.ReadBuffer(LSchema[1], FStream.Size);
  FSchemaParserCtxt := xmlSchemaNewMemParserCtxt(PAnsiChar(LSchema), FStream.Size);
  FSchemaPtr := xmlSchemaParse(FSchemaParserCtxt);
  FSchemaValidCtxt := xmlSchemaNewValidCtxt(FSchemaPtr);
end;

procedure TXMLSchemaValidContext.ValidateOneElement(ANode: IXMLSecNode);
var
  LNodePtr: xmlNodePtr;
  RetCode: Integer;
begin
  LNodePtr := (ANode as TXMLSecNode).FNode;
  RetCode := xmlSchemaValidateOneElement(FSchemaValidCtxt, LNodePtr);
  LibXMLCheck(RetCode);
end;

{ TXMLSec }

class procedure TXMLSec.ErrorNotify(const AMessage, AFunc, AName: string;
  ALine: Integer; const AObject, ASubject: string; AErrorNo: Integer;
  const AErrorString1, AErrorString2: string);
var
  LXMLSecError: TXMLSecError;
begin
  if Assigned(FErrorProc) then
  begin
    LXMLSecError.ErrorMessage := AMessage;
    LXMLSecError.Func := AFunc;
    LXMLSecError.Name := AName;
    LXMLSecError.Line := ALine;
    LXMLSecError.ErrorObject := AObject;
    LXMLSecError.Subject := ASubject;
    LXMLSecError.ErrorNo := AErrorNo;
    LXMLSecError.ErrorString1 := AErrorString1;
    LXMLSecError.ErrorString2 := AErrorString2;

    FErrorProc(LXMLSecError);
  end;
end;

class procedure TXMLSec.RegisterErrorCallback(AErrorProc: TErrorProc);
begin
  FErrorProc := AErrorProc;
end;

initialization

XmlCryptInitLock := TCriticalSection.Create;
XmlCryptInitialized := False;

finalization

XmlCryptShutdown;
XmlCryptInitLock.Free;

end.

