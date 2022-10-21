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
unit SAML.Request;

interface

uses
  System.Classes, System.SysUtils, System.Variants, Xml.xmldom,
  Xml.XMLIntf, Xml.XMLDoc, System.DateUtils, System.IOUtils,
  System.ZLib, System.NetEncoding, Generics.Collections;

type
  TSAMLAttribute = class(TObject)
  private
    FName: string;
    FValue: string;
    FFriendlyName: string;
  public
    property Name: string read FName write FName;
    property FriendlyName: string read FFriendlyName write FFriendlyName;
    property Value: string read FValue write FValue;
  end;

  TSAMLAttributes = class(TObjectList<TSAMLAttribute>)

  end;

  TSAMLAuthnRequest = class;

  ISAMLRequestBuilder = interface
    ['{5A245B70-2931-443D-804A-6F0505E190D7}']
    function SetID(const AID: string): ISAMLRequestBuilder;
    function SetIssuer(const AIssuer: string): ISAMLRequestBuilder;
    function SetProtocolBinding(const AProtocolBinding: string): ISAMLRequestBuilder;
    function SetSigned(ASigned: Boolean): ISAMLRequestBuilder;
    function Build: TSAMLAuthnRequest;

    function AsXML: string;
  end;

  TSAMLRequestBuilder = class(TInterfacedObject, ISAMLRequestBuilder)
  public
    FID: string;
    FIssuer: string;
    FProtocolBinding: string;
    FSigned: Boolean;
  public
    { ISAMLRequestBuilder }
    function SetID(const AID: string): ISAMLRequestBuilder;
    function SetIssuer(const AIssuer: string): ISAMLRequestBuilder;
    function SetProtocolBinding(const AProtocolBinding: string): ISAMLRequestBuilder;
    function SetSigned(ASigned: Boolean): ISAMLRequestBuilder;

    function AsXML: string;
    function Build: TSAMLAuthnRequest;
  end;

  TSAMLAuthnRequest = class(TObject)
  public
    class function New(): ISAMLRequestBuilder; static;
    class function RedirectEncode(const AAuthnRequest: string): string; static;
  private
    FID: string;
    FProtocolBinding: string;
    FIssuer: string;
    FSigned: Boolean;
    procedure AddSignTemplate(Request: IXMLNode);
  public
    constructor Create;
    property ID: string read FID;
    property Issuer: string read FIssuer;
    property ProtocolBinding: string read FProtocolBinding;
    property Signed: Boolean read FSigned;
    function AsXML: string;
  end;

  TSAMLResponse = class(TObject)
  private
    FDestination: string;
    FIssuer: string;
    FAttributes: TSAMLAttributes;
    FNameID: string;
    procedure ParseXML(const AXML: string);
  public
    constructor Create; overload;
    constructor Create(const AXML: string); overload;
    destructor Destroy; override;
    function FindAttribute(const AName: string): TSAMLAttribute;
    function GetAttribute(const AName: string): TSAMLAttribute;
    property Attributes: TSAMLAttributes read FAttributes;
    property Destination: string read FDestination;
    property Issuer: string read FIssuer;
    property NameID: string read FNameID;
  end;

  TSAMLLogoutRequest = class;

  ISAMLLogoutRequestBuilder = interface
    ['{C4A7B9CF-9D91-4A15-B933-5619D9D40342}']
    function SetID(const AID: string): ISAMLLogoutRequestBuilder;
    function SetIssuer(const AIssuer: string): ISAMLLogoutRequestBuilder;
    function SetDestination(const ADestination: string): ISAMLLogoutRequestBuilder;
    function SetNameID(const ASetNameID: string): ISAMLLogoutRequestBuilder;
    function Build: TSAMLLogoutRequest;

    function AsXML: string;
  end;

  TSAMLLogoutRequestBuilder = class(TInterfacedObject, ISAMLLogoutRequestBuilder)
  private
    FID: string;
    FIssuer: string;
    FNameID: string;
    FDestination: string;
  public
    function SetID(const AID: string): ISAMLLogoutRequestBuilder;
    function SetIssuer(const AIssuer: string): ISAMLLogoutRequestBuilder;
    function SetNameID(const ANameID: string): ISAMLLogoutRequestBuilder;
    function SetDestination(const ADestination: string): ISAMLLogoutRequestBuilder;
    function Build: TSAMLLogoutRequest;

    function AsXML: string;
  end;

  TSAMLLogoutRequest = class(TObject)
  public
    class function New(): ISAMLLogoutRequestBuilder; static;
  private
    FID: string;
    FIssuer: string;
    FNameID: string;
    FDestination: string;
  public
    constructor Create;
    property ID: string read FID;
    property Issuer: string read FIssuer;
    property NameID: string read FNameID;
    property Destination: string read FDestination;
    function AsXML: string;
  end;

