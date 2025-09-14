object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'SAML - ServiceProvider'
  ClientHeight = 736
  ClientWidth = 455
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  StyleElements = [seClient, seBorder]
  OnCreate = FormCreate
  TextHeight = 17
  object pgcConfig: TPageControl
    AlignWithMargins = True
    Left = 3
    Top = 69
    Width = 449
    Height = 604
    ActivePage = tabIdP
    Align = alClient
    TabOrder = 0
    object tabIdP: TTabSheet
      Caption = 'Identity Provider'
      object grpIdPSettings: TGroupBox
        AlignWithMargins = True
        Left = 3
        Top = 93
        Width = 435
        Height = 364
        Align = alTop
        Caption = 'IdP settings'
        TabOrder = 1
        object Label1: TLabel
          Left = 24
          Top = 71
          Width = 48
          Height = 17
          Caption = 'SSO Url:'
        end
        object Label4: TLabel
          Left = 24
          Top = 119
          Width = 47
          Height = 17
          Caption = 'SLO Url:'
        end
        object Label5: TLabel
          Left = 24
          Top = 21
          Width = 47
          Height = 17
          Caption = 'Entity ID'
        end
        object Label6: TLabel
          Left = 24
          Top = 167
          Width = 75
          Height = 17
          Caption = 'Sign PubKey:'
        end
        object Label9: TLabel
          Left = 24
          Top = 225
          Width = 70
          Height = 17
          Caption = 'Enc PubKey:'
        end
        object edtSSOUrl: TEdit
          Left = 24
          Top = 92
          Width = 321
          Height = 25
          TabOrder = 1
        end
        object edtSLOUrl: TEdit
          Left = 24
          Top = 140
          Width = 321
          Height = 25
          TabOrder = 2
        end
        object edtIdPEntityID: TEdit
          Left = 24
          Top = 42
          Width = 321
          Height = 25
          TabOrder = 0
        end
        object edtIdPSignPubKey: TEdit
          Left = 24
          Top = 190
          Width = 321
          Height = 25
          TabOrder = 3
        end
        object edtIdPEncPubKey: TEdit
          Left = 24
          Top = 248
          Width = 321
          Height = 25
          TabOrder = 4
        end
        object chkWantAuthnRequestsSigned: TCheckBox
          Left = 24
          Top = 279
          Width = 296
          Height = 17
          Caption = 'WantAuthnRequestsSigned'
          TabOrder = 5
        end
      end
      object grpIdPPresets: TGroupBox
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 435
        Height = 84
        Align = alTop
        Caption = 'Presets'
        TabOrder = 0
        object Label12: TLabel
          Left = 24
          Top = 26
          Width = 60
          Height = 17
          Caption = 'Preset file:'
        end
        object btnIdPFromFile: TButton
          Left = 326
          Top = 48
          Width = 19
          Height = 27
          Caption = '...'
          TabOrder = 1
          OnClick = btnIdPFromFileClick
        end
        object edtIdPPresets: TComboBox
          Left = 24
          Top = 49
          Width = 296
          Height = 25
          Style = csDropDownList
          TabOrder = 0
          OnChange = edtIdPPresetsChange
        end
      end
    end
    object tabServiceProvider: TTabSheet
      Caption = 'Service Provider'
      ImageIndex = 1
      object GroupBox2: TGroupBox
        AlignWithMargins = True
        Left = 3
        Top = 93
        Width = 435
        Height = 460
        Align = alTop
        Caption = 'Service provider'
        TabOrder = 0
        object Label2: TLabel
          Left = 16
          Top = 25
          Width = 47
          Height = 17
          Caption = 'Entity ID'
        end
        object Label3: TLabel
          Left = 16
          Top = 77
          Width = 72
          Height = 17
          Caption = 'Home page:'
        end
        object Label7: TLabel
          Left = 16
          Top = 184
          Width = 74
          Height = 17
          Caption = 'Sign PrivKey:'
        end
        object Label8: TLabel
          Left = 16
          Top = 232
          Width = 75
          Height = 17
          Caption = 'Sign PubKey:'
        end
        object Label14: TLabel
          Left = 16
          Top = 132
          Width = 91
          Height = 17
          Caption = 'Assertion page:'
        end
        object Label15: TLabel
          Left = 16
          Top = 286
          Width = 69
          Height = 17
          Caption = 'Enc PrivKey:'
        end
        object Label16: TLabel
          Left = 16
          Top = 334
          Width = 66
          Height = 17
          Caption = 'Enc PutKey:'
        end
        object Label18: TLabel
          Left = 16
          Top = 387
          Width = 80
          Height = 17
          Caption = 'AuthnContext:'
        end
        object edtSPEntityID: TEdit
          Left = 16
          Top = 46
          Width = 321
          Height = 25
          TabOrder = 0
          OnChange = edtSPEntityIDChange
        end
        object edtSPHomePage: TEdit
          Left = 16
          Top = 99
          Width = 321
          Height = 25
          TabOrder = 1
          OnChange = edtSPHomePageChange
        end
        object edtSpSignPrivKey: TComboBox
          Left = 16
          Top = 205
          Width = 321
          Height = 25
          TabOrder = 2
          OnChange = edtSpSignPrivKeyChange
        end
        object edtSpSignPubKey: TComboBox
          Left = 16
          Top = 255
          Width = 321
          Height = 25
          TabOrder = 3
          OnChange = edtSpSignPubKeyChange
        end
        object edtSPAssertionUrl: TEdit
          Left = 16
          Top = 155
          Width = 321
          Height = 25
          TabOrder = 4
          OnChange = edtSPAssertionUrlChange
        end
        object edtSpEncPrivKey: TComboBox
          Left = 16
          Top = 303
          Width = 321
          Height = 25
          TabOrder = 5
          OnChange = edtSpEncPrivKeyChange
        end
        object edtSpEncPubKey: TComboBox
          Left = 16
          Top = 355
          Width = 321
          Height = 25
          TabOrder = 6
          OnChange = edtSpEncPubKeyChange
        end
        object cmbAuthContext: TComboBox
          Left = 16
          Top = 410
          Width = 321
          Height = 25
          TabOrder = 7
          OnChange = cmbAuthContextChange
          Items.Strings = (
            
              'urn:oasis:names:tc:SAML:2.0:ac:classes:PasswordProtectedTranspor' +
              't'
            'https://www.spid.gov.it/SpidL1'
            'https://www.spid.gov.it/SpidL2'
            'https://www.spid.gov.it/SpidL3')
        end
      end
      object grpSPPresets: TGroupBox
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 435
        Height = 84
        Align = alTop
        Caption = 'Presets'
        TabOrder = 1
        object Label13: TLabel
          Left = 24
          Top = 26
          Width = 60
          Height = 17
          Caption = 'Preset file:'
        end
        object btnSPFromFile: TButton
          Left = 326
          Top = 48
          Width = 19
          Height = 27
          Caption = '...'
          TabOrder = 1
          OnClick = btnSPFromFileClick
        end
        object edtSPPresets: TComboBox
          Left = 24
          Top = 49
          Width = 296
          Height = 25
          Style = csDropDownList
          TabOrder = 0
          OnChange = edtSPPresetsChange
        end
      end
    end
    object TabLog: TTabSheet
      Caption = 'TabLog'
      ImageIndex = 2
      object MemoLog: TMemo
        Left = 0
        Top = 0
        Width = 441
        Height = 572
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Consolas'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssBoth
        TabOrder = 0
        WordWrap = False
      end
    end
  end
  object boxFooter: TPanel
    Left = 0
    Top = 676
    Width = 455
    Height = 60
    Align = alBottom
    BevelOuter = bvNone
    Caption = 'boxFooter'
    ShowCaption = False
    TabOrder = 1
    object Label17: TLabel
      Left = 15
      Top = 3
      Width = 27
      Height = 17
      Caption = 'Port:'
    end
    object btnStart: TButton
      Left = 92
      Top = 3
      Width = 258
      Height = 46
      Caption = 'Open browser'
      TabOrder = 0
      OnClick = btnStartClick
    end
    object Button1: TButton
      Left = 356
      Top = 3
      Width = 89
      Height = 46
      Caption = 'Start server'
      TabOrder = 1
      OnClick = Button1Click
    end
    object edtPort: TEdit
      Left = 15
      Top = 24
      Width = 71
      Height = 25
      NumbersOnly = True
      TabOrder = 2
      Text = '4567'
    end
  end
  object boxHeader: TPanel
    Left = 0
    Top = 0
    Width = 455
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
    TabOrder = 2
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
      Top = 12
      Width = 170
      Height = 37
      Caption = 'SAML - DEMO'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -27
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
  end
  object OpenDialog1: TOpenDialog
    Left = 216
    Top = 208
  end
end
