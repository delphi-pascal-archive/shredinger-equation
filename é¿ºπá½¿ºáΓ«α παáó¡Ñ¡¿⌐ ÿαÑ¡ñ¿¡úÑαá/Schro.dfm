object Form1: TForm1
  Left = 225
  Top = 127
  Width = 1064
  Height = 768
  Caption = #1042#1080#1079#1091#1072#1083#1080#1079#1072#1090#1086#1088' '#1091#1088#1072#1074#1085#1077#1085#1080#1081' '#1064#1088#1077#1085#1076#1080#1085#1075#1077#1088#1072
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 17
  object Image1: TImage
    Left = 568
    Top = 31
    Width = 457
    Height = 393
  end
  object Image2: TImage
    Left = 10
    Top = 34
    Width = 458
    Height = 392
  end
  object Label8: TLabel
    Left = 324
    Top = 9
    Width = 8
    Height = 17
    Caption = '0'
  end
  object Label9: TLabel
    Left = 531
    Top = 602
    Width = 197
    Height = 17
    Caption = 'Energies propres du systeme (J)'
  end
  object Label10: TLabel
    Left = 157
    Top = 9
    Width = 102
    Height = 17
    Caption = 'Energies propres'
  end
  object Label11: TLabel
    Left = 743
    Top = 7
    Width = 82
    Height = 17
    Caption = 'Etats propres'
  end
  object Image3: TImage
    Left = 511
    Top = 460
    Width = 233
    Height = 134
  end
  object Label13: TLabel
    Left = 568
    Top = 435
    Width = 108
    Height = 17
    Caption = 'Allure du potentiel'
  end
  object GroupBox2: TGroupBox
    Left = 778
    Top = 442
    Width = 247
    Height = 284
    Caption = 'Afficher les etats propres'
    TabOrder = 3
    object Label6: TLabel
      Left = 21
      Top = 31
      Width = 83
      Height = 17
      Caption = 'A partir du n'#176
    end
    object Label7: TLabel
      Left = 21
      Top = 73
      Width = 73
      Height = 17
      Caption = 'Jusqu'#39'au n'#176
    end
    object Edit6: TEdit
      Left = 126
      Top = 31
      Width = 64
      Height = 25
      TabOrder = 0
      Text = '1'
    end
    object Edit7: TEdit
      Left = 124
      Top = 67
      Width = 66
      Height = 25
      TabOrder = 1
      Text = '3'
    end
    object Button2: TButton
      Left = 4
      Top = 156
      Width = 239
      Height = 32
      Caption = 'Afficher les etats propres'
      TabOrder = 2
      OnClick = Button2Click
    end
    object CheckBox1: TCheckBox
      Left = 21
      Top = 126
      Width = 178
      Height = 22
      Caption = 'Afficher les etats en 2D'
      TabOrder = 3
    end
    object Button3: TButton
      Left = 4
      Top = 213
      Width = 239
      Height = 67
      Caption = 'Resoudre l'#39'equation de Schrodinger'
      TabOrder = 4
      OnClick = Button3Click
    end
  end
  object GroupBox1: TGroupBox
    Left = 10
    Top = 445
    Width = 274
    Height = 283
    Caption = 'Proprietes de la particule et du potentiel'
    TabOrder = 1
    object Label1: TLabel
      Left = 17
      Top = 29
      Width = 109
      Height = 17
      Caption = 'Nombre de points'
    end
    object Label2: TLabel
      Left = 20
      Top = 67
      Width = 153
      Height = 17
      Caption = 'Masse de la particule (Kg)'
    end
    object Label3: TLabel
      Left = 21
      Top = 102
      Width = 103
      Height = 17
      Caption = 'potentiel max (J)'
    end
    object Label4: TLabel
      Left = 21
      Top = 178
      Width = 124
      Height = 17
      Caption = 'Taille de l'#39'espace (m)'
    end
    object Label5: TLabel
      Left = 17
      Top = 213
      Width = 145
      Height = 17
      Caption = 'Afficher jusqu'#39'a l'#39'etat n'#176
    end
    object Label12: TLabel
      Left = 20
      Top = 136
      Width = 141
      Height = 17
      Caption = 'Potentiel de barriere (J)'
    end
    object Edit1: TEdit
      Left = 188
      Top = 31
      Width = 75
      Height = 25
      TabOrder = 0
      Text = '200'
    end
    object Edit2: TEdit
      Left = 188
      Top = 67
      Width = 75
      Height = 25
      TabOrder = 1
      Text = '1,67E-27'
    end
    object Edit3: TEdit
      Left = 188
      Top = 102
      Width = 75
      Height = 25
      TabOrder = 2
      Text = '1E-15'
    end
    object Edit4: TEdit
      Left = 188
      Top = 177
      Width = 75
      Height = 25
      TabOrder = 3
      Text = '4E-12'
    end
    object Edit8: TEdit
      Left = 188
      Top = 137
      Width = 75
      Height = 25
      TabOrder = 4
      Text = '2E-16'
    end
  end
  object Edit5: TEdit
    Left = 199
    Top = 656
    Width = 74
    Height = 25
    TabOrder = 2
    Text = '30'
  end
  object Button1: TButton
    Left = 30
    Top = 683
    Width = 243
    Height = 32
    Caption = 'Calculer les etats propres'
    TabOrder = 0
    OnClick = Button1Click
  end
  object ListBox1: TListBox
    Left = 511
    Top = 626
    Width = 233
    Height = 93
    ItemHeight = 17
    TabOrder = 4
  end
  object RadioGroup1: TRadioGroup
    Left = 292
    Top = 446
    Width = 180
    Height = 284
    Caption = 'Type de potentiel'
    TabOrder = 5
  end
  object RadioButton1: TRadioButton
    Left = 307
    Top = 476
    Width = 148
    Height = 22
    Caption = 'Puit plat'
    TabOrder = 6
  end
  object RadioButton2: TRadioButton
    Left = 307
    Top = 519
    Width = 148
    Height = 22
    Caption = 'Harmonique'
    Checked = True
    TabOrder = 7
    TabStop = True
  end
  object RadioButton3: TRadioButton
    Left = 307
    Top = 560
    Width = 148
    Height = 22
    Caption = 'Marche de potentiel'
    TabOrder = 8
  end
  object RadioButton4: TRadioButton
    Left = 307
    Top = 600
    Width = 161
    Height = 22
    Caption = 'Barriere de potentiel'
    TabOrder = 9
  end
  object RadioButton5: TRadioButton
    Left = 307
    Top = 685
    Width = 148
    Height = 22
    Caption = 'Puit en W'
    TabOrder = 10
  end
  object RadioButton6: TRadioButton
    Left = 307
    Top = 645
    Width = 148
    Height = 22
    Caption = 'Barriere inversee'
    TabOrder = 11
  end
end
