object W: TW
  Height = 208
  Width = 640
  object FDConnectionMain: TFDConnection
    Params.Strings = (
      'DriverID=PG')
    Left = 80
    Top = 80
  end
  object FDConnectionCompany: TFDConnection
    Params.Strings = (
      'DriverID=PG')
    Left = 216
    Top = 80
  end
  object FDPhysPgDriverLink1: TFDPhysPgDriverLink
    Left = 360
    Top = 80
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 488
    Top = 80
  end
end
