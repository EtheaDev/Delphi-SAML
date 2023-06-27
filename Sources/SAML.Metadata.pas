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
unit SAML.Metadata;

interface

uses
  System.Classes, System.SysUtils, System.Variants, Xml.xmldom,
  Xml.XMLIntf, Xml.XMLDoc, System.DateUtils, System.IOUtils,
  System.ZLib, System.NetEncoding, Generics.Collections, SAML.Core;

type
  {$SCOPEDENUMS ON}
  TMetadataKind = (
    Unknown,
    SP,
    IdP
  );

  TCertificateFormat = (
    Der,
    Pem
  );

  {$SCOPEDENUMS OFF}

  ESAMLMetadataError = class(ESAMLError)
  end;

  TSAMLMetadata = class;

  ISAMLMetadataBuilder = interface
    ['{469B99BE-74BF-40DD-BB82-B92BFCEB493B}']
    function SetEntityID(const AEntityID: string): ISAMLMetadataBuilder;
    function SetProtocolBinding(const AProtocolBinding: string): ISAMLMetadataBuilder;
    function SetCacheDuration(const ACacheDuration: string): ISAMLMetadataBuilder;
    function SetValidUntil(AValidUntil: TDateTime): ISAMLMetadataBuilder;
    function SetLocation(const ALocation: string): ISAMLMetadataBuilder;
    function SetAuthnRequestsSigned(AAuthnRequestsSigned: Boolean): ISAMLMetadataBuilder;
    function SetWantAssertionsSigned(AWantAssertionsSigned: Boolean): ISAMLMetadataBuilder;
    function AddX509Certificate(const AUse: string; ACertificate: TStream; AOwnsStream: Boolean): ISAMLMetadataBuilder; overload;
    function AddX509Certificate(const AUse: string; ACertificate: TStream; AFormat: TCertificateFormat; AOwnsStream: Boolean): ISAMLMetadataBuilder; overload;
    function Build: TSAMLMetadata;
    function AsXML: string;
  end;

  TKeyDescriptor = class(TObject)
  private
    FUse: string;
    FCertificate: TBytes;
    FFormat: TCertificateFormat;
  public
    property Use: string read FUse;
    property Certificate: TBytes read FCertificate;
    property Format: TCertificateFormat read FFormat;

    constructor Create(const AUse: string; ACertificate: TBytes; AFormat: TCertificateFormat = TCertificateFormat.Der);
  end;

  TKeyDescriptorList = class(TObjectList<TKeyDescriptor>)
  public
    procedure AddCertificate(const AUse: string; ACertificate: TStream; AFormat: TCertificateFormat; AOwnsStream: Boolean); overload;
    procedure AddCertificate(const AUse: string; ACertificate: TBytes; AFormat: TCertificateFormat); overload;
  end;

  TSSOService = class(TDictionary<string, string>)
  end;

  TConsumerService = class(TDictionary<string, string>)
  end;

  TSAMLMetadata = class(TObject)
  public
    class function New(): ISAMLMetadataBuilder; static;
  private
    FEntityID: string;
    FProtocolBinding: string;
    FCacheDuration: string;
    FLocation: string;
    FSSO: TSSOService;
    FSLO: TSSOService;
    FKeys: TKeyDescriptorList;
    FAuthnRequestsSigned: Boolean;
    FWantAssertionsSigned: Boolean;
    FValidUntil: TDateTime;
    FKind: TMetadataKind;
    FConsumerService: TConsumerService;
    procedure ParseXML(AStream: TStream);
    function GetKeys: TKeyDescriptorList;
    procedure ParseKeyNode(AKeyDescriptor: IXMLNode);
    procedure ParseConsumerServiceNode(AConsumerService: IXMLNode);
  public
    constructor Create; overload;
    constructor Create(const AFileName: string); overload;
    constructor Create(AStream: TStream); overload;
    destructor Destroy; override;

    property EntityID: string read FEntityID write FEntityID;
    property Kind: TMetadataKind read FKind write FKind;
    property ProtocolBinding: string read FProtocolBinding write FProtocolBinding;
    property CacheDuration: string read FCacheDuration write FCacheDuration;
    property ValidUntil: TDateTime read FValidUntil write FValidUntil;
    property Location: string read FLocation write FLocation;
    property AuthnRequestsSigned: Boolean read FAuthnRequestsSigned write FAuthnRequestsSigned;
    property WantAssertionsSigned: Boolean read FWantAssertionsSigned write FWantAssertionsSigned;
    property SSO: TSSOService read FSSO;
    property SLO: TSSOService read FSLO;
    property ConsumerService: TConsumerService read FConsumerService;
    property Keys: TKeyDescriptorList read GetKeys;
    function AsXML: string;
  end;

  TSAMLMetadataBuilder = class(TInterfacedObject, ISAMLMetadataBuilder)
  private
    FEntityID: string;
    FProtocolBinding: string;
    FCacheDuration: string;
    FLocation: string;
    FAuthnRequestsSigned: Boolean;
    FWantAssertionsSigned: Boolean;
    FValidUntil: TDateTime;
    FKeys: TKeyDescriptorList;
  public
    { ISAMLMetadataBuilder }
    function SetValidUntil(AValidUntil: TDateTime): ISAMLMetadataBuilder;
    function SetAuthnRequestsSigned(AAuthnRequestsSigned: Boolean): ISAMLMetadataBuilder;
    function SetWantAssertionsSigned(AWantAssertionsSigned: Boolean): ISAMLMetadataBuilder;
    function AddX509Certificate(const AUse: string; ACertificate: TStream; AOwnsStream: Boolean): ISAMLMetadataBuilder; overload;
    function AddX509Certificate(const AUse: string; ACertificate: TStream; AFormat: TCertificateFormat; AOwnsStream: Boolean): ISAMLMetadataBuilder; overload;
    function SetProtocolBinding(const AProtocolBinding: string): ISAMLMetadataBuilder;
    function SetEntityID(const AEntityID: string): ISAMLMetadataBuilder;
    function SetCacheDuration(const ACacheDuration: string): ISAMLMetadataBuilder;
    function SetLocation(const ALocation: string): ISAMLMetadataBuilder;
    function Build: TSAMLMetadata;
    function AsXML: string;

    constructor Create;
    destructor Destroy; override;
  end;

