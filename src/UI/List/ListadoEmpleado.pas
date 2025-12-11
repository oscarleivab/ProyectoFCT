unit ListadoEmpleado;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FrameListado, Data.DB,Vcl.ComCtrls,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.ExtCtrls,
  edEmpleado, uInterfaces;

type
  TListadoFrameEmpleado = class(TListadoFrame)
  private
    procedure CargarListado(filtro: string); override;
    procedure EditarRegistro(id: Integer); override;
    function CanDeleteRecord(AId: Integer; out AReason: string): Boolean; override;
  public
  end;

var
  ListadoFrameEmpleado: TListadoFrameEmpleado;

implementation

uses
  fMain, uTranslator, uGridHelper;

{$R *.dfm}

procedure TListadoFrameEmpleado.CargarListado(filtro: string);
begin
  with FDQuery do
  begin
    SQL.Clear;
    SQL.Add('SELECT ');
    SQL.Add('  id,');
    SQL.Add('  id_tipo_documento,');
    SQL.Add('  detalle_documento,');
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
    SQL.Add('  id_permiso');
    SQL.Add('FROM empleado');

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

    // Ajusta el texto que quieras para la cabecera
    FDQuery.FieldByName('id').DisplayLabel :=
      T_('ListadoEmpleado', 'detalle_documento');
  end;

  // Ocultamos campos que no quieras ver en el grid
  HideGridColumns(DBGridListado,
    ['id', 'id_tipo_documento', 'observaciones', 'pass_login', 'id_permiso', 'activo']);

  // Ajuste automático según contenido (hasta 200 filas)
  AutoSizeDBGridColumns(DBGridListado, 200);
end;

procedure TListadoFrameEmpleado.EditarRegistro(id: Integer);
var
  Empleado: TFrEdEmpleado;
  nuevaTab: TTabSheet;
begin
  nuevaTab := TTabSheet.Create(frmMain.Pagecontrol1);
  nuevaTab.PageControl := frmMain.PageControl1;

  if id = 0 then
    nuevaTab.Caption := 'Nuevo Empleado'
  else
    nuevaTab.Caption :=
      Copy(
        Trim(Format('%s %s %s',
          [FDQuery.FieldByName('Nombre').AsString,
           FDQuery.FieldByName('Apellidos').AsString,
           FDQuery.FieldByName('Empresa').AsString])),
        1, 15
      ) + '...';

  Empleado := TFrEdEmpleado.Create(nuevaTab);
  Empleado.Parent := nuevaTab;
  Empleado.Align := alClient;
  Empleado.Origen := Self as IListadoRefrescable;

  frmMain.Pagecontrol1.ActivePageIndex :=
    frmMain.Pagecontrol1.PageCount - 1;

  Empleado.CargarDatos(id);
end;

function TListadoFrameEmpleado.CanDeleteRecord(AId: Integer; out AReason: string): Boolean;
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
      '  AND tabla = ''EMPLEADO''';

    Q.ParamByName('id').AsInteger := AId;
    Q.Open;
    Count := Q.FieldByName('total').AsInteger;

    if Count > 0 then
    begin
      Result := False;
      AReason := 'No se puede eliminar el empleado porque tiene direcciones asociadas.';
      Exit;
    end;

    // 2) ¿Tiene datos bancarios asociados?
    Q.Close;
    Q.SQL.Text :=
      'SELECT COUNT(*) AS total ' +
      'FROM datos_banco ' +
      'WHERE id_entidad = :id ' +
      '  AND tabla = ''EMPLEADO''';

    Q.ParamByName('id').AsInteger := AId;
    Q.Open;
    Count := Q.FieldByName('total').AsInteger;

    if Count > 0 then
    begin
      Result := False;
      AReason := 'No se puede eliminar el empleado porque tiene datos bancarios asociados.';
      Exit;
    end;

  finally
    Q.Free;
  end;

  // Si llegamos aquí: no tiene ni direcciones ni datos bancarios → se puede borrar
end;

end.

