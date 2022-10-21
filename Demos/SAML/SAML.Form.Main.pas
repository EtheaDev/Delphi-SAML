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
unit SAML.Form.Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, IdBaseComponent, IdComponent,
  IdCustomTCPServer, IdCustomHTTPServer, IdHTTPServer, Vcl.StdCtrls, Xml.xmldom,
  Xml.XMLIntf, Xml.XMLDoc, DateUtils, ZLib, NetEncoding, ShellApi, IdContext,
  Xml.omnixmldom, ActiveX, IOUtils, IdGlobalProtocols, Vcl.ExtCtrls,
  Vcl.ComCtrls,

  SAML.Config, SAML.http.Server;

type
  TMainForm = class(TForm)
    OpenDialog1: TOpenDialog;
    pgcConfig: TPageControl;
    tabIdP: TTabSheet;
    tabServiceProvider: TTabSheet;
    grpIdPSettings: TGroupBox;
    Label1: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    edtSSOUrl: TEdit;
    edtSLOUrl: TEdit;
    edtIdPEntityID: TEdit;
    edtIdPSignPubKey: TEdit;
    GroupBox2: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    edtSPEntityID: TComboBox;
    edtSPHomePage: TComboBox;
    edtSpSignPrivKey: TComboBox;
    edtSpSignPubKey: TComboBox;
    boxFooter: TPanel;
    btnStart: TButton;
    Button1: TButton;
    boxHeader: TPanel;
    Label10: TLabel;
    Label11: TLabel;
    grpIdPPresets: TGroupBox;
    btnIdPFromFile: TButton;
    edtIdPPresets: TComboBox;
    Label12: TLabel;
    edtIdPEncPubKey: TEdit;
    Label9: TLabel;
    grpSPPresets: TGroupBox;
    Label13: TLabel;
    btnSPFromFile: TButton;
    edtSPPresets: TComboBox;
    edtSPAssertionUrl: TComboBox;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    edtSpEncPrivKey: TComboBox;
    edtSpEncPubKey: TComboBox;
    Label17: TLabel;
    edtPort: TEdit;
    procedure btnStartClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edtIdPPresetsChange(Sender: TObject);
    procedure btnIdPFromFileClick(Sender: TObject);
    procedure btnSPFromFileClick(Sender: TObject);
    procedure edtSPPresetsChange(Sender: TObject);
  private
    FHttpServer: TmodHttpServer;
    procedure LoadIdPPresets;
    procedure LoadSPPresets;
    procedure LoadIdPSetting(const AFileName: string);
    procedure LoadSPSetting(const AFileName: string);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  MainForm: TMainForm;

implementation

uses
  System.Types,
  SAML.Core, SAML.XML.Utils;

{$R *.dfm}

procedure TMainForm.btnIdPFromFileClick(Sender: TObject);
begin
  if OpenDialog1.Execute(Handle) then
  begin
    LoadIdPSetting(OpenDialog1.FileName);
  end;
end;

procedure TMainForm.btnSPFromFileClick(Sender: TObject);
begin
  if OpenDialog1.Execute(Handle) then
  begin
    LoadSPSetting(OpenDialog1.FileName);
  end;
end;

procedure TMainForm.btnStartClick(Sender: TObject);
begin
  if edtSSOUrl.Text = '' then
    raise Exception.Create('Choose a IDP');
  FHttpServer.Port := StrToInt(edtPort.Text);
  FHttpServer.Start;
  ShellExecute(Handle, 'open', PChar(FHttpServer.SPConfig.HomeUrl), '', '', SW_NORMAL);
end;

procedure TMainForm.Button1Click(Sender: TObject);
begin
  FHttpServer.Port := StrToInt(edtPort.Text);
  FHttpServer.Start;
end;

constructor TMainForm.Create(AOwner: TComponent);
begin
  inherited;
  FHttpServer := TmodHttpServer.Create(nil);
end;

destructor TMainForm.Destroy;
begin
  FHttpServer.Free;
  inherited;
end;

procedure TMainForm.edtIdPPresetsChange(Sender: TObject);
begin
  LoadIdPSetting(TPath.Combine(ExtractFilePath(Application.ExeName), edtIdPPresets.Text));
end;

procedure TMainForm.edtSPPresetsChange(Sender: TObject);
begin
  LoadSPSetting(TPath.Combine(ExtractFilePath(Application.ExeName), edtSPPresets.Text));
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  pgcConfig.ActivePageIndex := 0;
  LoadIdPPresets;
  LoadSPPresets;
end;

procedure TMainForm.LoadIdPPresets;
var
  LFiles: TStringDynArray;
  LFileName: string;
begin
  edtIdPPresets.Items.Clear;
  LFiles := TDirectory.GetFiles(ExtractFilePath(Application.ExeName), 'idp-*.ini');
  for LFileName in LFiles do
    edtIdPPresets.Items.Add(ExtractFileName(LFileName));
end;

procedure TMainForm.LoadIdPSetting(const AFileName: string);
begin
  FHttpServer.IdPConfig.LoadFromFile(AFileName);
  edtIdPEntityID.Text := FHttpServer.IdPConfig.EntityId;
  edtSSOUrl.Text := FHttpServer.IdPConfig.SSOUrl;
  edtSLOUrl.Text := FHttpServer.IdPConfig.SLOUrl;
  edtIdPSignPubKey.Text := FHttpServer.IdPConfig.SignPubKeyFile;
  edtIdPEncPubKey.Text := FHttpServer.IdPConfig.EncPubKeyFile;
end;

procedure TMainForm.LoadSPPresets;
var
{$if CompilerVersion > 32}
  LFiles: TArray<string>;
{$else}
  LFiles: TStringDynArray;
{$endif}
  LFileName: string;
begin
  edtSPPresets.Items.Clear;
  LFiles := TDirectory.GetFiles(ExtractFilePath(Application.ExeName), 'sp-*.ini');
  for LFileName in LFiles do
    edtSPPresets.Items.Add(ExtractFileName(LFileName));
end;

procedure TMainForm.LoadSPSetting(const AFileName: string);
begin
  FHttpServer.SPConfig.LoadFromFile(AFileName);
  edtSPEntityID.Text := FHttpServer.SPConfig.EntityId;
  edtSPHomePage.Text := FHttpServer.SPConfig.HomeUrl;
  edtSPAssertionUrl.Text := FHttpServer.SPConfig.AssertionUrl;
  edtSpSignPrivKey.Text := FHttpServer.SPConfig.SignPrivKeyFile;
  edtSpSignPubKey.Text := FHttpServer.SPConfig.SignPubKeyFile;
  edtSpEncPrivKey.Text := FHttpServer.SPConfig.EncPrivKeyFile;
  edtSpEncPubKey.Text := FHttpServer.SPConfig.EncPubKeyFile;
end;

initialization

  Randomize;

end.
