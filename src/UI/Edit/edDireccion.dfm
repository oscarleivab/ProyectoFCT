inherited FrEditDireccion: TFrEditDireccion
  Width = 918
  Height = 337
  ExplicitWidth = 918
  ExplicitHeight = 337
  inherited paneltop: TPanel
    Width = 918
    ExplicitWidth = 918
    inherited Buttonsalir: TButton
      Left = 853
      ExplicitLeft = 853
    end
  end
  object GroupBox1: TGroupBox [1]
    AlignWithMargins = True
    Left = 10
    Top = 75
    Width = 898
    Height = 238
    Margins.Left = 10
    Margins.Top = 10
    Margins.Right = 10
    Margins.Bottom = 10
    Align = alTop
    Caption = 'Direcci'#243'n'
    Ctl3D = True
    ParentCtl3D = False
    TabOrder = 1
    object labeldetalle: TLabel
      Left = 26
      Top = 40
      Width = 36
      Height = 15
      Caption = 'Detalle'
    end
    object labeldireccion: TLabel
      Left = 26
      Top = 77
      Width = 50
      Height = 15
      Caption = 'Direcci'#243'n'
    end
    object labelpoblacion: TLabel
      Left = 26
      Top = 106
      Width = 53
      Height = 15
      Caption = 'Poblaci'#243'n'
    end
    object labelprovincia: TLabel
      Left = 26
      Top = 135
      Width = 49
      Height = 15
      Caption = 'Provincia'
    end
    object Labelcpostal: TLabel
      Left = 26
      Top = 164
      Width = 18
      Height = 15
      Caption = 'C.P'
    end
    object Labelpais: TLabel
      Left = 26
      Top = 193
      Width = 21
      Height = 15
      Caption = 'Pais'
    end
    object DBdetalle: TDBEdit
      Left = 86
      Top = 37
      Width = 487
      Height = 23
      DataSource = DataSource
      TabOrder = 0
    end
    object DBdireccion: TDBEdit
      Left = 86
      Top = 74
      Width = 487
      Height = 23
      DataSource = DataSource
      TabOrder = 1
    end
    object DBpoblacion: TDBEdit
      Left = 86
      Top = 103
      Width = 487
      Height = 23
      DataSource = DataSource
      TabOrder = 2
    end
    object DBid_entidad: TDBEdit
      Left = 615
      Top = 61
      Width = 138
      Height = 23
      DataSource = DataSource
      ReadOnly = True
      TabOrder = 3
      Visible = False
    end
    object DBid: TDBEdit
      Left = 615
      Top = 90
      Width = 138
      Height = 23
      DataSource = DataSource
      ReadOnly = True
      TabOrder = 4
      Visible = False
    end
    object DBprovincia: TDBEdit
      Left = 86
      Top = 132
      Width = 487
      Height = 23
      DataSource = DataSource
      TabOrder = 5
    end
    object DBcp: TDBEdit
      Left = 86
      Top = 161
      Width = 487
      Height = 23
      DataSource = DataSource
      TabOrder = 6
    end
    object DBpais: TDBEdit
      Left = 86
      Top = 190
      Width = 487
      Height = 23
      DataSource = DataSource
      TabOrder = 7
    end
    object DBtabla: TDBEdit
      Left = 615
      Top = 24
      Width = 138
      Height = 23
      DataSource = DataSource
      ReadOnly = True
      TabOrder = 8
      Visible = False
    end
  end
end
