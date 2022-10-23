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
unit SAML.Forms.Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, System.IOUtils, System.Generics.Collections,
  SAML.Metadata, Vcl.Grids, Vcl.ValEdit, Vcl.ComCtrls;

type
  TMainForm = class(TForm)
    boxHeader: TPanel;
    Label10: TLabel;
    Label11: TLabel;
    SaveDialog1: TSaveDialog;
    pgcMain: TPageControl;
    tabReader: TTabSheet;
    Panel1: TPanel;
    Label12: TLabel;
    edtMetatadata: TComboBox;
    grdValues: TStringGrid;
    Panel2: TPanel;
    Label1: TLabel;
    edtKeys: TComboBox;
    btnSave: TButton;
    OpenDialog1: TOpenDialog;
    btnOpenFile: TButton;
    tabWriter: TTabSheet;
    Label2: TLabel;
    edtEntityID: TEdit;
    btnNew: TButton;
    btnWriterSave: TButton;
    dlgSaveMetadata: TSaveDialog;
    Label3: TLabel;
    edtLocation: TEdit;
    edtProtocolBinding: TComboBox;
    Label4: TLabel;
    edtCacheDuration: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    edtValidUntil: TEdit;
    Label7: TLabel;
    edtCertificate: TEdit;
    edtCerificateFormat: TComboBox;
    Label8: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure lstValuesKeyPress(Sender: TObject; var Key: Char);
    procedure AddValues(const AKey, AValue: string);
    procedure AddTitle(const ATitle: string);
    procedure grdValuesDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure FormResize(Sender: TObject);
    procedure edtMetatadataChange(Sender: TObject);
    procedure btnOpenFileClick(Sender: TObject);
    procedure btnNewClick(Sender: TObject);
    procedure btnWriterSaveClick(Sender: TObject);
  private
    FMetadata: TSAMLMetadata;
    FNewMetadata: TSAMLMetadata;
    procedure LoadXML;
    procedure ParseXML(const AFileName: string);
    procedure ParseINI(const AFileName: string);
    procedure ShowMetadata(AMetadata: TSAMLMetadata);
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  System.Types,
  SAML.Config, SAML.Core, SAML.XML.Utils;

procedure TMainForm.ShowMetadata(AMetadata: TSAMLMetadata);
var
  LSSOPair: TPair<string, string>;
  LKey: TKeyDescriptor;
  LConsumerService: TPair<string, string>;
  LIndex: Integer;
begin
  edtKeys.Clear;
  grdValues.ColCount := 2;
  grdValues.RowCount := 0;

  AddTitle('General');
  AddValues('EntityID', FMetadata.EntityID);
  if FMetadata.Kind = TMetadataKind.SP then
  begin
    AddValues('AuthnRequestsSigned', BoolToStr(FMetadata.AuthnRequestsSigned, True));
    AddValues('WantAssertionsSigned', BoolToStr(FMetadata.WantAssertionsSigned, True));
  end;

  if FMetadata.SSO.Count > 0 then
  begin
    AddTitle('SSO Service');
    for LSSOPair in FMetadata.SSO do
    begin
      AddValues(LSSOPair.Key, LSSOPair.Value);
    end;
  end;

  if FMetadata.SLO.Count > 0 then
  begin
    AddTitle('SLO Service');
    for LSSOPair in FMetadata.SLO do
    begin
      AddValues(LSSOPair.Key, LSSOPair.Value);
    end;
  end;

  if FMetadata.Keys.Count > 0 then
  begin
    AddTitle('KEYS');
    LIndex := 1;
    for LKey in FMetadata.Keys do
    begin
      AddValues('Key' + LIndex.ToString, LKey.Use);
      Inc(LIndex);
      edtKeys.Items.Add(LKey.Use);
    end;
  end;

  if FMetadata.ConsumerService.Count > 0 then
  begin
    AddTitle('ConsumerService');
    for LConsumerService in FMetadata.ConsumerService do
    begin
      AddValues(LConsumerService.Key, LConsumerService.Value);
    end;
  end;
end;

procedure TMainForm.ParseINI(const AFileName: string);
var
  LSPConfig: TSAMLSPConfig;
  LKeyData: TBytes;
  LKeyFileName: string;
begin
  if Assigned(FMetadata) then
    FMetadata.Free;

  FMetadata := TSAMLMetadata.Create();
  try
    LSPConfig := TSAMLSPConfig.Create;
    try
      LSPConfig.LoadFromFile(AFileName);
      FMetadata.EntityID := LSPConfig.EntityId;
      FMetadata.AuthnRequestsSigned := LSPConfig.SignRequest;
      FMetadata.ConsumerService.Add(TSAML.BINDINGS_HTTP_POST, LSPConfig.AssertionUrl);
      FMetadata.ConsumerService.Add(TSAML.BINDINGS_HTTP_REDIRECT, LSPConfig.AssertionUrl);

      if LSPConfig.SignPubKeyFormat <> TKeyDataFormat.Der then
        raise Exception.Create('The key must be in DER format');
      LKeyFileName := TPath.Combine(ExtractFileDir(AFileName), LSPConfig.SignPubKeyFile);
      LKeyData := TFile.ReadAllBytes(LKeyFileName);
      FMetadata.Keys.Add(TKeyDescriptor.Create('signing', LKeyData));

      if LSPConfig.EncPubKeyFormat <> TKeyDataFormat.Der then
        raise Exception.Create('The key must be in DER format');
      LKeyFileName := TPath.Combine(ExtractFileDir(AFileName), LSPConfig.EncPubKeyFile);
      LKeyData := TFile.ReadAllBytes(LKeyFileName);
      FMetadata.Keys.Add(TKeyDescriptor.Create('encryption', LKeyData));
    finally
      LSPConfig.Free;
    end;
    ShowMetadata(FMetadata);
  except
    FMetadata.Free;
    raise;
  end;
