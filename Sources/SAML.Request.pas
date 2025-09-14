{******************************************************************************}
{                                                                              }
{  Delphi SAML                                                                 }
{  Copyright (c) 2022-2025 Ethea S.r.l.                                        }
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
  System.ZLib, System.NetEncoding, Generics.Collections, SAML.Core;

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
    function SetIssuerFormat(const AFormat: string): ISAMLRequestBuilder;
    function SetIssuerNameQualifier(const ANameQualifier: string): ISAMLRequestBuilder;
    function SetProtocolBinding(const AProtocolBinding: string): ISAMLRequestBuilder;
    function SetSigned(ASigned: Boolean): ISAMLRequestBuilder;
    function SetNameIdFormat(const ANameIdFormat: string): ISAMLRequestBuilder;
    function SetComparison(const AComparison: string): ISAMLRequestBuilder;
    function SetAuthnContextClassRef(AAuthnContextClassRef: string): ISAMLRequestBuilder;
    function SetDestination(ADestination: string): ISAMLRequestBuilder;
    function SetAssertionConsumerServiceIndex(AAssertionConsumerServiceIndex: string): ISAMLRequestBuilder;
    function SetAttributeConsumingServiceIndex(AAttributeConsumingServiceIndex: string): ISAMLRequestBuilder;
    function SetAssertionConsumerServiceUrl(AAssertionConsumerServiceUrl: string): ISAMLRequestBuilder;
    function SetForceAuthn(AForceAuthn: Boolean): ISAMLRequestBuilder;
    function Build: TSAMLAuthnRequest;

    function AsXML: string;
  end;

  TSAMLRequestBuilder = class(TInterfacedObject, ISAMLRequestBuilder)
  public
    FID: string;
    FIssuer: string;
    FIssuerFormat: string;
    FIssuerNameQualifier: string;
    FProtocolBinding: string;
    FSigned: Boolean;
    FNameIdFormat: string;
    FComparison: string;
    FAuthnContextClassRef: string;
    FDestination: string;
    FAssertionConsumerServiceIndex: string;
    FAssertionConsumerServiceUrl: string;
    FAttributeConsumingServiceIndex: string;
    FForceAuthn: Boolean;
  public
    { ISAMLRequestBuilder }
    function SetID(const AID: string): ISAMLRequestBuilder;
    function SetIssuer(const AIssuer: string): ISAMLRequestBuilder;
    function SetIssuerFormat(const AFormat: string): ISAMLRequestBuilder;
    function SetIssuerNameQualifier(const ANameQualifier: string): ISAMLRequestBuilder;
    function SetProtocolBinding(const AProtocolBinding: string): ISAMLRequestBuilder;
    function SetSigned(ASigned: Boolean): ISAMLRequestBuilder;
    function SetNameIdFormat(const ANameIdFormat: string): ISAMLRequestBuilder;
    function SetComparison(const AComparison: string): ISAMLRequestBuilder;
    function SetAuthnContextClassRef(AAuthnContextClassRef: string): ISAMLRequestBuilder;
    function SetDestination(ADestination: string): ISAMLRequestBuilder;
    function SetAssertionConsumerServiceIndex(AAssertionConsumerServiceIndex: string): ISAMLRequestBuilder;
    function SetAttributeConsumingServiceIndex(AAttributeConsumingServiceIndex: string): ISAMLRequestBuilder;
    function SetAssertionConsumerServiceUrl(AAssertionConsumerServiceUrl: string): ISAMLRequestBuilder;
    function SetForceAuthn(AForceAuthn: Boolean): ISAMLRequestBuilder;

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
    FIssuerFormat: string;
    FIssuerNameQualifier: string;
    FSigned: Boolean;
    FAuthnContextClassRef: string;
    FDestination: string;
    FAttributeConsumingServiceIndex: string;
    FAssertionConsumerServiceIndex: string;
    FAssertionConsumerServiceUrl: string;
    FForceAuthn: Boolean;
    FNameIdFormat: string;
    FComparison: string;
    FAllowCreate: Boolean;
  public
    constructor Create;
    property ID: string read FID;
    property Issuer: string read FIssuer;
    property Destination: string read FDestination;
    property ProtocolBinding: string read FProtocolBinding;
    property Signed: Boolean read FSigned;
    property AuthnContextClassRef: string read FAuthnContextClassRef;
    property AssertionConsumerServiceIndex: string read FAssertionConsumerServiceIndex;
    property AttributeConsumingServiceIndex: string read FAttributeConsumingServiceIndex;
    property AssertionConsumerServiceUrl: string read FAssertionConsumerServiceUrl;
    property ForceAuthn: Boolean read FForceAuthn;
    property NameIdFormat: string read FNameIdFormat;
    property Comparison: string read FComparison;

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
  SAML.XML.Utils;

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

