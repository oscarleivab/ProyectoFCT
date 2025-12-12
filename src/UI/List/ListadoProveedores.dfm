inherited ListadoFrameProveedores: TListadoFrameProveedores
  inherited Panelfiltros: TPanel
    Height = 70
    ExplicitHeight = 70
    object cboPermisos: TComboBox
      Left = 234
      Top = 32
      Width = 145
      Height = 23
      TabOrder = 0
      Text = 'Filtrado por permisos'
      OnChange = cboPermisosChange
    end
    object cboTipoDocumento: TComboBox
      Left = 10
      Top = 32
      Width = 175
      Height = 23
      TabOrder = 1
      Text = 'Filtrado por tipo documento'
      OnChange = cboTipoDocumentoChange
    end
  end
  inherited DBGridListado: TDBGrid
    Top = 131
    Height = 535
  end
  inherited Menulateral: TPanel
    Top = 131
    Height = 545
    ExplicitTop = 67
    ExplicitHeight = 609
  end
end
