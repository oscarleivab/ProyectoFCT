unit uGridHelper;

interface

uses
  System.SysUtils, System.Classes, Vcl.DBGrids, Data.DB,uTranslator, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

{ Ajusta el ancho de cada columna según el contenido.
  MaxRows define cuántas filas como máximo se usan para calcular el tamaño
  (para evitar recorrer datasets enormes). }
procedure AutoSizeDBGridColumns(AGrid: TDBGrid; MaxRows: Integer = 200);

{ Ajusta todas las columnas para que ocupen el ancho del grid a partes iguales }
procedure FitColumnsToGrid(AGrid: TDBGrid);

{ Asigna anchos fijos a las columnas:
  SetGridColumnWidths(DBGridListado, [60, 120, 150, 200]); }
procedure SetGridColumnWidths(AGrid: TDBGrid; const Widths: array of Integer);

{ Oculta columnas del DBGrid según nombre de campo }
procedure HideGridColumns(AGrid: TDBGrid; const FieldNames: array of string);

procedure SetTranslatedDisplayLabels(Q: TFDQuery; const GrupoTraduccion: string);

implementation

uses
  Vcl.Graphics, System.Math;

procedure AutoSizeDBGridColumns(AGrid: TDBGrid; MaxRows: Integer = 200);
var
  I, W, MaxW, RowCount: Integer;
  DS: TDataSet;
  Bmk: TBookmark;
begin
  if (AGrid = nil) or (AGrid.DataSource = nil) then
    Exit;

  DS := AGrid.DataSource.DataSet;
  if (DS = nil) or (not DS.Active) or DS.IsEmpty then
    Exit;

  AGrid.Canvas.Font := AGrid.Font;

  DS.DisableControls;
  Bmk := DS.GetBookmark;
  try
    DS.First;
    RowCount := 0;

    for I := 0 to AGrid.Columns.Count - 1 do
    begin
      // Ancho mínimo según el título
      MaxW := AGrid.Canvas.TextWidth(AGrid.Columns[I].Title.Caption + '  ');

      DS.First;
      RowCount := 0;
      while (not DS.Eof) and (RowCount < MaxRows) do
      begin
        if AGrid.Columns[I].Field <> nil then
        begin
          W := AGrid.Canvas.TextWidth(AGrid.Columns[I].Field.DisplayText + '  ');
          MaxW := Max(MaxW, W);
        end;
        Inc(RowCount);
        DS.Next;
      end;

      AGrid.Columns[I].Width := MaxW + 10; // margen extra
    end;

    if DS.BookmarkValid(Bmk) then
      DS.GotoBookmark(Bmk)
    else
      DS.First;
  finally
    DS.FreeBookmark(Bmk);
    DS.EnableControls;
  end;
end;

procedure FitColumnsToGrid(AGrid: TDBGrid);
var
  I, TotalClientWidth, ColWidth: Integer;
begin
  if (AGrid = nil) or (AGrid.Columns.Count = 0) then
    Exit;

  TotalClientWidth := AGrid.ClientWidth;

  // Un pequeño margen para evitar scroll horizontal por 1px
  ColWidth := TotalClientWidth div AGrid.Columns.Count;

  for I := 0 to AGrid.Columns.Count - 1 do
    AGrid.Columns[I].Width := ColWidth - 2;
end;

procedure SetGridColumnWidths(AGrid: TDBGrid; const Widths: array of Integer);
var
  I, Count: Integer;
begin
  if (AGrid = nil) then
    Exit;

  Count := Min(AGrid.Columns.Count, Length(Widths));
  for I := 0 to Count - 1 do
    AGrid.Columns[I].Width := Widths[I];
end;

procedure HideGridColumns(AGrid: TDBGrid; const FieldNames: array of string);
var
  I, J: Integer;
begin
  if (AGrid = nil) then
    Exit;

  for I := 0 to AGrid.Columns.Count - 1 do
  begin
    for J := 0 to High(FieldNames) do
    begin
      if SameText(AGrid.Columns[I].FieldName, FieldNames[J]) then
      begin
        AGrid.Columns[I].Visible := False;
        Break;
      end;
    end;
  end;
end;

procedure SetTranslatedDisplayLabels(Q: TFDQuery; const GrupoTraduccion: string);
var
  I: Integer;
  F: TField;
begin
  if (Q = nil) or (not Q.Active) then
    Exit;

  for I := 0 to Q.Fields.Count - 1 do
  begin
    F := Q.Fields[I];

    // T_(Seccion, Clave) -> si no existe, devuelve la propia clave (FieldName)
    F.DisplayLabel := T_(GrupoTraduccion, F.FieldName);
  end;
end;


end.

