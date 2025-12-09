unit ListadoProveedor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FrameListado, Vcl.Grids, Vcl.StdCtrls,
  Vcl.ComCtrls, Vcl.ExtCtrls, System.Generics.Collections,FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.DBGrids,edProveedor,utoashelper;

type
  TListadoFrameProveedor = class(TListadoFrame)
  private
    procedure CargarListado(filtro:string); override;
    procedure EditarRegistro(id: Integer); override;
    procedure EliminarRegistro(id: Integer); override;
  public
  procedure doEdit; override;
  procedure doSearch; override;
  procedure doDelete; override;
  protected
    procedure Loaded; override;
  end;

var
  FrBase: TListadoFrameProveedor;

implementation

uses
  fMain, uTranslator, uGridHelper;

{$R *.dfm}

procedure TListadoFrameProveedor.cargarlistado(filtro:string);
begin
  with FDQuery do
  begin
    SQL.Clear;
    SQL.Add('SELECT ');
    SQL.Add('  id,');
    SQL.Add('  id_tipo,');
    SQL.Add('  id_tipo_documento,');
    SQL.Add('  detalle_documento,');
    SQL.Add('  codigo_interno,');
    SQL.Add('  nombre,');
    SQL.Add('  apellidos,');
    SQL.Add('  empresa,');
    SQL.Add('  email,');
    SQL.Add('  observaciones,');
    SQL.Add('  telefono1,');
    SQL.Add('  telefono2,');
    SQL.Add('  persona_contacto,');
    SQL.Add('  url_web,');
    SQL.Add('  user_login,');
    SQL.Add('  pass_login,');
    SQL.Add('  activo,');
    SQL.Add('  id_permiso,');
    SQL.Add('  direcciones,');
    SQL.Add('  id_tarifa_aplicada,');
    SQL.Add('  datos_bancarios');
    SQL.Add('FROM proveedores');

    if not filtro.IsEmpty then
    begin
    SQL.Add('WHERE (');
    SQL.Add('  CAST(id AS TEXT) ILIKE :filtro');
    SQL.Add('  OR detalle_documento ILIKE :filtro');
    SQL.Add('  OR nombre ILIKE :filtro');
    SQL.Add('  OR apellidos ILIKE :filtro');
    SQL.Add('  OR nombre || '' '' || apellidos ILIKE :filtro');
    SQL.Add('  OR apellidos || '' '' || nombre ILIKE :filtro');
    SQL.Add('  OR empresa ILIKE :filtro');
    SQL.Add('  OR email ILIKE :filtro');
    SQL.Add('  OR observaciones ILIKE :filtro');
    SQL.Add('  OR telefono1 ILIKE :filtro');
    SQL.Add('  OR telefono2 ILIKE :filtro');
    SQL.Add('  OR persona_contacto ILIKE :filtro');
    SQL.Add('  OR direcciones ILIKE :filtro');
    SQL.Add('  OR datos_bancarios ILIKE :filtro');
    SQL.Add('  OR CAST(id_tarifa_aplicada AS TEXT) ILIKE :filtro');
    SQL.Add('  OR CAST(codigo_interno AS TEXT) ILIKE :filtro');
    SQL.Add(')');

      ParamByName('filtro').AsString := '%' + filtro.Trim + '%';
    end;

    SQL.Add('ORDER BY id');

    Open;
  end;
end;


procedure TListadoFrameProveedor.EditarRegistro(id: Integer);
var
  Proveedor: TFrEdProveedor;
  nuevaTab: TTabSheet;
begin
  nuevaTab := TTabSheet.Create(frmMain.Pagecontrol1);
  nuevaTab.PageControl := frmMain.PageControl1;

  if id = 0 then
    nuevaTab.Caption := 'Nuevo Proveedor'
  else
    nuevaTab.Caption := 'Proveedor ID ' + id.ToString;

  Proveedor := TFrEdProveedor.Create(nuevaTab);
  Proveedor.Parent := nuevaTab;
  Proveedor.Align := alClient;
  Proveedor.FrameOrigen:=self.Name;

  frmMain.Pagecontrol1.ActivePageIndex :=
    frmMain.Pagecontrol1.PageCount - 1;

  Proveedor.cargardatos(id);
end;

procedure TListadoFrameProveedor.Loaded;
begin
  inherited;
  // ...
end;


procedure TListadoFrameProveedor.doEdit;
begin
  EditarRegistro(FDQuery.FieldByName('id').AsInteger);
end;

procedure TListadoFrameProveedor.doSearch;
begin
Cargarlistado(buscaedit.Text);
end;

procedure TListadoFrameProveedor.doDelete;
       var
  id: Integer;
begin
  if FDQuery.IsEmpty then
    Exit;

  id := FDQuery.FieldByName('id').AsInteger;

  EliminarRegistro(id);
end;

procedure TListadoFrameProveedor.EliminarRegistro(id: Integer);
var
  Q: TFDQuery;
begin
  if MessageDlg('¿Eliminar el proveedor seleccionado?',
     mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    Exit;

  Q := TFDQuery.Create(nil);
  try
    Q.Connection := FDQuery.Connection;
    Q.SQL.Text := 'DELETE FROM proveedores WHERE id = :id';
    Q.ParamByName('id').AsInteger := id;
    Q.ExecSQL;
    MostrarToast(T_('Borrado Correctamente', 'errorbdprincipal'), 'success')
  finally
    Q.Free;
  end;

  // Refrescar el listado
  CargarListado(buscaedit.Text);
end;
end.

