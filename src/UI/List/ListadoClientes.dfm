inherited ListadoFrameCliente: TListadoFrameCliente
  inherited Panelfiltros: TPanel
    Height = 6
    ExplicitHeight = 6
    object cboPermisos: TComboBox
      Left = 234
      Top = 16
      Width = 145
      Height = 23
      TabOrder = 0
      Text = 'Filtrado por permisos'
      OnChange = cboPermisosChange
    end
    object cboTipoDocumento: TComboBox
      Left = 10
      Top = 16
      Width = 175
      Height = 23
      TabOrder = 1
      Text = 'Filtrado por tipo documento'
      OnChange = cboTipoDocumentoChange
    end
  end
  inherited DBGridListado: TDBGrid
    Top = 67
    Height = 599
  end
  inherited Menulateral: TPanel
    Top = 67
    Height = 609
  end
  inherited FDQuery: TFDQuery
    Left = 528
  end
  inherited DataSource: TDataSource
    Left = 456
  end
end
