unit ListadoPermisos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FrameListado, Vcl.Grids,
  Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Vcl.DBGrids, edPermisos;

type
  TListadoFramePermisos = class(TListadoFrame)
  private
    procedure CargarListado(filtro: string); override;
    procedure EditarRegistro(id: Integer); override;
    procedure EliminarRegistro(id: Integer); override;
  protected
    procedure Loaded; override;
    procedure doEdit; override;
    procedure doSearch; override;
    procedure doDelete; override;
    procedure doAdd; override;
  end;

var
  ListadoFramePermisos: TListadoFramePermisos;

implementation

uses
  fMain, uTranslator, uGridHelper;

{$R *.dfm}

procedure TListadoFramePermisos.CargarListado(filtro: string);
begin
  with FDQuery do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT ');
    SQL.Add('   id AS ID, ');
    SQL.Add('   nombre, ');
    SQL.Add('   ccrearcliente, ');
    SQL.Add('   ceditarcliente, ');
    SQL.Add('   clistarcliente, ');
    SQL.Add('   ccrearproveedor, ');
    SQL.Add('   ceditarproveedor, ');
    SQL.Add('   clistarproveedor, ');
    SQL.Add('   ccrearempleado, ');
    SQL.Add('   ceditarempleado, ');
    SQL.Add('   clistarempleado, ');
    SQL.Add('   activo ');
    SQL.Add('FROM permisos');

    if not filtro.Trim.IsEmpty then
    begin
      SQL.Add('WHERE (');
      SQL.Add('      CAST(id AS VARCHAR) ILIKE :filtro');
      SQL.Add('   OR nombre ILIKE :filtro');
      SQL.Add(')');
      ParamByName('filtro').AsString := '%' + filtro.Trim + '%';
    end;

    SQL.Add('ORDER BY id');
    Open;

    HideGridColumns(DBGridListado, ['id']);

    AutoSizeDBGridColumns(DBGridListado, 200);
  end;
end;

procedure TListadoFramePermisos.EditarRegistro(id: Integer);
var
  FramePermisos: TFrEdit1;
  nuevaTab: TTabSheet;
begin
  nuevaTab := TTabSheet.Create(frmMain.PageControl1);
  nuevaTab.PageControl := frmMain.PageControl1;

  if id = 0 then
    nuevaTab.Caption := 'Nuevo Permiso'
  else
    nuevaTab.Caption := 'Permiso ID ' + id.ToString;

  FramePermisos := TFrEdit1.Create(nuevaTab);
  FramePermisos.Parent := nuevaTab;
  FramePermisos.Align := alClient;

  frmMain.PageControl1.ActivePage := nuevaTab;

  FramePermisos.CargarDatos(id);
end;

procedure TListadoFramePermisos.EliminarRegistro(id: Integer);
begin
  if MessageDlg('¿Eliminar el permiso ID ' + id.ToString + '?',
    mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    FDQuery.Close;
    FDQuery.SQL.Clear;
    FDQuery.SQL.Add('DELETE FROM permisos WHERE id = :id');
    FDQuery.ParamByName('id').AsInteger := id;
    FDQuery.ExecSQL;
    CargarListado('');
  end;
end;

procedure TListadoFramePermisos.Loaded;
begin
  inherited;
  TranslateTree(Self, '');
end;

procedure TListadoFramePermisos.doEdit;
begin
  EditarRegistro(FDQuery.FieldByName('id').AsInteger);
end;

procedure TListadoFramePermisos.doSearch;
begin
  CargarListado(buscaedit.Text);
end;

procedure TListadoFramePermisos.doDelete;
begin
  EliminarRegistro(FDQuery.FieldByName('id').AsInteger);
end;

procedure TListadoFramePermisos.doAdd;
begin
  EditarRegistro(0);
end;

end.

