unit edProveedor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FrameEdit, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Mask, Vcl.DBCtrls, Vcl.WinXCtrls, dmConnection,uTranslator;

type
  TFrEdProveedor = class(TFrEdit)
    ScrollBox1: TScrollBox;
    Panel5: TPanel;
    GroupBox1: TGroupBox;
    labelnombre: TLabel;
    labelapellidos: TLabel;
    labelempresa: TLabel;
    labelcodigo: TLabel;
    labeltipo: TLabel;
    labeldocumento: TLabel;
    DBnombre: TDBEdit;
    DBapellidos: TDBEdit;
    DBempresa: TDBEdit;
    DBdetalle_documento: TDBEdit;
    DBid_tipo: TDBEdit;
    GroupBox2: TGroupBox;
    labeltarifa: TLabel;
    labelpermiso: TLabel;
    DBid_permiso: TDBEdit;
    DBactivo: TDBCheckBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    labeltelefono1: TLabel;
    labeltelefono2: TLabel;
    labelcontacto: TLabel;
    labelemail: TLabel;
    DBtelefono1: TDBEdit;
    DBtelefono2: TDBEdit;
    DBemail: TDBEdit;
    DBpersona_contacto: TDBEdit;
    GroupBox5: TGroupBox;
    DBobservaciones: TDBMemo;
    GroupBox6: TGroupBox;
    GroupBox7: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    DBuser_login: TDBEdit;
    DBpass_login: TDBEdit;
    DBurl_web: TDBEdit;
    DBdirecciones: TDBMemo;
    DBdatos_bancarios: TDBMemo;
    DBid_tipo_documento: TComboBox;
    DBid_tarifa_aplicada: TComboBox;
    procedure DBComboChange(Sender: TObject);
    procedure DBComboEnter(Sender: TObject);
  private
    procedure VincularControles;
    procedure CargarCombos;
    procedure MostrarValores;
  public
    procedure Cargardatos(Id: Integer); override;
  end;

var
  FrEdProveedor: TFrEdProveedor;

implementation

uses fmain;

{$R *.dfm}

const
  TipoDocumentoText: array[1..4] of string = ('DNI', 'NIE', 'PASAPORTE', 'CIF');
  TarifaText: array[1..2] of string = ('Tarifa 1', 'Tarifa 2');

procedure TFrEdProveedor.CargarCombos;
var
  i: Integer;
begin
  // Tipo documento
  DBid_tipo_documento.Items.Clear;
  for i := Low(TipoDocumentoText) to High(TipoDocumentoText) do
    DBid_tipo_documento.Items.Add(TipoDocumentoText[i]);

  // Tarifa aplicada
  DBid_tarifa_aplicada.Items.Clear;
  for i := Low(TarifaText) to High(TarifaText) do
    DBid_tarifa_aplicada.Items.Add(TarifaText[i]);
end;

procedure TFrEdProveedor.DBComboChange(Sender: TObject);
begin
  if not (FDQuery.State in [dsEdit, dsInsert]) then
    FDQuery.Edit;

  if Sender = DBid_tipo_documento then
    FDQuery.FieldByName('id_tipo_documento').AsInteger := DBid_tipo_documento.ItemIndex + 1
  else if Sender = DBid_tarifa_aplicada then
    FDQuery.FieldByName('id_tarifa_aplicada').AsInteger := DBid_tarifa_aplicada.ItemIndex + 1;
end;

procedure TFrEdProveedor.MostrarValores;
begin
  // Tipo documento
  if not FDQuery.FieldByName('id_tipo_documento').IsNull then
    DBid_tipo_documento.ItemIndex := FDQuery.FieldByName('id_tipo_documento').AsInteger - 1
  else
    DBid_tipo_documento.ItemIndex := -1;

  // Tarifa aplicada
  if not FDQuery.FieldByName('id_tarifa_aplicada').IsNull then
    DBid_tarifa_aplicada.ItemIndex := FDQuery.FieldByName('id_tarifa_aplicada').AsInteger - 1
  else
    DBid_tarifa_aplicada.ItemIndex := -1;
end;


procedure TFrEdProveedor.DBComboEnter(Sender: TObject);
begin
  if FDQuery.Active and (FDQuery.State = dsBrowse) then
    FDQuery.Edit;
end;

procedure TFrEdProveedor.VincularControles;
var
  I: Integer;
  Ed: TDBEdit;
  Memo: TDBMemo;
  FieldName: string;
begin
  // Recorremos todos los componentes para enlazar automáticamente
  for I := 0 to ComponentCount - 1 do
  begin
    if Components[I] is TDBEdit then
    begin
      Ed := TDBEdit(Components[I]);
      if SameText(Copy(Ed.Name, 1, 2), 'DB') then
      begin
        FieldName := Copy(Ed.Name, 3, MaxInt);
        if Assigned(FDQuery.FindField(FieldName)) then
          Ed.DataField := FieldName;
      end;
    end;

    if Components[I] is TDBMemo then
    begin
      Memo := TDBMemo(Components[I]);
      if SameText(Copy(Memo.Name, 1, 2), 'DB') then
      begin
        FieldName := Copy(Memo.Name, 3, MaxInt);
        if Assigned(FDQuery.FindField(FieldName)) then
          Memo.DataField := FieldName;
      end;
    end;
  end;
end;

procedure TFrEdProveedor.Cargardatos(Id: Integer);
begin
  // Asignar conexión
  FDQuery.Connection := DataModuleConnection.FDConnectionCompany;
  FDQuery.Close;

  // Nuevo registro
  if Id = 0 then
  begin
    FDQuery.SQL.Text := 'SELECT * FROM proveedores WHERE 1=0';
    FDQuery.Open;
    FDQuery.Append;

    FDQuery.FieldByName('activo').AsBoolean := True;
    FDQuery.FieldByName('id_tipo_documento').AsInteger := 1;
    FDQuery.FieldByName('id_tarifa_aplicada').AsInteger := 1;
  end
  else
  begin
    // Editar registro existente
    FDQuery.SQL.Text := 'SELECT * FROM proveedores WHERE id = :pid_proveedor';
    FDQuery.ParamByName('pid_proveedor').AsInteger := Id;
    FDQuery.Open;
  end;

  // Vincular DataSource
  DataSource.DataSet := FDQuery;

  // Llenar combos
  CargarCombos;

  // Mostrar valores correctamente
  MostrarValores;

  // Vincular DBEdit/DBMemo automáticamente
  VincularControles;

  // Configurar checkbox PostgreSQL
  DBactivo.DataSource := DataSource;
  DBactivo.DataField := 'activo';
  DBactivo.ValueChecked := 't';
  DBactivo.ValueUnchecked := 'f';

  // Hacer readonly el id_tipo (se genera automáticamente)
  DBid_tipo.ReadOnly := False;
  MostrarToast(T_('Cargado correctamente', 'errorbdprincipal'), 'success')
end;

end.