implementation

function EncodeCert(ACertificate: TBytes; AFormat: TCertificateFormat): string;
var
  LBuffer: TBytes;
begin
  if AFormat = TCertificateFormat.Pem then
    LBuffer := PemToDer(ACertificate)
  else
    LBuffer := ACertificate;

  Result := Base64EncodeStr(LBuffer);
end;

{ TSAMLMetadata }

function TSAMLMetadata.AsXML: string;
const
  XMLBool: array [Boolean] of string = ('false', 'true');
var
  LDocument: IXMLDocument;
  LEntityDescriptor: IXMLNode;
  LSPSSODescriptor: IXMLNode;
  LNameIDFormat: IXMLNode;
  LAssertionConsumerService: IXMLNode;
  LKeyDescriptorNode: IXMLNode;
  LKeyInfo: IXMLNode;
  LX509Data: IXMLNode;
  LX509Certificate: IXMLNode;
  LKeyDescriptor: TKeyDescriptor;
begin
  if FEntityID = '' then
    raise ESAMLMetadataError.Create('"EntityID" required');
  if FProtocolBinding = '' then
    raise ESAMLMetadataError.Create('"ProtocolBinding" required');
  if FCacheDuration = '' then
    raise ESAMLMetadataError.Create('"CacheDuration" required');
  if FLocation = '' then
    raise ESAMLMetadataError.Create('"Location" required');
  if FValidUntil <= 0 then
    raise ESAMLMetadataError.Create('"ValidUntil" required');

  LDocument := TXMLDocument.Create(nil);
  LDocument.Active := True;

  LEntityDescriptor := LDocument.AddChild('md:EntityDescriptor', 'urn:oasis:names:tc:SAML:2.0:metadata');
  LEntityDescriptor.Attributes['validUntil'] := DateToISO8601(FValidUntil, False);
  LEntityDescriptor.Attributes['cacheDuration'] := FCacheDuration;
  LEntityDescriptor.Attributes['entityID'] := FEntityID;

  LSPSSODescriptor := LEntityDescriptor.AddChild('md:SPSSODescriptor', 'urn:oasis:names:tc:SAML:2.0:metadata');
  LSPSSODescriptor.Attributes['AuthnRequestsSigned'] := XMLBool[FAuthnRequestsSigned];
  LSPSSODescriptor.Attributes['WantAssertionsSigned'] := XMLBool[FWantAssertionsSigned];
  LSPSSODescriptor.Attributes['protocolSupportEnumeration'] := 'urn:oasis:names:tc:SAML:2.0:protocol';

  for LKeyDescriptor in FKeys do
  begin
    LKeyDescriptorNode := LSPSSODescriptor.AddChild('md:KeyDescriptor', 'urn:oasis:names:tc:SAML:2.0:metadata');
    LKeyDescriptorNode.Attributes['use'] := LKeyDescriptor.Use;
    LKeyInfo := LKeyDescriptorNode.AddChild('ds:KeyInfo', 'http://www.w3.org/2000/09/xmldsig#');
    LX509Data := LKeyInfo.AddChild('ds:X509Data', 'http://www.w3.org/2000/09/xmldsig#');
    LX509Certificate := LX509Data.AddChild('ds:X509Certificate', 'http://www.w3.org/2000/09/xmldsig#');
    LX509Certificate.Text := EncodeCert(LKeyDescriptor.Certificate, LKeyDescriptor.FFormat);
  end;

  LNameIDFormat := LSPSSODescriptor.AddChild('md:NameIDFormat', 'urn:oasis:names:tc:SAML:2.0:metadata');
  LNameIDFormat.Text := 'urn:oasis:names:tc:SAML:1.1:nameid-format:unspecified';

  LAssertionConsumerService := LSPSSODescriptor.AddChild('md:AssertionConsumerService', 'urn:oasis:names:tc:SAML:2.0:metadata');
  LAssertionConsumerService.Attributes['Binding'] := TSAML.BINDINGS_HTTP_POST;
  LAssertionConsumerService.Attributes['Location'] := FLocation;
  LAssertionConsumerService.Attributes['index'] := '1';

  LAssertionConsumerService := LSPSSODescriptor.AddChild('md:AssertionConsumerService', 'urn:oasis:names:tc:SAML:2.0:metadata');
  LAssertionConsumerService.Attributes['Binding'] := TSAML.BINDINGS_HTTP_REDIRECT;
  LAssertionConsumerService.Attributes['Location'] := FLocation;
  LAssertionConsumerService.Attributes['index'] := '2';

  Result := LDocument.XML.Text;
