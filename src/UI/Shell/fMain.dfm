object FrmMain: TFrmMain
  Left = 0
  Top = 0
  Caption = 'Gevensoft'
  ClientHeight = 751
  ClientWidth = 1008
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 15
  object PageControl1: TPageControl
    AlignWithMargins = True
    Left = 10
    Top = 57
    Width = 988
    Height = 684
    Margins.Left = 10
    Margins.Top = 15
    Margins.Right = 10
    Margins.Bottom = 10
    ActivePage = TabSheetPrincipal
    Align = alClient
    TabOrder = 0
    StyleName = 'Windows'
    object TabSheetPrincipal: TTabSheet
      Caption = 'Principal'
      DoubleBuffered = True
      ImageIndex = -1
      ParentDoubleBuffered = False
      object panelescritorio: TPanel
        Left = 3
        Top = 16
        Width = 609
        Height = 401
        BevelOuter = bvNone
        TabOrder = 0
        object botonEmpleado: TButton
          Left = 48
          Top = 161
          Width = 120
          Height = 60
          Action = dmActions.ActEmpleado
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = []
          ImageAlignment = iaTop
          ImageMargins.Top = 5
          Images = dmImages.VirtualImageList1
          ParentFont = False
          TabOrder = 0
          StyleName = 'Windows'
        end
        object botonPermisos: TButton
          Left = 48
          Top = 227
          Width = 120
          Height = 60
          Action = dmActions.ActPermisos
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = []
          ImageAlignment = iaTop
          ImageMargins.Top = 5
          Images = dmImages.VirtualImageList1
          ParentFont = False
          TabOrder = 1
          StyleName = 'Windows'
        end
        object botonProveedor: TButton
          Left = 48
          Top = 95
          Width = 120
          Height = 60
          Action = dmActions.ActProveedores
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = []
          ImageAlignment = iaTop
          ImageMargins.Top = 5
          Images = dmImages.VirtualImageList1
          ParentFont = False
          TabOrder = 2
          StyleName = 'Windows'
        end
        object botonFacturaSimp: TButton
          Left = 446
          Top = 293
          Width = 120
          Height = 60
          Caption = 'Factura Simplificada'
          DisabledImageIndex = 1
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = []
          ImageAlignment = iaTop
          ImageIndex = 3
          ImageMargins.Top = 5
          ParentFont = False
          TabOrder = 3
          Visible = False
          StyleName = 'Windows'
        end
        object botonPedido: TButton
          Left = 446
          Top = 293
          Width = 120
          Height = 60
          Caption = 'Pedido'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = []
          ImageAlignment = iaTop
          ImageIndex = 5
          ImageMargins.Top = 5
          ParentFont = False
          TabOrder = 4
          Visible = False
          StyleName = 'Windows'
        end
        object botonPresupuesto: TButton
          Left = 446
          Top = 293
          Width = 120
          Height = 60
          Caption = 'Presupuesto'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = []
          ImageAlignment = iaTop
          ImageIndex = 7
          ImageMargins.Top = 5
          ParentFont = False
          TabOrder = 5
          Visible = False
          StyleName = 'Windows'
        end
        object botonFactura: TButton
          Left = 446
          Top = 293
          Width = 120
          Height = 60
          Caption = 'Factura'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = []
          ImageAlignment = iaTop
          ImageIndex = 5
          ImageMargins.Top = 5
          ParentFont = False
          TabOrder = 6
          Visible = False
          StyleName = 'Windows'
        end
        object botonAlbaran: TButton
          Left = 446
          Top = 293
          Width = 120
          Height = 60
          Caption = 'Albar'#225'n'
          DisabledImageIndex = 1
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = []
          ImageAlignment = iaTop
          ImageIndex = 4
          ImageMargins.Top = 5
          ParentFont = False
          TabOrder = 7
          Visible = False
          StyleName = 'Windows'
        end
        object botonConfiguracion: TButton
          Left = 48
          Top = 293
          Width = 120
          Height = 60
          Caption = 'Configuraci'#243'n'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = []
          ImageAlignment = iaTop
          ImageIndex = 0
          ImageMargins.Top = 5
          ParentFont = False
          TabOrder = 8
          StyleName = 'Windows'
          OnClick = botonConfiguracionClick
        end
        object botonCerrarSesion: TButton
          Left = 184
          Top = 293
          Width = 120
          Height = 60
          Action = dmActions.actLogout
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = []
          ImageAlignment = iaTop
          ImageMargins.Top = 5
          Images = dmImages.VirtualImageList1
          ParentFont = False
          TabOrder = 9
          StyleName = 'Windows'
        end
        object botonCerrarApp: TButton
          Left = 320
          Top = 293
          Width = 120
          Height = 60
          Action = dmActions.actApagar
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = []
          ImageAlignment = iaTop
          ImageMargins.Top = 5
          Images = dmImages.VirtualImageList1
          ParentFont = False
          TabOrder = 10
          StyleName = 'Windows'
        end
        object botonServicios: TButton
          Left = 446
          Top = 293
          Width = 120
          Height = 60
          Caption = 'Servicios'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = []
          ImageAlignment = iaTop
          ImageIndex = 16
          ImageMargins.Top = 5
          ParentFont = False
          TabOrder = 11
          Visible = False
          StyleName = 'Windows'
        end
        object botonGastos: TButton
          Left = 446
          Top = 293
          Width = 120
          Height = 60
          Caption = 'Gastos'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = []
          ImageAlignment = iaTop
          ImageIndex = 15
          ImageMargins.Top = 5
          ParentFont = False
          TabOrder = 12
          Visible = False
          StyleName = 'Windows'
        end
        object botonEstadisticas: TButton
          Left = 446
          Top = 293
          Width = 120
          Height = 60
          Caption = 'Estadisticas'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = []
          ImageAlignment = iaTop
          ImageIndex = 14
          ImageMargins.Top = 5
          ParentFont = False
          TabOrder = 13
          Visible = False
          StyleName = 'Windows'
        end
        object Button1: TButton
          Left = 446
          Top = 293
          Width = 120
          Height = 60
          Caption = 'Empresa'
          DisabledImageIndex = 1
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = []
          ImageAlignment = iaTop
          ImageIndex = 1
          ImageMargins.Top = 5
          ParentFont = False
          TabOrder = 14
          Visible = False
          StyleName = 'Windows'
        end
        object btncliente: TButton
          Left = 48
          Top = 29
          Width = 120
          Height = 60
          Action = dmActions.ActCliente
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = []
          ImageAlignment = iaTop
          ImageMargins.Top = 5
          Images = dmImages.VirtualImageList1
          ParentFont = False
          TabOrder = 15
          StyleName = 'Windows'
        end
        object Button3: TButton
          Left = 184
          Top = 227
          Width = 120
          Height = 60
          Caption = 'Prueba de log'
          TabOrder = 16
          OnClick = Button3Click
        end
        object btnRegistros: TButton
          Left = 184
          Top = 95
          Width = 120
          Height = 60
          Action = dmActions.ActRegistros
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = []
          ImageAlignment = iaTop
          ImageMargins.Top = 5
          Images = dmImages.VirtualImageList1
          ParentFont = False
          TabOrder = 17
          StyleName = 'Windows'
        end
      end
      object Button2: TButton
        Left = 187
        Top = 177
        Width = 120
        Height = 60
        Caption = 'Prueba de toast'
        TabOrder = 1
        OnClick = Button2Click
      end
    end
  end
  object MenuPrincipalBar1: TActionMainMenuBar
    Left = 0
    Top = 0
    Width = 1008
    Height = 42
    UseSystemFont = False
    ActionManager = dmActions.ActionManager1
    Caption = 'MenuPrincipalBar1'
    Color = clMenuBar
    ColorMap.DisabledFontColor = 10461087
    ColorMap.HighlightColor = clWhite
    ColorMap.BtnSelectedFont = clBlack
    ColorMap.UnusedColor = clWhite
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    StyleName = 'Windows'
    Spacing = 0
  end
end
