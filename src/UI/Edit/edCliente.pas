unit edCliente;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FrameEdit, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Mask, Vcl.DBCtrls, Vcl.WinXCtrls, dmConnection, uTranslator, Vcl.Grids,
  Vcl.DBGrids, ListadoDirecciones, ListadoDatosBanco, vcl.ComCtrls,uFuncionesglobales;

type
  TFrEdCliente = class(TFrEdit)
    ScrollBox1: TScrollBox;
    Panel5: TPanel;
    GroupDatosfiscales: TGroupBox;
    labelnombre: TLabel;
    labelapellidos: TLabel;
    labelempresa: TLabel;
    labelcodigo: TLabel;
    labeltipo: TLabel;
    labeldocumento: TLabel;
    GroupBox2: TGroupBox;
    labeltarifa: TLabel;
    labelpermiso: TLabel;
    GroupBoxDirecciones: TGroupBox;
    GroupDatoscontacto: TGroupBox;
    labeltelefono1: TLabel;
    labeltelefono2: TLabel;
    labelcontacto: TLabel;
    labelemail: TLabel;
    GroupBox5: TGroupBox;
    GroupBox6: TGroupBox;
    GroupBox7: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    DBnombre: TDBEdit;
    DBapellidos: TDBEdit;
    DBempresa: TDBEdit;
    DBtelefono1: TDBEdit;
    DBtelefono2: TDBEdit;
    DBemail: TDBEdit;
    DBpersona_contacto: TDBEdit;
    DBobservaciones: TDBMemo;
    DBuser_login: TDBEdit;
    DBurl_web: TDBEdit;
    DBactivo: TDBCheckBox;
    DBdetalle_documento: TDBEdit;
    DBid: TDBEdit;
    DBComboPermisos: TDBLookupComboBox;
    DataSourcePermisos: TDataSource;
    FDQueryPermisos: TFDQuery;
    DBComboTarifa: TDBLookupComboBox;
    DataSourceTarifa: TDataSource;
    FDQueryTarifa: TFDQuery;
    DataSourceTipodoc: TDataSource;
    FDQueryTipodoc: TFDQuery;
    DBComboTipodoc: TDBLookupComboBox;
    paneldirecciones: TPanel;
    DataSourceDirecciones: TDataSource;
    FDQueryDirecciones: TFDQuery;
    panelDatosBanco: TPanel;
    labelactivo: TLabel;
    EditPassword: TEdit;
    procedure EditPasswordChange(Sender: TObject);  // <-- Asegúrate de tener este panel en el DFM
  private
    Listadodirecciones: TListadoFrameDirecciones;
    ListadoDatosBanco: TListadoFrameDatosBanco;
    procedure VincularControles;
    Procedure CargarPermisos;
    Procedure CargarTarifas;
    Procedure CargarTipoDoc;
    Function ValidarCampos:boolean; Override;
    procedure cargarListadoDirecciones(id:integer);
    Procedure cargarframedirecciones(ID:Integer);
    Procedure cargarframeDatosBanco(ID: Integer);
  public
    Procedure Cargardatos(Id: Integer); Override;
    procedure NuevoRegistro; Override;
    procedure doSave; Override;
  end;

var
  FrEdCliente: TFrEdCliente;

implementation

uses
  fmain;

{$R *.dfm}

procedure TFrEdCliente.doSave;
var
  IdCliente: Integer;
begin

 if FDQuery.State in dsEditModes then
  begin
    // Si el usuario ha escrito algo en el edit, significa que quiere cambiar el password
    if EditPassword.Text <> '' then
      FDQuery.FieldByName('pass_login').AsString := GetSHA256(EditPassword.Text);
  end;

  inherited;

  // Si sigue en edición, es que no se ha llegado a hacer Post (falló validación)
  if FDQuery.State in dsEditModes then
    Exit;

  IdCliente := DBId.Field.AsInteger;

  if Assigned(Listadodirecciones) then
    Listadodirecciones.cargarlistadoentidad(IdCliente, 'CLIENTE');

  if Assigned(ListadoDatosBanco) then
    ListadoDatosBanco.CargarListadoEntidad(IdCliente, 'CLIENTE');

end;

procedure TFrEdCliente.EditPasswordChange(Sender: TObject);
begin
  inherited;
  if not (FDQuery.State in dsEditModes) then
    FDQuery.Edit;
end;

procedure TFrEdCliente.VincularControles;
var
  I: Integer;
  Ed: TDBEdit;
  FieldName: string;
begin
  // Recorremos TODOS los componentes del formulario
  for I := 0 to ComponentCount - 1 do
  begin
    if Components[I] is TDBEdit then
    begin
      Ed := TDBEdit(Components[I]);

      // Esperamos nombres tipo: DBid, DBnombre, DBapellidos, etc.
      if SameText(Copy(Ed.Name, 1, 2), 'DB') then
      begin
        // Quitamos el "DB" del principio para obtener el nombre del campo
        FieldName := Copy(Ed.Name, 3, MaxInt);  // "DBnombre" -> "nombre"

        // Si el campo existe en el dataset, lo enlazamos
        if Assigned(FDQuery.FindField(FieldName)) then
        begin
          Ed.DataField  := FieldName;
        end;
      end;
    end;
  end;

  DBActivo.DataField := 'activo';
  DBobservaciones.DataField := 'observaciones';

  // Vincular permisos
  DBComboPermisos.DataField := 'id_permiso';
  DBComboPermisos.KeyField  := 'id';
  DBComboPermisos.ListField := 'nombre';

  // Vincular tarifas
  DBComboTarifa.DataField := 'id_tarifa';
  DBComboTarifa.KeyField  := 'id';
  DBComboTarifa.ListField := 'nombre';

  // Vincular tipo de documento
  DBComboTipodoc.DataField := 'id_tipo_documento';
  DBComboTipodoc.KeyField  := 'id';
  DBComboTipodoc.ListField := 'nombre';
