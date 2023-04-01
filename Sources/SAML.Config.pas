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
unit SAML.Config;

interface

uses
  System.Classes, System.SysUtils, System.NetEncoding,
  SAML.XML.Utils, Xml.XMLIntf;

type
  ESAMLConfigError = class(Exception);

  TSAMLCertificate = class
  private
    FData: TBytes;
    FFormat: TKeyDataFormat;
  public
    procedure LoadFromMetadata(const AValue: string); overload;
    procedure LoadFromMetadata(ANode: IXMLNode); overload;
    procedure LoadFromFile(const AFileName: string; AFormat: TKeyDataFormat);
    procedure Clear;
    function IsEmpty: Boolean;
    property Data: TBytes read FData;
    property Format: TKeyDataFormat read FFormat;
  end;

  TSAMLKey = class
  private
    FData: TBytes;
    FFormat: TKeyDataFormat;
  public
    procedure LoadFromFile(const AFileName: string; AFormat: TKeyDataFormat);
    procedure Clear;
    function IsEmpty: Boolean;
    property Data: TBytes read FData;
    property Format: TKeyDataFormat read FFormat;
  end;

  TSAMLIdPConfig = class
  private
    FSignPubKeyFile: string;
    FWantAuthnRequestsSigned: Boolean;
    FSLOBinding: string;
    FEncPubKeyFormat: TKeyDataFormat;
    FSSOUrl: string;
    FEntityId: string;
    FEncPubKeyFile: string;
    FSLOUrl: string;
    FSignPubKeyFormat: TKeyDataFormat;
    FSSOBinding: string;
    FSkipSignatureCheck: Boolean;
    FSigningCertificate: TSAMLCertificate;
    FEncryptionCertificate: TSAMLCertificate;
    procedure LoadFromXmlFile(const AFileName: string);
    procedure LoadFromIniFile(const AFileName: string);
  public
    property EntityId: string read FEntityId write FEntityId;

    property SSOUrl: string read FSSOUrl write FSSOUrl;
    property SSOBinding: string read FSSOBinding write FSSOBinding;
    property SLOUrl: string read FSLOUrl write FSLOUrl;
    property SLOBinding: string read FSLOBinding write FSLOBinding;

    property WantAuthnRequestsSigned: Boolean read FWantAuthnRequestsSigned write FWantAuthnRequestsSigned;
    property SkipSignatureCheck: Boolean read FSkipSignatureCheck write FSkipSignatureCheck;

    property SigningCertificate: TSAMLCertificate read FSigningCertificate;
    property EncryptionCertificate: TSAMLCertificate read FEncryptionCertificate;

    property SignPubKeyFile: string read FSignPubKeyFile write FSignPubKeyFile;
    property SignPubKeyFormat: TKeyDataFormat read FSignPubKeyFormat write FSignPubKeyFormat;
    property EncPubKeyFile: string read FEncPubKeyFile write FEncPubKeyFile;
    property EncPubKeyFormat: TKeyDataFormat read FEncPubKeyFormat write FEncPubKeyFormat;

    constructor Create;
    destructor Destroy; override;

    procedure LoadFromFile(const AFileName: string);
    procedure Clear;
  end;

  TSAMLSPConfig = class
  private
    FEntityId: string;
    FSignPrivKeyFile: string;
    FSignRequest: Boolean;
    FSignPubKeyFormat: TKeyDataFormat;
    FHomeUrl: string;
    FSignPrivKeyFormat: TKeyDataFormat;
    FSignPubKeyFile: string;
    FAssertionUrl: string;
    FEncPrivKeyFile: string;
    FEncPubKeyFormat: TKeyDataFormat;
    FEncPubKeyFile: string;
    FEncPrivKeyFormat: TKeyDataFormat;
    FAssertionConsumerServiceIndex: string;
    FAttributeConsumingServiceIndex: string;
    FAuthnContext: string;
    FSigningCertificate: TSAMLCertificate;
    FEncryptionCertificate: TSAMLCertificate;
    FEncryptionKey: TSAMLKey;
    FSigningKey: TSAMLKey;
    procedure LoadFromIniFile(const AFileName: string);
    procedure LoadFromXmlFile(const AFileName: string);
    procedure SetSignPrivKeyFile(const Value: string);
    procedure SetSignPubKeyFile(const Value: string);
    procedure SetEncPrivKeyFile(const Value: string);
    procedure SetEncPubKeyFile(const Value: string);
  public
    property EntityId: string read FEntityId write FEntityId;

    property HomeUrl: string read FHomeUrl write FHomeUrl;
    property AssertionUrl: string read FAssertionUrl write FAssertionUrl;

    property SigningCertificate: TSAMLCertificate read FSigningCertificate;
    property EncryptionCertificate: TSAMLCertificate read FEncryptionCertificate;

    property SigningKey: TSAMLKey read FSigningKey;
    property EncryptionKey: TSAMLKey read FEncryptionKey;

    property SignRequest: Boolean read FSignRequest write FSignRequest;
    property AssertionConsumerServiceIndex: string read FAssertionConsumerServiceIndex write FAssertionConsumerServiceIndex;
    property AttributeConsumingServiceIndex: string read FAttributeConsumingServiceIndex write FAttributeConsumingServiceIndex;

    property SignPrivKeyFile: string read FSignPrivKeyFile write SetSignPrivKeyFile;
    property SignPrivKeyFormat: TKeyDataFormat read FSignPrivKeyFormat write FSignPrivKeyFormat;
    property SignPubKeyFile: string read FSignPubKeyFile write SetSignPubKeyFile;
    property SignPubKeyFormat: TKeyDataFormat read FSignPubKeyFormat write FSignPubKeyFormat;

    property EncPrivKeyFile: string read FEncPrivKeyFile write SetEncPrivKeyFile;
    property EncPrivKeyFormat: TKeyDataFormat read FEncPrivKeyFormat write FEncPrivKeyFormat;
    property EncPubKeyFile: string read FEncPubKeyFile write SetEncPubKeyFile;
    property EncPubKeyFormat: TKeyDataFormat read FEncPubKeyFormat write FEncPubKeyFormat;
    property AuthnContext: string read FAuthnContext write FAuthnContext;

    constructor Create;
    destructor Destroy; override;

    procedure Clear;
    procedure LoadFromFile(const AFileName: string);
  end;

