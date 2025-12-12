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
    cboPermisos: TComboBox;
    cboTipoDocumento: TComboBox;
    procedure cboPermisosChange(Sender: TObject);
    procedure cboTipoDocumentoChange(Sender: TObject);
  private
    procedure CargarListado(filtro: string); override;
    procedure EditarRegistro(id: Integer); override;
    function CanDeleteRecord(AId: Integer; out AReason: string): Boolean; override;
    procedure CargarCombos;

  public
    constructor Create(AOwner: TComponent); override;
    procedure AplicarPermisos; override;
  end;

var
  ListadoFrameEmpleado: TListadoFrameEmpleado;

implementation

uses
  fMain, uTranslator, uGridHelper, uSession;

{$R *.dfm}

procedure TListadoFrameEmpleado.AplicarPermisos;
begin
  BotonNuevo.Enabled  := AppSession.UserPermissions.CrearEmpleado;
  BotonEditar.Enabled := AppSession.UserPermissions.EditarEmpleado;
  botonFiltrar.Visible := AppSession.UserPermissions.ListarEmpleado;
end;


constructor TListadoFrameEmpleado.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  CargarCombos;
end;

procedure TListadoFrameEmpleado.CargarCombos;
var
  Q: TFDQuery;
begin
  // === Tipo Documento ===
  cboTipoDocumento.Items.Clear;
  cboTipoDocumento.Items.AddObject('Filtrar por documento', TObject(0));     // sin filtro
  cboTipoDocumento.Items.AddObject('DNI', TObject(1));  // <-- ajusta IDs reales
  cboTipoDocumento.Items.AddObject('CIF', TObject(2));  // <-- ajusta IDs reales

  // === Permisos ===
  cboPermisos.Items.Clear;
  cboPermisos.Items.AddObject('Filtrar por permisos', TObject(0)); // sin filtro

  Q := TFDQuery.Create(nil);
  try
    Q.Connection := FDQuery.Connection;
    Q.SQL.Text := 'SELECT id, nombre FROM permisos WHERE activo = TRUE ORDER BY nombre';
    Q.Open;

    while not Q.Eof do
    begin
      cboPermisos.Items.AddObject(
        Q.FieldByName('nombre').AsString,
        TObject(Q.FieldByName('id').AsInteger)
      );
      Q.Next;
    end;

  finally
    Q.Free;
  end;
end;

procedure TListadoFrameEmpleado.CargarListado(filtro: string);
begin
  with FDQuery do
  begin
    SQL.Clear;
    SQL.Add('SELECT id, id_tipo_documento, detalle_documento, nombre, apellidos, empresa,');
    SQL.Add('email, observaciones, telefono1, telefono2, persona_contacto, url_web,');
    SQL.Add('user_login, pass_login, activo, id_permiso');
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
      SQL.Add('AND 1=1');
      ParamByName('filtro').AsString := '%' + filtro.Trim + '%';
    end
    else
      SQL.Add('WHERE 1=1');

    // FILTRO TIPO DOCUMENTO (INTEGER)
    if cboTipoDocumento.ItemIndex > 0 then
    begin
      SQL.Add('AND id_tipo_documento = :tipodoc');
      ParamByName('tipodoc').AsInteger :=
        Integer(cboTipoDocumento.Items.Objects[cboTipoDocumento.ItemIndex]);
    end;

    // FILTRO PERMISOS (INTEGER)
    if cboPermisos.ItemIndex > 0 then
    begin
      SQL.Add('AND id_permiso = :permiso');
      ParamByName('permiso').AsInteger :=
        Integer(cboPermisos.Items.Objects[cboPermisos.ItemIndex]);
    end;

    SQL.Add('ORDER BY id');
    Open;
  end;

  HideGridColumns(DBGridListado,
    ['id','id_tipo_documento','observaciones','pass_login','id_permiso','activo']);

  AutoSizeDBGridColumns(DBGridListado, 200);
end;

procedure TListadoFrameEmpleado.cboPermisosChange(Sender: TObject);
begin
  inherited;
  CargarListado(buscaedit.Text);
end;

procedure TListadoFrameEmpleado.cboTipoDocumentoChange(Sender: TObject);
begin
  inherited;
  CargarListado(buscaedit.Text);
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

