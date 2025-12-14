unit ListadoLog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FrameListado, Vcl.Grids,
  Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls, System.Generics.Collections,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async,
  FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.DBGrids,
  FrameBase, uLog;

type
  TFrListadoLog = class(TListadoFrame)
    chkINFO: TCheckBox;
    chkERROR: TCheckBox;
    procedure chkERRORClick(Sender: TObject);
    procedure chkINFOClick(Sender: TObject);
  private
    procedure CargarListado(filtro: string); override;
  protected
    procedure Loaded; override;
  public
    //procedure doFilter; override;
  end;

var
  FrListadoLog: TFrListadoLog;

implementation

uses
  fMain, uTranslator, uGridHelper;

{$R *.dfm}

procedure TFrListadoLog.CargarListado(filtro: string);
var
  tiposSeleccionados: TStringList;
  i: Integer;
  tipoCond: string;
begin
  tiposSeleccionados := TStringList.Create;
  try
    with FDQuery do
    begin
      SQL.Clear;
      SQL.Add('SELECT id AS ID, tipo, observaciones, "USER" AS usuario, tipodoc, iddoc, fechahora');
      SQL.Add('FROM logbd');
      SQL.Add('WHERE 1=1');

      // Filtro por observaciones
      if filtro.Trim <> '' then
      begin
        SQL.Add('  AND observaciones ILIKE :filtro');
        ParamByName('filtro').AsString := '%' + filtro.Trim + '%';
      end;

      // Filtro por tipo usando checkboxes
      tiposSeleccionados.Clear;
      if chkINFO.Checked then tiposSeleccionados.Add('0');
      if chkERROR.Checked then tiposSeleccionados.Add('1');

      if tiposSeleccionados.Count > 0 then
      begin
        // Construimos la cláusula IN correctamente para números
        tipoCond := '';
        for i := 0 to tiposSeleccionados.Count - 1 do
        begin
          if i > 0 then
            tipoCond := tipoCond + ',';
          tipoCond := tipoCond + tiposSeleccionados[i];
        end;
        SQL.Add('  AND tipo IN (' + tipoCond + ')');
      end;

      SQL.Add('ORDER BY id ASC');
      Open;

      FDQuery.FieldByName('id').DisplayLabel := T_('TFrListadoLog','detalle_documento');
    end;

    HideGridColumns(DBGridListado, ['id','tipo']);

    AutoSizeDBGridColumns(DBGridListado, 200);
  finally
    tiposSeleccionados.Free;
  end;
end;

procedure TFrListadoLog.chkERRORClick(Sender: TObject);
begin
  inherited;
  CargarListado(buscaedit.Text);
end;

procedure TFrListadoLog.chkINFOClick(Sender: TObject);
begin
  inherited;
  CargarListado(buscaedit.Text);
end;

procedure TFrListadoLog.Loaded;
begin
  inherited;
  Botonnuevo.Visible := False;
  Botoneditar.Visible := False;
  btnborrar.Visible := False;
  Panelfiltros.Height := 5;
  TranslateTree(Self, '');
end;

//procedure TFrListadoLog.doFilter;
//const
//  ALTURA_PANEL_OCULTO = 5;
//  ALTURA_PANEL_VISIBLE = 64;
//begin
//  if Panelfiltros.Height <= ALTURA_PANEL_OCULTO then
//  begin
//    Panelfiltros.Height := ALTURA_PANEL_VISIBLE;
//    Panelfiltros.Visible := True;
//  end
//  else
//  begin
//    Panelfiltros.Height := ALTURA_PANEL_OCULTO;
//    Panelfiltros.Visible := False;
//  end;
//
//  // Forzar que se actualice la UI
//  Panelfiltros.Update;
//  Panelfiltros.Repaint;
//end;

end.

