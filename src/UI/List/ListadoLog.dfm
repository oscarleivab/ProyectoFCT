inherited FrListadoLog: TFrListadoLog
  inherited Panelfiltros: TPanel
    Height = 6
    ExplicitHeight = 6
    object chkERROR: TCheckBox
      Left = 16
      Top = 39
      Width = 97
      Height = 17
      Caption = 'Filtrar por ERROR'
      TabOrder = 0
      OnClick = chkERRORClick
    end
    object chkINFO: TCheckBox
      Left = 16
      Top = 16
      Width = 97
      Height = 17
      Caption = 'Filtrar por INFO'
      TabOrder = 1
      OnClick = chkINFOClick
    end
  end
  inherited DBGridListado: TDBGrid
    Top = 67
    Height = 599
  end
  inherited Menulateral: TPanel
    Top = 67
    Height = 609
    ExplicitTop = 67
    ExplicitHeight = 609
  end
end
