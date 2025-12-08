unit uFuncionesglobales;

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
  Vcl.Buttons, Datasnap.Provider, Datasnap.DBClient, Vcl.DBGrids,Vcl.DBCtrls, Vcl.ComCtrls, Vcl.Mask,System.Hash;

  //FUNCIONES GLOBALES
  procedure SeleccionarComboPorID(Combo: TComboBox; ID: Integer);
  function GetSHA256(const Texto: string): string;
  function iif(AValue: Boolean; Str1, Str2: Variant): Variant;

implementation

function GetSHA256(const Texto: string): string;
begin
  Result := THashSHA2.GetHashString(Texto, SHA256);
end;

procedure SeleccionarComboPorID(Combo: TComboBox; ID: Integer);
var
  i: Integer;
begin
  for i := 0 to Combo.Items.Count - 1 do
    if Integer(Combo.Items.Objects[i]) = ID then
    begin
      Combo.ItemIndex := i;
      Break;
    end;
end;

function iif(AValue: Boolean; Str1, Str2: Variant): Variant;
begin
  if AValue then
    Result := Str1
  else
    Result := Str2;
end;



end.
