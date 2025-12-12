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
    cboTipoDocumento: TComboBox;
    cboPermisos: TComboBox;
    procedure cboPermisosChange(Sender: TObject);
    procedure cboTipoDocumentoChange(Sender: TObject);
  private
    procedure CargarListado(filtro:string); override;
    procedure EditarRegistro(id: Integer); override;
    function CanDeleteRecord(AId: Integer; out AReason: string): Boolean; Override;

    procedure CargarCombos;
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  ListadoFrameProveedores: TListadoFrameProveedores;

implementation

uses
  fMain, uTranslator, uGridHelper;

{$R *.dfm}

constructor TListadoFrameProveedores.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  CargarCombos;
end;

procedure TListadoFrameProveedores.CargarCombos;
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

procedure TListadoFrameProveedores.CargarListado(filtro:string);
begin
  with FDQuery do begin
    SQL.Clear;
    SQL.Add('SELECT ');
    SQL.Add('id, id_tipo_documento, detalle_documento, nombre, apellidos, empresa,');
    SQL.Add('email, observaciones, telefono1, telefono2, id_tarifa, persona_contacto,');
    SQL.Add('url_web, user_login, pass_login, activo, id_permiso');
    SQL.Add('FROM proveedores');

    // FILTRO TEXTO
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
      SQL.Add('AND 1=1'); // permite añadir más filtros

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
    ['id','id_tipo_documento','observaciones','pass_login','id_tarifa','id_permiso','activo']
  );

  AutoSizeDBGridColumns(DBGridListado, 200);
end;

procedure TListadoFrameProveedores.cboPermisosChange(Sender: TObject);
begin
  inherited;
  CargarListado(buscaedit.Text);
end;

procedure TListadoFrameProveedores.cboTipoDocumentoChange(Sender: TObject);
begin
  inherited;
  CargarListado(buscaedit.Text);
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
