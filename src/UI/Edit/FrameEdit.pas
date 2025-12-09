unit FrameEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FrameBase, Vcl.StdCtrls, Vcl.ExtCtrls,dmUIActions, dmImageResources,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

type
  TFrEdit = class(TFrBase)
    paneltop: TPanel;
    Buttonguardar: TButton;
    Buttonnuevo: TButton;
    Buttonsalir: TButton;
  private
    { Private declarations }
  public
    Procedure Cargardatos(Id:Integer); Virtual;
    { Public declarations }
  end;

var
  FrEdit: TFrEdit;

implementation

Procedure TFrEdit.Cargardatos(Id:Integer);
begin
  //
end;



{$R *.dfm}

end.
