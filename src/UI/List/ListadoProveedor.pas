unit ListadoProveedor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FrameListado, Vcl.Grids, Vcl.StdCtrls,
  Vcl.ComCtrls, Vcl.ExtCtrls, System.Generics.Collections,FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.DBGrids, edProveedor,
  FrameBase;

type
  TFrBase1 = class(TListadoFrame)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ListadoFrameProveedor: TFrBase1;

implementation

{$R *.dfm}

end.