end;

procedure TMainForm.ParseXML(const AFileName: string);
begin
  if Assigned(FMetadata) then
    FMetadata.Free;

  FMetadata := TSAMLMetadata.Create(AFileName);
  try
    ShowMetadata(FMetadata);
  except
    FMetadata.Free;
    raise;
  end;
end;

procedure TMainForm.AddTitle(const ATitle: string);
begin
  AddValues('+' + ATitle, '');
end;

procedure TMainForm.AddValues(const AKey, AValue: string);
var
  LRowIndex: Integer;
begin
  LRowIndex := grdValues.RowCount - 1;
  grdValues.Cells[0, LRowIndex] := AKey;
  grdValues.Cells[1, LRowIndex] := AValue;
  grdValues.RowCount := grdValues.RowCount + 1;
end;

procedure TMainForm.LoadXML;
var
  LFiles: TStringDynArray;
  LFileName: string;
begin
  edtMetatadata.Items.Clear;
  LFiles := TDirectory.GetFiles(ExtractFilePath(Application.ExeName), '*.xml');
  for LFileName in LFiles do
    edtMetatadata.Items.Add(ExtractFileName(LFileName));
end;

procedure TMainForm.lstValuesKeyPress(Sender: TObject; var Key: Char);
begin
  Key := #0;
end;

procedure TMainForm.btnNewClick(Sender: TObject);
begin
  if Assigned(FNewMetadata) then
    FreeAndNil(FNewMetadata);

  FNewMetadata := TSAMLMetadata.Create;
end;

procedure TMainForm.btnOpenFileClick(Sender: TObject);
begin
  if OpenDialog1.Execute(Handle) then
  begin
    if SameText(ExtractFileExt(OpenDialog1.FileName), '.xml') then
      ParseXML(OpenDialog1.FileName)
    else
      ParseINI(OpenDialog1.FileName)
  end;
end;

procedure TMainForm.btnSaveClick(Sender: TObject);
begin
  if edtKeys.ItemIndex >= 0 then
  begin
    SaveDialog1.FileName := edtKeys.Text + '.der';
    if SaveDialog1.Execute(Handle) then
    begin
      TFile.WriteAllBytes(SaveDialog1.FileName, FMetadata.Keys[edtKeys.ItemIndex].Certificate);
    end;
  end;
end;

procedure TMainForm.btnWriterSaveClick(Sender: TObject);
begin
  FNewMetadata.EntityID := edtEntityID.Text;
  FNewMetadata.Location := edtLocation.Text;
  FNewMetadata.ProtocolBinding := edtProtocolBinding.Text;
  FNewMetadata.CacheDuration := edtCacheDuration.Text;
  FNewMetadata.ValidUntil := Now + StrToIntDef(edtValidUntil.Text, 1) * 365;
  FNewMetadata.Keys.Clear;

  if edtCertificate.Text <> '' then
  begin
    if not FileExists(edtCertificate.Text) then
      raise Exception.CreateFmt('File "%s" not found', [edtCertificate.Text]);

    FNewMetadata.Keys.AddCertificate('signing',
      TFileStream.Create(edtCertificate.Text, fmOpenRead),
      TCertificateFormat(edtCerificateFormat.ItemIndex),
      True);
  end;

  if dlgSaveMetadata.Execute(Handle) then
  begin
    TFile.WriteAllText(dlgSaveMetadata.FileName, FNewMetadata.AsXML);
  end;
end;

procedure TMainForm.edtMetatadataChange(Sender: TObject);
begin
  if edtMetatadata.ItemIndex >= 0 then
    ParseXML(edtMetatadata.Text);
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  pgcMain.ActivePageIndex := 0;
  LoadXML;
  FNewMetadata := TSAMLMetadata.Create;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  FMetadata.Free;
  FNewMetadata.Free;
end;

procedure TMainForm.FormResize(Sender: TObject);
const
  ScrollbarAndBorderWidth = 30;
begin
  grdValues.ColCount := 2;
  grdValues.ColWidths[0] := (grdValues.Width - ScrollbarAndBorderWidth) div 2;
  grdValues.ColWidths[1] := (grdValues.Width - ScrollbarAndBorderWidth) div 2;
end;

procedure TMainForm.grdValuesDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
  if grdValues.Cells[0, ARow].StartsWith('+') then
  begin
    grdValues.Canvas.Brush.Color := clBtnFace;
    grdValues.Canvas.FillRect(Rect);
    if ACol = 0 then
      grdValues.Canvas.TextRect(Rect, Rect.Left + 5, Rect.Top + 5, Copy(grdValues.Cells[0, ARow], 2, 100));
  end;
end;

end.
