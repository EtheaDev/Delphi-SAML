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
unit SAML.XML.MainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, ZLib, System.IOUtils,
  Vcl.ExtCtrls, System.NetEncoding;

type
  TMainForm = class(TForm)
    memInput: TMemo;
    edtInputXMLName: TComboBox;
    edtPublicKeyName: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    edtPrivateKeyName: TComboBox;
    memOutput: TMemo;
    Label5: TLabel;
    edtPrivateKeyFormat: TComboBox;
    Label6: TLabel;
    edtPublicKeyFormat: TComboBox;
    edtOutputXMLName: TComboBox;
    btnInputXMLView: TButton;
    btnOutputXMLView: TButton;
    boxFooter: TPanel;
    btnSign: TButton;
    btnVerify: TButton;
    btnEncrypt: TButton;
    btnDecrypt: TButton;
    boxHeader: TPanel;
    Label10: TLabel;
    Label11: TLabel;
    btnVerifyKeyEmb: TButton;
    Label7: TLabel;
    cmbRoot: TComboBox;
    memLog: TMemo;
    procedure btnSignClick(Sender: TObject);
    procedure btnVerifyClick(Sender: TObject);
    procedure btnDecryptClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnInputXMLViewClick(Sender: TObject);
    procedure btnOutputXMLViewClick(Sender: TObject);
    procedure btnEncryptClick(Sender: TObject);
    procedure btnVerifyKeyEmbClick(Sender: TObject);
    procedure edtInputXMLNameChange(Sender: TObject);
  private
    procedure Log(const AMessage: string);
    procedure ClearLog;
    procedure FillCombos;
    procedure FindRootNode(const AFileName: string);
  public
    { Public declarations }
  end;

  TNodeInfo = record
    Namespace: string;
    TagName: string;
    class operator Implicit(const AValue: string): TNodeInfo;
    class operator Implicit(const AValue: TNodeInfo): string;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  System.Types,
  SAML.XML.Utils;

procedure TMainForm.btnEncryptClick(Sender: TObject);
var
  LXMLDocument: IXMLSecDocument;
  LEncryptionContext: IEncryptionContext;
begin
  ClearLog;

  LXMLDocument := TXMLSecDocument.Create(TFileStream.Create(edtInputXMLName.Text, fmOpenRead), True);

  LEncryptionContext := TEncryptionContext.Create;
  //LEncryptionContext.LoadKey(TFileStream.Create(edtPublicKeyName.Text, fmOpenRead), TKeyDataFormat(edtPublicKeyFormat.ItemIndex), True);
  LEncryptionContext.Encrypt(LXMLDocument);

  LXMLDocument.SaveToFile(edtOutputXMLName.Text);
end;

procedure TMainForm.btnInputXMLViewClick(Sender: TObject);
begin
  memInput.Text := TFile.ReadAllText(edtInputXMLName.Text);
end;

procedure TMainForm.btnOutputXMLViewClick(Sender: TObject);
begin
  memOutput.Text := TFile.ReadAllText(edtOutputXMLName.Text);
end;

procedure TMainForm.btnSignClick(Sender: TObject);
var
  LXMLDocument: IXMLSecDocument;
  LSignatureContext: ISignatureContext;
  LNodeInfo: TNodeInfo;
begin
  ClearLog;

  LNodeInfo := cmbRoot.Text;

  LXMLDocument := TXMLSecDocument.Create(TFileStream.Create(edtInputXMLName.Text, fmOpenRead), True);
  LXMLDocument.CheckSignatureTemplate('', []);

  LXMLDocument.AddIDAttr('ID', LNodeInfo.TagName, LNodeInfo.Namespace);

  LSignatureContext := TSignatureContext.Create;
  LSignatureContext.LoadKey(TFileStream.Create(edtPrivateKeyName.Text, fmOpenRead), TKeyDataFormat(edtPrivateKeyFormat.ItemIndex), True);
  LSignatureContext.Sign(LXMLDocument);

  memOutput.Text := LXMLDocument.ToXML;
  LXMLDocument.SaveToFile(edtOutputXMLName.Text);
end;

procedure TMainForm.btnVerifyClick(Sender: TObject);
var
  LXMLDocument: IXMLSecDocument;
  LSignatureContext: ISignatureContext;
  LStatus: Boolean;
  LSignedNode: IXMLSecNode;
  LNodeInfo: TNodeInfo;
begin
  ClearLog;

  LNodeInfo := cmbRoot.Text;

  LXMLDocument := TXMLSecDocument.Create(TFileStream.Create(edtInputXMLName.Text, fmOpenRead), True);
  LSignedNode := LXMLDocument.FindNode(LNodeInfo.TagName, LNodeInfo.Namespace);

  LXMLDocument.AddIDAttr('ID', LNodeInfo.TagName, LNodeInfo.Namespace);

  LSignatureContext := TSignatureContext.Create;
  LSignatureContext.LoadKey(TFileStream.Create(edtPublicKeyName.Text, fmOpenRead), TKeyDataFormat(edtPublicKeyFormat.ItemIndex), True);
  LStatus := LSignatureContext.Verify(LSignedNode);

  ShowMessage(BoolToStr(LStatus, True));
end;

