inherited FrEdCliente: TFrEdCliente
  Width = 892
  Height = 920
  ExplicitWidth = 892
  ExplicitHeight = 920
  inherited paneltop: TPanel
    Width = 892
    ExplicitWidth = 892
    inherited Buttonsalir: TButton
      Left = 827
      ExplicitLeft = 827
    end
  end
  object ScrollBox1: TScrollBox [1]
    Left = 0
    Top = 65
    Width = 892
    Height = 855
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
      Width = 862
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
        Width = 862
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
          Top = 53
          Width = 24
          Height = 15
          Caption = 'Tipo'
        end
        object labeldocumento: TLabel
          Left = 10
          Top = 82
          Width = 63
          Height = 15
          Caption = 'Documento'
        end
        object DBnombre: TDBEdit
          Left = 354
          Top = 21
          Width = 487
          Height = 23
          DataSource = DataSource
          TabOrder = 0
        end
        object DBapellidos: TDBEdit
          Left = 354
          Top = 50
          Width = 487
          Height = 23
          DataSource = DataSource
          TabOrder = 1
        end
        object DBempresa: TDBEdit
          Left = 354
          Top = 79
          Width = 487
          Height = 23
          DataSource = DataSource
          TabOrder = 2
        end
        object DBid_tipo_documento: TDBComboBox
          Left = 95
          Top = 50
          Width = 138
          Height = 23
          DataSource = DataSource
          TabOrder = 3
        end
        object DBdetalle_documento: TDBEdit
          Left = 95
          Top = 79
          Width = 138
          Height = 23
          DataSource = DataSource
          TabOrder = 4
        end
        object DBid_cliente: TDBEdit
          Left = 95
          Top = 21
          Width = 138
          Height = 23
          DataSource = DataSource
          TabOrder = 5
        end
      end
      object GroupBox2: TGroupBox
        AlignWithMargins = True
        Left = 0
        Top = 717
        Width = 862
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
        object DBid_tarifa: TDBComboBox
          Left = 95
          Top = 39
          Width = 233
          Height = 23
          DataSource = DataSource
          TabOrder = 0
        end
        object DBid_permiso: TDBEdit
          Left = 422
          Top = 39
          Width = 219
          Height = 23
          DataSource = DataSource
          TabOrder = 1
        end
        object DBactivo: TDBCheckBox
          Left = 696
          Top = 40
          Width = 97
          Height = 17
          Caption = 'Activado'
          DataSource = DataSource
          TabOrder = 2
        end
      end
      object GroupBox3: TGroupBox
        AlignWithMargins = True
        Left = 0
        Top = 245
        Width = 862
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
        Width = 862
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
        object DBtelefono1: TDBEdit
          Left = 95
          Top = 36
          Width = 154
          Height = 23
          DataSource = DataSource
          TabOrder = 0
        end
        object DBtelefono2: TDBEdit
          Left = 95
          Top = 65
          Width = 154
          Height = 23
          DataSource = DataSource
          TabOrder = 1
        end
        object DBemail: TDBEdit
          Left = 354
          Top = 36
          Width = 487
          Height = 23
          DataSource = DataSource
          TabOrder = 2
        end
        object DBpersona_contacto: TDBEdit
          Left = 354
          Top = 65
          Width = 487
          Height = 23
          DataSource = DataSource
          TabOrder = 3
        end
      end
      object GroupBox5: TGroupBox
        AlignWithMargins = True
        Left = 0
        Top = 363
        Width = 862
        Height = 105
        Margins.Left = 0
        Margins.Top = 10
        Margins.Right = 0
        Align = alTop
        Caption = 'Observaciones'
        TabOrder = 4
        object DBobservaciones: TDBMemo
          AlignWithMargins = True
          Left = 5
          Top = 20
          Width = 852
          Height = 80
          Align = alClient
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = bsNone
          DataSource = DataSource
          TabOrder = 0
        end
      end
      object GroupBox6: TGroupBox
        AlignWithMargins = True
        Left = 0
        Top = 481
        Width = 862
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
        Width = 862
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
        object DBuser_login: TDBEdit
          Left = 95
          Top = 38
          Width = 298
          Height = 23
          DataSource = DataSource
          TabOrder = 0
        end
        object DBpass_login: TDBEdit
          Left = 543
          Top = 38
          Width = 298
          Height = 23
          DataSource = DataSource
          TabOrder = 1
        end
        object DBEdit10: TDBEdit
          Left = 95
          Top = 67
          Width = 746
          Height = 23
          DataSource = DataSource
          TabOrder = 2
        end
      end
    end
  end
  inherited FDQuery: TFDQuery
    Connection = DataModuleConnection.FDConnectionCompany
    Left = 536
    Top = 16
  end
  inherited DataSource: TDataSource
    Left = 456
    Top = 16
  end
end
