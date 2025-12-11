unit FrameListado;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.WinXPickers,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.VCLUI.Wait,
  Data.DB, FireDAC.Comp.Client, FireDAC.Phys.IBDef, FireDAC.Phys.IBBase,
  FireDAC.Phys.IB, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, Vcl.Grids, Vcl.ExtCtrls,
  Vcl.Buttons, Datasnap.Provider, Datasnap.DBClient, Vcl.DBGrids,ClipBrd,
  Vcl.DBCtrls, Vcl.ComCtrls, FrameBase,uColores,dmUIActions, dmImageResources,dmconnection,uInterfaces;

type
    TListadoFrame = class(TFrBase, IListadoRefrescable)
    panelbusquedavanzada: TPanel;
    buscaedit: TEdit;
    botonbuscar: TButton;
    botonborrarfiltro: TButton;
    botonfiltrar: TButton;
    Panelfiltros: TPanel;
    Botonnuevo: TButton;
    Botoneditar: TButton;
    botonsalir: TButton;
    btnborrar: TButton;
    DBGridListado: TDBGrid;
    Menulateral: TPanel;
    Botonnuevo2: TButton;
    Botoneditar2: TButton;
    btnborrar2: TButton;
    procedure DBGridListadoDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
  private
    procedure FDQueryAfterOpen(DataSet: TDataSet);
    { Private declarations }
  public
    { Public declarations }
    procedure ActualizarRegistro(AId: Integer);
    function CanDeleteRecord(AId: Integer; out AReason: string): Boolean; Virtual;
    procedure CargarListado(filtro:string); Virtual;
    procedure EditarRegistro(id: Integer); Virtual;
    procedure EliminarRegistro(id: Integer); Virtual;
    procedure doClearFilter; Override;
    procedure doSearch; override;
    procedure doEdit; override;
    procedure doAdd; override;
    procedure doDelete; override;
    procedure doRefresh; override;
    procedure doFilter; override;

  Protected
    procedure Loaded; override;
    procedure AplicarTraduccionesCampos; virtual;
    function GetGrupoTraduccion: string; virtual;
  end;

var
  ListadoFrame: TListadoFrame;

implementation

uses
 fMain, uTranslator, uGridHelper;

{$R *.dfm}

{ TListadoFrame }

procedure TListadoFrame.doSearch;
begin
Cargarlistado(buscaedit.Text);
end;

procedure TListadoFrame.doFilter;
const
  ALTURA_PANEL_OCULTO = 5;
  ALTURA_PANEL_VISIBLE = 64;
begin
  if Panelfiltros.Height <= ALTURA_PANEL_OCULTO then
  begin
    Panelfiltros.Height := ALTURA_PANEL_VISIBLE;
    Panelfiltros.Visible := True;
  end
  else
  begin
    Panelfiltros.Height := ALTURA_PANEL_OCULTO;
    Panelfiltros.Visible := False;
  end;

  Panelfiltros.Update;
  Panelfiltros.Repaint;
end;

procedure TListadoFrame.doEdit;
begin
if GetIdFieldName<>'' then
EditarRegistro(FDQuery.FieldByName(GetIdFieldName).AsInteger);
end;

procedure TListadoFrame.doAdd;
begin
EditarRegistro(0);
end;

procedure TListadoFrame.doRefresh;
begin
//ActualizarRegistro();
end;


procedure TListadoFrame.doClearFilter;
begin
//
buscaedit.Text:='';
end;

procedure TListadoFrame.CargarListado(filtro:string);
begin
//
end;

procedure TListadoFrame.DBGridListadoDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  inherited;
var
  Grid: TDBGrid;
begin
  Grid := Sender as TDBGrid;

  if gdFixed in State then
  begin
    // Títulos
    Grid.Canvas.Brush.Color := clMoneyGreen;
    Grid.Canvas.Font.Color  := clBlack;
    Grid.Canvas.Font.Style  := [fsBold];

    Grid.Canvas.FillRect(Rect);
    Grid.Canvas.TextRect(Rect, Rect.Left+4, Rect.Top+2, Column.Title.Caption);
  end
  else
  begin
    // 👉 Fila seleccionada
    if gdSelected in State then
    begin
      Grid.Canvas.Brush.Color := $00F1D99A;      // Color de fondo seleccionado
      Grid.Canvas.Font.Color  := clBlack;       // Color del texto
    end
    else
    begin
      // 👉 Fila normal
      Grid.Canvas.Brush.Color := clWhite;
      Grid.Canvas.Font.Color  := clBlack;
    end;

    Grid.Canvas.FillRect(Rect);
    Grid.Canvas.TextRect(Rect, Rect.Left+4, Rect.Top+2,
      Column.Field.AsString);
  end;
