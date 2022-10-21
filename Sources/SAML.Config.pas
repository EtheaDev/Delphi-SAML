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
  System.Classes, System.SysUtils, SAML.XML.Utils;

type
  TSAMLIdPConfig = class
  private
    FSignPubKeyFile: string;
    FSignRequest: Boolean;
    FSLOBinding: string;
    FEncPubKeyFormat: TKeyDataFormat;
    FSSOUrl: string;
    FEntityId: string;
    FEncPubKeyFile: string;
    FSLOUrl: string;
    FSignPubKeyFormat: TKeyDataFormat;
    FSSOBinding: string;
    FSkipSignatureCheck: Boolean;
  public
    property EntityId: string read FEntityId write FEntityId;

    property SSOUrl: string read FSSOUrl write FSSOUrl;
    property SSOBinding: string read FSSOBinding write FSSOBinding;
    property SLOUrl: string read FSLOUrl write FSLOUrl;
    property SLOBinding: string read FSLOBinding write FSLOBinding;

    property SignRequest: Boolean read FSignRequest write FSignRequest;
    property SkipSignatureCheck: Boolean read FSkipSignatureCheck write FSkipSignatureCheck;

    property SignPubKeyFile: string read FSignPubKeyFile write FSignPubKeyFile;
    property SignPubKeyFormat: TKeyDataFormat read FSignPubKeyFormat write FSignPubKeyFormat;
    property EncPubKeyFile: string read FEncPubKeyFile write FEncPubKeyFile;
    property EncPubKeyFormat: TKeyDataFormat read FEncPubKeyFormat write FEncPubKeyFormat;

    constructor Create;
    procedure LoadFromFile(const AFileName: string);
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
  public
    property EntityId: string read FEntityId write FEntityId;

    property HomeUrl: string read FHomeUrl write FHomeUrl;
    property AssertionUrl: string read FAssertionUrl write FAssertionUrl;

    property SignRequest: Boolean read FSignRequest write FSignRequest;
    property SignPrivKeyFile: string read FSignPrivKeyFile write FSignPrivKeyFile;
    property SignPrivKeyFormat: TKeyDataFormat read FSignPrivKeyFormat write FSignPrivKeyFormat;
    property SignPubKeyFile: string read FSignPubKeyFile write FSignPubKeyFile;
    property SignPubKeyFormat: TKeyDataFormat read FSignPubKeyFormat write FSignPubKeyFormat;

    property EncPrivKeyFile: string read FEncPrivKeyFile write FEncPrivKeyFile;
    property EncPrivKeyFormat: TKeyDataFormat read FEncPrivKeyFormat write FEncPrivKeyFormat;
    property EncPubKeyFile: string read FEncPubKeyFile write FEncPubKeyFile;
    property EncPubKeyFormat: TKeyDataFormat read FEncPubKeyFormat write FEncPubKeyFormat;

    constructor Create;
    procedure LoadFromFile(const AFileName: string);
  end;


implementation

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

procedure TSAMLIdPConfig.LoadFromFile(const AFileName: string);
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
    SignRequest := LConfig.Values['SignRequest'] = '1';
    SkipSignatureCheck := LConfig.Values['SkipSignatureCheck'] = '1';
    SignPubKeyFile := LConfig.Values['SignPubKeyFile'];
    SignPubKeyFormat := StrToKeyFormat(LConfig.Values['SignPubKeyFormat']);
    EncPubKeyFile := LConfig.Values['EncPubKeyFile'];
    EncPubKeyFormat := StrToKeyFormat(LConfig.Values['EncPubKeyFormat']);
  finally
    LConfig.Free;
  end;
end;

constructor TSAMLIdPConfig.Create;
begin

end;

{ TSAMLSPConfig }

constructor TSAMLSPConfig.Create;
begin

end;

procedure TSAMLSPConfig.LoadFromFile(const AFileName: string);
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

    SignPrivKeyFile := LConfig.Values['SignPrivKeyFile'];
    SignPrivKeyFormat := StrToKeyFormat(LConfig.Values['SignPrivKeyFormat']);
    SignPubKeyFile := LConfig.Values['SignPubKeyFile'];
    SignPubKeyFormat := StrToKeyFormat(LConfig.Values['SignPubKeyFormat']);

    EncPrivKeyFile := LConfig.Values['EncPrivKeyFile'];
    EncPrivKeyFormat := StrToKeyFormat(LConfig.Values['EncPrivKeyFormat']);
    EncPubKeyFile := LConfig.Values['EncPubKeyFile'];
    EncPubKeyFormat := StrToKeyFormat(LConfig.Values['EncPubKeyFormat']);
  finally
    LConfig.Free;
  end;
end;

end.
