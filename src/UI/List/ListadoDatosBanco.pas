unit ListadoDatosBanco;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FrameListado, Data.DB,Vcl.ComCtrls,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.ExtCtrls,
  edDatosBanco, uInterfaces; // asumo que tendrás un editor edDatosBanco

type
  TListadoFrameDatosBanco = class(TListadoFrame)
  private
    entidadActiva: Integer;
    tablaActiva: string;

    procedure CargarListado(filtro: string); override;
    procedure EditarRegistro(id: Integer); override;
  public
    procedure CargarListadoEntidad(Id: Integer; const Tabla: string);
  end;

var
  ListadoFrameDatosBanco: TListadoFrameDatosBanco;

implementation

uses
  fMain, uTranslator, uGridHelper;

{$R *.dfm}

procedure TListadoFrameDatosBanco.CargarListado(filtro: string);
begin
  // Si tenemos entidad+tabla activas, usamos el listado por entidad
  if (entidadActiva <> 0) and (tablaActiva <> '') then
  begin
    CargarListadoEntidad(entidadActiva, tablaActiva);
    Exit;
  end;

  // Listado general (sin filtrar por entidad)
  with FDQuery do
  begin
    SQL.Clear;
    SQL.Add('SELECT ');
    SQL.Add('  id,');
    SQL.Add('  id_entidad,');
    SQL.Add('  sucursal,');
    SQL.Add('  ccc,');
    SQL.Add('  observacion,');
    SQL.Add('  tabla');
    SQL.Add('FROM datos_banco');

    if not filtro.IsEmpty then
    begin
      SQL.Add('WHERE (');
      SQL.Add('      unaccent(CAST(id AS TEXT)) ILIKE unaccent(:filtro)');
      SQL.Add('   OR unaccent(CAST(id_entidad AS TEXT)) ILIKE unaccent(:filtro)');
      SQL.Add('   OR unaccent(sucursal) ILIKE unaccent(:filtro)');
      SQL.Add('   OR unaccent(ccc) ILIKE unaccent(:filtro)');
      SQL.Add('   OR unaccent(observacion) ILIKE unaccent(:filtro)');
      SQL.Add('   OR unaccent(tabla) ILIKE unaccent(:filtro)');
      SQL.Add(')');

      ParamByName('filtro').AsString := '%' + filtro.Trim + '%';
    end;

    SQL.Add('ORDER BY id');
    Open;

    // Ajuste automático según contenido (hasta 200 filas)
    AutoSizeDBGridColumns(DBGridListado, 200);
  end;


end;

procedure TListadoFrameDatosBanco.CargarListadoEntidad(Id: Integer; const Tabla: string);
begin
  entidadActiva := Id;
  tablaActiva := Tabla;

  // Habilitar/deshabilitar botones según haya entidad activa
  if entidadactiva=0 then
  begin
  botonnuevo.Enabled:=false;
  botonnuevo2.Enabled:=false;
  botoneditar.Enabled:=false;
  botoneditar2.Enabled:=false;
  btnborrar.Enabled:=false;
  btnborrar2.Enabled:=false;
  end
  else
  begin
  botonnuevo.Enabled:=true;
  botonnuevo2.Enabled:=true;
  botoneditar.Enabled:=true;
  botoneditar2.Enabled:=true;
  btnborrar.Enabled:=true;
  btnborrar2.Enabled:=true;
  end;

  FDQuery.Close;
  with FDQuery do
  begin
    SQL.Clear;
    SQL.Add('SELECT ');
    SQL.Add('  id,');
    SQL.Add('  id_entidad,');
    SQL.Add('  sucursal,');
    SQL.Add('  ccc,');
    SQL.Add('  observacion,');
    SQL.Add('  tabla');
    SQL.Add('FROM datos_banco');
    SQL.Add('WHERE (id_entidad = :pid AND tabla = :ptabla)');
    ParamByName('pid').AsInteger   := Id;
    ParamByName('ptabla').AsString := Tabla;
    SQL.Add('ORDER BY id');
    Open;

    // Ajuste automático según contenido (hasta 200 filas)
    AutoSizeDBGridColumns(DBGridListado, 200);
  end;
end;

procedure TListadoFrameDatosBanco.EditarRegistro(id: Integer);
var
  Banco: TFrEdDatosBanco;
  nuevaTab: TTabSheet;
begin
  // Si no hay entidad activa, no permitimos crear/editar
  if entidadActiva = 0 then
  begin
    MostrarToast(T_('info', 'entidadbanco'), 'warning'); // define esta clave en el traductor
    Exit;
  end;

  nuevaTab := TTabSheet.Create(frmMain.PageControl1);
  nuevaTab.PageControl := frmMain.PageControl1;

  if id = 0 then
    nuevaTab.Caption := 'Nuevo dato bancario'
  else
    nuevaTab.Caption := 'Banco ID ' + id.ToString;

  Banco := TFrEdDatosBanco.Create(nuevaTab);
  Banco.Parent := nuevaTab;
  Banco.Align := alClient;
  Banco.Origen := Self as IListadoRefrescable;

  frmMain.PageControl1.ActivePageIndex :=
    frmMain.PageControl1.PageCount - 1;

  Banco.CargarDatos(id);

  // Si es nuevo, forzamos entidad+tabla
  if id = 0 then
  begin
    Banco.DataSource.DataSet.FieldByName('tabla').AsString      := tablaActiva;
    Banco.DataSource.DataSet.FieldByName('id_entidad').AsInteger := entidadActiva;
  end;
end;

end.

