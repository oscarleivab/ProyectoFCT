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
    chkCrearCliente: TCheckBox;
    chkEditarCliente: TCheckBox;
    chkListarCliente: TCheckBox;
    chkCrearProveedor: TCheckBox;
    chkEditarProveedor: TCheckBox;
    chkListarProveedor: TCheckBox;
    chkCrearEmpleado: TCheckBox;
    chkEditarEmpleado: TCheckBox;
    chkListarEmpleado: TCheckBox;
    procedure chkCrearClienteClick(Sender: TObject);
    procedure chkCrearEmpleadoClick(Sender: TObject);
    procedure chkCrearProveedorClick(Sender: TObject);
    procedure chkEditarClienteClick(Sender: TObject);
    procedure chkEditarEmpleadoClick(Sender: TObject);
    procedure chkEditarProveedorClick(Sender: TObject);
    procedure chkListarClienteClick(Sender: TObject);
    procedure chkListarEmpleadoClick(Sender: TObject);
    procedure chkListarProveedorClick(Sender: TObject);
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
    SQL.Add('SELECT id AS ID, nombre, ccrearcliente, ceditarcliente, clistarcliente,');
    SQL.Add('       ccrearproveedor, ceditarproveedor, clistarproveedor,');
    SQL.Add('       ccrearempleado, ceditarempleado, clistarempleado, activo');
    SQL.Add('FROM permisos');
    SQL.Add('WHERE 1=1');

    // filtro de texto
    if not filtro.Trim.IsEmpty then
    begin
      SQL.Add('  AND (CAST(id AS VARCHAR) ILIKE :filtro OR nombre ILIKE :filtro)');
      ParamByName('filtro').AsString := '%' + filtro.Trim + '%';
    end;

    // filtros por checkboxes
    if chkCrearCliente.Checked then
      SQL.Add('  AND ccrearcliente = TRUE');
    if chkEditarCliente.Checked then
      SQL.Add('  AND ceditarcliente = TRUE');
    if chkListarCliente.Checked then
      SQL.Add('  AND clistarcliente = TRUE');
    if chkCrearProveedor.Checked then
      SQL.Add('  AND ccrearproveedor = TRUE');
    if chkEditarProveedor.Checked then
      SQL.Add('  AND ceditarproveedor = TRUE');
    if chkListarProveedor.Checked then
      SQL.Add('  AND clistarproveedor = TRUE');
    if chkCrearEmpleado.Checked then
      SQL.Add('  AND ccrearempleado = TRUE');
    if chkEditarEmpleado.Checked then
      SQL.Add('  AND ceditarempleado = TRUE');
    if chkListarEmpleado.Checked then
      SQL.Add('  AND clistarempleado = TRUE');

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

procedure TListadoFramePermisos.chkCrearClienteClick(Sender: TObject);
begin
  inherited;
  CargarListado(buscaedit.Text);
end;

procedure TListadoFramePermisos.chkCrearEmpleadoClick(Sender: TObject);
begin
  inherited;
  CargarListado(buscaedit.Text);
end;

procedure TListadoFramePermisos.chkCrearProveedorClick(Sender: TObject);
begin
  inherited;
  CargarListado(buscaedit.Text);
end;

procedure TListadoFramePermisos.chkEditarClienteClick(Sender: TObject);
begin
  inherited;
  CargarListado(buscaedit.Text);
end;

procedure TListadoFramePermisos.chkEditarEmpleadoClick(Sender: TObject);
begin
  inherited;
  CargarListado(buscaedit.Text);
end;

procedure TListadoFramePermisos.chkEditarProveedorClick(Sender: TObject);
begin
  inherited;
  CargarListado(buscaedit.Text);
end;

procedure TListadoFramePermisos.chkListarClienteClick(Sender: TObject);
begin
  inherited;
  CargarListado(buscaedit.Text);
end;

procedure TListadoFramePermisos.chkListarEmpleadoClick(Sender: TObject);
begin
  inherited;
  CargarListado(buscaedit.Text);
end;

procedure TListadoFramePermisos.chkListarProveedorClick(Sender: TObject);
begin
  inherited;
  CargarListado(buscaedit.Text);
end;

procedure TListadoFramePermisos.doAdd;
begin
  EditarRegistro(0);
end;

end.

