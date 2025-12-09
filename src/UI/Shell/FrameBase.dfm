object FrBase: TFrBase
  Left = 0
  Top = 0
  Width = 640
  Height = 480
  TabOrder = 0
  object FDQuery: TFDQuery
    SQL.Strings = (
      '')
    Left = 552
    Top = 32
  end
  object DataSource: TDataSource
    DataSet = FDQuery
    Left = 480
    Top = 32
  end
end
