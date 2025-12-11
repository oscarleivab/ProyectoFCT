unit ListadoDirecciones;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FrameListado, Vcl.Grids, Vcl.StdCtrls,
  Vcl.ComCtrls, Vcl.ExtCtrls, System.Generics.Collections,FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.DBGrids,edDireccion,uInterfaces;

type
  TListadoFrameDirecciones = class(TListadoFrame)
  private
    { Private declarations }
    entidadactiva:integer;
    tablaactiva:string;
    procedure cargarlistado(filtro:string); Override;
    procedure EditarRegistro(id: Integer); override;
 //   procedure EliminarRegistro(id: Integer); override;
  public
    procedure cargarlistadoentidad(id:integer;tabla:string);
    { Public declarations }
  end;

var
  ListadoFrameDirecciones: TListadoFrameDirecciones;

implementation

uses
  fMain, uTranslator, uGridHelper;

{$R *.dfm}

procedure TListadoFrameDirecciones.cargarListado(filtro: string);
begin

  if (entidadactiva<>0) and (tablaactiva<>'') then
  cargarlistadoentidad(entidadactiva,tablaactiva)
  else
  begin
  with FDQuery do
  begin
    SQL.Clear;
    SQL.Add('SELECT ');
    SQL.Add('  id,');
    SQL.Add('  id_entidad,');
    SQL.Add('  detalle,');
    SQL.Add('  direccion,');
    SQL.Add('  poblacion,');
    SQL.Add('  provincia,');
    SQL.Add('  pais,');
    SQL.Add('  cp');
    SQL.Add('FROM datos_direccion');

    if not filtro.IsEmpty then
    begin
      SQL.Add('WHERE (');
      SQL.Add('      unaccent(CAST(id AS TEXT)) ILIKE unaccent(:filtro)');
      SQL.Add('   OR unaccent(CAST(id_entidad AS TEXT)) ILIKE unaccent(:filtro)');
      SQL.Add('   OR unaccent(detalle) ILIKE unaccent(:filtro)');
      SQL.Add('   OR unaccent(direccion) ILIKE unaccent(:filtro)');
      SQL.Add('   OR unaccent(poblacion) ILIKE unaccent(:filtro)');
      SQL.Add('   OR unaccent(provincia) ILIKE unaccent(:filtro)');
      SQL.Add('   OR unaccent(pais) ILIKE unaccent(:filtro)');
      SQL.Add('   OR unaccent(cp) ILIKE unaccent(:filtro)');
      SQL.Add(')');

      ParamByName('filtro').AsString := '%' + filtro.Trim + '%';
    end;

    SQL.Add('ORDER BY id');

    Open;

    // Ajuste automático según contenido (hasta 200 filas)
    AutoSizeDBGridColumns(DBGridListado, 200);
  end;
  end;


end;

procedure TListadoFrameDirecciones.cargarlistadoentidad(Id:integer;tabla:string);
begin

  entidadactiva:=Id;
  tablaactiva:=tabla;

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
    SQL.Add('  detalle,');
    SQL.Add('  direccion,');
    SQL.Add('  poblacion,');
    SQL.Add('  provincia,');
    SQL.Add('  pais,');
    SQL.Add('  cp');
    SQL.Add('FROM datos_direccion');

      SQL.Add('WHERE (');
      SQL.Add('id_entidad=:pid and tabla=:ptabla');
      SQL.Add(')');

      ParamByName('pid').AsInteger := Id;
      ParamByName('ptabla').AsString := tabla;

    SQL.Add('ORDER BY id');

    Open;

    // Ajuste automático según contenido (hasta 200 filas)
    AutoSizeDBGridColumns(DBGridListado, 200);
  end;
end;


procedure TListadoFrameDirecciones.EditarRegistro(id: Integer);
var
  Direccion: TFrEditDireccion;
  nuevaTab: TTabSheet;
begin

  if entidadactiva=0 then
  begin
  MostrarToast(T_('info','entidaddireccion'),'warning')
  end
  else
  begin
    nuevaTab := TTabSheet.Create(frmMain.Pagecontrol1);
    nuevaTab.PageControl := frmMain.PageControl1;

    if id = 0 then
      nuevaTab.Caption := 'Nueva Dirección'
    else
      nuevaTab.Caption := 'Dirección ID ' + id.ToString;

    Direccion := TFrEditDireccion.Create(nuevaTab);
    Direccion.Parent := nuevaTab;
    Direccion.Align := alClient;
    Direccion.Origen := Self as IListadoRefrescable;

    frmMain.Pagecontrol1.ActivePageIndex :=
      frmMain.Pagecontrol1.PageCount - 1;


    Direccion.cargardatos(id);

    if id=0 then
    begin
    Direccion.DataSource.DataSet.FieldByName('tabla').AsString := tablaactiva;
    Direccion.DataSource.DataSet.FieldByName('id_entidad').AsInteger := entidadactiva;
    end;
  end;

end;



end.
