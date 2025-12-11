unit FrameEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FrameBase, Vcl.StdCtrls, Vcl.ExtCtrls,dmUIActions, dmImageResources,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,dmconnection;

type
  TFrEdit = class(TFrBase)
    paneltop: TPanel;
    Buttonguardar: TButton;
    Buttonnuevo: TButton;
    Buttonsalir: TButton;
  private

    { Private declarations }

  public
    procedure DataSourceStateChange(Sender: TObject);
    Procedure doAdd; Override;
    Procedure Cargardatos(Id:Integer); Virtual;
    procedure NuevoRegistro; Virtual;
    { Public declarations }
  end;

var
  FrEdit: TFrEdit;

implementation

uses fmain;

Procedure TFrEdit.Cargardatos(Id:Integer);
begin
  //
end;

procedure TFrEdit.NuevoRegistro;
begin
  //
end;

procedure TFrEdit.DataSourceStateChange(Sender: TObject);
begin
buttonGuardar.Enabled := (DataSource.DataSet.State in dsEditModes);
end;

procedure TFrEdit.doAdd;
begin
 cargardatos(0);
end;


{$R *.dfm}

end.
