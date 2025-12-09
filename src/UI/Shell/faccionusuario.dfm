object Dialogouserfrm: TDialogouserfrm
  Left = 0
  Top = 0
  BorderIcons = [biMinimize, biMaximize]
  BorderStyle = bsDialog
  Caption = 'Dialogoopcionusuario'
  ClientHeight = 191
  ClientWidth = 526
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poMainFormCenter
  StyleName = 'Windows'
  TextHeight = 15
  object Panelaccion: TPanel
    Left = 0
    Top = 0
    Width = 526
    Height = 81
    Align = alTop
    BevelOuter = bvNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object Labelaccionusuario: TLabel
      Left = 0
      Top = 0
      Width = 104
      Height = 21
      Align = alClient
      Alignment = taCenter
      Caption = 'Acci'#243'n Usuario'
      Layout = tlCenter
      WordWrap = True
    end
  end
  object panelaceptar: TPanel
    Left = 0
    Top = 81
    Width = 526
    Height = 110
    Align = alClient
    TabOrder = 2
    Visible = False
    object botonaceptar: TButton
      AlignWithMargins = True
      Left = 11
      Top = 11
      Width = 504
      Height = 88
      Margins.Left = 10
      Margins.Top = 10
      Margins.Right = 10
      Margins.Bottom = 10
      Align = alClient
      Caption = 'Aceptar'
      ModalResult = 1
      TabOrder = 0
      StyleName = 'Windows'
      OnClick = botonaceptarClick
    end
  end
  object Paneleleccion: TPanel
    Left = 0
    Top = 81
    Width = 526
    Height = 110
    Align = alClient
    TabOrder = 1
    Visible = False
    object Botonsi: TButton
      AlignWithMargins = True
      Left = 11
      Top = 11
      Width = 160
      Height = 88
      Margins.Left = 10
      Margins.Top = 10
      Margins.Bottom = 10
      Align = alLeft
      Caption = 'SI'
      ModalResult = 6
      TabOrder = 0
      StyleName = 'Windows'
      OnClick = BotonsiClick
    end
    object Botonno: TButton
      AlignWithMargins = True
      Left = 184
      Top = 11
      Width = 158
      Height = 88
      Margins.Left = 10
      Margins.Top = 10
      Margins.Right = 10
      Margins.Bottom = 10
      Align = alClient
      Caption = 'NO'
      ModalResult = 7
      TabOrder = 1
      StyleName = 'Windows'
      OnClick = BotonnoClick
    end
    object Botoncancelar: TButton
      AlignWithMargins = True
      Left = 355
      Top = 11
      Width = 160
      Height = 88
      Margins.Top = 10
      Margins.Right = 10
      Margins.Bottom = 10
      Align = alRight
      Caption = 'CANCELAR'
      ModalResult = 2
      TabOrder = 2
      StyleName = 'Windows'
      OnClick = BotoncancelarClick
    end
  end
end