implementation

uses
  SAML.Core;

function SafeFindNode(AChildNodes: IXMLNodeList; const ANodeName, ANamespaceURI: string): IXMLNode;
begin
  Result := AChildNodes.FindNode(ANodeName, ANamespaceURI);
  if not Assigned(Result) then
    raise Exception.CreateFmt('"%s" not found', [ANodeName]);
end;

function ZCompressStrNoHeader(const AAuthnRequest: string): TBytes;
const
  ZLIB_STANDARD_NOHEADER = -15;
var
  LUTF8AuthnRequest: UTF8String;
  LCompressedStream: TBytesStream;
  LCompressStream: TZCompressionStream;
begin
  LUTF8AuthnRequest := UTF8String(AAuthnRequest);
  LCompressedStream := TBytesStream.Create();
  try
    LCompressStream := TZCompressionStream.Create(LCompressedStream, zcDefault, ZLIB_STANDARD_NOHEADER);
    try
      LCompressStream.Write(LUTF8AuthnRequest[1], Length(LUTF8AuthnRequest));
    finally
      LCompressStream.Free;
    end;
    Result := LCompressedStream.Bytes;
    SetLength(Result, LCompressedStream.Size);
  finally
    LCompressedStream.Free;
  end;
end;

{ TSAMLResponse }

constructor TSAMLResponse.Create;
begin
  inherited;
  FAttributes := TSAMLAttributes.Create(True);
end;

constructor TSAMLResponse.Create(const AXML: string);
begin
  Create;
  ParseXML(AXML);
end;

destructor TSAMLResponse.Destroy;
begin
  FAttributes.Free;
  inherited;
end;
function TSAMLResponse.FindAttribute(const AName: string): TSAMLAttribute;
var
  LAttribute: TSAMLAttribute;
begin
  Result := nil;
  for LAttribute in FAttributes do
    if LAttribute.Name = AName then
      Exit(LAttribute);
end;

function TSAMLResponse.GetAttribute(const AName: string): TSAMLAttribute;
begin
  Result := FindAttribute(AName);
  if not Assigned(Result) then
    raise ESAMLError.CreateFmt('Attribute "%s" non found', [AName]);
end;

procedure TSAMLResponse.ParseXML(const AXML: string);
var
  LDocument: IXMLDocument;
  LAssertion: IXMLNode;
  LResponse: IXMLNode;
  LAttributeStatement: IXMLNode;
  LAttribute: IXMLNode;
  LIssuer: IXMLNode;
  LSubject: IXMLNode;
  LNameID: IXMLNode;
  LAttributeValue: IXMLNode;
  LEncryptedAssertion: IXMLNode;
  LIndex: Integer;
  LSAMLAttribute: TSAMLAttribute;