implementation

uses
  Xml.xmldom, Xml.XMLDoc, SAML.Core;

const
  MetadataNS = 'urn:oasis:names:tc:SAML:2.0:metadata';
  XmlSigNS = 'http://www.w3.org/2000/09/xmldsig#';

function StrToKeyFormat(const AKeyFormat: string): TKeyDataFormat;
begin
  if SameText(AKeyFormat, 'BINARY') then
    Result := TKeyDataFormat.Binary
  else if SameText(AKeyFormat, 'PEM') then
    Result := TKeyDataFormat.Pem
  else if SameText(AKeyFormat, 'DER') then
    Result := TKeyDataFormat.Der
  else if SameText(AKeyFormat, 'PKCS8_PEM') then
    Result := TKeyDataFormat.Pkcs8Pem
  else if SameText(AKeyFormat, 'PKCS_DER') then
    Result := TKeyDataFormat.Pkcs8Der
  else if SameText(AKeyFormat, 'PKCS12') then
    Result := TKeyDataFormat.Pkcs12
  else if SameText(AKeyFormat, 'CERT_PEM') then
    Result := TKeyDataFormat.CertPem
  else if SameText(AKeyFormat, 'CERT_DER') then
    Result := TKeyDataFormat.CertDer
  else
    Result := TKeyDataFormat.Unknown;
end;

{ TSAMLIdPConfig }

procedure TSAMLIdPConfig.LoadFromIniFile(const AFileName: string);
var
  LConfig: TStrings;
