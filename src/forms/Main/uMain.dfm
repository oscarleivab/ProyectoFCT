object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'Main'
  ClientHeight = 634
  ClientWidth = 1013
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object ActionMainMenuBar1: TActionMainMenuBar
    Left = 0
    Top = 0
    Width = 1013
    Height = 29
    UseSystemFont = False
    Caption = 'ActionMainMenuBar1'
    Color = clMenuBar
    ColorMap.DisabledFontColor = 10461087
    ColorMap.HighlightColor = clWhite
    ColorMap.BtnSelectedFont = clBlack
    ColorMap.UnusedColor = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    Spacing = 0
    ExplicitWidth = 624
  end
  object TabSheetPrincipal: TPageControl
    Left = 0
    Top = 48
    Width = 1014
    Height = 584
    ActivePage = TabSheet1
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = 'Principal'
      object Button1: TButton
        Left = 3
        Top = 3
        Width = 57
        Height = 41
        Action = DataModule3.actLogout
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ImageAlignment = iaTop
        ImageMargins.Top = 5
        Images = DataModule2.VirtualImageList1
        ParentFont = False
        TabOrder = 0
        StyleName = 'Windows'
      end
      object Button2: TButton
        Left = 966
        Top = 507
        Width = 37
        Height = 44
        Action = DataModule3.actApagar
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ImageAlignment = iaTop
        ImageMargins.Top = 5
        Images = DataModule2.VirtualImageList1
        ParentFont = False
        TabOrder = 1
        StyleName = 'Windows'
      end
    end
  end
end
