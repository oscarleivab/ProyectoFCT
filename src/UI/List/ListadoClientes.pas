unit ListadoClientes;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  FrameListado, Vcl.Grids, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls,
  System.Generics.Collections, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.DBGrids, edCliente,
  uInterfaces;

type
  TListadoFrameCliente = class(TListadoFrame)
    cboTipoDocumento: TComboBox;
    cboPermisos: TComboBox;
    procedure cboPermisosChange(Sender: TObject);
    procedure cboTipoDocumentoChange(Sender: TObject);

  private
    procedure CargarCombos;         // NUEVO
    procedure CargarListado(filtro: string); override;
    procedure EditarRegistro(id: Integer); override;
    function CanDeleteRecord(AId: Integer; out AReason: string): Boolean; override;

  public
    constructor Create(AOwner: TComponent); override;
    procedure AplicarPermisos; override;
  end;

var
  ListadoFrameCliente: TListadoFrameCliente;

implementation

uses
  fMain, uTranslator, uGridHelper, uSession;

{$R *.dfm}

procedure TListadoFrameCliente.AplicarPermisos;
begin
  BotonNuevo.Enabled  := AppSession.UserPermissions.CrearCliente;
  BotonEditar.Enabled := AppSession.UserPermissions.EditarCliente;
  botonFiltrar.Visible := AppSession.UserPermissions.ListarCliente;
end;

{ ---------------------------------------------------------------
  CONSTRUCTOR - carga los combos al crear el frame
  --------------------------------------------------------------- }
constructor TListadoFrameCliente.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  CargarCombos;
end;

{ ---------------------------------------------------------------
  CARGA DE COMBOS
  --------------------------------------------------------------- }
procedure TListadoFrameCliente.CargarCombos;
var
  Q: TFDQuery;
begin
  { ---- Combo Tipo de documento ---- }
  cboTipoDocumento.Items.Clear;
  cboTipoDocumento.Items.AddObject('Filtrar por documento', TObject(0));       // Sin filtro
  cboTipoDocumento.Items.AddObject('DNI', TObject(1));
  cboTipoDocumento.Items.AddObject('CIF', TObject(2));

  { ---- Combo Permisos ---- }
  cboPermisos.Items.Clear;
  cboPermisos.Items.Add('Filtrar por permisos');            // Sin filtro

  Q := TFDQuery.Create(nil);
  try
    Q.Connection := FDQuery.Connection;
    Q.SQL.Text := 'SELECT id, nombre FROM permisos WHERE activo = TRUE ORDER BY nombre';
    Q.Open;

    while not Q.Eof do
    begin
      // Guardamos ID en Items.Objects
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


{ ---------------------------------------------------------------
  CARGA DEL LISTADO (con filtros)
  --------------------------------------------------------------- }
