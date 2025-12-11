unit ListadoProveedores;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FrameListado, Vcl.Grids, Vcl.StdCtrls,
  Vcl.ComCtrls, Vcl.ExtCtrls, System.Generics.Collections,FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.DBGrids,edProveedor,uInterfaces;

type
  TListadoFrameProveedores = class(TListadoFrame)
  private
    procedure CargarListado(filtro:string); override;
    procedure EditarRegistro(id: Integer); override;
    function CanDeleteRecord(AId: Integer; out AReason: string): Boolean; Override;
  public
  end;

var
  ListadoFrameProveedores: TListadoFrameProveedores;

implementation

uses
  fMain, uTranslator, uGridHelper;

{$R *.dfm}

procedure TListadoFrameProveedores.cargarlistado(filtro:string);
begin

  with FDQuery do begin
    SQL.Clear;
    SQL.Add('SELECT ');
      SQL.Add('id,');
      SQL.Add('id_tipo_documento,');
      SQL.Add('detalle_documento,');
      SQL.Add('nombre,');
      SQL.Add('apellidos,');
      SQL.Add('empresa,');
      SQL.Add('email,');
      SQL.Add('observaciones,');
      SQL.Add('telefono1,');
      SQL.Add('telefono2,');
      SQL.Add('id_tarifa, ');
      SQL.Add('persona_contacto,');
      SQL.Add('url_web,');
      SQL.Add('user_login, ');
      SQL.Add('pass_login,');
      SQL.Add('activo,');
      SQL.Add('id_permiso  ');
    SQL.Add('FROM proveedores');

    if not filtro.IsEmpty then
    begin
      SQL.Add('WHERE (');
      SQL.Add('      unaccent(CAST(id AS TEXT)) ILIKE unaccent(:filtro)');
      SQL.Add('   OR unaccent(detalle_documento) ILIKE unaccent(:filtro)');
      SQL.Add('   OR unaccent(nombre) ILIKE unaccent(:filtro)');
      SQL.Add('   OR unaccent(apellidos) ILIKE unaccent(:filtro)');
      SQL.Add('   OR unaccent(nombre || '' '' || apellidos) ILIKE unaccent(:filtro)');
      SQL.Add('   OR unaccent(apellidos || '' '' || nombre) ILIKE unaccent(:filtro)');
      SQL.Add('   OR unaccent(empresa) ILIKE unaccent(:filtro)');
      SQL.Add('   OR unaccent(email) ILIKE unaccent(:filtro)');
      SQL.Add('   OR unaccent(observaciones) ILIKE unaccent(:filtro)');
      SQL.Add('   OR unaccent(telefono1) ILIKE unaccent(:filtro)');
      SQL.Add('   OR unaccent(telefono2) ILIKE unaccent(:filtro)');
      SQL.Add('   OR unaccent(persona_contacto) ILIKE unaccent(:filtro)');
      SQL.Add(')');

      ParamByName('filtro').AsString := '%' + filtro.Trim + '%';
    end;
    SQL.Add('ORDER BY id');
    Open;
  end;

  HideGridColumns(DBGridListado, ['id','id_tipo_documento', 'observaciones','pass_login','id_tarifa','id_permiso','activo']);
    // Ajuste automático según contenido (hasta 200 filas)
  AutoSizeDBGridColumns(DBGridListado, 200);

end;


procedure TListadoFrameProveedores.EditarRegistro(id: Integer);
var
  Proveedor: TFrEdProveedor;
  nuevaTab: TTabSheet;
  stexto:String;
begin
  nuevaTab := TTabSheet.Create(frmMain.Pagecontrol1);
  nuevaTab.PageControl := frmMain.PageControl1;

  if id = 0 then
    nuevaTab.Caption := 'Nuevo Cliente'
  else
  nuevaTab.Caption := Copy(
  Trim(Format('%s %s %s',
    [FDQuery.FieldByName('Nombre').AsString,
     FDQuery.FieldByName('Apellidos').AsString,
     FDQuery.FieldByName('Empresa').AsString])),
      1, 15)+'...';

  Proveedor := TFrEdProveedor.Create(nuevaTab);
  Proveedor.Parent := nuevaTab;
  Proveedor.Align := alClient;
  Proveedor.Origen := Self as IListadoRefrescable;

  frmMain.Pagecontrol1.ActivePageIndex :=
    frmMain.Pagecontrol1.PageCount - 1;

  Proveedor.cargardatos(id);
end;


function TListadoFrameProveedores.CanDeleteRecord(AId: Integer; out AReason: string): Boolean;
var
  Q: TFDQuery;
  Count: Integer;
begin
  Result := True;
  AReason := '';

  Q := TFDQuery.Create(nil);
  try
    Q.Connection := FDQuery.Connection;

    // 1) ¿Tiene direcciones asociadas?
    Q.SQL.Text :=
      'SELECT COUNT(*) AS total ' +
      'FROM datos_direccion ' +
      'WHERE id_entidad = :id ' +
      '  AND tabla = ''PROVEEDORES''';

    Q.ParamByName('id').AsInteger := AId;
    Q.Open;
    Count := Q.FieldByName('total').AsInteger;

    if Count > 0 then
    begin
      Result := False;
      AReason := 'No se puede eliminar el cliente porque tiene direcciones asociadas.';
      Exit;
    end;

    // 2) ¿Tiene datos bancarios asociados?
    Q.Close;
    Q.SQL.Text :=
      'SELECT COUNT(*) AS total ' +
      'FROM datos_banco ' +
      'WHERE id_entidad = :id ' +
      '  AND tabla = ''PROVEEDORES''';

    Q.ParamByName('id').AsInteger := AId;
    Q.Open;
    Count := Q.FieldByName('total').AsInteger;

    if Count > 0 then
    begin
      Result := False;
      AReason := 'No se puede eliminar el cliente porque tiene datos bancarios asociados.';
      Exit;
    end;

  finally
    Q.Free;
  end;

  // Si llegamos aquí: no tiene ni direcciones ni datos bancarios → se puede borrar
end;

end.
