object Frame2: TFrame2
  Left = 0
  Top = 0
  Width = 800
  Height = 599
  TabOrder = 0
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 800
    Height = 599
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Panel1'
    ParentBackground = False
    TabOrder = 0
    StyleName = 'Windows'
    ExplicitHeight = 600
    object Panel2: TPanel
      Left = 0
      Top = 0
      Width = 800
      Height = 41
      Caption = 'Panel2'
      TabOrder = 0
    end
    object PanelCard: TPanel
      Left = 196
      Top = 159
      Width = 440
      Height = 281
      BevelOuter = bvNone
      Color = clWindow
      TabOrder = 1
      object Button1: TButton
        Left = 168
        Top = 216
        Width = 75
        Height = 25
        Caption = 'Button1'
        TabOrder = 0
      end
      object Button2: TButton
        Left = 296
        Top = 216
        Width = 75
        Height = 25
        Caption = 'Button2'
        TabOrder = 1
      end
      object ComboBox1: TComboBox
        Left = 208
        Top = 144
        Width = 145
        Height = 23
        TabOrder = 2
        Text = 'ComboBox1'
      end
      object ComboBox2: TComboBox
        Left = 208
        Top = 173
        Width = 145
        Height = 23
        TabOrder = 3
        Text = 'ComboBox2'
      end
      object Edit1: TEdit
        Left = 208
        Top = 96
        Width = 121
        Height = 23
        TabOrder = 4
        Text = 'Edit1'
      end
    end
  end
end
