object DataModule3: TDataModule3
  Height = 257
  Width = 331
  object ActionManager1: TActionManager
    Images = DataModule2.VirtualImageList1
    Left = 144
    Top = 104
    StyleName = 'Platform Default'
    object actLogin: TAction
      Caption = 'Conectar'
      ImageIndex = 2
      ImageName = 'loginico'
      OnExecute = actLoginExecute
    end
    object actLogout: TAction
      ImageIndex = 3
      ImageName = 'logoutico'
    end
    object actApagar: TAction
      ImageIndex = 0
      ImageName = 'apagarico'
    end
  end
end
