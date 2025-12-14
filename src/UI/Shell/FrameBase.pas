unit FrameBase;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,faccionusuario,
  utoashelper,Vcl.ComCtrls, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client,uTranslator,uInterfaces;

type
  TFrBase = class(TFrame)
    FDQuery: TFDQuery;
    DataSource: TDataSource;
  private
    { Private declarations }
    FOrigen: IListadoRefrescable;

  public
    { Public declarations }
    Dialogouserfrm: TDialogouserfrm;
    property Origen: IListadoRefrescable read FOrigen write FOrigen;
    procedure doClose; Virtual;
    procedure doFilter; Virtual;
    procedure doClearFilter; Virtual;
    procedure doSearch; Virtual;
    procedure doAdd; Virtual;
    procedure doEdit; Virtual;
    procedure doSave; Virtual;
    procedure doDelete; Virtual;
    procedure doRefresh; Virtual;
    procedure liberarObjetos;
  protected
    FToastManager: TToastManager;

    function GetIdFieldName: string; virtual;
    procedure MostrarToast(const Texto: string; Tipo: string = 'success');
    procedure Loaded; override;
    Function Validarcampos:boolean; Virtual;
    destructor Destroy; override;


    { Public declarations }

  end;

implementation

uses
fmain, uLog;

{$R *.dfm}


destructor TFrBase.Destroy;
begin
  liberarObjetos;
  inherited;
end;

Function TFrBase.Validarcampos:boolean;
begin
Result:=true;
end;

procedure TFrBase.doSearch;
begin
//
end;

procedure TFrBase.doRefresh;
begin
//
end;


procedure TFrBase.doFilter;
begin
//
end;

procedure TFrBase.doAdd;
begin
//
end;

procedure TFrBase.doEdit;
begin
//
end;

procedure TFrBase.doSave;
begin
 if FDQuery.State in dsEditModes then
 begin

    if ValidarCampos then begin

      FDQuery.Post;     // Guarda en memoria y ejecuta el UPDATE
      //refresca y posiciona si tiene listado, el resgistro que hemos guardado
        // Usamos la interfaz, sin conocer el objeto real
      if (Assigned(FOrigen)) and (GetIdFieldName<>'') then
        FOrigen.ActualizarRegistro(FDQuery.FieldByName(GetIdFieldName).AsInteger);

      MostrarToast(T_('info','saveok'), 'ok');
      DBLog('El usuario ha creado un registro correctamente', conINFO, tipoINFO, idINFO);
    end;

 end;
end;

procedure TFrBase.doDelete;
begin
//
end;

procedure TFrBase.doClearFilter;
begin
//
end;

procedure TFrBase.doClose;
var
  LParent: TWinControl;
begin
  LParent := Parent;

  // 1) El frame está dentro de una pestaña del PageControl principal
  if (LParent is TTabSheet) and
     (TTabSheet(LParent).PageControl = FrmMain.PageControl1) then
  begin
    FrmMain.EliminarSheet;
    Exit; // después de esto, Self probablemente ya está destruido
  end;

  // 2) El frame está dentro de un panel contenedor dinámico
  if (LParent is TPanel) then
  begin
    // Si el panel se creó dinámicamente para este frame y es su Owner:
    // TPanel.Free liberará también el frame
    LParent.Free;
    Exit;
  end;

  // 3) Caso genérico / fallback (por si algún día lo pones suelto en un form)
  Free;
end;


procedure TFrBase.liberarObjetos;
begin
 if Assigned(FToastManager) then
    begin
      FToastManager.ClearAll;
    end;
end;

procedure TFrBase.Loaded;
begin
  inherited;
  TranslateTree(Self,''); //traducir el form completo
  FToastManager := TToastManager.Create(Self);
  Dialogouserfrm := TDialogouserfrm.Create(Self);
  FDQuery.UpdateOptions.AutoIncFields := GetIdFieldName; // ← importante
end;

procedure TFrBase.MostrarToast(const Texto: string; Tipo: string = 'success');
begin
  if Assigned(FToastManager) then
    FToastManager.Show(Texto, Tipo);
end;

function TFrBase.GetIdFieldName: string;
begin
  Result := 'id'; // valor por defecto, la mayoría de tablas
end;

end.
