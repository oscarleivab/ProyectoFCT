inherited FrEdit1: TFrEdit1
  object ScrollBox1: TScrollBox [1]
    Left = 0
    Top = 65
    Width = 640
    Height = 415
    Align = alClient
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    ParentBackground = True
    TabOrder = 1
    object Panel5: TPanel
      AlignWithMargins = True
      Left = 15
      Top = 0
      Width = 593
      Height = 913
      Margins.Left = 15
      Margins.Top = 0
      Margins.Right = 15
      Margins.Bottom = 0
      Align = alTop
      BevelEdges = [beBottom]
      BevelOuter = bvNone
      TabOrder = 0
      object GroupPermisos: TGroupBox
        Left = 0
        Top = 0
        Width = 593
        Height = 265
        Align = alTop
        Caption = 'Permisos'
        Ctl3D = True
        ParentCtl3D = False
        TabOrder = 0
        ExplicitTop = 3
        object labelnombre: TLabel
          Left = 299
          Top = 24
          Width = 44
          Height = 15
          Caption = 'Nombre'
        end
        object labellistarproveedor: TLabel
          Left = 299
          Top = 69
          Width = 85
          Height = 15
          Caption = 'Listar Proveedor'
        end
        object labelcrearempleado: TLabel
          Left = 299
          Top = 106
          Width = 84
          Height = 15
          Caption = 'Crear Empleado'
        end
        object labelcodigo: TLabel
          Left = 16
          Top = 24
          Width = 11
          Height = 15
          Caption = 'ID'
        end
        object labelcrearcliente: TLabel
          Left = 16
          Top = 69
          Width = 68
          Height = 15
          Caption = 'Crear Cliente'
        end
        object labeleditarcliente: TLabel
          Left = 16
          Top = 106
          Width = 70
          Height = 15
          Caption = 'Editar Cliente'
        end
        object labellistarcliente: TLabel
          Left = 16
          Top = 144
          Width = 68
          Height = 15
          Caption = 'Listar Cliente'
        end
        object labelcrearproveedor: TLabel
          Left = 16
          Top = 184
          Width = 85
          Height = 15
          Caption = 'Crear Proveedor'
        end
        object labeleditarproveedor: TLabel
          Left = 16
          Top = 224
          Width = 87
          Height = 15
          Caption = 'Editar Proveedor'
        end
        object labeleditarempleado: TLabel
          Left = 299
          Top = 144
          Width = 86
          Height = 15
          Caption = 'Editar Empleado'
        end
        object labellistarempleado: TLabel
          Left = 299
          Top = 184
          Width = 84
          Height = 15
          Caption = 'Listar Empleado'
        end
        object labelactivo: TLabel
          Left = 299
          Top = 224
          Width = 34
          Height = 15
          Caption = 'Activo'
        end
        object DBnombre: TDBEdit
          Left = 354
          Top = 21
          Width = 487
          Height = 23
          DataSource = DataSource
          TabOrder = 0
        end
        object DBid: TDBEdit
          Left = 95
          Top = 21
          Width = 138
          Height = 23
          DataSource = DataSource
          ReadOnly = True
          TabOrder = 1
        end
        object DBccrearcliente: TDBCheckBox
          Left = 136
          Top = 69
          Width = 97
          Height = 17
          TabOrder = 2
        end
        object DBceditarcliente: TDBCheckBox
          Left = 136
          Top = 106
          Width = 97
          Height = 17
          TabOrder = 3
        end
        object DBclistarcliente: TDBCheckBox
          Left = 136
          Top = 144
          Width = 97
          Height = 17
          TabOrder = 4
        end
        object DBccrearproveedor: TDBCheckBox
          Left = 136
          Top = 184
          Width = 97
          Height = 17
          TabOrder = 5
        end
        object DBceditarproveedor: TDBCheckBox
          Left = 136
          Top = 224
          Width = 97
          Height = 17
          TabOrder = 6
        end
        object DBclistarproveedor: TDBCheckBox
          Left = 416
          Top = 69
          Width = 97
          Height = 17
          TabOrder = 7
        end
        object DBccrearempleado: TDBCheckBox
          Left = 416
          Top = 106
          Width = 97
          Height = 17
          TabOrder = 8
        end
        object DBceditarempleado: TDBCheckBox
          Left = 416
          Top = 144
          Width = 97
          Height = 17
          TabOrder = 9
        end
        object DBclistarempleado: TDBCheckBox
          Left = 416
          Top = 184
          Width = 97
          Height = 17
          TabOrder = 10
        end
        object DBactivo: TDBCheckBox
          Left = 416
          Top = 224
          Width = 97
          Height = 17
          TabOrder = 11
        end
      end
    end
  end
end