procedure TMainForm.btnVerifyKeyEmbClick(Sender: TObject);
var
  LXMLDocument: IXMLSecDocument;
  LSignatureContext: ISignatureContext;
  LStatus: Boolean;
  LSignedNode: IXMLSecNode;
  LKeyNode: IXMLSecNode;
  LKey: TBytes;
  LNodeInfo: TNodeInfo;
begin
  ClearLog;

  LNodeInfo := cmbRoot.Text;

  LXMLDocument := TXMLSecDocument.Create(TFileStream.Create(edtInputXMLName.Text, fmOpenRead), True);
  LSignedNode := LXMLDocument.FindNode(LNodeInfo.TagName, LNodeInfo.Namespace);

  LXMLDocument.AddIDAttr('ID', LNodeInfo.TagName, LNodeInfo.Namespace);

  LKeyNode := LXMLDocument.FindNode('X509Certificate', 'http://www.w3.org/2000/09/xmldsig#');
  LKey := TNetEncoding.Base64.DecodeStringToBytes(LKeyNode.Text);

  LSignatureContext := TSignatureContext.Create;
  LSignatureContext.LoadKey(TBytesStream.Create(LKey), TKeyDataFormat.CertDer, True);
  LStatus := LSignatureContext.Verify(LSignedNode);

  ShowMessage(BoolToStr(LStatus, True));
end;

procedure TMainForm.ClearLog;
begin
  memLog.Clear;
end;

procedure TMainForm.FindRootNode(const AFileName: string);
var
  LXMLDocument: IXMLSecDocument;
  LRootNode: IXMLSecNode;
begin
  LXMLDocument := TXMLSecDocument.Create(TFileStream.Create(edtInputXMLName.Text, fmOpenRead), True);
  LRootNode := LXMLDocument.Root;
  cmbRoot.Text := LRootNode.Namespace + ':' + LRootNode.NodeName;
end;

procedure TMainForm.edtInputXMLNameChange(Sender: TObject);
begin
  if FileExists(edtInputXMLName.Text) then
    FindRootNode(edtInputXMLName.Text);
end;

procedure TMainForm.btnDecryptClick(Sender: TObject);
var
  LXMLDocument: IXMLSecDocument;
  LEncryptionContext: IEncryptionContext;
begin
  ClearLog;

  LXMLDocument := TXMLSecDocument.Create(TFileStream.Create(edtInputXMLName.Text, fmOpenRead), True);
  LXMLDocument.AddIDAttr('Id', 'EncryptedKey', 'http://www.w3.org/2001/04/xmlenc#');

  LEncryptionContext := TEncryptionContext.Create;
  LEncryptionContext.LoadKey(TFileStream.Create(edtPrivateKeyName.Text, fmOpenRead), TKeyDataFormat(edtPrivateKeyFormat.ItemIndex), True);
  LEncryptionContext.Decrypt(LXMLDocument);

  LXMLDocument.SaveToFile(edtOutputXMLName.Text);
end;

procedure TMainForm.FillCombos;
var
  LFiles: TStringDynArray;
  LFileName: string;
begin
  LFiles := TDirectory.GetFiles(ExtractFilePath(Application.ExeName), '*.xml');
  for LFileName in LFiles do
  begin
    edtInputXMLName.Items.Add(ExtractFileName(LFileName));
    edtOutputXMLName.Items.Add(ExtractFileName(LFileName));
  end;

  LFiles := TDirectory.GetFiles(ExtractFilePath(Application.ExeName), '*.pem');
  for LFileName in LFiles do
  begin
    edtPublicKeyName.Items.Add(ExtractFileName(LFileName));
    edtPrivateKeyName.Items.Add(ExtractFileName(LFileName));
  end;
  LFiles := TDirectory.GetFiles(ExtractFilePath(Application.ExeName), '*.der');
  for LFileName in LFiles do
  begin
    edtPublicKeyName.Items.Add(ExtractFileName(LFileName));
    edtPrivateKeyName.Items.Add(ExtractFileName(LFileName));
  end;
  LFiles := TDirectory.GetFiles(ExtractFilePath(Application.ExeName), '*.crt');
  for LFileName in LFiles do
  begin
    edtPublicKeyName.Items.Add(ExtractFileName(LFileName));
    edtPrivateKeyName.Items.Add(ExtractFileName(LFileName));
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  edtPrivateKeyFormat.ItemIndex := 0;
  edtPublicKeyFormat.ItemIndex := 0;
  FillCombos;

  edtPrivateKeyFormat.ItemIndex := 2;
  edtPublicKeyFormat.ItemIndex := 7;

  TXMLSec.RegisterErrorCallback(
    procedure (const ASecError: TXMLSecError)
    begin
      MainForm.Log(ASecError.ErrorMessage);
    end
  );
end;

procedure TMainForm.Log(const AMessage: string);
begin
  memLog.Lines.Add(AMessage);
end;

{ TNodeInfo }

class operator TNodeInfo.Implicit(const AValue: TNodeInfo): string;
begin
  Result := AValue.Namespace + ':' + AValue.TagName;
end;

class operator TNodeInfo.Implicit(const AValue: string): TNodeInfo;
var
  LIndex: Integer;
begin
  LIndex := AValue.LastIndexOf(':');
  if LIndex >= 0 then
  begin
    Result.Namespace := AValue.Substring(0, LIndex);
    Result.TagName := AValue.Substring(LIndex + 1);
  end
  else
  begin
    Result.Namespace := '';
    Result.TagName := AValue;
  end;
end;

end.
