object formGmailSender: TformGmailSender
  Left = 0
  Top = 0
  Caption = 'Gmail Sender'
  ClientHeight = 496
  ClientWidth = 713
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object PanelStatus: TPanel
    Left = 0
    Top = 455
    Width = 713
    Height = 41
    Align = alBottom
    TabOrder = 2
    DesignSize = (
      713
      41)
    object Label1: TLabel
      Left = 46
      Top = 6
      Width = 481
      Height = 27
      AutoSize = False
    end
    object btnConnect: TButton
      Left = 626
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Connect'
      Default = True
      TabOrder = 0
      OnClick = btnConnectClick
    end
    object btnCancel: TButton
      Left = 547
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = 'Cancel'
      Enabled = False
      ModalResult = 2
      TabOrder = 1
      OnClick = btnCancelClick
    end
    object ActivityIndicator1: TActivityIndicator
      Left = 8
      Top = 5
    end
  end
  object PanelListView: TPanel
    Left = 0
    Top = 87
    Width = 713
    Height = 368
    Align = alClient
    Caption = 'ListViewPanel'
    TabOrder = 1
    ExplicitTop = 46
    ExplicitHeight = 409
    object ListView1: TListView
      Left = 1
      Top = 1
      Width = 711
      Height = 366
      Align = alClient
      Columns = <
        item
          Caption = 'Sender'
          Width = 400
        end
        item
          Caption = 'Count'
        end>
      TabOrder = 0
      ViewStyle = vsReport
      ExplicitHeight = 407
    end
  end
  inline frameUserNamePassword1: TframeUserNamePassword
    Left = 0
    Top = 41
    Width = 713
    Height = 46
    Align = alTop
    TabOrder = 0
    ExplicitWidth = 713
    inherited Panel1: TPanel
      Width = 713
      ExplicitWidth = 713
      inherited lblEditUserName: TLabeledEdit
        Left = 77
        EditLabel.ExplicitLeft = 16
        EditLabel.ExplicitTop = 18
        EditLabel.ExplicitWidth = 58
        ExplicitLeft = 77
      end
      inherited cbDomains: TCheckBox
        Visible = True
      end
      inherited UpDown1: TUpDown
        Visible = True
      end
      inherited lblEditThreadCount: TLabeledEdit
        Visible = True
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 713
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 3
    ExplicitLeft = 88
    ExplicitWidth = 185
    object leMailBoxName: TLabeledEdit
      Left = 64
      Top = 14
      Width = 289
      Height = 21
      EditLabel.Width = 43
      EditLabel.Height = 13
      EditLabel.Caption = 'MailBox: '
      LabelPosition = lpLeft
      TabOrder = 0
    end
  end
  inline IdIMAP41: TIdIMAP4
    IOHandler = IdSSLIOHandlerSocketOpenSSL1
    Port = 993
    Host = 'imap.gmail.com'
    UseTLS = utUseImplicitTLS
    SASLMechanisms = <>
    MilliSecsToWaitToClearBuffer = 10
    Left = 352
    Top = 208
  end
  object IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL
    Destination = 'imap.gmail.com:993'
    Host = 'imap.gmail.com'
    MaxLineAction = maException
    Port = 993
    DefaultPort = 0
    SSLOptions.Mode = sslmClient
    SSLOptions.VerifyMode = []
    SSLOptions.VerifyDepth = 0
    Left = 504
    Top = 208
  end
  inline MainMenu1: TMainMenu
    Left = 456
    Top = 128
    object MailBoxes1: TMenuItem
      Caption = 'Mail Boxes'
      object mnuListMailBoxes: TMenuItem
        Caption = 'List Mail Boxes'
        OnClick = mnuListMailBoxesClick
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Caption = 'Exit'
        OnClick = Exit1Click
      end
    end
  end
end