begin
  LConfig := TStringList.Create;
  try
    LConfig.LoadFromFile(AFileName);
    EntityId := LConfig.Values['EntityId'];
    SSOUrl := LConfig.Values['SSOUrl'];
    SSOBinding := LConfig.Values['SSOBinding'];
    SLOUrl := LConfig.Values['SLOUrl'];
    SLOBinding := LConfig.Values['SLOBinding'];
    WantAuthnRequestsSigned := LConfig.Values['SignRequest'] = '1';
    SkipSignatureCheck := LConfig.Values['SkipSignatureCheck'] = '1';
    SignPubKeyFile := LConfig.Values['SignPubKeyFile'];
    SignPubKeyFormat := StrToKeyFormat(LConfig.Values['SignPubKeyFormat']);
    EncPubKeyFile := LConfig.Values['EncPubKeyFile'];
    EncPubKeyFormat := StrToKeyFormat(LConfig.Values['EncPubKeyFormat']);
  finally
    LConfig.Free;
  end;
end;

destructor TSAMLIdPConfig.Destroy;
begin
  FSigningCertificate.Free;
  FEncryptionCertificate.Free;
  inherited;
end;

procedure TSAMLIdPConfig.LoadFromFile(const AFileName: string);
begin
  Clear;
  if SameText(ExtractFileExt(AFileName), '.ini') then
    LoadFromIniFile(AFileName)
  else if SameText(ExtractFileExt(AFileName), '.xml') then
    LoadFromXmlFile(AFileName)
  else
    raise ESAMLConfigError.Create('Format not supported');
end;

procedure TSAMLIdPConfig.LoadFromXmlFile(const AFileName: string);
var
  LDocument: IXMLDocument;
  LEntityDescriptorNode: IXMLNode;
  LIDPSSODescriptorNode: IXMLNode;
  LNode: IXMLNode;
  LIndex: Integer;
begin
  LDocument := TXMLDocument.Create(nil);
  LDocument.LoadFromFile(AFileName);
  LDocument.Active := True;

  LEntityDescriptorNode := LDocument.ChildNodes.FindNode('EntityDescriptor', MetadataNS);
  if not Assigned(LEntityDescriptorNode) then
    raise ESAMLConfigError.Create('Invalid mata data: "EntityDescriptor" not found');

  EntityId := LEntityDescriptorNode.Attributes['entityID'];

  LIDPSSODescriptorNode := LEntityDescriptorNode.ChildNodes.FindNode('IDPSSODescriptor', MetadataNS);
  if not Assigned(LIDPSSODescriptorNode) then
    raise ESAMLConfigError.Create('Invalid mata data: "IDPSSODescriptor" not found');

  WantAuthnRequestsSigned := LIDPSSODescriptorNode.Attributes['WantAuthnRequestsSigned'] = 'true';

  for LIndex := 0 to LIDPSSODescriptorNode.ChildNodes.Count - 1 do
  begin
    LNode := LIDPSSODescriptorNode.ChildNodes[LIndex];

    if (LNode.LocalName = 'KeyDescriptor') and (LNode.NamespaceURI = MetadataNS) then
    begin
      if LNode.Attributes['use'] = 'signing' then
        FSigningCertificate.LoadFromMetadata(LNode);
      if LNode.Attributes['use'] = 'encryption' then
        FEncryptionCertificate.LoadFromMetadata(LNode);
    end;
    if (LNode.LocalName = 'SingleSignOnService') and (LNode.NamespaceURI = MetadataNS) then
    begin
      if (LNode.Attributes['Binding'] = TSAML.BINDINGS_HTTP_POST) and (SSOUrl = '') then
      begin
        SSOBinding := LNode.Attributes['Binding'];
        SSOUrl := LNode.Attributes['Location'];
      end;
    end;

    if (LNode.LocalName = 'SingleLogoutService') and (LNode.NamespaceURI = MetadataNS) then
    begin
      if SLOUrl = '' then
      begin
        SLOBinding := LNode.Attributes['Binding'];
        SLOUrl := LNode.Attributes['Location'];
      end;
    end;

  end;

