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
    ActivePage = tabReader
    Align = alClient
    TabOrder = 1
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
end
