object FrConfiguracion: TFrConfiguracion
  Left = 0
  Top = 0
  Width = 640
  Height = 480
  TabOrder = 0
  object btnCerrar: TButton
    Left = 547
    Top = 16
    Width = 75
    Height = 25
    Caption = 'Cerrar'
    TabOrder = 0
    OnClick = btnCerrarClick
  end
  object cboidiomac: TComboBox
    Left = 48
    Top = 17
    Width = 145
    Height = 23
    TabOrder = 1
    Text = 'Idioma'
  end
end