end;

procedure TSAMLIdPConfig.Clear;
begin
  FSignPubKeyFile := '';
  FWantAuthnRequestsSigned := False;
  FSLOBinding := '';
  FEncPubKeyFormat := TKeyDataFormat.Unknown;
  FSSOUrl := '';
  FEntityId := '';
  FEncPubKeyFile := '';
  FSLOUrl := '';
  FSignPubKeyFormat := TKeyDataFormat.Unknown;
  FSSOBinding := '';
  FSkipSignatureCheck := False;
  FSigningCertificate.Clear;
  FEncryptionCertificate.Clear;
end;

constructor TSAMLIdPConfig.Create;
begin
  FSigningCertificate := TSAMLCertificate.Create;
  FEncryptionCertificate := TSAMLCertificate.Create;
end;

{ TSAMLSPConfig }

procedure TSAMLSPConfig.Clear;
begin
  FEntityId := '';
  FSignPrivKeyFile := '';
  FSignRequest := False;
  FSignPubKeyFormat := TKeyDataFormat.Unknown;
  FHomeUrl := '';
  FSignPrivKeyFormat := TKeyDataFormat.Unknown;
  FSignPubKeyFile := '';
  FAssertionUrl := '';
  FEncPrivKeyFile := '';
  FEncPubKeyFormat := TKeyDataFormat.Unknown;
  FEncPubKeyFile  := '';
  FEncPrivKeyFormat := TKeyDataFormat.Unknown;
  FAssertionConsumerServiceIndex := '';
  FAttributeConsumingServiceIndex := '';
  FAuthnContext := '';
  FSigningCertificate.Clear;
  FEncryptionCertificate.Clear;
  FEncryptionKey.Clear;
  FSigningKey.Clear;
end;

constructor TSAMLSPConfig.Create;
begin
  FSigningCertificate := TSAMLCertificate.Create;
  FEncryptionCertificate := TSAMLCertificate.Create;

  FSigningKey := TSAMLKey.Create;
  FEncryptionKey := TSAMLKey.Create;
end;

procedure TSAMLSPConfig.LoadFromXmlFile(const AFileName: string);
const
  DefaultHomePage = 'http://localhost:4567/pages/sp.html';
var
  LDocument: IXMLDocument;
  LEntityDescriptorNode: IXMLNode;
  LSPSSODescriptorNode: IXMLNode;
  LNode: IXMLNode;
  LIndex: Integer;
begin
  LDocument := TXMLDocument.Create(nil);
  LDocument.LoadFromFile(AFileName);
  LDocument.Active := True;

  HomeUrl := DefaultHomePage;

  LEntityDescriptorNode := LDocument.ChildNodes.FindNode('EntityDescriptor', MetadataNS);
  if not Assigned(LEntityDescriptorNode) then
    raise ESAMLConfigError.Create('Invalid mata data: "EntityDescriptor" not found');

  EntityId := LEntityDescriptorNode.Attributes['entityID'];

  LSPSSODescriptorNode := LEntityDescriptorNode.ChildNodes.FindNode('SPSSODescriptor', MetadataNS);
  if not Assigned(LSPSSODescriptorNode) then
    raise ESAMLConfigError.Create('Invalid mata data: "SPSSODescriptor" not found');

  //WantAuthnRequestsSigned := LIDPSSODescriptorNode.Attributes['WantAuthnRequestsSigned'] = 'true';

  for LIndex := 0 to LSPSSODescriptorNode.ChildNodes.Count - 1 do
  begin
    LNode := LSPSSODescriptorNode.ChildNodes[LIndex];

    if (LNode.LocalName = 'KeyDescriptor') and (LNode.NamespaceURI = MetadataNS) then
    begin
      if LNode.Attributes['use'] = 'signing' then
        FSigningCertificate.LoadFromMetadata(LNode);
      if LNode.Attributes['use'] = 'encryption' then
        FEncryptionCertificate.LoadFromMetadata(LNode);
    end;
    if (LNode.LocalName = 'AssertionConsumerService') and (LNode.NamespaceURI = MetadataNS) then
    begin
      if AssertionUrl = '' then
      begin
        AssertionUrl := LNode.Attributes['Location'];
        AssertionConsumerServiceIndex := LNode.Attributes['index'];
      end;
    end;
    if (LNode.LocalName = 'AttributeConsumingService') and (LNode.NamespaceURI = MetadataNS) then
    begin
      if AttributeConsumingServiceIndex = '' then
      begin
        AttributeConsumingServiceIndex := LNode.Attributes['index'];
      end;
    end;
  end;

  // Guess auth context
  if AFileName.ToUpper.Contains('SPID') then
    AuthnContext := TSAML.AUTHCONTEXT_SpidL1;

