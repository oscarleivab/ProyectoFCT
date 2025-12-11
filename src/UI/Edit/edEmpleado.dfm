inherited FrEdEmpleado: TFrEdEmpleado
  Width = 984
  Height = 964
  ExplicitWidth = 984
  ExplicitHeight = 964
  inherited paneltop: TPanel
    Width = 984
    ExplicitWidth = 984
    inherited Buttonsalir: TButton
      Left = 919
      ExplicitLeft = 919
    end
  end
  object ScrollBox1: TScrollBox [1]
    Left = 0
    Top = 65
    Width = 984
    Height = 899
    VertScrollBar.Position = 14
    Align = alClient
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    ParentBackground = True
    TabOrder = 1
    object Panel5: TPanel
      AlignWithMargins = True
      Left = 15
      Top = -14
      Width = 937
      Height = 913
      Margins.Left = 15
      Margins.Top = 0
      Margins.Right = 15
      Margins.Bottom = 0
      Align = alTop
      BevelEdges = [beBottom]
      BevelOuter = bvNone
      TabOrder = 0
      object GroupDatosfiscales: TGroupBox
        Left = 0
        Top = 0
        Width = 937
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
        object DBdetalle_documento: TDBEdit
          Left = 95
          Top = 79
          Width = 138
          Height = 23
          DataSource = DataSource
          TabOrder = 3
        end
        object DBid: TDBEdit
          Left = 95
          Top = 21
          Width = 138
          Height = 23
          DataSource = DataSource
          ReadOnly = True
          TabOrder = 4
        end
        object DBComboTipodoc: TDBLookupComboBox
          Left = 95
          Top = 50
          Width = 138
          Height = 23
          DataSource = DataSource
          TabOrder = 5
        end
      end
      object GroupBox2: TGroupBox
        AlignWithMargins = True
        Left = 0
        Top = 817
        Width = 937
        Height = 84
        Margins.Left = 0
        Margins.Top = 10
        Margins.Right = 0
        Align = alTop
        Caption = 'Tarifa y permisos'
        TabOrder = 1
        object labelpermiso: TLabel
          Left = 27
          Top = 36
          Width = 48
          Height = 15
          Caption = 'Permisos'
        end
        object labelactivo: TLabel
          Left = 359
          Top = 35
          Width = 34
          Height = 15
          BiDiMode = bdRightToLeft
          Caption = 'Activo'
          ParentBiDiMode = False
        end
        object DBactivo: TDBCheckBox
          Left = 399
          Top = 34
          Width = 17
          Height = 17
          DataSource = DataSource
          TabOrder = 0
        end
        object DBComboPermisos: TDBLookupComboBox
          Left = 95
          Top = 32
          Width = 243
          Height = 23
          DataSource = DataSource
          TabOrder = 1
        end
      end
      object GroupBoxDirecciones: TGroupBox
        AlignWithMargins = True
        Left = 0
        Top = 245
        Width = 937
        Height = 160
        Margins.Left = 0
        Margins.Top = 10
        Margins.Right = 0
        Align = alTop
        Caption = 'Direcciones'
        TabOrder = 2
        object paneldirecciones: TPanel
          Left = 2
          Top = 17
          Width = 933
          Height = 141
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 0
        end
      end
      object GroupDatoscontacto: TGroupBox
        AlignWithMargins = True
        Left = 0
        Top = 127
        Width = 937
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
        Top = 418
        Width = 937
        Height = 105
        Margins.Left = 0
        Margins.Top = 10
        Margins.Right = 0
        Align = alTop
        Caption = 'Observaciones'
        TabOrder = 4
        object DBobservaciones: TDBMemo
          AlignWithMargins = True
          Left = 7
          Top = 17
          Width = 923
          Height = 81
          Margins.Left = 5
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 5
          Align = alClient
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = bsNone
          Color = 16382457
          DataSource = DataSource
          TabOrder = 0
        end
      end
      object GroupBox6: TGroupBox
        AlignWithMargins = True
        Left = 0
        Top = 526
        Width = 937
        Height = 160
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 0
        Align = alTop
        Caption = 'Datos Bancarios'
        TabOrder = 5
        object panelDatosBanco: TPanel
          Left = 2
          Top = 17
          Width = 933
          Height = 141
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 0
        end
      end
      object GroupBox7: TGroupBox
        AlignWithMargins = True
        Left = 0
        Top = 699
        Width = 937
        Height = 105
        Margins.Left = 0
        Margins.Top = 10
        Margins.Right = 0
        Align = alTop
        Caption = 'Accesos Login'
        TabOrder = 6
        ExplicitLeft = 2
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
        object DBurl_web: TDBEdit
          Left = 95
          Top = 67
          Width = 746
          Height = 23
          DataSource = DataSource
          TabOrder = 1
        end
        object EditPassword: TEdit
          Left = 536
          Top = 38
          Width = 305
          Height = 23
          PasswordChar = '*'
          TabOrder = 2
          OnChange = EditPasswordChange
        end
      end
    end
  end
  object DataSourceDirecciones: TDataSource
    DataSet = FDQueryDirecciones
    Left = 672
    Top = 8
  end
  object FDQueryDirecciones: TFDQuery
    Connection = DataModuleConnection.FDConnectionCompany
    SQL.Strings = (
      '')
    Left = 760
    Top = 8
  end
  object DataSourceTipodoc: TDataSource
    DataSet = FDQueryTipodoc
    Left = 152
    Top = 16
  end
  object DataSourcePermisos: TDataSource
    DataSet = FDQueryPermisos
    Left = 240
    Top = 16
  end
  object FDQueryTipodoc: TFDQuery
    Connection = DataModuleConnection.FDConnectionCompany
    SQL.Strings = (
      '')
    Left = 296
    Top = 8
  end
  object FDQueryPermisos: TFDQuery
    Connection = DataModuleConnection.FDConnectionCompany
    SQL.Strings = (
      '')
    Left = 360
    Top = 16
  end
end