end;

constructor TSAMLMetadata.Create;
begin
  inherited;
  FSSO := TSSOService.Create;
  FSLO := TSSOService.Create;
  FKeys := TKeyDescriptorList.Create(True);
  FConsumerService := TConsumerService.Create;
  FProtocolBinding := TSAML.BINDINGS_HTTP_POST;
  FCacheDuration := 'PT604800S';
  FValidUntil := Now + 10 * 365;
end;

constructor TSAMLMetadata.Create(AStream: TStream);
begin
  Create;
  ParseXML(AStream);
end;

destructor TSAMLMetadata.Destroy;
begin
  FSSO.Free;
  FSLO.Free;
  FKeys.Free;
  FConsumerService.Free;
  inherited;
end;

function TSAMLMetadata.GetKeys: TKeyDescriptorList;
begin
  Result := FKeys;
end;

constructor TSAMLMetadata.Create(const AFileName: string);
var
  LFileStream: TFileStream;
begin
  LFileStream := TFileStream.Create(AFileName, fmOpenRead);
  try
    Create(LFileStream);
  finally
    LFileStream.Free;
  end;
end;

class function TSAMLMetadata.New: ISAMLMetadataBuilder;
begin
  Result := TSAMLMetadataBuilder.Create;
end;

procedure TSAMLMetadata.ParseKeyNode(AKeyDescriptor: IXMLNode);
var
  LUse: string;
  LKeyInfo: IXMLNode;
  LX509Data: IXMLNode;
  LX509Certificate: IXMLNode;
begin
  LUse := VarToStr(AKeyDescriptor.Attributes['use']);
  LKeyInfo := AKeyDescriptor.ChildNodes.FindNode('KeyInfo', 'http://www.w3.org/2000/09/xmldsig#');
  if not Assigned(LKeyInfo) then
    raise ESAMLMetadataError.Create('Invalid metadata: KeyInfo missing');
  LX509Data := LKeyInfo.ChildNodes.FindNode('X509Data', 'http://www.w3.org/2000/09/xmldsig#');
  if not Assigned(LX509Data) then
    raise ESAMLMetadataError.Create('Invalid metadata: X509Data missing');
  LX509Certificate := LX509Data.ChildNodes.FindNode('X509Certificate', 'http://www.w3.org/2000/09/xmldsig#');
  FKeys.Add(TKeyDescriptor.Create(LUse, TNetEncoding.Base64.DecodeStringToBytes(LX509Certificate.Text)));