begin
  LDocument := TXMLDocument.Create(nil);
  LDocument.LoadFromXML(AXML);
  LDocument.Active := True;

  LDocument.ChildNodes.First.NodeName;
  LResponse := SafeFindNode(LDocument.ChildNodes, 'Response', 'urn:oasis:names:tc:SAML:2.0:protocol');

  FDestination := VarToStr(LResponse.Attributes['Destination']);

  LIssuer := SafeFindNode(LResponse.ChildNodes, 'Issuer', 'urn:oasis:names:tc:SAML:2.0:assertion');
  FIssuer := LIssuer.Text;

  LEncryptedAssertion := LResponse.ChildNodes.FindNode('EncryptedAssertion', 'urn:oasis:names:tc:SAML:2.0:assertion');
  if Assigned(LEncryptedAssertion) then
    LAssertion := LEncryptedAssertion.ChildNodes.FindNode('Assertion', 'urn:oasis:names:tc:SAML:2.0:assertion')
  else
    LAssertion := LResponse.ChildNodes.FindNode('Assertion', 'urn:oasis:names:tc:SAML:2.0:assertion');

  if Assigned(LAssertion) then
  begin
    LSubject := SafeFindNode(LAssertion.ChildNodes, 'Subject', 'urn:oasis:names:tc:SAML:2.0:assertion');
    LNameID := SafeFindNode(LSubject.ChildNodes, 'NameID', 'urn:oasis:names:tc:SAML:2.0:assertion');
    FNameID := LNameID.Text;

    LAttributeStatement := LAssertion.ChildNodes.FindNode('AttributeStatement', 'urn:oasis:names:tc:SAML:2.0:assertion');
    if Assigned(LAttributeStatement) then
    begin
      for LIndex := 0 to LAttributeStatement.ChildNodes.Count - 1 do
      begin
        LAttribute := LAttributeStatement.ChildNodes[LIndex];
        if LAttribute.NodeName = LAttribute.Prefix + ':Attribute' then
        begin
          LSAMLAttribute := TSAMLAttribute.Create;
          try
            LAttributeValue := LAttribute.ChildNodes.FindNode('AttributeValue', 'urn:oasis:names:tc:SAML:2.0:assertion');

            LSAMLAttribute.Name := VarToStr(LAttribute.Attributes['Name']);
            LSAMLAttribute.FriendlyName := VarToStr(LAttribute.Attributes['FriendlyName']);
            LSAMLAttribute.Value := LAttributeValue.Text;

            FAttributes.Add(LSAMLAttribute);

          except
            LSAMLAttribute.Free;
            raise;
          end;
        end;
      end;
    end;
  end
  else
    raise Exception.Create('Error: no assertions found');
end;

{ TSAMLRequest }

procedure TSAMLAuthnRequest.AddSignTemplate(Request: IXMLNode);
var
  LSignature: IXMLNode;
  LSignedInfo: IXMLNode;
  LCanonicalizationMethod: IXMLNode;
  LSignatureMethod: IXMLNode;
  LReference: IXMLNode;
  LTransforms: IXMLNode;
  LTransform: IXMLNode;
  LDigestMethod: IXMLNode;
  LDigestValue: IXMLNode;
  LSignatureValue: IXMLNode;
  LKeyInfo: IXMLNode;
  LKeyName: IXMLNode;
begin
  LSignature := Request.AddChild('Signature', 'http://www.w3.org/2000/09/xmldsig#');
  LSignedInfo := LSignature.AddChild('SignedInfo', 'http://www.w3.org/2000/09/xmldsig#');

  LCanonicalizationMethod := LSignedInfo.AddChild('CanonicalizationMethod', 'http://www.w3.org/2000/09/xmldsig#');
  LCanonicalizationMethod.Attributes['Algorithm'] := 'http://www.w3.org/TR/2001/REC-xml-c14n-20010315';

  LSignatureMethod := LSignedInfo.AddChild('SignatureMethod', 'http://www.w3.org/2000/09/xmldsig#');
  LSignatureMethod.Attributes['Algorithm'] := 'http://www.w3.org/2000/09/xmldsig#rsa-sha1';

  LReference := LSignedInfo.AddChild('Reference', 'http://www.w3.org/2000/09/xmldsig#');
  LReference.Attributes['URI'] := '';

  LTransforms := LReference.AddChild('Transforms', 'http://www.w3.org/2000/09/xmldsig#');

  LTransform := LTransforms.AddChild('Transform', 'http://www.w3.org/2000/09/xmldsig#');
  LTransform.Attributes['Algorithm'] := 'http://www.w3.org/2000/09/xmldsig#enveloped-signature';

  LDigestMethod := LReference.AddChild('DigestMethod', 'http://www.w3.org/2000/09/xmldsig#');
  LDigestMethod.Attributes['Algorithm'] := 'http://www.w3.org/2000/09/xmldsig#sha1';

  LDigestValue := LReference.AddChild('DigestValue', 'http://www.w3.org/2000/09/xmldsig#');

  LSignatureValue := LSignature.AddChild('SignatureValue', 'http://www.w3.org/2000/09/xmldsig#');

  LKeyInfo := LSignature.AddChild('KeyInfo', 'http://www.w3.org/2000/09/xmldsig#');

  LKeyName := LKeyInfo.AddChild('KeyName', 'http://www.w3.org/2000/09/xmldsig#');

