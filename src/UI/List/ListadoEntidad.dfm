inherited ListadoEntidadFrame: TListadoEntidadFrame
  inherited Panelfiltros: TPanel
    Height = 34
    ExplicitHeight = 34
    object activocheck: TToggleSwitch
      Left = 12
      Top = 7
      Width = 98
      Height = 20
      State = tssOn
      StateCaptions.CaptionOn = 'Activo'
      StateCaptions.CaptionOff = 'Inactivo'
      TabOrder = 0
    end
  end
  inherited Listadogrid: TStringGrid
    Top = 159
    Height = 507
    ExplicitTop = 159
    ExplicitHeight = 507
  end
end
