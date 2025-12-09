inherited ListadoFrame: TListadoFrame
  Width = 882
  Height = 676
  ExplicitWidth = 882
  ExplicitHeight = 676
  object panelbusquedavanzada: TPanel [0]
    AlignWithMargins = True
    Left = 3
    Top = 10
    Width = 876
    Height = 46
    Margins.Top = 10
    Align = alTop
    BevelOuter = bvNone
    Caption = 'paneltop'
    ParentColor = True
    ShowCaption = False
    TabOrder = 0
    StyleName = 'Windows'
    object buscaedit: TEdit
      AlignWithMargins = True
      Left = 164
      Top = 10
      Width = 406
      Height = 26
      Margins.Left = 10
      Margins.Top = 10
      Margins.Bottom = 10
      Align = alLeft
      TabOrder = 0
      TextHint = 'Texto a buscar'
      ExplicitHeight = 23
    end
    object botonbuscar: TButton
      AlignWithMargins = True
      Left = 583
      Top = 3
      Width = 40
      Height = 40
      Margins.Left = 10
      Action = dmActions.actSearch
      Align = alLeft
      ImageAlignment = iaCenter
      Images = dmImages.VirtualImageList1
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      StyleName = 'Windows'
    end
    object botonborrarfiltro: TButton
      AlignWithMargins = True
      Left = 631
      Top = 3
      Width = 40
      Height = 40
      Margins.Left = 5
      Action = dmActions.actClearFilter
      Align = alLeft
      ImageAlignment = iaCenter
      Images = dmImages.VirtualImageList1
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      StyleName = 'Windows'
    end
    object botonfiltrar: TButton
      AlignWithMargins = True
      Left = 679
      Top = 3
      Width = 40
      Height = 40
      Margins.Left = 5
      Action = dmActions.actFilter
      Align = alLeft
      ImageAlignment = iaCenter
      Images = dmImages.VirtualImageList1
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      StyleName = 'Windows'
    end
    object Botonnuevo: TButton
      AlignWithMargins = True
      Left = 15
      Top = 3
      Width = 40
      Height = 40
      Margins.Left = 15
      Action = dmActions.actAdd
      Align = alLeft
      ImageAlignment = iaCenter
      Images = dmImages.VirtualImageList1
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      StyleName = 'Windows'
    end
    object Botoneditar: TButton
      AlignWithMargins = True
      Left = 63
      Top = 3
      Width = 40
      Height = 40
      Margins.Left = 5
      Action = dmActions.actEdit
      Align = alLeft
      ImageAlignment = iaCenter
      Images = dmImages.VirtualImageList1
      ParentShowHint = False
      ShowHint = True
      TabOrder = 5
      StyleName = 'Windows'
    end
    object botonsalir: TButton
      AlignWithMargins = True
      Left = 821
      Top = 3
      Width = 40
      Height = 40
      Margins.Left = 5
      Margins.Right = 15
      Action = dmActions.actClose
      Align = alRight
      ImageAlignment = iaCenter
      Images = dmImages.VirtualImageList1
      TabOrder = 6
      StyleName = 'Windows'
    end
    object btnborrar: TButton
      AlignWithMargins = True
      Left = 111
      Top = 3
      Width = 40
      Height = 40
      Margins.Left = 5
      Action = dmActions.actDelete
      Align = alLeft
      ImageAlignment = iaCenter
      Images = dmImages.VirtualImageList1
      ParentShowHint = False
      ShowHint = True
      TabOrder = 7
      StyleName = 'Windows'
    end
  end
  object Panelfiltros: TPanel [1]
    AlignWithMargins = True
    Left = 10
    Top = 62
    Width = 862
    Height = 7
    Margins.Left = 10
    Margins.Right = 10
    Align = alTop
    BevelOuter = bvNone
    Caption = 'paneltop'
    Color = 16382457
    ParentBackground = False
    ShowCaption = False
    TabOrder = 1
    StyleName = 'Windows'
  end
  object DBGridListado: TDBGrid [2]
    Left = 0
    Top = 72
    Width = 882
    Height = 604
    Align = alClient
    DataSource = DataSource
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
  end
  inherited FDQuery: TFDQuery
    Connection = DataModuleConnection.FDConnectionCompany
    Left = 472
    Top = 24
  end
  inherited DataSource: TDataSource
    Left = 408
    Top = 24
  end
end