end;

function TSAMLAuthnRequest.AsXML: string;
const
  NameIdFormat = 'urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress';
var
  LDocument: IXMLDocument;
  LRequest: IXMLNode;
  LIssuerNode: IXMLNode;
  LNameIDPolicy: IXMLNode;
  LRequestedAuthnContext: IXMLNode;
  LAuthnContextClassRef: IXMLNode;
begin
  if FID = '' then
    raise ESAMLError.Create('"ID" required');
  if FProtocolBinding = '' then
    raise ESAMLError.Create('"ProtocolBinding" required');
  if FIssuer = '' then
    raise ESAMLError.Create('"Issuer" required');

  LDocument := TXMLDocument.Create(nil);

  LDocument.Active := True;

  LRequest := LDocument.AddChild('samlp:AuthnRequest', 'urn:oasis:names:tc:SAML:2.0:protocol');
  LRequest.Attributes['ID'] := FID;
  LRequest.Attributes['IssueInstant'] := DateToISO8601(Now, False);
  LRequest.Attributes['ProtocolBinding'] := FProtocolBinding;
  LRequest.Attributes['Version'] := '2.0';
  LRequest.Attributes['Destination'] := 'https://samltest.id/idp/profile/SAML2/Redirect/SSO';

  LIssuerNode := LRequest.AddChild('saml:Issuer', 'urn:oasis:names:tc:SAML:2.0:assertion');
  LIssuerNode.Text := FIssuer;

  if Signed then
    AddSignTemplate(LRequest);

  LNameIDPolicy := LRequest.AddChild('samlp:NameIDPolicy', 'urn:oasis:names:tc:SAML:2.0:protocol');
  LNameIDPolicy.Attributes['Format'] := NameIdFormat;
  LNameIDPolicy.Attributes['AllowCreate'] := 'true';

  LRequestedAuthnContext := LRequest.AddChild('samlp:RequestedAuthnContext', 'urn:oasis:names:tc:SAML:2.0:protocol');
  LRequestedAuthnContext.Attributes['Comparison'] := 'exact';

  LAuthnContextClassRef := LRequestedAuthnContext.AddChild('saml:AuthnContextClassRef', 'urn:oasis:names:tc:SAML:2.0:assertion');
  LAuthnContextClassRef.Text := 'urn:oasis:names:tc:SAML:2.0:ac:classes:PasswordProtectedTransport';
  (*

  <samlp:NameIDPolicy Format="urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress" AllowCreate="true"/>
  <samlp:RequestedAuthnContext Comparison="exact">
    <saml:AuthnContextClassRef>urn:oasis:names:tc:SAML:2.0:ac:classes:PasswordProtectedTransport</saml:AuthnContextClassRef>
  </samlp:RequestedAuthnContext>

  *)

  Result := LDocument.XML.Text;
end;

constructor TSAMLAuthnRequest.Create;
begin
  inherited;
  FProtocolBinding := TSAML.BINDINGS_HTTP_POST;
end;

class function TSAMLAuthnRequest.New: ISAMLRequestBuilder;
begin
  Result := TSAMLRequestBuilder.Create;
end;

class function TSAMLAuthnRequest.RedirectEncode(const AAuthnRequest: string): string;
var
  LCompressedBytes: TBytes;
begin
  LCompressedBytes := ZCompressStrNoHeader(AAuthnRequest);
  Result := Base64EncodeStr(LCompressedBytes);
end;

{ TSAMLRequestBuilder }

function TSAMLRequestBuilder.AsXML: string;
var
  ARequest: TSAMLAuthnRequest;
begin
  ARequest := Self.Build;
  try
    Result := ARequest.AsXML;
  finally
    ARequest.Free;
  end;
end;

function TSAMLRequestBuilder.Build: TSAMLAuthnRequest;
begin
  Result := TSAMLAuthnRequest.Create;
  try
    if FID <> '' then
      Result.FID := FID;
    if FIssuer <> '' then
      Result.FIssuer := FIssuer;
    if FProtocolBinding <> '' then
      Result.FProtocolBinding := FProtocolBinding;
    Result.FSigned := FSigned;
  except
    Result.Free;
    raise;
  end;
