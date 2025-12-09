inherited FrEditCliente: TFrEditCliente
  Width = 895
  Height = 891
  ExplicitWidth = 895
  ExplicitHeight = 891
  inherited paneltop: TPanel
    Width = 895
    Height = 58
    OnClick = paneltopClick
    ExplicitWidth = 895
    ExplicitHeight = 58
    inherited Buttonguardar: TButton
      Width = 40
      Height = 38
      ExplicitWidth = 40
      ExplicitHeight = 38
    end
    inherited Buttonnuevo: TButton
      Left = 63
      Width = 40
      Height = 38
      ExplicitLeft = 63
      ExplicitWidth = 40
      ExplicitHeight = 38
    end
    inherited Buttonsalir: TButton
      Left = 840
      Width = 40
      Height = 38
      ExplicitLeft = 840
      ExplicitWidth = 40
      ExplicitHeight = 38
    end
  end
  object ScrollBox1: TScrollBox [1]
    Left = 0
    Top = 58
    Width = 895
    Height = 833
    Align = alClient
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    ParentBackground = True
    TabOrder = 1
    OnMouseWheelDown = ScrollBox1MouseWheelDown
    OnMouseWheelUp = ScrollBox1MouseWheelUp
    object Panel5: TPanel
      AlignWithMargins = True
      Left = 15
      Top = 0
      Width = 848
      Height = 847
      Margins.Left = 15
      Margins.Top = 0
      Margins.Right = 15
      Margins.Bottom = 0
      Align = alTop
      BevelEdges = [beBottom]
      BevelOuter = bvNone
      TabOrder = 0
      object GroupBox1: TGroupBox
        Left = 0
        Top = 0
        Width = 848
        Height = 117
        Align = alTop
        Caption = 'Datos Fiscales'
        Ctl3D = True
        ParentCtl3D = False
        TabOrder = 0
        object labelnombre: TLabel
          Left = 299
          Top = 24
          Width = 44
          Height = 15
          Caption = 'Nombre'
        end
        object labelapellidos: TLabel
          Left = 299
          Top = 53
          Width = 49
          Height = 15
          Caption = 'Apellidos'
        end
        object labelempresa: TLabel
          Left = 299
          Top = 82
          Width = 45
          Height = 15
          Caption = 'Empresa'
        end
        object labelcodigo: TLabel
          Left = 10
          Top = 27
          Width = 11
          Height = 15
          Caption = 'ID'
        end
        object labeltipo: TLabel
          Left = 10
          Top = 56
          Width = 24
          Height = 15
          Caption = 'Tipo'
        end
        object labeldocumento: TLabel
          Left = 10
          Top = 85
          Width = 63
          Height = 15
          Caption = 'Documento'
        end
        object idedit: TEdit
          Left = 94
          Top = 24
          Width = 166
          Height = 23
          ReadOnly = True
          TabOrder = 0
        end
        object tipodocbox: TComboBox
          Left = 94
          Top = 53
          Width = 166
          Height = 23
          BevelInner = bvNone
          BevelOuter = bvNone
          Style = csDropDownList
          Ctl3D = True
          ParentCtl3D = False
          TabOrder = 1
          Items.Strings = (
            'DNI'
            'CIF'
            'PASAPORTE')
        end
        object documentoedit: TEdit
          Left = 94
          Top = 82
          Width = 166
          Height = 23
          TabOrder = 2
        end
        object Empresaedit: TEdit
          Left = 359
          Top = 79
          Width = 417
          Height = 23
          Hint = 'Empresa'
          TabOrder = 3
        end
        object apellidosedit: TEdit
          Left = 359
          Top = 50
          Width = 417
          Height = 23
          Hint = 'Apellidos'
          TabOrder = 4
        end
        object nombreedit: TEdit
          Left = 359
          Top = 21
          Width = 417
          Height = 23
          Hint = 'Nombre'
          TabOrder = 5
        end
      end
      object GroupBox2: TGroupBox
        AlignWithMargins = True
        Left = 0
        Top = 717
        Width = 848
        Height = 84
        Margins.Left = 0
        Margins.Top = 10
        Margins.Right = 0
        Align = alTop
        Caption = 'Tarifa y permisos'
        TabOrder = 1
        object labeltarifa: TLabel
          Left = 10
          Top = 42
          Width = 76
          Height = 15
          Caption = 'Tarifa aplicada'
        end
        object labelpermiso: TLabel
          Left = 354
          Top = 44
          Width = 48
          Height = 15
          Caption = 'Permisos'
        end
        object tipotarifabox: TComboBox
          Left = 94
          Top = 39
          Width = 204
          Height = 23
          Style = csDropDownList
          TabOrder = 0
          TabStop = False
        end
        object grupopermisobox: TComboBox
          Left = 420
          Top = 41
          Width = 197
          Height = 23
          Style = csDropDownList
          TabOrder = 1
          TabStop = False
        end
        object activocheck: TToggleSwitch
          Left = 706
          Top = 41
          Width = 98
          Height = 20
          Alignment = taLeftJustify
          State = tssOn
          StateCaptions.CaptionOn = 'Activo'
          StateCaptions.CaptionOff = 'Inactivo'
          StyleName = 'Windows'
          TabOrder = 2
        end
      end
      object GroupBox3: TGroupBox
        AlignWithMargins = True
        Left = 0
        Top = 245
        Width = 848
        Height = 105
        Margins.Left = 0
        Margins.Top = 10
        Margins.Right = 0
        Align = alTop
        Caption = 'Direcciones'
        TabOrder = 2
      end
      object GroupBox4: TGroupBox
        AlignWithMargins = True
        Left = 0
        Top = 127
        Width = 848
        Height = 105
        Margins.Left = 0
        Margins.Top = 10
        Margins.Right = 0
        Align = alTop
        Caption = 'Datos de contacto'
        TabOrder = 3
        object labeltelefono1: TLabel
          Left = 10
          Top = 39
          Width = 55
          Height = 15
          Caption = 'Tel'#233'fono 1'
        end
        object labeltelefono2: TLabel
          Left = 10
          Top = 68
          Width = 55
          Height = 15
          Caption = 'Tel'#233'fono 2'
        end
        object labelcontacto: TLabel
          Left = 299
          Top = 68
          Width = 49
          Height = 15
          Caption = 'Contacto'
        end
        object labelemail: TLabel
          Left = 299
          Top = 39
          Width = 29
          Height = 15
          Caption = 'Email'
        end
        object telefono1edit: TEdit
          Left = 94
          Top = 34
          Width = 166
          Height = 23
          Hint = 'DNI/CIF'
          TabOrder = 0
        end
        object telefono2edit: TEdit
          Left = 94
          Top = 63
          Width = 166
          Height = 23
          Hint = 'DNI/CIF'
          TabOrder = 1
        end
        object emailedit: TEdit
          Left = 359
          Top = 34
          Width = 417
          Height = 23
          Hint = 'Empresa'
          TabOrder = 2
        end
        object personacontacto: TEdit
          Left = 359
          Top = 63
          Width = 417
          Height = 23
          Hint = 'Empresa'
          TabOrder = 3
        end
      end
      object GroupBox5: TGroupBox
        AlignWithMargins = True
        Left = 0
        Top = 363
        Width = 848
        Height = 105
        Margins.Left = 0
        Margins.Top = 10
        Margins.Right = 0
        Align = alTop
        Caption = 'Observaciones'
        TabOrder = 4
        object observacionesmemo: TMemo
          AlignWithMargins = True
          Left = 12
          Top = 27
          Width = 824
          Height = 66
          Hint = 'Observaciones'
          Margins.Left = 10
          Margins.Top = 10
          Margins.Right = 10
          Margins.Bottom = 10
          Align = alClient
          Color = 16121598
          TabOrder = 0
          ExplicitLeft = 14
          ExplicitTop = 29
        end
      end
      object GroupBox6: TGroupBox
        AlignWithMargins = True
        Left = 0
        Top = 481
        Width = 848
        Height = 105
        Margins.Left = 0
        Margins.Top = 10
        Margins.Right = 0
        Align = alTop
        Caption = 'Datos Bancarios'
        TabOrder = 5
      end
      object GroupBox7: TGroupBox
        AlignWithMargins = True
        Left = 0
        Top = 599
        Width = 848
        Height = 105
        Margins.Left = 0
        Margins.Top = 10
        Margins.Right = 0
        Align = alTop
        Caption = 'Accesos Login'
        TabOrder = 6
        object Label1: TLabel
          Left = 10
          Top = 41
          Width = 40
          Height = 15
          Caption = 'Usuario'
        end
        object Label2: TLabel
          Left = 422
          Top = 41
          Width = 95
          Height = 15
          Caption = 'Nueva contrase'#241'a'
        end
        object Label3: TLabel
          Left = 10
          Top = 70
          Width = 48
          Height = 15
          Caption = 'Web URL'
        end
        object usuarioedit: TEdit
          Left = 94
          Top = 38
          Width = 289
          Height = 23
          TabOrder = 0
        end
        object Passwordedit: TEdit
          Left = 523
          Top = 38
          Width = 281
          Height = 23
          PasswordChar = '*'
          TabOrder = 1
        end
        object webedit: TEdit
          Left = 94
          Top = 67
          Width = 710
          Height = 23
          TabOrder = 2
        end
      end
    end
  end
  inherited FDQuery: TFDQuery
    Left = 536
    Top = 8
  end
  inherited DataSource: TDataSource
    Left = 464
    Top = 8
  end
end
