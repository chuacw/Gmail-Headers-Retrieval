object formListMailboxes: TformListMailboxes
  Left = 0
  Top = 0
  Caption = 'List Mail Boxes'
  ClientHeight = 427
  ClientWidth = 557
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 386
    Width = 557
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      557
      41)
    object btnListMailboxes: TButton
      Left = 479
      Top = 5
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'List Mailboxes'
      Default = True
      TabOrder = 0
      OnClick = btnListMailboxesClick
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 46
    Width = 557
    Height = 340
    Align = alClient
    Caption = 'Panel2'
    TabOrder = 1
    object lbMailboxes: TListBox
      Left = 1
      Top = 1
      Width = 555
      Height = 338
      Align = alClient
      ItemHeight = 13
      TabOrder = 0
      OnDblClick = lbMailboxesDblClick
    end
  end
  inline frameUserNamePassword1: TframeUserNamePassword
    Left = 0
    Top = 0
    Width = 557
    Height = 46
    Align = alTop
    TabOrder = 2
    ExplicitWidth = 557
    inherited Panel1: TPanel
      Width = 557
      ExplicitWidth = 557
    end
  end
  inline IdIMAP41: TIdIMAP4
    IOHandler = IdSSLIOHandlerSocketOpenSSL1
    Port = 993
    Host = 'imap.gmail.com'
    UseTLS = utUseImplicitTLS
    SASLMechanisms = <>
    MilliSecsToWaitToClearBuffer = 10
    Left = 112
    Top = 192
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
    Left = 120
    Top = 136
  end
  object MainMenu1: TMainMenu
    Left = 456
    Top = 128
    object MailBoxes1: TMenuItem
      Caption = 'Mail Boxes'
      object mnuListMessageHeaders: TMenuItem
        Caption = 'List Message Headers'
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
