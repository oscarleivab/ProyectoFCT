unit edDatosBanco;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FrameEdit, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Mask, Vcl.DBCtrls;

type
  TFrEdDatosBanco = class(TFrEdit)
    GroupBox1: TGroupBox;
    labelsucursal: TLabel;
    labelccc: TLabel;
    labelobservacion: TLabel;
    DBsucursal: TDBEdit;
    DBccc: TDBEdit;
    DBobservacion: TDBEdit;
    DBid_entidad: TDBEdit;
    DBid: TDBEdit;
    DBtabla: TDBEdit;
  private
    procedure VincularControles;
  public
    procedure CargarDatos(Id: Integer); override;
    procedure NuevoRegistro; override;
  end;

var
  FrEdDatosBanco: TFrEdDatosBanco;

implementation

{$R *.dfm}

{ TFrEdDatosBanco }

procedure TFrEdDatosBanco.CargarDatos(Id: Integer);
begin
  // Para que el botón guardar se habilite/deshabilite según el estado
  DataSource.OnStateChange := DataSourceStateChange;

  if Id <> 0 then
  begin
    // Edición de registro existente
    with FDQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT ');
      SQL.Add('  id,');
      SQL.Add('  id_entidad,');
      SQL.Add('  sucursal,');
      SQL.Add('  ccc,');
      SQL.Add('  observacion,');
      SQL.Add('  tabla');
      SQL.Add('FROM datos_banco');
      SQL.Add('WHERE id = :pid');
      ParamByName('pid').AsInteger := Id;
      Open;
    end;

    Buttonguardar.Enabled := False;
  end
  else
    // Nuevo registro
    NuevoRegistro;

  // Enlazar automáticamente los DBEdit con los campos
  VincularControles;
end;

procedure TFrEdDatosBanco.NuevoRegistro;
begin
  FDQuery.Close;
  FDQuery.SQL.Clear;
  // Solo queremos la estructura, sin registros
  FDQuery.SQL.Text := 'SELECT * FROM datos_banco WHERE 1 = 0';
  FDQuery.Open;

  // Crear registro nuevo
  FDQuery.Append;  // ahora State = dsInsert

  // Ojo: los campos 'tabla' e 'id_entidad' los rellenará el listado
  // después de llamar a CargarDatos(0), igual que haces con direcciones:
  //   Banco.DataSource.DataSet.FieldByName('tabla').AsString      := tablaActiva;
  //   Banco.DataSource.DataSet.FieldByName('id_entidad').AsInteger := entidadActiva;
end;

procedure TFrEdDatosBanco.VincularControles;
var
  I: Integer;
  Ed: TDBEdit;
  FieldName: string;
begin
  // Recorrer todos los componentes y enlazar DB + nombreCampo
  for I := 0 to ComponentCount - 1 do
  begin
    if Components[I] is TDBEdit then
    begin
      Ed := TDBEdit(Components[I]);

      if SameText(Copy(Ed.Name, 1, 2), 'DB') then
      begin
        // "DBsucursal" -> "sucursal"
        FieldName := Copy(Ed.Name, 3, MaxInt);

        if Assigned(FDQuery.FindField(FieldName)) then
          Ed.DataField := FieldName;
      end;
    end;
  end;
end;

end.

