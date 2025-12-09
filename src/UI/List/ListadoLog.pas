unit ListadoLog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FrameListado, Vcl.Grids,
  Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls, System.Generics.Collections,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.DBGrids, FrameBase, uLog;

type
  TFrListadoLog = class(TListadoFrame)
    chkINFO: TCheckBox;
    chkERROR: TCheckBox;
  private
    procedure CargarListado(filtro: string); override;
    //procedure EditarRegistro(id: Integer); override;
    //procedure EliminarRegistro(id: Integer); override;
  protected
    procedure Loaded; override;
  public
    procedure doSearch; override;
    procedure doFilter; override;
  end;

var
  FrListadoLog: TFrListadoLog;

implementation

uses
  fMain, uTranslator, uGridHelper;

{$R *.dfm}



{ ------------------------------------------- }
{  CARGAR LISTADO DE LOGBD                    }
{ ------------------------------------------- }

procedure TFrListadoLog.CargarListado(filtro: string);
var
  tiposSeleccionados: TStringList;
  i: Integer;
begin
  tiposSeleccionados := TStringList.Create;
  try
    with FDQuery do
    begin
      SQL.Clear;
      SQL.Add('SELECT id AS ID, tipo, observaciones, "USER" AS usuario, tipodoc, iddoc, fechahora');
      SQL.Add('FROM logbd');
      SQL.Add('WHERE 1=1');

      // Filtro por observaciones
      if filtro.Trim <> '' then
      begin
        SQL.Add('  AND observaciones ILIKE :f');
        ParamByName('f').AsString := '%' + filtro.Trim + '%';
      end;

      // Filtro por tipo usando checkboxes
      tiposSeleccionados.Clear;
      if chkINFO.Checked then tiposSeleccionados.Add('0');
      if chkERROR.Checked then tiposSeleccionados.Add('1');
      // si más checkboxes, solo añadirlos aquí
      if tiposSeleccionados.Count > 0 then
        SQL.Add('  AND tipo IN (' + tiposSeleccionados.CommaText + ')');

      SQL.Add('ORDER BY id ASC');
      Open;
    end;
  finally
    tiposSeleccionados.Free;
  end;
end;



procedure TFrListadoLog.Loaded;
begin
  inherited;
  Botonnuevo.Visible := False;
  Botoneditar.Visible := False;
  btnborrar.Visible := False;
  TranslateTree(Self, '');
end;


procedure TFrListadoLog.doSearch;
begin
  CargarListado(buscaedit.Text);
end;

procedure TFrListadoLog.doFilter;
begin
  if Panelfiltros.Height < 50 then
    Panelfiltros.Height := 64  // mostrar panel
  else
    Panelfiltros.Height := 5;   // ocultar panel
end;
end.

