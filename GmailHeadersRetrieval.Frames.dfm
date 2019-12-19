object frameUserNamePassword: TframeUserNamePassword
  Left = 0
  Top = 0
  Width = 806
  Height = 46
  Align = alTop
  TabOrder = 0
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 806
    Height = 46
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    inline lblEditPassword: TLabeledEdit
      Left = 256
      Top = 14
      Width = 121
      Height = 21
      EditLabel.Width = 46
      EditLabel.Height = 13
      EditLabel.Caption = 'Password'
      LabelPosition = lpLeft
      PasswordChar = '*'
      TabOrder = 1
    end
    inline lblEditUserName: TLabeledEdit
      Left = 72
      Top = 14
      Width = 121
      Height = 21
      EditLabel.Width = 58
      EditLabel.Height = 13
      EditLabel.Caption = 'User name: '
      LabelPosition = lpLeft
      TabOrder = 0
    end
    object cbDomains: TCheckBox
      Left = 540
      Top = 17
      Width = 97
      Height = 17
      Caption = 'Domains Only'
      TabOrder = 4
      Visible = False
    end
    object UpDown1: TUpDown
      Left = 495
      Top = 14
      Width = 17
      Height = 21
      TabOrder = 3
      Visible = False
    end
    inline lblEditThreadCount: TLabeledEdit
      Left = 454
      Top = 14
      Width = 42
      Height = 21
      EditLabel.Width = 46
      EditLabel.Height = 13
      EditLabel.Caption = 'Threads: '
      LabelPosition = lpLeft
      TabOrder = 2
      Text = '6'
      Visible = False
    end
  end
end
