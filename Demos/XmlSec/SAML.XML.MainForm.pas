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
    procedure btnSignClick(Sender: TObject);
    procedure btnVerifyClick(Sender: TObject);
    procedure btnDecryptClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnInputXMLViewClick(Sender: TObject);
    procedure btnOutputXMLViewClick(Sender: TObject);
    procedure btnEncryptClick(Sender: TObject);
    procedure btnVerifyKeyEmbClick(Sender: TObject);
  private
    procedure FillCombos;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  SAML.XML.Utils;

procedure TMainForm.btnEncryptClick(Sender: TObject);
var
  LXMLDocument: IXMLSecDocument;
  LEncryptionContext: IEncryptionContext;
begin
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
begin
  LXMLDocument := TXMLSecDocument.Create(TFileStream.Create(edtInputXMLName.Text, fmOpenRead), True);
  LXMLDocument.AddIDAttr('ID', 'AuthnRequest', 'urn:oasis:names:tc:SAML:2.0:protocol');

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
begin
  LXMLDocument := TXMLSecDocument.Create(TFileStream.Create(edtInputXMLName.Text, fmOpenRead), True);
  if not LXMLDocument.TryFindNode('Assertion', 'urn:oasis:names:tc:SAML:2.0:assertion', LSignedNode) then
    LSignedNode := LXMLDocument.FindNode('Response', 'urn:oasis:names:tc:SAML:2.0:protocol');

  LXMLDocument.AddIDAttr('ID', LSignedNode.NodeName, LSignedNode.Namespace);

  LSignatureContext := TSignatureContext.Create;
  LSignatureContext.LoadKey(TFileStream.Create(edtPublicKeyName.Text, fmOpenRead), TKeyDataFormat(edtPublicKeyFormat.ItemIndex), True);
  LStatus := LSignatureContext.Verify(LXMLDocument);

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
begin
  LXMLDocument := TXMLSecDocument.Create(TFileStream.Create(edtInputXMLName.Text, fmOpenRead), True);
  if not LXMLDocument.TryFindNode('Assertion', 'urn:oasis:names:tc:SAML:2.0:assertion', LSignedNode) then
    LSignedNode := LXMLDocument.FindNode('Response', 'urn:oasis:names:tc:SAML:2.0:protocol');

  LXMLDocument.AddIDAttr('ID', LSignedNode.NodeName, LSignedNode.Namespace);

  LKeyNode := LXMLDocument.FindNode('X509Certificate', 'http://www.w3.org/2000/09/xmldsig#');
  LKey := TNetEncoding.Base64.DecodeStringToBytes(LKeyNode.Text);

  LSignatureContext := TSignatureContext.Create;
  LSignatureContext.LoadKey(TBytesStream.Create(LKey), TKeyDataFormat.CertDer, True);
  LStatus := LSignatureContext.Verify(LXMLDocument);

  ShowMessage(BoolToStr(LStatus, True));
end;

procedure TMainForm.btnDecryptClick(Sender: TObject);
var
  LXMLDocument: IXMLSecDocument;
  LEncryptionContext: IEncryptionContext;
begin
  LXMLDocument := TXMLSecDocument.Create(TFileStream.Create(edtInputXMLName.Text, fmOpenRead), True);
  LXMLDocument.AddIDAttr('Id', 'EncryptedKey', 'http://www.w3.org/2001/04/xmlenc#');

  LEncryptionContext := TEncryptionContext.Create;
  LEncryptionContext.LoadKey(TFileStream.Create(edtPrivateKeyName.Text, fmOpenRead), TKeyDataFormat(edtPrivateKeyFormat.ItemIndex), True);
  LEncryptionContext.Decrypt(LXMLDocument);

  LXMLDocument.SaveToFile(edtOutputXMLName.Text);
end;

procedure TMainForm.FillCombos;
var
  LFiles: TArray<string>;
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
end;

end.
