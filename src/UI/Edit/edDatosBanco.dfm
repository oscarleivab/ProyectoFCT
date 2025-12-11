inherited FrEdDatosBanco: TFrEdDatosBanco
  Width = 799
  ExplicitWidth = 799
  inherited paneltop: TPanel
    Width = 799
    inherited Buttonsalir: TButton
      Left = 734
    end
  end
  object GroupBox1: TGroupBox [1]
    AlignWithMargins = True
    Left = 10
    Top = 75
    Width = 779
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
    ExplicitLeft = -258
    ExplicitWidth = 898
    object labelsucursal: TLabel
      Left = 26
      Top = 40
      Width = 44
      Height = 15
      Caption = 'Sucursal'
    end
    object labelccc: TLabel
      Left = 26
      Top = 77
      Width = 38
      Height = 15
      Caption = 'Cuenta'
    end
    object labelobservacion: TLabel
      Left = 26
      Top = 106
      Width = 66
      Height = 15
      Caption = 'Observacion'
    end
    object DBsucursal: TDBEdit
      Left = 98
      Top = 37
      Width = 475
      Height = 23
      DataSource = DataSource
      TabOrder = 0
    end
    object DBccc: TDBEdit
      Left = 98
      Top = 74
      Width = 475
      Height = 23
      DataSource = DataSource
      TabOrder = 1
    end
    object DBobservacion: TDBEdit
      Left = 98
      Top = 103
      Width = 475
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
    object DBtabla: TDBEdit
      Left = 615
      Top = 24
      Width = 138
      Height = 23
      DataSource = DataSource
      ReadOnly = True
      TabOrder = 5
      Visible = False
    end
  end
end