end;
end;

procedure TListadoFrame.EditarRegistro;
begin
//
end;

procedure TListadoFrame.Loaded;
begin
  inherited;
  Panelfiltros.Height:=5;

  if Assigned(FDQuery) then
  FDQuery.AfterOpen := FDQueryAfterOpen;

   // Asegura que muestra títulos
  DBGridListado.Options := DBGridListado.Options + [dgTitles];


  // Fuente de los títulos
  DBGridListado.TitleFont.Color := $00676767;
  //DBGridListado.TitleFont.Style := [fsBold];
  DBGridListado.TitleFont.Size :=8;
  // IMPORTANTE: si usas estilos VCL, pueden pisar estos colores.
  // Con esto le dices al grid que NO use el estilo para el cliente:
  DBGridListado.StyleElements := [];
  // o, si quieres dejar bordes y demás:
  // DBGrid1.StyleElements := DBGrid1.StyleElements - [seClient];

end;

function TListadoFrame.GetGrupoTraduccion: string;
begin
  // Puedes usar ClassName tal cual, y en el INI/JSON tener secciones:
  // [TListadoFrameCliente]
  // [TListadoFrameDirecciones]
  // [TListadoFrameDatosBanco]
  Result := ClassName;

  // Si prefieres algo sin la "T" inicial:
  // Result := Copy(ClassName, 2, MaxInt);
end;

procedure TListadoFrame.AplicarTraduccionesCampos;
begin
  if Assigned(FDQuery) and FDQuery.Active then
    SetTranslatedDisplayLabels(FDQuery, GetGrupoTraduccion);
end;

procedure TListadoFrame.ActualizarRegistro(AId: Integer);
begin
  FDQuery.DisableControls;
    try
    FDQuery.Refresh;
    if (Aid<>0) and (GetIdFieldName<>'') then

    FDQuery.Locate(GetIdFieldName, AId, []);
    finally
       FDQuery.EnableControls;
    end;
end;

procedure TListadoFrame.FDQueryAfterOpen(DataSet: TDataSet);
begin
  AplicarTraduccionesCampos;
end;

function TListadoFrame.CanDeleteRecord(AId: Integer; out AReason: string): Boolean;
begin
  // Por defecto, siempre permitimos borrar.
  // En cada listado concreto (clientes, proveedores, etc.) podrás sobrescribirlo.
  Result := True;
  AReason := '';
end;

procedure TListadoFrame.doDelete;
var
  IdField: string;
  AId: Integer;
  Reason: string;
begin
  // No hay dataset o no hay registros
  if (FDQuery = nil) or FDQuery.IsEmpty then
    Exit;

  // Tomamos el nombre del campo ID desde la base
  IdField := GetIdFieldName;
  if (IdField = '') or (FDQuery.FindField(IdField) = nil) then
    Exit;

  AId := FDQuery.FieldByName(IdField).AsInteger;
  if AId = 0 then
    Exit;

  // Validación de negocio previa al borrado
  if not CanDeleteRecord(AId, Reason) then
  begin
    if Reason <> '' then
      MostrarToast(Reason, 'warning');  // Mensaje de por qué no se puede borrar
    Exit;
  end;

  // Confirmación al usuario
  if MessageDlg('¿Deseas eliminar el registro seleccionado?',
                mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    Exit;

  // Delegamos el borrado en el método virtual
  EliminarRegistro(AId);

  // Recargar listado manteniendo el filtro actual
  CargarListado(buscaedit.Text);
end;

procedure TListadoFrame.EliminarRegistro(id: Integer);
begin
  // Implementación genérica:
  // asumimos que el FDQuery está posicionado en el registro correcto.
  if FDQuery.Active and (not FDQuery.IsEmpty) then
  begin
    if FDQuery.State in dsEditModes then
      FDQuery.Cancel;
    FDQuery.Delete;
  end;
end;


end.
