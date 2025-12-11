unit edDireccion;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FrameEdit, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.DBCtrls, Vcl.Mask;

type
  TFrEditDireccion = class(TFrEdit)
    GroupBox1: TGroupBox;
    labeldetalle: TLabel;
    labeldireccion: TLabel;
    labelpoblacion: TLabel;
    DBdetalle: TDBEdit;
    DBdireccion: TDBEdit;
    DBpoblacion: TDBEdit;
    DBid_entidad: TDBEdit;
    DBid: TDBEdit;
    labelprovincia: TLabel;
    DBprovincia: TDBEdit;
    Labelcpostal: TLabel;
    DBcp: TDBEdit;
    DBpais: TDBEdit;
    Labelpais: TLabel;
    DBtabla: TDBEdit;
  private
    { Private declarations }
    procedure VincularControles;
  public
    { Public declarations }
    entidadactiva:integer;
    tablaactiva:string;
    Procedure Cargardatos(Id: Integer); Override;
    procedure NuevoRegistro; Override;
  end;

var
  FrEditDireccion: TFrEditDireccion;

implementation

{$R *.dfm}


Procedure TFrEditDireccion.Cargardatos(Id: Integer);
begin

  DataSource.OnStateChange:=DataSourceStateChange;

    if Id<>0 then begin
    with FDQuery do begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT ');
        SQL.Add('id,');
        SQL.Add('id_entidad,');
        SQL.Add('detalle,');
        SQL.Add('direccion,');
        SQL.Add('poblacion,');
        SQL.Add('provincia,');
        SQL.Add('pais,');
        SQL.Add('cp,');
        SQL.Add('tabla');
        SQL.Add('FROM datos_direccion');
        SQL.Add('WHERE (id=:pid)');
        ParamByName('pid').Asinteger := ID;
        Open;
    end;
    Buttonguardar.Enabled:=false;
  end
  else
  NuevoRegistro;

  VincularControles; // mismo que usas para enlazar los DBEdit

end;

procedure TFrEditDireccion.VincularControles;
var
  I: Integer;
  Ed: TDBEdit;
  FieldName: string;
begin

  // 2. Recorremos TODOS los componentes del formulario
  for I := 0 to ComponentCount - 1 do
  begin
    if Components[I] is TDBEdit then
    begin
      Ed := TDBEdit(Components[I]);

      // Esperamos nombres tipo: DBid_cliente, DBnombre, DBapellidos, etc.
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

end;

procedure TFrEditDireccion.NuevoRegistro;
begin

  FDQuery.Close;
  FDQuery.Sql.Clear;
  // Solo queremos la estructura, sin registros
  FDQuery.SQL.Text := 'SELECT * FROM datos_direccion WHERE 1 = 0';
  FDQuery.Open;


  // Crear registro nuevo
  FDQuery.Append;  // ahora State = dsInsert

end;

end.