end;

procedure TSAMLMetadata.ParseConsumerServiceNode(AConsumerService: IXMLNode);
var
  LBinding: string;
  LLocation: string;
begin
  LBinding := VarToStr(AConsumerService.Attributes['Binding']);
  LLocation := VarToStr(AConsumerService.Attributes['Location']);
  FConsumerService.Add(LBinding, LLocation);
end;

procedure TSAMLMetadata.ParseXML(AStream: TStream);
var
  LDocument: IXMLDocument;
  LEntityDescriptor: IXMLNode;
  LPSSODescriptor: IXMLNode;
  LService: IXMLNode;
  LIndex: Integer;
begin
  LDocument := TXMLDocument.Create(nil);
  LDocument.LoadFromStream(AStream);
  LDocument.Active := True;

  LDocument.ChildNodes.First.NodeName;
  LEntityDescriptor := LDocument.ChildNodes.FindNode('EntityDescriptor', 'urn:oasis:names:tc:SAML:2.0:metadata');
  if not Assigned(LEntityDescriptor) then
    raise ESAMLMetadataError.Create('Invalid metadata: EntityDescriptor missing');

  FEntityID := VarToStr(LEntityDescriptor.Attributes['entityID']);

  LPSSODescriptor := LEntityDescriptor.ChildNodes.FindNode('IDPSSODescriptor', 'urn:oasis:names:tc:SAML:2.0:metadata');
  if Assigned(LPSSODescriptor) then
  begin
    FKind := TMetadataKind.IdP;
    for LIndex := 0 to LPSSODescriptor.ChildNodes.Count - 1do
    begin
      LService := LPSSODescriptor.ChildNodes[LIndex];
      if LService.DOMNode.localName = 'SingleLogoutService' then
      begin
        FSLO.Add(VarToStr(LService.Attributes['Binding']), VarToStr(LService.Attributes['Location']));
      end;
      if LService.DOMNode.localName = 'SingleSignOnService' then
      begin
        FSSO.Add(VarToStr(LService.Attributes['Binding']), VarToStr(LService.Attributes['Location']));
      end;
      if LService.DOMNode.localName = 'KeyDescriptor' then
      begin
        ParseKeyNode(LService);
      end;

    end;
  end;

  LPSSODescriptor := LEntityDescriptor.ChildNodes.FindNode('SPSSODescriptor', 'urn:oasis:names:tc:SAML:2.0:metadata');
  if Assigned(LPSSODescriptor) then
  begin
    FKind := TMetadataKind.SP;
    FAuthnRequestsSigned := VarToStr(LPSSODescriptor.Attributes['AuthnRequestsSigned']) = 'true';
    FWantAssertionsSigned := VarToStr(LPSSODescriptor.Attributes['WantAssertionsSigned']) = 'true';
    for LIndex := 0 to LPSSODescriptor.ChildNodes.Count - 1do
    begin
      LService := LPSSODescriptor.ChildNodes[LIndex];
      if LService.DOMNode.localName = 'KeyDescriptor' then
      begin
        ParseKeyNode(LService);
      end;
      if LService.DOMNode.localName = 'AssertionConsumerService' then
      begin
        ParseConsumerServiceNode(LService);
      end;
    end;
  end;

  //FDestination := VarToStr(LResponse.Attributes['Destination']);

end;

{ TSAMLMetadataBuilder }

function TSAMLMetadataBuilder.AddX509Certificate(const AUse: string;
  ACertificate: TStream; AOwnsStream: Boolean): ISAMLMetadataBuilder;
begin
  FKeys.AddCertificate(AUse, ACertificate, TCertificateFormat.Der, AOwnsStream);

  Result := Self;
end;

function TSAMLMetadataBuilder.AddX509Certificate(const AUse: string;
  ACertificate: TStream; AFormat: TCertificateFormat;
  AOwnsStream: Boolean): ISAMLMetadataBuilder;
