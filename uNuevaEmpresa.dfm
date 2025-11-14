object frmNuevaEmpresa: TfrmNuevaEmpresa
  Left = 0
  Top = 0
  Caption = 'A'#241'adir nueva empresa'
  ClientHeight = 284
  ClientWidth = 375
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object Edit1: TEdit
    Left = 80
    Top = 64
    Width = 217
    Height = 23
    TabOrder = 0
    TextHint = 'Introduce el nombre de la empresa'
  end
  object Edit2: TEdit
    Left = 80
    Top = 93
    Width = 217
    Height = 23
    TabOrder = 1
    TextHint = 'Introduce el nombre de la BD'
  end
  object Edit3: TEdit
    Left = 80
    Top = 122
    Width = 217
    Height = 23
    TabOrder = 2
    TextHint = 'Introduce el nombre de usuario'
  end
  object Edit4: TEdit
    Left = 80
    Top = 151
    Width = 217
    Height = 23
    TabOrder = 3
    TextHint = 'Introduce la contrase'#241'a del usuario'
  end
  object Button1: TButton
    Left = 64
    Top = 180
    Width = 121
    Height = 25
    Caption = 'Continuar'
    TabOrder = 4
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 191
    Top = 180
    Width = 121
    Height = 25
    Caption = 'Cancelar'
    TabOrder = 5
    OnClick = Button2Click
  end
  object FDQuery1: TFDQuery
    Left = 344
    Top = 8
  end
end