end;

function TSAMLRequestBuilder.SetProtocolBinding(
  const AProtocolBinding: string): ISAMLRequestBuilder;
begin
  FProtocolBinding := AProtocolBinding;
  Result := Self;
end;

function TSAMLRequestBuilder.SetSigned(ASigned: Boolean): ISAMLRequestBuilder;
begin
  FSigned := ASigned;
  Result := Self;
end;

function TSAMLRequestBuilder.SetID(const AID: string): ISAMLRequestBuilder;
begin
  FID := AID;
  Result := Self;
end;

function TSAMLRequestBuilder.SetIssuer(
  const AIssuer: string): ISAMLRequestBuilder;
begin
  FIssuer := AIssuer;
  Result := Self;
end;

{ TSAMLLogoutRequestBuilder }

function TSAMLLogoutRequestBuilder.AsXML: string;
var
  LLogoutRequest: TSAMLLogoutRequest;
begin
  LLogoutRequest := Self.Build;
  try
    Result := LLogoutRequest.AsXML;
  finally
    LLogoutRequest.Free;
  end;
end;

function TSAMLLogoutRequestBuilder.Build: TSAMLLogoutRequest;
begin
  Result := TSAMLLogoutRequest.Create;
  try
    if FID <> '' then
      Result.FID := FID;
    if FIssuer <> '' then
      Result.FIssuer := FIssuer;
    if FNameID <> '' then
      Result.FNameID := FNameID;
    if FDestination <> '' then
      Result.FDestination := FDestination;
  except
    Result.Free;
    raise;
  end;
end;

function TSAMLLogoutRequestBuilder.SetDestination(
  const ADestination: string): ISAMLLogoutRequestBuilder;
begin
  FDestination := ADestination;
  Result := Self;
end;

function TSAMLLogoutRequestBuilder.SetID(
  const AID: string): ISAMLLogoutRequestBuilder;
begin
  FID := AID;
  Result := Self;
end;

function TSAMLLogoutRequestBuilder.SetIssuer(
  const AIssuer: string): ISAMLLogoutRequestBuilder;
begin
  FIssuer := AIssuer;
  Result := Self;
end;

function TSAMLLogoutRequestBuilder.SetNameID(
  const ANameID: string): ISAMLLogoutRequestBuilder;
begin
  FNameID := ANameID;
  Result := Self;
end;

{ TSAMLLogoutRequest }

function TSAMLLogoutRequest.AsXML: string;
var
  Document: IXMLDocument;
  Request: IXMLNode;
  IssuerNode: IXMLNode;
  NameIDNode: IXMLNode;
begin
  if FID = '' then
    raise ESAMLError.Create('"ID" required');
  if FIssuer = '' then
    raise ESAMLError.Create('"Issuer" required');
  if FDestination = '' then
    raise ESAMLError.Create('"Destination" required');
  if FNameID = '' then
    raise ESAMLError.Create('"NameID" required');

  Document := TXMLDocument.Create(nil);

  Document.Active := True;
  Request := Document.AddChild('samlp:LogoutRequest', 'urn:oasis:names:tc:SAML:2.0:protocol');

  Request.Attributes['ID'] := FID;
  Request.Attributes['IssueInstant'] := DateToISO8601(Now, False);
  Request.Attributes['Version'] := '2.0';
  Request.Attributes['Destination'] := FDestination;
  Request.Attributes['NotOnOrAfter'] := DateToISO8601(Now + (1/24/6), False);
  Request.Attributes['Reason'] := 'urn:oasis:names:tc:SAML:2.0:logout:user';

  IssuerNode := Request.AddChild('saml:Issuer', 'urn:oasis:names:tc:SAML:2.0:assertion');
  IssuerNode.Text := FIssuer;
  NameIDNode := Request.AddChild('saml:NameID', 'urn:oasis:names:tc:SAML:2.0:assertion');
  NameIDNode.Text := FNameID;

  Result := Document.XML.Text;end;

constructor TSAMLLogoutRequest.Create;
begin
  inherited;
end;

class function TSAMLLogoutRequest.New: ISAMLLogoutRequestBuilder;
begin
  Result := TSAMLLogoutRequestBuilder.Create;
end;

end.