begin
  FKeys.AddCertificate(AUse, ACertificate, AFormat, AOwnsStream);

  Result := Self;
end;

function TSAMLMetadataBuilder.AsXML: string;
var
  LMetadata: TSAMLMetadata;
begin
  LMetadata := Self.Build;
  try
    Result := LMetadata.AsXML;
  finally
    LMetadata.Free;
  end;
end;

function TSAMLMetadataBuilder.Build: TSAMLMetadata;
var
  LKeyDescriptor: TKeyDescriptor;
begin
  Result := TSAMLMetadata.Create;
  if FEntityID <> '' then
    Result.FEntityID := FEntityID;
  if FProtocolBinding <> '' then
    Result.FProtocolBinding := FProtocolBinding;
  if FCacheDuration <> '' then
    Result.FCacheDuration := FCacheDuration;
  if FLocation <> '' then
    Result.FLocation := FLocation;

  Result.FAuthnRequestsSigned := FAuthnRequestsSigned;
  Result.FWantAssertionsSigned := FWantAssertionsSigned;

  if FValidUntil > 0 then
    Result.FValidUntil := FValidUntil;

  for LKeyDescriptor in FKeys do
    Result.Keys.Add( TKeyDescriptor.Create(LKeyDescriptor.FUse, LKeyDescriptor.FCertificate) );
end;

constructor TSAMLMetadataBuilder.Create;
begin
  inherited;
  FKeys := TKeyDescriptorList.Create(True);
end;

destructor TSAMLMetadataBuilder.Destroy;
begin
  FKeys.Free;
  inherited;
end;

function TSAMLMetadataBuilder.SetAuthnRequestsSigned(
  AAuthnRequestsSigned: Boolean): ISAMLMetadataBuilder;
begin
  FAuthnRequestsSigned := AAuthnRequestsSigned;
  Result := Self;
end;

function TSAMLMetadataBuilder.SetCacheDuration(
  const ACacheDuration: string): ISAMLMetadataBuilder;
begin
  FCacheDuration := ACacheDuration;
  Result := Self;
end;

function TSAMLMetadataBuilder.SetEntityID(
  const AEntityID: string): ISAMLMetadataBuilder;
begin
  FEntityID := AEntityID;
  Result := Self;
end;

function TSAMLMetadataBuilder.SetLocation(
  const ALocation: string): ISAMLMetadataBuilder;
begin
  FLocation := ALocation;
  Result := Self;
end;

function TSAMLMetadataBuilder.SetProtocolBinding(
  const AProtocolBinding: string): ISAMLMetadataBuilder;
begin
  FProtocolBinding := AProtocolBinding;
  Result := Self;
end;

function TSAMLMetadataBuilder.SetValidUntil(
  AValidUntil: TDateTime): ISAMLMetadataBuilder;
begin
  FValidUntil := AValidUntil;
  Result := Self;
end;

function TSAMLMetadataBuilder.SetWantAssertionsSigned(
  AWantAssertionsSigned: Boolean): ISAMLMetadataBuilder;
begin
  FWantAssertionsSigned := AWantAssertionsSigned;
  Result := Self;
end;

{ TKeyDescriptor }

constructor TKeyDescriptor.Create(const AUse: string; ACertificate: TBytes; AFormat: TCertificateFormat);
begin
  inherited Create;
  FUse := AUse;
  FCertificate := ACertificate;
  FFormat := AFormat;
end;

{ TKeyDescriptorList }

procedure TKeyDescriptorList.AddCertificate(const AUse: string;
  ACertificate: TBytes; AFormat: TCertificateFormat);
var
  LKeyDescriptor: TKeyDescriptor;
begin
  LKeyDescriptor := TKeyDescriptor.Create(AUse, ACertificate, AFormat);
  Add(LKeyDescriptor);
end;

procedure TKeyDescriptorList.AddCertificate(const AUse: string;
  ACertificate: TStream; AFormat: TCertificateFormat; AOwnsStream: Boolean);
var
  LData: TBytes;
begin
  SetLength(LData, ACertificate.Size);
  ACertificate.ReadBuffer(LData[0], ACertificate.Size);

  Add(TKeyDescriptor.Create(AUse, LData, AFormat));

  if AOwnsStream then
    ACertificate.Free;
end;

end.
