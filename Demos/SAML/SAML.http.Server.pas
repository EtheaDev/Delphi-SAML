{******************************************************************************}
{                                                                              }
{  Delphi SAML                                                                 }
{  Copyright (c) 2022 Ethea                                                    }
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
unit SAML.http.Server;

interface

uses
  System.SysUtils, System.Classes, Winapi.ActiveX, System.NetEncoding, System.IOUtils,
  Xml.xmldom, Xml.XMLIntf, Xml.XMLDoc, DateUtils,
  IdContext, IdCustomHTTPServer, IdGlobalProtocols,
  IdBaseComponent, IdComponent, IdCustomTCPServer, IdHTTPServer, SAML.Config;

type
  TmodHttpServer = class(TDataModule)
    SPServer: TIdHTTPServer;
    procedure SPServerCommandGet(AContext: TIdContext;
      ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
  private
    FIdPConfig: TSAMLIdPConfig;
    FSPConfig: TSAMLSPConfig;

    procedure ValidateAuthResponse(const AXML: string);

    procedure HandleAssertion(AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo;
      AResponseInfo: TIdHTTPResponseInfo);
    procedure HandlePages(AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo;
      AResponseInfo: TIdHTTPResponseInfo);
    procedure HandleDefault(AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo;
      AResponseInfo: TIdHTTPResponseInfo);
    procedure HandleIssue(AContext: TIdContext;
      ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
    procedure HandleLogout(AContext: TIdContext;
      ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
    function GetPort: Integer;
    procedure SetPort(const Value: Integer);
  public
    property IdPConfig: TSAMLIdPConfig read FIdPConfig;
    property SPConfig: TSAMLSPConfig read FSPConfig;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property Port: Integer read GetPort write SetPort;
    procedure Start;
    procedure Stop;
  end;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses
  SAML.Core, SAML.XML.Utils, SAML.Metadata, SAML.Request;

{$R *.dfm}

function DecryptXML(const AXML, AKeyFileName: string; AKeyDataFormat: TKeyDataFormat): string;
var
  LXMLDocument: IXMLSecDocument;
  LSignatureContext: IEncryptionContext;
begin
  LXMLDocument := TXMLSecDocument.Create(TStringStream.Create(AXML, TEncoding.UTF8), True);
  LXMLDocument.AddIDAttr('Id', 'EncryptedKey', 'http://www.w3.org/2001/04/xmlenc#');

  LSignatureContext := TEncryptionContext.Create;
  LSignatureContext.LoadKey(TFileStream.Create(AKeyFileName, fmOpenRead), AKeyDataFormat, True);
  LSignatureContext.Decrypt(LXMLDocument);

  Result := LXMLDocument.ToXML;
end;

function SignRequest(const AXMLRequest, AKeyFileName: string; AKeyDataFormat: TKeyDataFormat): string;
var
  LXMLDocument: IXMLSecDocument;
  LSignatureContext: ISignatureContext;
begin
  LXMLDocument := TXMLSecDocument.Create(TStringStream.Create(AXMLRequest, TEncoding.UTF8), True);
  LXMLDocument.CheckSignatureTemplate;
  LXMLDocument.AddIDAttr('ID', 'AuthnRequest', 'urn:oasis:names:tc:SAML:2.0:protocol');

  LSignatureContext := TSignatureContext.Create;
  LSignatureContext.LoadKey(TFileStream.Create(AKeyFileName, fmOpenRead), AKeyDataFormat, True);
  LSignatureContext.Sign(LXMLDocument);

  Result := LXMLDocument.ToXML;
end;

function GetAuthnRequest(AIdPConfig: TSAMLIdPConfig; ASPConfig: TSAMLSPConfig): string;
var
  LRequestXML: string;
  LSigned: Boolean;
begin
  LSigned := ASPConfig.SignPrivKeyFile <> '';

  LRequestXML := TSAMLAuthnRequest.New
    .SetID('SAML_' + IntToStr(Random(1000000000)))
    .SetIssuer(ASPConfig.EntityId)
    .SetSigned(LSigned)
    .SetProtocolBinding(TSAML.BINDINGS_HTTP_POST)
    .SetDestination(AIdPConfig.SSOUrl)
    .SetAssertionConsumerServiceIndex(ASPConfig.AssertionConsumerServiceIndex)
    .SetAttributeConsumingServiceIndex(ASPConfig.AttributeConsumingService)
    .SetAuthnContext(ASPConfig.AuthnContext)
    .AsXML;

  //TFile.WriteAllText('sp-authnrequest2.xml', LRequestXML);

  if LSigned then
    Result := SignRequest(LRequestXML, ASPConfig.SignPrivKeyFile, ASPConfig.SignPrivKeyFormat)
  else
    Result := LRequestXML;

end;

function GetLogoutRequest(const ASLOUrl, AIssuer: string): string;
const
  NameID_Test = 'AAdzZWNyZXQx2MBz+72EffcuUFEz3OMXkLO6V4xaSTgFBKUtpCxzHGUGoetH6geS08EXqTEm9QYebzZhI2OlKTk6DCQRpX9fTBFe54ANLYAVYOpMfCCVS/YkSHNARqW/Fxiq';
begin
  Result := TSAMLLogoutRequest.New
    .SetID('SAML_' + IntToStr(Random(1000000000)))
    .SetIssuer(AIssuer)
    .SetDestination(ASLOUrl)
    .SetNameID(NameID_Test)
    .AsXML;
end;

function GetAuthnRequestUrl(AIdPConfig: TSAMLIdPConfig; ASPConfig: TSAMLSPConfig): string;
var
  AuthnRequest: string;
  CompressedRequest: string;
begin
  AuthnRequest := GetAuthnRequest(AIdPConfig, ASPConfig);

  CompressedRequest := TSAMLAuthnRequest.RedirectEncode(AuthnRequest);

  Result := AIdPConfig.SSOUrl + '?SAMLRequest=' + TNetEncoding.URL.Encode(CompressedRequest);
end;

function GetLogoutRequestUrl(const ASLOUrl, AIssuer: string): string;
var
  AuthnRequest: string;
  CompressedRequest: string;
begin
  AuthnRequest := GetLogoutRequest(ASLOUrl, AIssuer);

  CompressedRequest := TSAMLAuthnRequest.RedirectEncode(AuthnRequest);

  Result := ASLOUrl + '?SAMLRequest=' + TNetEncoding.URL.Encode(CompressedRequest);
end;

function GetSignatureValue(ARequestDocument: IXMLDocument): string;
var
  LAuthnRequest: IXMLNode;
  LSignature: IXMLNode;
  LSignatureValue: IXMLNode;
begin
  LAuthnRequest := ARequestDocument.ChildNodes.FindNode('AuthnRequest', 'urn:oasis:names:tc:SAML:2.0:protocol');

  LSignature := LAuthnRequest.ChildNodes.FindNode('Signature', 'http://www.w3.org/2000/09/xmldsig#');
  LSignatureValue := LSignature.ChildNodes.FindNode('SignatureValue', 'http://www.w3.org/2000/09/xmldsig#');

  Result := StringReplace(LSignatureValue.Text, ' ', '', [rfReplaceAll]);
end;

procedure RemoveSignature(ARequestDocument: IXMLDocument);
var
  LAuthnRequest: IXMLNode;
  LSignature: IXMLNode;
begin
  LAuthnRequest := ARequestDocument.ChildNodes.FindNode('AuthnRequest', 'urn:oasis:names:tc:SAML:2.0:protocol');
  LSignature := LAuthnRequest.ChildNodes.FindNode('Signature', 'http://www.w3.org/2000/09/xmldsig#');

  LAuthnRequest.ChildNodes.Remove(LSignature);

end;

function BuildRedirectUrl(const ASSOUrl, ASignedAuthnRequest: string): string;
var
  LCompressedRequest: string;
  LRequestDoc: IXMLDocument;
  LSignatureValue: string;
begin
  LRequestDoc := TXMLDocument.Create(nil);
  LRequestDoc.LoadFromXML(ASignedAuthnRequest);
  LRequestDoc.Active := True;

  LSignatureValue := GetSignatureValue(LRequestDoc);
  RemoveSignature(LRequestDoc);

  LCompressedRequest := TSAMLAuthnRequest.RedirectEncode(LRequestDoc.XML.Text);

  Result := ASSOUrl + '?SAMLRequest=' + TNetEncoding.URL.Encode(LCompressedRequest) + '&SigAlg=' + Base64EncodeStr(TEncoding.UTF8.GetBytes(LSignatureValue));
end;

procedure TmodHttpServer.SetPort(const Value: Integer);
begin
  SPServer.DefaultPort := Value;
end;

procedure TmodHttpServer.SPServerCommandGet(AContext: TIdContext;
  ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
begin
  CoInitialize(nil);
  try
    if ARequestInfo.Document.StartsWith('/pages/', True) then
      HandlePages(AContext, ARequestInfo, AResponseInfo)
    else if ARequestInfo.Document.StartsWith('/assertion', True) then
      HandleAssertion(AContext, ARequestInfo, AResponseInfo)
    else if ARequestInfo.Document.StartsWith('/issue', True) then
      HandleIssue(AContext, ARequestInfo, AResponseInfo)
    else if ARequestInfo.Document.StartsWith('/logout', True) then
      HandleLogout(AContext, ARequestInfo, AResponseInfo)
    else
      HandleDefault(AContext, ARequestInfo, AResponseInfo)

  finally
    CoUninitialize;
  end;
end;

procedure TmodHttpServer.Start;
begin
  SPServer.Active := True;
end;

procedure TmodHttpServer.Stop;
begin
  SPServer.Active := False;
end;

constructor TmodHttpServer.Create(AOwner: TComponent);
begin
  inherited;
  FIdPConfig := TSAMLIdPConfig.Create;
  FSPConfig := TSAMLSPConfig.Create;
end;

destructor TmodHttpServer.Destroy;
begin
  FIdPConfig.Free;
  FSPConfig.Free;
  inherited;
end;

function TmodHttpServer.GetPort: Integer;
begin
  Result := SPServer.DefaultPort;
end;

procedure TmodHttpServer.HandleAssertion(AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
var
  SAMLResponse: string;
  CompressedResponse: TBytes;
  XML: string;
  LSAMLResponse: TSAMLResponse;
  LAttrib: TSAMLAttribute;
  AttrbHTML: string;
  InfoHTML: string;
begin
  SAMLResponse := ARequestInfo.Params.Values['SAMLResponse'];
  CompressedResponse := TNetEncoding.Base64.DecodeStringToBytes(SAMLResponse);

  XML := TEncoding.UTF8.GetString(CompressedResponse);
  //TFile.WriteAllBytes('signed-response.xml', CompressedResponse);
  if (not FIdPConfig.SkipSignatureCheck) and (FIdPConfig.SignPubKeyFile <> '') then
    ValidateAuthResponse(XML);

  if FSPConfig.EncPrivKeyFile <> '' then
    XML := DecryptXML(XML, FSPConfig.EncPrivKeyFile, FSPConfig.EncPrivKeyFormat);

  AttrbHTML := '';
  LSAMLResponse := TSAMLResponse.Create(XML);
  try
    InfoHTML := '<table border="1">' +
      '<tr><td>Destination</td><td>' + LSAMLResponse.Destination + '</td></tr>' +
      '<tr><td>Issuer</td><td>' + LSAMLResponse.Issuer + '</td></tr>' +
      '<tr><td>NameID</td><td><b>' + LSAMLResponse.NameID + '</b></td></tr>' +
      '</table>';

    AttrbHTML := AttrbHTML + '<tr><th>Name</th><th>FriendlyName</th><th>Value</th></tr>';
    for LAttrib in LSAMLResponse.Attributes do
    begin
      AttrbHTML := AttrbHTML + '<tr><td>' + LAttrib.Name + '</td><td>' + LAttrib.FriendlyName + '</td><td>' + LAttrib.Value + '</td></tr>';
    end;
  finally
    LSAMLResponse.Free;
  end;

  AResponseInfo.ContentType := 'text/html';
  AResponseInfo.ContentText := '<html><body><h1>Header</h1>' + InfoHTML + '<h1>Attributes</h1><table border="1">' + AttrbHTML + '</table></body></html>';

end;

procedure TmodHttpServer.HandlePages(AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
var
  PagePath: string;
  FileExt: string;
begin
  if Pos('..', ARequestInfo.Document) > 0 then
    raise Exception.Create('Page not found');

  FileExt := ExtractFileExt(ARequestInfo.Document);
  PagePath := ExtractFileDir(ParamStr(0)) + '\..\SAML\' + TPath.Combine('pages', ARequestInfo.Document);
  PagePath := StringReplace(PagePath, '/', '\', [rfReplaceAll]);

  AResponseInfo.ContentType := SPServer.MIMETable.GetFileMIMEType(PagePath);
  AResponseInfo.ContentLength := FileSizeByName(PagePath);
  AResponseInfo.WriteHeader;

  //EnableTransferFile := not (AContext.Connection.IOHandler is TIdSSLIOHandlerSocketBase);
  AContext.Connection.IOHandler.WriteFile(PagePath);
end;

procedure TmodHttpServer.HandleDefault(AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
begin
  AResponseInfo.ContentType := 'text/plain';
  AResponseInfo.ContentText := 'SAML Server';
end;

procedure TmodHttpServer.HandleIssue(AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
begin
  if ARequestInfo.Params.Values['showdecoded'] <> '' then
  begin
    AResponseInfo.ContentType := 'application/xml';
    AResponseInfo.ContentText := GetAuthnRequest(FIdPConfig, FSPConfig);
  end
  else
  begin
    AResponseInfo.ContentType := 'text/plain';
    AResponseInfo.ContentText := GetAuthnRequestUrl(FIdPConfig, FSPConfig);
  end;
end;

procedure TmodHttpServer.HandleLogout(AContext: TIdContext;
  ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
begin
  AResponseInfo.ContentType := 'text/plain';
  AResponseInfo.ContentText := GetLogoutRequestUrl(FIdPConfig.SLOUrl, FSPConfig.EntityId);
end;

procedure TmodHttpServer.ValidateAuthResponse(const AXML: string);
const
  UseXMLCertificate = True;
var
  LXMLDocument: IXMLSecDocument;
  LSignedNode: IXMLSecNode;
  LKeyNode: IXMLSecNode;
  LKey: TBytes;
  LSignatureContext: ISignatureContext;
  LStatus: Boolean;
begin
  LXMLDocument := TXMLSecDocument.Create(TStringStream.Create(AXML), True);
  if not LXMLDocument.TryFindNode('Assertion', 'urn:oasis:names:tc:SAML:2.0:assertion', LSignedNode) then
    LSignedNode := LXMLDocument.FindNode('Response', 'urn:oasis:names:tc:SAML:2.0:protocol');

  LXMLDocument.AddIDAttr('ID', LSignedNode.NodeName, LSignedNode.Namespace);

  LSignatureContext := TSignatureContext.Create;
  if UseXMLCertificate then
  begin
    LKeyNode := LXMLDocument.FindNode('X509Certificate', 'http://www.w3.org/2000/09/xmldsig#');
    LKey := TNetEncoding.Base64.DecodeStringToBytes(LKeyNode.Text);
    //TFile.WriteAllBytes('auth0-cert.der', LKey);
    // TODO: check fingerprint of certificate
    LSignatureContext.LoadKey(TBytesStream.Create(LKey), TKeyDataFormat.CertDer, True);
  end
  else
    LSignatureContext.LoadKey(TFileStream.Create(FIdPConfig.SignPubKeyFile, fmOpenRead), FIdPConfig.SignPubKeyFormat, True);

  LStatus := LSignatureContext.Verify(LXMLDocument);

  if not LStatus then
    raise Exception.Create('Invalid auth response');
end;

end.
