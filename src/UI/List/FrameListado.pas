unit FrameListado;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.WinXPickers,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.VCLUI.Wait,
  Data.DB, FireDAC.Comp.Client, FireDAC.Phys.IBDef, FireDAC.Phys.IBBase,
  FireDAC.Phys.IB, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, Vcl.Grids, Vcl.ExtCtrls,
  Vcl.Buttons, Datasnap.Provider, Datasnap.DBClient, Vcl.DBGrids,ClipBrd,
  Vcl.DBCtrls, Vcl.ComCtrls, FrameBase,uColores,dmUIActions, dmImageResources,dmconnection;

type
  TListadoFrame = class(TFrBase)
    panelbusquedavanzada: TPanel;
    buscaedit: TEdit;
    botonbuscar: TButton;
    botonborrarfiltro: TButton;
    botonfiltrar: TButton;
    Panelfiltros: TPanel;
    Botonnuevo: TButton;
    Botoneditar: TButton;
    botonsalir: TButton;
    btnborrar: TButton;
    DBGridListado: TDBGrid;
  private

    { Private declarations }
  public
    { Public declarations }
    procedure CargarListado(filtro:string); Virtual;
    procedure EditarRegistro(id: Integer); Virtual;
    procedure EliminarRegistro(id: Integer); Virtual;
    procedure doClearFilter; Override;
    procedure doSearch; override;
    procedure doEdit; override;
    procedure doAdd; override;
    procedure doDelete; override;
    procedure ActualizarRegistro(AId: Integer);

  Protected
    procedure Loaded; override;
  end;

var
  ListadoFrame: TListadoFrame;

implementation

{$R *.dfm}

{ TListadoFrame }

procedure TListadoFrame.ActualizarRegistro(AId: Integer);
begin
  FDQuery.DisableControls;
  try
    FDQuery.Refresh;                        // vuelve a ejecutar el SELECT
    FDQuery.Locate('id', AId, []);  // vuelve a la fila
  finally
    FDQuery.EnableControls;
  end;
end;

procedure TListadoFrame.doSearch;
begin
Cargarlistado(buscaedit.Text);
end;

procedure TListadoFrame.doEdit;
begin
EditarRegistro(FDQuery.FieldByName('id').AsInteger);
end;

procedure TListadoFrame.doAdd;
begin
EditarRegistro(0);
end;

procedure TListadoFrame.doDelete;
begin

end;


procedure TListadoFrame.doClearFilter;
begin
//
buscaedit.Text:='';
doSearch;
end;

procedure TListadoFrame.CargarListado;
begin
//
end;

procedure TListadoFrame.EditarRegistro;
begin
//
end;

procedure TListadoFrame.EliminarRegistro(id: Integer);
begin
//
end;

procedure TListadoFrame.Loaded;
begin
  inherited;
  Panelfiltros.Height:=5;
end;


end.