function TSAMLAuthnRequest.AsXML: string;
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
  LRequest.Attributes['Destination'] := FDestination;

  if FAssertionConsumerServiceIndex <> '' then
    LRequest.Attributes['AssertionConsumerServiceIndex'] := FAssertionConsumerServiceIndex;
  if FAttributeConsumingServiceIndex <> '' then
    LRequest.Attributes['AttributeConsumingServiceIndex'] := FAttributeConsumingServiceIndex;
  if FAssertionConsumerServiceUrl <> '' then
    LRequest.Attributes['AssertionConsumerServiceURL'] := FAssertionConsumerServiceUrl;
  if FForceAuthn then
    LRequest.Attributes['ForceAuthn'] := 'true';

  LIssuerNode := LRequest.AddChild('saml:Issuer', 'urn:oasis:names:tc:SAML:2.0:assertion');
  LIssuerNode.Text := FIssuer;

  if FIssuerFormat <> '' then
    LIssuerNode.Attributes['Format'] := FIssuerFormat;
  if FIssuerNameQualifier <> '' then
    LIssuerNode.Attributes['NameQualifier'] := FIssuerNameQualifier;

  if NameIdFormat <> '' then
  begin
    LNameIDPolicy := LRequest.AddChild('samlp:NameIDPolicy', 'urn:oasis:names:tc:SAML:2.0:protocol');
    LNameIDPolicy.Attributes['Format'] := NameIdFormat;
    if FAllowCreate then
      LNameIDPolicy.Attributes['AllowCreate'] := 'true';
  end;

  if (FComparison <> '') or (FAuthnContextClassRef <> '') then
  begin
    LRequestedAuthnContext := LRequest.AddChild('samlp:RequestedAuthnContext', 'urn:oasis:names:tc:SAML:2.0:protocol');
    if FComparison <> '' then
      LRequestedAuthnContext.Attributes['Comparison'] := FComparison;

    if FAuthnContextClassRef <> '' then
    begin
      LAuthnContextClassRef := LRequestedAuthnContext.AddChild('saml:AuthnContextClassRef', 'urn:oasis:names:tc:SAML:2.0:assertion');
      LAuthnContextClassRef.Text := FAuthnContextClassRef;
    end;
  end;

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
    Result.FIssuerFormat := FIssuerFormat;
    Result.FIssuerNameQualifier := FIssuerNameQualifier;
    Result.FSigned := FSigned;
    Result.FNameIdFormat := FNameIdFormat;
    Result.FComparison := FComparison;
    Result.FSigned := FSigned;
    Result.FAuthnContextClassRef := FAuthnContextClassRef;
    Result.FDestination := FDestination;
    Result.FAssertionConsumerServiceIndex := FAssertionConsumerServiceIndex;
    Result.FAttributeConsumingServiceIndex := FAttributeConsumingServiceIndex;
    Result.FAssertionConsumerServiceUrl := FAssertionConsumerServiceUrl;
    Result.FForceAuthn := FForceAuthn;
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

function TSAMLRequestBuilder.SetAssertionConsumerServiceIndex(
  AAssertionConsumerServiceIndex: string): ISAMLRequestBuilder;
begin
  FAssertionConsumerServiceIndex := AAssertionConsumerServiceIndex;
  Result := Self;
end;

function TSAMLRequestBuilder.SetForceAuthn(
  AForceAuthn: Boolean): ISAMLRequestBuilder;
begin
  FForceAuthn := AForceAuthn;
  Result := Self;
end;

function TSAMLRequestBuilder.SetAssertionConsumerServiceUrl(
  AAssertionConsumerServiceUrl: string): ISAMLRequestBuilder;
begin
  FAssertionConsumerServiceUrl := AAssertionConsumerServiceUrl;
  Result := Self;
end;

function TSAMLRequestBuilder.SetAttributeConsumingServiceIndex(
  AAttributeConsumingServiceIndex: string): ISAMLRequestBuilder;
begin
  FAttributeConsumingServiceIndex := AAttributeConsumingServiceIndex;
  Result := Self;
end;

function TSAMLRequestBuilder.SetAuthnContextClassRef(AAuthnContextClassRef: string): ISAMLRequestBuilder;
begin
  FAuthnContextClassRef := AAuthnContextClassRef;
  Result := Self;
end;

function TSAMLRequestBuilder.SetComparison(
  const AComparison: string): ISAMLRequestBuilder;
begin
  FComparison := AComparison;
  Result := Self;
end;

function TSAMLRequestBuilder.SetDestination(
  ADestination: string): ISAMLRequestBuilder;
begin
  FDestination := ADestination;
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

function TSAMLRequestBuilder.SetIssuerFormat(
  const AFormat: string): ISAMLRequestBuilder;
begin
  FIssuerFormat := AFormat;
  Result := Self;
end;

function TSAMLRequestBuilder.SetIssuerNameQualifier(
  const ANameQualifier: string): ISAMLRequestBuilder;
begin
  FIssuerNameQualifier := ANameQualifier;
  Result := Self;
end;

function TSAMLRequestBuilder.SetNameIdFormat(
  const ANameIdFormat: string): ISAMLRequestBuilder;
begin
  FNameIdFormat := ANameIdFormat;
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