end;

procedure TSAMLSPConfig.SetEncPrivKeyFile(const Value: string);
begin
  if FEncPrivKeyFile <> Value then
  begin
    FEncPrivKeyFile := Value;
    if Value = '' then
      FEncryptionKey.Clear
    else
      FEncryptionKey.LoadFromFile(FEncPrivKeyFile, TKeyDataFormat.Pem);
  end;
end;

procedure TSAMLSPConfig.SetEncPubKeyFile(const Value: string);
begin
  if FEncPubKeyFile <> Value then
  begin
    FEncPubKeyFile := Value;
    if Value = '' then
      FEncryptionCertificate.Clear
    else
      FEncryptionCertificate.LoadFromFile(FEncPubKeyFile, TKeyDataFormat.Pkcs8Pem);
  end;
end;

procedure TSAMLSPConfig.SetSignPrivKeyFile(const Value: string);
begin
  if FSignPrivKeyFile <> Value then
  begin
    FSignPrivKeyFile := Value;
    if Value = '' then
      FSigningKey.Clear
    else
      FSigningKey.LoadFromFile(FSignPrivKeyFile, TKeyDataFormat.Pem);
  end;
end;

procedure TSAMLSPConfig.SetSignPubKeyFile(const Value: string);
begin
  if FSignPubKeyFile <> Value then
  begin
    FSignPubKeyFile := Value;
    if FSignPubKeyFile = '' then
      FSigningCertificate.Clear
    else
      FSigningCertificate.LoadFromFile(FSignPubKeyFile, TKeyDataFormat.Pkcs8Pem)
  end;
end;

destructor TSAMLSPConfig.Destroy;
begin
  FSigningCertificate.Free;
  FEncryptionCertificate.Free;

  FSigningKey.Free;
  FEncryptionKey.Free;
  inherited;
end;

procedure TSAMLSPConfig.LoadFromFile(const AFileName: string);
begin
  Clear;
  if SameText(ExtractFileExt(AFileName), '.ini') then
    LoadFromIniFile(AFileName)
  else if SameText(ExtractFileExt(AFileName), '.xml') then
    LoadFromXmlFile(AFileName)
  else
    raise ESAMLConfigError.Create('Format not supported');
end;

procedure TSAMLSPConfig.LoadFromIniFile(const AFileName: string);
var
  LConfig: TStrings;