end;

procedure TFrEdCliente.NuevoRegistro;
begin
  FDQuery.Close;
  FDQuery.Sql.Clear;
  // Solo queremos la estructura, sin registros
  FDQuery.SQL.Text := 'SELECT * FROM cliente WHERE 1 = 0';
  FDQuery.Open;

  // Crear registro nuevo
  FDQuery.Append;  // ahora State = dsInsert

  FDQuery.FieldByName('activo').AsBoolean := False;
  FDQuery.FieldByName('id_tarifa').AsInteger := 1;
  FDQuery.FieldByName('id_permiso').AsInteger := 1;
  FDQuery.FieldByName('id_tipo_documento').AsInteger := 1;

  // 🔹 Actualizar el título de la pestaña
    // 🔹 Cambiar el nombre de la pestaña donde está este frame
  if Parent is TTabSheet then
    TTabSheet(Parent).Caption := 'Nuevo Cliente';
end;

Procedure TFrEdCliente.CargarPermisos;
begin
  with FDQueryPermisos do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT ');
    SQL.Add('id,');
    SQL.Add('nombre');
    SQL.Add('FROM permisos');
    SQL.Add('ORDER BY nombre');
    Open;
  end;
end;

Function TFrEdCliente.ValidarCampos:boolean;
begin
  Result := True;

  // Validar campo obligatorio: permiso
  if (FDQuery.FieldByName('id_permiso').IsNull) or
     (FDQuery.FieldByName('id_permiso').AsInteger < 1) then
  begin
    MostrarToast(T_('info','combopermiso'), 'warning');
    DBComboPermisos.SetFocus;
    Exit(False);
  end;

  // Validar campo obligatorio: tarifa
  if (FDQuery.FieldByName('id_tarifa').IsNull) or
     (FDQuery.FieldByName('id_tarifa').AsInteger < 1) then
  begin
    MostrarToast(T_('info','combotarifa'), 'warning');
    DBCombotarifa.SetFocus;
    Exit(False);
  end;

  // Validar que hay al menos nombre / apellidos / empresa
  if (FDQuery.FieldByName('nombre').AsString = '') and
     (FDQuery.FieldByName('apellidos').AsString = '') and
     (FDQuery.FieldByName('empresa').AsString = '') then
  begin
    MostrarToast(T_('info','faltandatos'), 'warning');
    Dbnombre.SetFocus;
    Exit(False);
  end;
end;

Procedure TFrEdCliente.CargarTarifas;
begin
  with FDQueryTarifa do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT ');
    SQL.Add('id,');
    SQL.Add('nombre');
    SQL.Add('FROM Tarifa');
    SQL.Add('ORDER BY nombre');
    Open;
  end;
end;

Procedure TFrEdCliente.CargarTipoDoc;
begin
  with FDQueryTipoDoc do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT ');
    SQL.Add('id,');
    SQL.Add('nombre');
    SQL.Add('FROM tipo_documento_identidad');
    SQL.Add('ORDER BY nombre');
    Open;
  end;
end;

Procedure TFrEdCliente.Cargardatos(Id: Integer);
begin
  DataSource.OnStateChange := DataSourceStateChange;

  CargarPermisos;
  CargarTarifas;
  CargarTipoDoc;

  if Id <> 0 then
  begin
    with FDQuery do
    begin
      Close;
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
      SQL.Add('FROM cliente');
      SQL.Add('WHERE (id = :pid_cliente)');
      ParamByName('pid_cliente').AsInteger := ID;
      Open;
    end;
    Buttonguardar.Enabled := False;
  end
  else
    NuevoRegistro;

  VincularControles;

  // Cargar subframes
  cargarframedirecciones(Id);
  cargarframeDatosBanco(Id);
end;

Procedure TFrEdCliente.cargarframedirecciones(ID:integer);
begin
  if Assigned(ListadoDirecciones) then
  begin
    ListadoDirecciones.Free;
    ListadoDirecciones := nil;
  end;

  ListadoDirecciones := TListadoFrameDirecciones.Create(Self);
  Listadodirecciones.Parent := Paneldirecciones;
  Listadodirecciones.Align := alClient;
  Listadodirecciones.panelbusquedavanzada.Visible := False;
  Listadodirecciones.Menulateral.Visible := True;
  Listadodirecciones.cargarlistadoentidad(ID, 'CLIENTE');
end;

Procedure TFrEdCliente.cargarframeDatosBanco(ID: Integer);
begin
  if Assigned(ListadoDatosBanco) then
  begin
    ListadoDatosBanco.Free;
    ListadoDatosBanco := nil;
  end;

  ListadoDatosBanco := TListadoFrameDatosBanco.Create(Self);
  ListadoDatosBanco.Parent := panelDatosBanco;
  ListadoDatosBanco.Align := alClient;
  ListadoDatosBanco.panelbusquedavanzada.Visible := False;
  ListadoDatosBanco.Menulateral.Visible := True;
  ListadoDatosBanco.CargarListadoEntidad(ID, 'CLIENTE');
end;

procedure TFrEdCliente.cargarListadoDirecciones(id:integer);
begin
  if Id <> 0 then
  begin
    with FDQueryDirecciones do
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
      SQL.Add('WHERE (id = :pid)');
      ParamByName('pid').AsInteger := id;
      SQL.Add('ORDER BY id');
      Open;
    end;
  end;
end;

end.

