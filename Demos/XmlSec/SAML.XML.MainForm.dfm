object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'XmlSec DEMO'
  ClientHeight = 647
  ClientWidth = 953
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 17
  object Label1: TLabel
    Left = 8
    Top = 79
    Width = 62
    Height = 17
    Caption = 'Input XML:'
  end
  object Label2: TLabel
    Left = 8
    Top = 456
    Width = 63
    Height = 17
    Caption = 'public Key:'
  end
  object Label3: TLabel
    Left = 488
    Top = 82
    Width = 73
    Height = 17
    Caption = 'Output XML:'
  end
  object Label4: TLabel
    Left = 8
    Top = 359
    Width = 67
    Height = 17
    Caption = 'Private Key:'
  end
  object Label5: TLabel
    Left = 8
    Top = 412
    Width = 44
    Height = 17
    Caption = 'Format:'
  end
  object Label6: TLabel
    Left = 8
    Top = 506
    Width = 44
    Height = 17
    Caption = 'Format:'
  end
  object Label7: TLabel
    Left = 8
    Top = 551
    Width = 147
    Height = 17
    Caption = 'Root node (ns:tagName):'
  end
  object memInput: TMemo
    Left = 8
    Top = 130
    Width = 450
    Height = 225
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    Lines.Strings = (
      'Memo1')
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 0
    WordWrap = False
  end
  object edtInputXMLName: TComboBox
    Left = 8
    Top = 99
    Width = 361
    Height = 25
    TabOrder = 1
    OnChange = edtInputXMLNameChange
  end
  object edtPublicKeyName: TComboBox
    Left = 8
    Top = 477
    Width = 450
    Height = 25
    TabOrder = 2
  end
  object edtPrivateKeyName: TComboBox
    Left = 8
    Top = 381
    Width = 450
    Height = 25
    TabOrder = 3
  end
  object memOutput: TMemo
    Left = 488
    Top = 128
    Width = 450
    Height = 227
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    Lines.Strings = (
      'Memo1')
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 4
    WordWrap = False
  end
  object edtPrivateKeyFormat: TComboBox
    Left = 8
    Top = 431
    Width = 450
    Height = 25
    Style = csDropDownList
    TabOrder = 6
    Items.Strings = (
      ' Unknown = 0'
      'Binary = 1'
      'Pem = 2'
      'Der = 3'
      'Pkcs8Pem = 4'
      'Pkcs8Der = 5'
      'Pkcs12 = 6'
      'CertPem = 7'
      'CertDer = 8')
  end
  object edtPublicKeyFormat: TComboBox
    Left = 8
    Top = 527
    Width = 450
    Height = 25
    Style = csDropDownList
    TabOrder = 5
    Items.Strings = (
      ' Unknown = 0'
      'Binary = 1'
      'Pem = 2'
      'Der = 3'
      'Pkcs8Pem = 4'
      'Pkcs8Der = 5'
      'Pkcs12 = 6'
      'CertPem = 7'
      'CertDer = 8')
  end
  object edtOutputXMLName: TComboBox
    Left = 488
    Top = 99
    Width = 360
    Height = 25
    TabOrder = 7
  end
  object btnInputXMLView: TButton
    Left = 382
    Top = 97
    Width = 75
    Height = 25
    Caption = 'View'
    TabOrder = 8
    OnClick = btnInputXMLViewClick
  end
  object btnOutputXMLView: TButton
    Left = 863
    Top = 97
    Width = 75
    Height = 25
    Caption = 'View'
    TabOrder = 9
    OnClick = btnOutputXMLViewClick
  end
  object boxFooter: TPanel
    Left = 0
    Top = 602
    Width = 953
    Height = 45
    Align = alBottom
    BevelOuter = bvNone
    Caption = 'boxFooter'
    ShowCaption = False
    TabOrder = 10
    object btnSign: TButton
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 113
      Height = 39
      Align = alLeft
      Caption = 'Sign request'
      TabOrder = 0
      OnClick = btnSignClick
    end
    object btnVerify: TButton
      AlignWithMargins = True
      Left = 122
      Top = 3
      Width = 175
      Height = 39
      Align = alLeft
      Caption = 'Verify response with key'
      TabOrder = 1
      OnClick = btnVerifyClick
    end
    object btnEncrypt: TButton
      AlignWithMargins = True
      Left = 501
      Top = 3
      Width = 113
      Height = 39
      Margins.Left = 20
      Align = alLeft
      Caption = 'Encrypt'
      TabOrder = 2
      OnClick = btnEncryptClick
    end
    object btnDecrypt: TButton
      AlignWithMargins = True
      Left = 620
      Top = 3
      Width = 113
      Height = 39
      Align = alLeft
      Caption = 'Decrypt'
      TabOrder = 3
      OnClick = btnDecryptClick
    end
    object btnVerifyKeyEmb: TButton
      AlignWithMargins = True
      Left = 303
      Top = 3
      Width = 175
      Height = 39
      Align = alLeft
      Caption = 'Verify response without key'
      TabOrder = 4
      OnClick = btnVerifyKeyEmbClick
    end
  end
  object boxHeader: TPanel
    Left = 0
    Top = 0
    Width = 953
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
    TabOrder = 11
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
      Width = 200
      Height = 37
      Caption = 'XMLSEC - DEMO'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -27
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
  end
  object cmbRoot: TComboBox
    Left = 8
    Top = 571
    Width = 450
    Height = 25
    TabOrder = 12
    Text = 'urn:oasis:names:tc:SAML:2.0:protocol:AuthnRequest'
    Items.Strings = (
      'urn:oasis:names:tc:SAML:2.0:protocol:AuthnRequest'
      'urn:oasis:names:tc:SAML:2.0:metadata:EntityDescriptor'
      'urn:oasis:names:tc:SAML:2.0:protocol:Response'
      'urn:oasis:names:tc:SAML:2.0:assertion:Assertion')
  end
  object memLog: TMemo
    Left = 495
    Top = 381
    Width = 450
    Height = 215
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 13
    WordWrap = False
  end
  object chkAddSignatureTemplate: TCheckBox
    Left = 256
    Top = 360
    Width = 201
    Height = 17
    Caption = 'Add signature template'
    Checked = True
    State = cbChecked
    TabOrder = 14
  end
  object chkAddEncryptionTemplate: TCheckBox
    Left = 256
    Top = 458
    Width = 201
    Height = 17
    Caption = 'Add encryption template'
    Checked = True
    State = cbChecked
    TabOrder = 15
  end
end
