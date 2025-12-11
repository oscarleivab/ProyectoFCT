unit edPermisos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FrameEdit,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async,
  FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.DBCtrls, Vcl.Mask, dmConnection, Vcl.Grids;

type
  TFrEdit1 = class(TFrEdit)
    ScrollBox1: TScrollBox;
    Panel5: TPanel;
    GroupPermisos: TGroupBox;

    labelnombre: TLabel;
    labelcodigo: TLabel;
    DBnombre: TDBEdit;
    DBid: TDBEdit;

    labelcrearcliente: TLabel;
    labeleditarcliente: TLabel;
    labellistarcliente: TLabel;
    labelcrearproveedor: TLabel;
    labeleditarproveedor: TLabel;
    labellistarproveedor: TLabel;
    labelcrearempleado: TLabel;
    labeleditarempleado: TLabel;
    labellistarempleado: TLabel;
    labelactivo: TLabel;

    DBccrearcliente: TDBCheckBox;
    DBceditarcliente: TDBCheckBox;
    DBclistarcliente: TDBCheckBox;
    DBccrearproveedor: TDBCheckBox;
    DBceditarproveedor: TDBCheckBox;
    DBclistarproveedor: TDBCheckBox;
    DBccrearempleado: TDBCheckBox;
    DBceditarempleado: TDBCheckBox;
    DBclistarempleado: TDBCheckBox;
    DBactivo: TDBCheckBox;

  private
    procedure VincularControles;
    procedure VincularCheckBoxes;

  public
    procedure CargarDatos(Id: Integer); override;
    procedure doSave; override;
  end;

var
  FrEdit1: TFrEdit1;

implementation

{$R *.dfm}

{----------------------------------------------}
{    Vincular automáticamente los TDBEdit       }
{----------------------------------------------}
procedure TFrEdit1.VincularControles;
var
  I: Integer;
  Ed: TDBEdit;
  FieldName: string;
begin
  for I := 0 to ComponentCount - 1 do
  begin
    if Components[I] is TDBEdit then
    begin
      Ed := TDBEdit(Components[I]);
      if SameText(Copy(Ed.Name, 1, 2), 'DB') then
      begin
        FieldName := Copy(Ed.Name, 3, MaxInt);
        if Assigned(FDQuery.FindField(FieldName)) then
        begin
          Ed.DataSource := DataSource;
          Ed.DataField  := FieldName;
        end;
      end;
    end;
  end;
end;

{----------------------------------------------}
{   Vincular automáticamente los TDBCheckBox    }
{----------------------------------------------}
procedure TFrEdit1.VincularCheckBoxes;
var
  I: Integer;
  CB: TDBCheckBox;
  FieldName: string;
begin
  for I := 0 to ComponentCount - 1 do
  begin
    if Components[I] is TDBCheckBox then
    begin
      CB := TDBCheckBox(Components[I]);
      if SameText(Copy(CB.Name, 1, 2), 'DB') then
      begin
        FieldName := Copy(CB.Name, 3, MaxInt);
        if Assigned(FDQuery.FindField(FieldName)) then
        begin
          CB.DataSource := DataSource;
          CB.DataField  := FieldName;

          // PostgreSQL BOOLEAN requiere 'true'/'false'
          CB.ValueChecked   := 'true';
          CB.ValueUnchecked := 'false';
        end;
      end;
    end;
  end;
end;

{----------------------------------------------}
{              Cargar datos desde BDD           }
{----------------------------------------------}
procedure TFrEdit1.CargarDatos(Id: Integer);
var
  f: TField;
begin
  FDQuery.Connection := DataModuleConnection.FDConnectionCompany;
  FDQuery.CachedUpdates := True;
  FDQuery.Close;
  FDQuery.SQL.Clear;

  FDQuery.SQL.Add('SELECT id, nombre, ccrearcliente, ceditarcliente, clistarcliente, ' +
                  'ccrearproveedor, ceditarproveedor, clistarproveedor, ' +
                  'ccrearempleado, ceditarempleado, clistarempleado, activo ' +
                  'FROM permisos');

  if Id <> 0 then
  begin
    FDQuery.SQL.Add('WHERE id = :pid');
    FDQuery.ParamByName('pid').AsInteger := Id;
    FDQuery.Open;
    FDQuery.Edit;
  end
  else
  begin
    FDQuery.SQL.Add('WHERE 1=0');
    FDQuery.Open;
    FDQuery.Append;

    for f in FDQuery.Fields do
      if (f.DataType = ftBoolean) then
      begin
        // Si el campo llega NULL (caso típico al hacer Append)
        if f.IsNull then
          f.AsBoolean := False;
      end;

    // Valor por defecto especial
    FDQuery.FieldByName('activo').AsBoolean := True;
  end;

  VincularControles;
  VincularCheckBoxes;
end;



{----------------------------------------------}
{               Guardar registro                }
{----------------------------------------------}
procedure TFrEdit1.doSave;
begin
  if not (FDQuery.State in [dsInsert, dsEdit]) then
    FDQuery.Edit;

  FDQuery.Post;
  FDQuery.ApplyUpdates(-1);

  ShowMessage('Permiso guardado correctamente.');
end;

end.

