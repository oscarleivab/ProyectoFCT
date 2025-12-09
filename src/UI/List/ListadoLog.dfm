inherited FrListadoLog: TFrListadoLog
  inherited Panelfiltros: TPanel
    Height = 11
    ExplicitHeight = 11
    object chkINFO: TCheckBox
      Left = 16
      Top = 16
      Width = 97
      Height = 17
      Caption = 'Filtrar por INFO'
      TabOrder = 0
    end
    object chkERROR: TCheckBox
      Left = 16
      Top = 39
      Width = 97
      Height = 17
      Caption = 'Filtrar por ERROR'
      TabOrder = 1
    end
  end
  inherited DBGridListado: TDBGrid
    Top = 76
    Height = 600
  end
end