procedure TListadoFrameCliente.CargarListado(filtro: string);
begin
  with FDQuery do
  begin
    SQL.Clear;
    SQL.Add('SELECT ');
    SQL.Add('id, id_tipo_documento, detalle_documento, nombre, apellidos, empresa,');
    SQL.Add('email, observaciones, telefono1, telefono2, id_tarifa, persona_contacto,');
    SQL.Add('url_web, user_login, pass_login, activo, id_permiso');
    SQL.Add('FROM cliente');

    // ---------------------------------------
    // FILTRO POR TEXTO
    // ---------------------------------------
    if not filtro.IsEmpty then
    begin
      SQL.Add('WHERE (');
      SQL.Add('  unaccent(CAST(id AS TEXT)) ILIKE unaccent(:filtro)');
      SQL.Add('  OR unaccent(detalle_documento) ILIKE unaccent(:filtro)');
      SQL.Add('  OR unaccent(nombre) ILIKE unaccent(:filtro)');
      SQL.Add('  OR unaccent(apellidos) ILIKE unaccent(:filtro)');
      SQL.Add('  OR unaccent(nombre || '' '' || apellidos) ILIKE unaccent(:filtro)');
      SQL.Add('  OR unaccent(apellidos || '' '' || nombre) ILIKE unaccent(:filtro)');
      SQL.Add('  OR unaccent(empresa) ILIKE unaccent(:filtro)');
      SQL.Add('  OR unaccent(email) ILIKE unaccent(:filtro)');
      SQL.Add('  OR unaccent(observaciones) ILIKE unaccent(:filtro)');
      SQL.Add('  OR unaccent(telefono1) ILIKE unaccent(:filtro)');
      SQL.Add('  OR unaccent(telefono2) ILIKE unaccent(:filtro)');
      SQL.Add('  OR unaccent(persona_contacto) ILIKE unaccent(:filtro)');
      SQL.Add(')');
      SQL.Add('AND 1 = 1'); // permite añadir más filtros

      ParamByName('filtro').AsString := '%' + filtro.Trim + '%';
    end
    else
    begin
      SQL.Add('WHERE 1 = 1');
    end;

    // ---------------------------------------
    // FILTRO POR TIPO DE DOCUMENTO
    // ---------------------------------------
    if cboTipoDocumento.ItemIndex > 0 then
    begin
      SQL.Add('AND id_tipo_documento = :tipodoc');
      ParamByName('tipodoc').AsInteger :=
        Integer(cboTipoDocumento.Items.Objects[cboTipoDocumento.ItemIndex]);
    end;


    // ---------------------------------------
    // FILTRO POR PERMISOS (por ID)
    // ---------------------------------------
    if cboPermisos.ItemIndex > 0 then
    begin
      SQL.Add('AND id_permiso = :permiso');
      ParamByName('permiso').AsInteger :=
        Integer(cboPermisos.Items.Objects[cboPermisos.ItemIndex]);
    end;

    SQL.Add('ORDER BY id');

    Open;

    HideGridColumns(DBGridListado,
      ['id', 'id_tipo_documento', 'observaciones', 'pass_login',
       'id_tarifa', 'id_permiso', 'activo']);

    AutoSizeDBGridColumns(DBGridListado, 200);
  end;
end;

procedure TListadoFrameCliente.cboPermisosChange(Sender: TObject);
begin
  inherited;
  CargarListado(buscaedit.Text);
end;

procedure TListadoFrameCliente.cboTipoDocumentoChange(Sender: TObject);
begin
  inherited;
  CargarListado(buscaedit.Text);
end;

{ ---------------------------------------------------------------
  EDITAR REGISTRO
  --------------------------------------------------------------- }
procedure TListadoFrameCliente.EditarRegistro(id: Integer);
var
  Cliente: TFrEdCliente;
  nuevaTab: TTabSheet;
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
       1,15) + '...';

  Cliente := TFrEdCliente.Create(nuevaTab);
  Cliente.Parent := nuevaTab;
  Cliente.Align := alClient;
  Cliente.Origen := Self as IListadoRefrescable;

  frmMain.Pagecontrol1.ActivePageIndex :=
    frmMain.Pagecontrol1.PageCount - 1;

  Cliente.cargardatos(id);
end;


{ ---------------------------------------------------------------
  VALIDAR BORRADO DEL CLIENTE
  --------------------------------------------------------------- }
function TListadoFrameCliente.CanDeleteRecord(AId: Integer; out AReason: string): Boolean;
var
  Q: TFDQuery;
  Count: Integer;
begin
  Result := True;
  AReason := '';

  Q := TFDQuery.Create(nil);
  try
    Q.Connection := FDQuery.Connection;

    // ¿Tiene direcciones asociadas?
    Q.SQL.Text :=
      'SELECT COUNT(*) AS total FROM datos_direccion ' +
      'WHERE id_entidad = :id AND tabla = ''CLIENTE''';
    Q.ParamByName('id').AsInteger := AId;
    Q.Open;

    Count := Q.FieldByName('total').AsInteger;
    if Count > 0 then
    begin
      Result := False;
      AReason := 'No se puede eliminar el cliente porque tiene direcciones asociadas.';
      Exit;
    end;

    // ¿Tiene datos bancarios?
    Q.Close;
    Q.SQL.Text :=
      'SELECT COUNT(*) AS total FROM datos_banco ' +
      'WHERE id_entidad = :id AND tabla = ''CLIENTE''';
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
end;

end.

