object Form2: TForm2
  Left = 420
  Top = 200
  Width = 1064
  Height = 768
  Caption = 'Resolution de l'#39'equation de Schrodinger dependante du temps'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnClose = FormClose
  PixelsPerInch = 120
  TextHeight = 17
  object Image1: TImage
    Left = 10
    Top = 31
    Width = 497
    Height = 471
  end
  object Image2: TImage
    Left = 527
    Top = 31
    Width = 497
    Height = 471
  end
  object Label8: TLabel
    Left = 97
    Top = 10
    Width = 328
    Height = 17
    Caption = 'Evolution temporelle de la fonction d'#39'onde et potentiel'
  end
  object Label9: TLabel
    Left = 670
    Top = 10
    Width = 198
    Height = 17
    Caption = 'Representation 2D de l'#39'evolution'
  end
  object GroupBox1: TGroupBox
    Left = 10
    Top = 513
    Width = 232
    Height = 217
    Caption = 'Etat initial (distribution gaussienne)'
    TabOrder = 1
    object Label1: TLabel
      Left = 24
      Top = 42
      Width = 73
      Height = 17
      Caption = 'Largeur (m)'
    end
    object Label2: TLabel
      Left = 24
      Top = 77
      Width = 81
      Height = 17
      Caption = 'Decalage (m)'
    end
    object Label3: TLabel
      Left = 24
      Top = 143
      Width = 118
      Height = 17
      Caption = 'Impulsion (kg*m/s)'
    end
    object Edit1: TEdit
      Left = 149
      Top = 42
      Width = 79
      Height = 21
      TabOrder = 0
      Text = '1,7E-13'
    end
    object Edit2: TEdit
      Left = 149
      Top = 77
      Width = 79
      Height = 21
      TabOrder = 1
      Text = '-1,2E-12'
    end
    object Edit3: TEdit
      Left = 149
      Top = 143
      Width = 79
      Height = 21
      TabOrder = 2
      Text = '6E-22'
    end
    object CheckBox1: TCheckBox
      Left = 16
      Top = 112
      Width = 174
      Height = 23
      Caption = 'Donner une impulsion'
      Checked = True
      State = cbChecked
      TabOrder = 3
    end
    object Button1: TButton
      Left = 16
      Top = 178
      Width = 197
      Height = 33
      Caption = 'Enregistrer les modifications'
      TabOrder = 4
      OnClick = Button1Click
    end
  end
  object GroupBox2: TGroupBox
    Left = 794
    Top = 513
    Width = 231
    Height = 176
    Caption = 'Affichage de l'#39'evolution en 2D'
    TabOrder = 0
    object Label4: TLabel
      Left = 84
      Top = 31
      Width = 33
      Height = 17
      Caption = 't0 (s)'
    end
    object Label5: TLabel
      Left = 86
      Top = 67
      Width = 29
      Height = 17
      Caption = 'tf (s)'
    end
    object Label6: TLabel
      Left = 56
      Top = 102
      Width = 57
      Height = 17
      Caption = 'Iterations'
    end
    object Edit4: TEdit
      Left = 126
      Top = 31
      Width = 85
      Height = 21
      TabOrder = 0
      Text = '0'
    end
    object Edit5: TEdit
      Left = 126
      Top = 67
      Width = 85
      Height = 21
      TabOrder = 1
      Text = '4E-17'
    end
    object Edit6: TEdit
      Left = 126
      Top = 102
      Width = 85
      Height = 21
      TabOrder = 2
      Text = '200'
    end
  end
  object GroupBox3: TGroupBox
    Left = 250
    Top = 510
    Width = 218
    Height = 220
    Caption = 'Animation de la fonction d'#39'onde'
    TabOrder = 2
    object Label7: TLabel
      Left = 20
      Top = 126
      Width = 118
      Height = 17
      Caption = 'Temporisation (ms)'
    end
    object Label13: TLabel
      Left = 63
      Top = 44
      Width = 33
      Height = 17
      Caption = 't0 (s)'
    end
    object Label14: TLabel
      Left = 63
      Top = 80
      Width = 33
      Height = 17
      Caption = 'dt (s)'
    end
    object Button3: TButton
      Left = 14
      Top = 183
      Width = 61
      Height = 33
      Caption = 'Play'
      TabOrder = 0
      OnClick = Button3Click
    end
    object Edit7: TEdit
      Left = 146
      Top = 119
      Width = 54
      Height = 21
      TabOrder = 1
      Text = '40'
    end
    object Edit8: TEdit
      Left = 115
      Top = 42
      Width = 89
      Height = 21
      TabOrder = 2
      Text = '0'
    end
    object Edit9: TEdit
      Left = 115
      Top = 77
      Width = 89
      Height = 21
      TabOrder = 3
      Text = '2E-19'
    end
    object Button5: TButton
      Left = 82
      Top = 183
      Width = 55
      Height = 33
      Caption = 'Pause'
      TabOrder = 4
      OnClick = Button5Click
    end
    object Button6: TButton
      Left = 145
      Top = 183
      Width = 63
      Height = 33
      Caption = 'Stop'
      TabOrder = 5
      OnClick = Button6Click
    end
  end
  object GroupBox4: TGroupBox
    Left = 476
    Top = 510
    Width = 310
    Height = 217
    Caption = 'Caracteristiques de la particule'
    TabOrder = 3
    object Label10: TLabel
      Left = 21
      Top = 84
      Width = 117
      Height = 17
      Caption = 'Energie moyenne='
    end
    object Label11: TLabel
      Left = 21
      Top = 136
      Width = 110
      Height = 17
      Caption = 'Probabilite totale='
    end
    object Label12: TLabel
      Left = 21
      Top = 38
      Width = 15
      Height = 17
      Caption = 't='
    end
  end
  object Button4: TButton
    Left = 832
    Top = 650
    Width = 151
    Height = 33
    Caption = 'Afficher'
    TabOrder = 4
    OnClick = Button4Click
  end
  object Button2: TButton
    Left = 800
    Top = 697
    Width = 225
    Height = 33
    Caption = 'Revenir a la fiche precedente'
    TabOrder = 5
    OnClick = Button2Click
  end
  object Timer1: TTimer
    Interval = 30
    OnTimer = Timer1Timer
    Left = 8
    Top = 8
  end
end
