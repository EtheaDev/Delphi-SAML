object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'Metadata - Demo'
  ClientHeight = 603
  ClientWidth = 801
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  TextHeight = 15
  object boxHeader: TPanel
    Left = 0
    Top = 0
    Width = 801
    Height = 66
    Align = alTop
    BevelOuter = bvNone
    Caption = 'boxHeader'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    ShowCaption = False
    TabOrder = 0
    ExplicitWidth = 797
    object Label10: TLabel
      Left = 15
      Top = 16
      Width = 33
      Height = 33
      Caption = #59607
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -33
      Font.Name = 'Segoe MDL2 Assets'
      Font.Style = []
      ParentFont = False
    end
    object Label11: TLabel
      Left = 77
      Top = 17
      Width = 216
      Height = 37
      Caption = 'Metadata - DEMO'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -27
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
  end
  object pgcMain: TPageControl
    Left = 0
    Top = 66
    Width = 801
    Height = 537
    ActivePage = tabWriter
    Align = alClient
    TabOrder = 1
    ExplicitWidth = 797
    ExplicitHeight = 536
    object tabReader: TTabSheet
      Caption = 'Reader'
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 793
        Height = 63
        Align = alTop
        BevelOuter = bvNone
        Caption = 'Panel1'
        ShowCaption = False
        TabOrder = 0
        object Label12: TLabel
          Left = 16
          Top = 10
          Width = 72
          Height = 15
          Caption = 'Metadata file:'
        end
        object edtMetatadata: TComboBox
          Left = 16
          Top = 31
          Width = 296
          Height = 23
          Style = csDropDownList
          TabOrder = 0
          OnChange = edtMetatadataChange
          Items.Strings = (
            'Unknown = 0'
            'Binary = 1'
            'Pem = 2'
            'Der = 3'
            'Pkcs8Pem = 4'
            'Pkcs8Der = 5'
            'Pkcs12 = 6'
            'CertPem = 7'
            'CertDer = 8')
        end
        object btnOpenFile: TButton
          Left = 318
          Top = 30
          Width = 91
          Height = 25
          Caption = 'Open file...'
          TabOrder = 1
          OnClick = btnOpenFileClick
        end
      end
      object grdValues: TStringGrid
        Left = 0
        Top = 63
        Width = 793
        Height = 371
        Align = alClient
        FixedCols = 0
        FixedRows = 0
        TabOrder = 1
        OnDrawCell = grdValuesDrawCell
        OnKeyPress = lstValuesKeyPress
      end
      object Panel2: TPanel
        Left = 0
        Top = 434
        Width = 793
        Height = 73
        Align = alBottom
        BevelOuter = bvNone
        Caption = 'Panel2'
        ShowCaption = False
        TabOrder = 2
        object Label1: TLabel
          Left = 16
          Top = 18
          Width = 27
          Height = 15
          Caption = 'Keys:'
        end
        object edtKeys: TComboBox
          Left = 16
          Top = 39
          Width = 425
          Height = 23
          Style = csDropDownList
          TabOrder = 0
          Items.Strings = (
            'Unknown = 0'
            'Binary = 1'
            'Pem = 2'
            'Der = 3'
            'Pkcs8Pem = 4'
            'Pkcs8Der = 5'
            'Pkcs12 = 6'
            'CertPem = 7'
            'CertDer = 8')
        end
        object btnSave: TButton
          Left = 454
          Top = 39
          Width = 99
          Height = 25
          Caption = 'Save key to file...'
          TabOrder = 1
          OnClick = btnSaveClick
        end
      end
    end
    object tabWriter: TTabSheet
      Caption = 'Writer'
      ImageIndex = 1
      object Label9: TLabel
        Left = 24
        Top = 18
        Width = 72
        Height = 15
        Caption = 'Metadata file:'
      end
      object btnNew: TButton
        Left = 544
        Top = 91
        Width = 105
        Height = 25
        Caption = 'New'
        TabOrder = 0
        OnClick = btnNewClick
      end
      object btnWriterSave: TButton
        Left = 544
        Top = 122
        Width = 105
        Height = 37
        Caption = 'Save'
        TabOrder = 1
        OnClick = btnWriterSaveClick
      end
      object cmbIniFiles: TComboBox
        Left = 24
        Top = 39
        Width = 296
        Height = 23
        Style = csDropDownList
        TabOrder = 2
        OnChange = cmbIniFilesChange
      end
      object btnIniFile: TButton
        Left = 326
        Top = 38
        Width = 91
        Height = 25
        Caption = 'Open file...'
        TabOrder = 3
      end
      object GroupBox1: TGroupBox
        Left = 24
        Top = 82
        Width = 497
        Height = 319
        Caption = 'Metadata'
        TabOrder = 4
        object Label2: TLabel
          Left = 62
          Top = 32
          Width = 44
          Height = 15
          Alignment = taRightJustify
          Caption = 'EntityID:'
        end
        object Label3: TLabel
          Left = 57
          Top = 72
          Width = 49
          Height = 15
          Alignment = taRightJustify
          Caption = 'Location:'
        end
        object Label4: TLabel
          Left = 14
          Top = 115
          Width = 92
          Height = 15
          Alignment = taRightJustify
          Caption = 'Protocol binding:'
        end
        object Label5: TLabel
          Left = 23
          Top = 152
          Width = 84
          Height = 15
          Alignment = taRightJustify
          Caption = 'Cache duration:'
        end
        object Label6: TLabel
          Left = 17
          Top = 188
          Width = 90
          Height = 15
          Alignment = taRightJustify
          Caption = 'Valid unit (years):'
        end
        object Label7: TLabel
          Left = 50
          Top = 228
          Width = 57
          Height = 15
          Alignment = taRightJustify
          Caption = 'Certificate:'
        end
        object Label8: TLabel
          Left = 66
          Top = 267
          Width = 41
          Height = 15
          Alignment = taRightJustify
          Caption = 'Format:'
        end
        object edtEntityID: TEdit
          Left = 112
          Top = 29
          Width = 353
          Height = 23
          TabOrder = 0
        end
        object edtLocation: TEdit
          Left = 112
          Top = 69
          Width = 353
          Height = 23
          TabOrder = 1
        end
        object edtProtocolBinding: TComboBox
          Left = 112
          Top = 112
          Width = 353
          Height = 23
          TabOrder = 2
          Items.Strings = (
            'urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST'
            'urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect')
        end
        object edtCacheDuration: TEdit
          Left = 113
          Top = 149
          Width = 352
          Height = 23
          TabOrder = 3
          Text = 'PT604800S'
        end
        object edtValidUntil: TEdit
          Left = 113
          Top = 185
          Width = 352
          Height = 23
          TabOrder = 4
          Text = '10'
        end
        object edtCertificate: TEdit
          Left = 113
          Top = 225
          Width = 352
          Height = 23
          TabOrder = 5
        end
        object edtCerificateFormat: TComboBox
          Left = 113
          Top = 264
          Width = 353
          Height = 23
          Style = csDropDownList
          ItemIndex = 0
          TabOrder = 6
          Text = 'DER'
          Items.Strings = (
            'DER'
            'PEM')
        end
      end
    end
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'der'
    Filter = 'DER file (*.der)|*.der'
    Left = 376
    Top = 152
  end
  object OpenDialog1: TOpenDialog
    Filter = 
      'XML Files (*.xml)|*.xml|SP ini files (*.ini)|*.ini|All files (*.' +
      '*)|*.*'
    Left = 316
    Top = 292
  end
  object dlgSaveMetadata: TSaveDialog
    DefaultExt = 'xml'
    Filter = 'XML File (*.xml)|*.xml'
    Title = 'Save Metadata'
    Left = 524
    Top = 236
  end
end
