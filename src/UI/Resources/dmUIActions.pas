unit dmUIActions;

interface

uses
  System.SysUtils, System.Classes, System.Actions,uTranslator,
  Vcl.ActnList, Vcl.Menus,Vcl.Dialogs, Vcl.PlatformDefaultStyleActnCtrls,
  Vcl.ActnMan, Vcl.Controls;

type
  TdmActions = class(TDataModule)
    ActionManager1: TActionManager;
    ActCliente: TAction;
    actLogin: TAction;
    actLogout: TAction;
    actSearch: TAction;
    actApagar: TAction;
    actClose: TAction;
    actClearFilter: TAction;
    actFilter: TAction;
    actAdd: TAction;
    actEdit: TAction;
    actDelete: TAction;
    actSave: TAction;
    ActEmpleado: TAction;
    ActRegistros: TAction;
    ActPermisos: TAction;
    ActProveedores: TAction;
    procedure DataModuleCreate(Sender: TObject);
    procedure ActionListUpdate(Action: TBasicAction; var Handled: Boolean);
    procedure actSearchExecute(Sender: TObject);
    procedure actCloseExecute(Sender: TObject);
    procedure actFilterExecute(Sender: TObject);
    procedure actClearFilterExecute(Sender: TObject);
    procedure actAddExecute(Sender: TObject);
    procedure actEditExecute(Sender: TObject);
    procedure actDeleteExecute(Sender: TObject);
    procedure actSaveExecute(Sender: TObject);
    procedure ActEmpleadoExecute(Sender: TObject);
    procedure ActClienteExecute(Sender: TObject);
    procedure ActRegistrosExecute(Sender: TObject);
    procedure ActPermisosExecute(Sender: TObject);
    procedure ActProveedoresExecute(Sender: TObject);

  public

  end;

var
  dmActions: TdmActions;

implementation

{$R *.dfm}

uses
  dmImageResources,  // dmImages: ImageCollection1 + VirtualImageList1
  uSession,         // AppSession (estado de login)
  fMain,framebase,framelistado;



procedure TdmActions.DataModuleCreate(Sender: TObject);
var
 I: Integer;
begin
  TranslateTree(dmActions,''); //traducir el componente
end;

function FrameOfSender(Sender: TObject): TFrBase;
var
  Ctrl: TControl;
begin
  Result := nil;
  Ctrl := nil;

  // Si el sender es directamente un control (p.ej. botón)
  if Sender is TControl then
    Ctrl := TControl(Sender)
  // Si el sender es una acción, usamos ActionComponent
  else if (Sender is TCustomAction) and
          (TCustomAction(Sender).ActionComponent is TControl) then
    Ctrl := TControl(TCustomAction(Sender).ActionComponent);

  if Ctrl = nil then
    Exit;

  // Subimos por la jerarquía de Parent hasta encontrar un TFrBase
  while Ctrl <> nil do
  begin
    if Ctrl is TFrBase then
      Exit(TFrBase(Ctrl));
    Ctrl := Ctrl.Parent;
  end;
end;

{ ---------------------------------------------------------------------------- }
{ Acciones                                                                     }
{ ---------------------------------------------------------------------------- }

procedure TdmActions.actSaveExecute(Sender: TObject);
var
  F: TFrBase;
begin
  F := FrameOfSender(Sender);

  if Assigned(F) then
    F.DoSave;
end;

procedure TdmActions.actSearchExecute(Sender: TObject);
var
  F: TFrBase;
begin
   F := FrameOfSender(Sender);
  if Assigned(F) then
    F.DoSearch;
end;

procedure TdmActions.actAddExecute(Sender: TObject);
var
  F: TFrBase;
begin
  F := FrameOfSender(Sender);

  if Assigned(F) then
  F.doAdd;
end;


procedure TdmActions.actClearFilterExecute(Sender: TObject);
var
  F: TFrBase;
begin
   F := FrameOfSender(Sender);
  if Assigned(F) then
    F.doClearFilter;
end;

procedure TdmActions.ActClienteExecute(Sender: TObject);
begin
FrmMain.abrirlistadoCliente;
end;

procedure TdmActions.ActPermisosExecute(Sender: TObject);
begin
FrmMain.abrirlistadoPermisos
end;


procedure TdmActions.ActProveedoresExecute(Sender: TObject);
begin
FrmMain.abrirlistadoProveedores;
end;

procedure TdmActions.actCloseExecute(Sender: TObject);
var
  F: TFrBase;
begin
  F := FrameOfSender(Sender);
  if Assigned(F) then
    F.DoClose;
end;

procedure TdmActions.actDeleteExecute(Sender: TObject);
var
  F: TFrBase;
begin
   F := FrameOfSender(Sender);
  if Assigned(F) then
    F.doDelete;
end;

procedure TdmActions.actEditExecute(Sender: TObject);
var
  F: TFrBase;
begin
   F := FrameOfSender(Sender);
  if Assigned(F) then
    F.doEdit;
end;

procedure TdmActions.ActEmpleadoExecute(Sender: TObject);
begin
FrmMain.abrirlistadoEmpleado;
end;

procedure TdmActions.ActRegistrosExecute(Sender: TObject);
begin
FrmMain.abrirlistadoRegistros;
end;

procedure TdmActions.actFilterExecute(Sender: TObject);
var
  F: TFrBase;
begin
  F := FrameOfSender(Sender);
  if Assigned(F) then
    F.DoFilter;
end;



{ ---------------------------------------------------------------------------- }
{ Lógica general de actualización (habilitar/deshabilitar acciones)            }
{ ---------------------------------------------------------------------------- }


procedure TdmActions.ActionListUpdate(Action: TBasicAction; var Handled: Boolean);
var
  Logged: Boolean;
begin
  Logged := (AppSession.UserId <> 0); // ajusta según tu lógica de sesión

  actApagar.Enabled := not Logged;
  actLogin.Enabled    := not Logged;
  actLogout.Enabled   := Logged;
  actSearch.Enabled   := Logged;
  actCliente.Enabled   := Logged;
  actSearch.Enabled   := Logged;
  actClose.Enabled   := Logged;
  Handled := True;
end;
end.