begin
  LConfig := TStringList.Create;
  try
    LConfig.LoadFromFile(AFileName);

    EntityId := LConfig.Values['EntityId'];

    HomeUrl := LConfig.Values['HomeUrl'];
    AssertionUrl := LConfig.Values['AssertionUrl'];
    SignRequest := LConfig.Values['SignRequest'] = '1';
    AssertionConsumerServiceIndex := LConfig.Values['AssertionConsumerServiceIndex'];
    AttributeConsumingServiceIndex := LConfig.Values['AttributeConsumingServiceIndex'];
    AuthnContext := LConfig.Values['AuthnContext'];

    SignPrivKeyFile := LConfig.Values['SignPrivKeyFile'];
    SignPrivKeyFormat := StrToKeyFormat(LConfig.Values['SignPrivKeyFormat']);
    SignPubKeyFile := LConfig.Values['SignPubKeyFile'];
    SignPubKeyFormat := StrToKeyFormat(LConfig.Values['SignPubKeyFormat']);

    EncPrivKeyFile := LConfig.Values['EncPrivKeyFile'];
    EncPrivKeyFormat := StrToKeyFormat(LConfig.Values['EncPrivKeyFormat']);
    EncPubKeyFile := LConfig.Values['EncPubKeyFile'];
    EncPubKeyFormat := StrToKeyFormat(LConfig.Values['EncPubKeyFormat']);

    if SignPubKeyFile <> '' then
      FSigningCertificate.LoadFromFile(SignPubKeyFile, SignPubKeyFormat);
    if EncPubKeyFile <> '' then
      FEncryptionCertificate.LoadFromFile(EncPubKeyFile, EncPubKeyFormat);

    if SignPrivKeyFile <> '' then
      FSigningKey.LoadFromFile(SignPrivKeyFile, SignPrivKeyFormat);
    if EncPrivKeyFile <> '' then
      FEncryptionKey.LoadFromFile(EncPrivKeyFile, EncPrivKeyFormat);

  finally
    LConfig.Free;
  end;
end;

{ TSAMLCertificate }

procedure TSAMLCertificate.LoadFromMetadata(const AValue: string);
begin
  FData := TNetEncoding.Base64.DecodeStringToBytes(AValue);
  FFormat := TKeyDataFormat.CertDer;
end;

procedure TSAMLCertificate.Clear;
begin
  SetLength(FData, 0);
end;

function TSAMLCertificate.IsEmpty: Boolean;
begin
  Result := Length(FData) = 0;
end;

procedure TSAMLCertificate.LoadFromFile(const AFileName: string;
  AFormat: TKeyDataFormat);
var
  LFileStream: TFileStream;
begin
  LFileStream := TFileStream.Create(AFileName, fmOpenRead);
  try
    SetLength(FData, LFileStream.Size);
    LFileStream.ReadBuffer(FData[0], Length(FData))
  finally
    LFileStream.Free;
  end;

  FFormat := AFormat;
end;

procedure TSAMLCertificate.LoadFromMetadata(ANode: IXMLNode);
var
  LKeyInfoNode: IXMLNode;
  LX509DataNode: IXMLNode;
  LX509CertificateNode: IXMLNode;
  LCertificate: string;
begin
  LKeyInfoNode := ANode.ChildNodes.FindNode('KeyInfo', XmlSigNS);
  if not Assigned(LKeyInfoNode) then
    raise ESAMLConfigError.Create('Node "KeyInfo" not found');

  LX509DataNode := LKeyInfoNode.ChildNodes.FindNode('X509Data', XmlSigNS);
  if not Assigned(LX509DataNode) then
    raise ESAMLConfigError.Create('Node "X509Data" not found');

  LX509CertificateNode := LX509DataNode.ChildNodes.FindNode('X509Certificate', XmlSigNS);
  if not Assigned(LX509CertificateNode) then
    raise ESAMLConfigError.Create('Node "X509Certificate" not found');

  LCertificate := LX509CertificateNode.Text;
  LoadFromMetadata(LCertificate);
end;

{ TSAMLKey }

procedure TSAMLKey.Clear;
begin
  SetLength(FData, 0);
end;

function TSAMLKey.IsEmpty: Boolean;
begin
  Result := Length(FData) = 0;
end;

procedure TSAMLKey.LoadFromFile(const AFileName: string;
  AFormat: TKeyDataFormat);
var
  LFileStream: TFileStream;
begin
  LFileStream := TFileStream.Create(AFileName, fmOpenRead);
  try
    SetLength(FData, LFileStream.Size);
    LFileStream.ReadBuffer(FData[0], Length(FData))
  finally
    LFileStream.Free;
  end;

  FFormat := AFormat;
end;

end.
