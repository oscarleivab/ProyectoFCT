unit fMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,dmUIActions,
  Vcl.Controls,dmImageResources, Vcl.Forms, Vcl.Dialogs, frStatusBar, frLoginOverlay, uLoginManager, uSession, dmConnection,
  Vcl.StdCtrls,uTranslator, Vcl.ExtCtrls, Vcl.Imaging.pngimage, Vcl.ComCtrls,
  System.Actions, Vcl.ActnList, Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan, uLog,
  Vcl.ToolWin, Vcl.ActnCtrls, Vcl.ActnMenus, uConfigIni, System.UITypes,utoashelper,FormBase,FrameBase,ListadoClientes,
  ListadoProveedor, ListadoLog;

type
  TFrmMain = class(TFBase)
    PageControl1: TPageControl;
    TabSheetPrincipal: TTabSheet;
    panelescritorio: TPanel;
    botonEmpleado: TButton;
    botonPermisos: TButton;
    botonProveedor: TButton;
    botonFacturaSimp: TButton;
    botonPedido: TButton;
    botonPresupuesto: TButton;
    botonFactura: TButton;
    botonAlbaran: TButton;
    botonConfiguracion: TButton;
    botonCerrarSesion: TButton;
    botonCerrarApp: TButton;
    botonServicios: TButton;
    botonGastos: TButton;
    botonEstadisticas: TButton;
    Button1: TButton;
    Button2: TButton;
    MenuPrincipalBar1: TActionMainMenuBar;
    btncliente: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private

    //Objetos
    FrStatusBar: TFrameStatusBar;
    FrLoginOverlay: TFrameLoginOverlay;

    procedure ShowLoginOverlay;
    procedure ShowStatusBarOverlay;
    procedure HideLoginOverlay;
    procedure HookLoginEvents;
    procedure HideMainMenuBar(const AHide: Boolean);
    procedure abrirlistado(Tipo:integer);

    //Acciones
    Procedure EnlazarAcciones;
    procedure OnLoginEnter(Sender: TObject);
    procedure OnLogOutEnter(Sender: TObject);
    procedure OnApagar(Sender: TObject);
    procedure OnEmpresaChange(Sender: TObject);
    procedure OnAbrirCliente(Sender: TObject);
    procedure OnIdiomaChange(Sender: TObject);
    procedure OnAbrirProveedor(Sender: TObject);
    procedure OnAbrirLog(Sender: TObject);


    //Operaciones
    Procedure Cargarempresaslogin;
    function sheetcreada(namesheet: string): Boolean;
    procedure ApplySessionToUI;

  public
    function ActiveFrame: TFrBase;
    Procedure EliminarSheet;

  end;


var
  FrmMain: TFrmMain;

implementation

uses
  pruebadbgrid;


{$R *.dfm}

procedure TFrmMain.FormCreate(Sender: TObject);
begin
  inherited;
  ShowStatusBarOverlay; //crear StatusBar

  HideMainMenuBar(true);  //oculto la barra de menu superior.

  EnlazarAcciones; // Enlaza acciones a metodos

   // Conecta la base principal
   try
    DataModuleConnection.ConnectToMainDatabase;
    ShowLoginOverlay; //Muestra Frame de Login
  except
    on E: Exception do
    begin
      MostrarToast(T_('Errores','errorbdprincial'), 'error');
      Exit;
      //Mostrar form de configuración de acceso a base de datos principal;
    end;
  end;

  TranslateTree(Self,''); //traducir el form completo

  Cargarempresaslogin; //cargar empresas

end;

Procedure TFrmMain.EnlazarAcciones;
begin
   //Enlaza acciones a tus métodos
  dmActions.actLogin.OnExecute  := OnLoginEnter;   // “Entrar” del overlay
  dmActions.actLogOut.OnExecute  := OnLogOutEnter;   // “Salir” del Main
  dmActions.actApagar.OnExecute := OnApagar;   // “Apagar” del overlay (cierra app)
  dmActions.actCliente.OnExecute := OnAbrirCliente;
  dmActions.actProveedor.OnExecute := OnAbrirProveedor;
  dmActions.actLog.OnExecute := OnAbrirLog;
end;

function FindFrameInControl(AControl: TWinControl): TFrBase;
var
  I: Integer;
  ctrl: TControl;
  sub: TFrBase;
begin
  Result := nil;

  if AControl = nil then
    Exit;

  for I := 0 to AControl.ControlCount - 1 do
  begin
    ctrl := AControl.Controls[I];

    // Si es un frame TFrBase, lo devolvemos
    if ctrl is TFrBase then
      Exit(TFrBase(ctrl));

    // Si es un contenedor, buscamos dentro
    if ctrl is TWinControl then
    begin
      sub := FindFrameInControl(TWinControl(ctrl));
      if sub <> nil then
        Exit(sub);
    end;
  end;
end;

function TfrmMain.ActiveFrame: TFrBase;
var
  pg: TTabSheet;
begin
  Result := nil;

  pg := PageControl1.ActivePage;
  if pg = nil then
    Exit;

  Result := FindFrameInControl(pg);
end;

Procedure TFrmMain.Cargarempresaslogin;
begin
   // Cargar empresas desde la base principal
  TLoginManager.LoadCompanies(FrLoginOverlay.cboEmpresa.Items);

  if FrLoginOverlay.cboEmpresa.Items.Count > 0 then
  begin
  FrLoginOverlay.cboEmpresa.ItemIndex := 0;
  OnEmpresaChange(nil);
  end;
end;

procedure TFrmMain.ApplySessionToUI;
begin
  // Cargar datos de la sesión en la barra de estado
  if Assigned(FrStatusBar) then
    FrStatusBar.UpdateStatus(AppSession.UserName, AppSession.CompanyName);
end;

procedure TFrmMain.Button2Click(Sender: TObject);
begin
  inherited;
  MostrarToast(T_('Errores','errorbdprincial')+' Una prueba de mensaje mucho mas largo con detalles que puede ser que se esté saliendo del bucle y no salga bien en pantalla', 'ok');
  MostrarToast(T_('Errores','errorbdprincial'), 'error');
  MostrarToast(T_('Errores','errorbdprincial'), 'warning');
  MostrarToast('Una prueba de mensaje mucho mas largo con detalles que puede ser que se esté saliendo del bucle y no salga bien en pantalla', 'ok');
end;

procedure TFrmMain.Button3Click(Sender: TObject);
begin
  inherited;
  //Dblog('Error al crear la base de datos inicial',conERROR,AppSession.UserId.ToString);
  //TxtLog('Error al crear la base de datos inicial');
  //DBLog('Error al procesar la factura', conError, tipoFACT, idFACT);
  TxtLog('Error');
  DBLog('Error al procesar la factura', conINFO, tipoINFO, idINFO);
end;

procedure TFrmMain.Button4Click(Sender: TObject);
begin
  inherited;
  form1.show;
end;

procedure TFrmMain.HideMainMenuBar(const AHide: Boolean);
begin
  if AHide then begin
    MenuPrincipalBar1.Align:=alnone;
    MenuPrincipalBar1.Top :=  -MenuPrincipalBar1.Height; // Mover fuera del formulario
  end
  else begin
    MenuPrincipalBar1.Align:=altop;
    MenuPrincipalBar1.Top := 0;
  end;                    // Devolver al sitio
end;

procedure TFrmMain.ShowStatusBarOverlay;
begin
  FrStatusBar := TFrameStatusBar.Create(Self);
  FrStatusBar.Parent := Self;
  FrStatusBar.Align := alBottom;
  FrStatusBar.UpdateStatus(' ', ' ');
  FrStatusBar.Visible:=false;
end;

procedure TFrmMain.ShowLoginOverlay;
begin
  if Assigned(FrLoginOverlay) then Exit;

  FrStatusBar.Visible:=false;
  MenuPrincipalBar1.enabled:=false;
  HideMainMenuBar(true);
  FrLoginOverlay := TFrameLoginOverlay.Create(self);
  FrLoginOverlay.Parent := Self;
  FrLoginOverlay.Align := alClient;
  HookLoginEvents;
  LoadAvailableLanguages(FrLoginOverlay.cboidioma);
end;

procedure TFrmMain.HideLoginOverlay;
begin
  if Assigned(FrLoginOverlay) then
  begin
    FrLoginOverlay.cboEmpresa.OnChange := nil;
    FreeAndNil(FrLoginOverlay);
  end;
end;

procedure TFrmMain.HookLoginEvents;
begin

//  Solo eventos propios del overlay
  FrLoginOverlay.cboEmpresa.OnChange := OnEmpresaChange;
  FrLoginOverlay.cboidioma.OnChange := OnIdiomaChange;

end;

procedure TFrmMain.OnIdiomaChange(Sender: TObject);
begin
  UseLanguage(FrLoginOverlay.cboidioma.text);
  TranslateTree(dmActions,'');
  TranslateTree(FrmMain,'');
end;


procedure TFrmMain.OnEmpresaChange(Sender: TObject);
var
  CompanyId: Integer;
  CompanyName: string;
begin

  if (FrLoginOverlay.cboEmpresa.ItemIndex < 0) then Exit;

  CompanyId := Integer(NativeInt(FrLoginOverlay.cboEmpresa.Items.Objects[FrLoginOverlay.cboEmpresa.ItemIndex]));
  TLoginManager.ConnectCompanyAndLoadEmployees(CompanyId, FrLoginOverlay.cboUsuario.Items, CompanyName);

  AppSession.CompanyId   := CompanyId;
  AppSession.CompanyName := CompanyName;

  if FrLoginOverlay.cboUsuario.Items.Count > 0 then
    FrLoginOverlay.cboUsuario.ItemIndex := 0;
end;

procedure TFrmMain.OnLoginEnter(Sender: TObject);
var
  EmployeeId: Integer;
begin
  if not Assigned(FrLoginOverlay) then
    Exit; // seguridad, evita Access Violation

  if (FrLoginOverlay.cboUsuario.ItemIndex < 0) then
  begin
    MostrarToast(T_('Errores','selecuser'), 'error');
    Exit;
  end;

  EmployeeId := Integer(NativeInt(FrLoginOverlay.cboUsuario.Items.Objects[FrLoginOverlay.cboUsuario.ItemIndex]));

  if TLoginManager.ValidateEmployee(EmployeeId, FrLoginOverlay.edtPass.Text) then
  begin
    HideLoginOverlay;
    ApplySessionToUI;
    FrStatusBar.Visible:=true;
    HideMainMenuBar(false);
    MenuPrincipalBar1.enabled:=true;
  end
  else
  begin
    MostrarToast(T_('Errores','errorcredenciales'), 'error');
  end;
end;

procedure TFrmMain.OnLogOutEnter(Sender: TObject);
begin
 AppSession.UserId := 0;
 ShowLoginOverlay;
 Cargarempresaslogin;
end;

procedure TFrmMain.OnAbrirCliente(Sender: TObject);
begin
 abrirlistado(0);
end;

procedure TFrmMain.OnAbrirProveedor(Sender: TObject);
begin
  abrirlistado(1);
end;

procedure TFrmMain.OnAbrirLog(Sender: TObject);
begin
  abrirlistado(2);
end;

procedure TFrmMain.abrirlistado(Tipo:integer);
var
  ListadoCliente: TListadoFrameCliente;
  ListadoProveedor: TFrBase1;
  ListadoLog: TFrListadoLog;
  nuevaTab: TTabSheet;
  nombreTab: string;
begin
  if Tipo = 0 then
    nombreTab := 'Clientes'
  else if Tipo = 1 then
    nombreTab := 'Proveedores'
  else if Tipo = 2 then
    nombreTab := 'Log';

  if not sheetcreada(nombreTab) then
  begin
    nuevaTab := TTabSheet.Create(PageControl1);
    nuevaTab.Name := 'TabSheet' + nombreTab;
    nuevaTab.Caption := nombreTab;
    nuevaTab.PageControl := PageControl1;

    case Tipo of
      0: begin
           // CLIENTES
           ListadoCliente := TListadoFrameCliente.Create(nuevaTab);
           ListadoCliente.Parent := nuevaTab;
           ListadoCliente.Align := alClient;
           ListadoCliente.doSearch;
         end;

      1: begin
           // PROVEEDORES
           ListadoProveedor := TFrBase1.Create(nuevaTab);
           ListadoProveedor.Parent := nuevaTab;
           ListadoProveedor.Align := alClient;
           ListadoProveedor.doSearch;
         end;

      2: begin
           // LOG
           ListadoLog := TFrListadoLog.Create(nuevaTab);
           ListadoLog.Parent := nuevaTab;
           ListadoLog.Align := alClient;
           ListadoLog.doSearch;
         end;
    end;

    PageControl1.ActivePage := nuevaTab;
  end;
end;


function TFrmMain.sheetcreada(namesheet: string): Boolean;
var
  sheet: TTabSheet;
  a: integer;
begin
  result := false;

  for a := 0 to PageControl1.ControlCount - 1 do
  begin
    sheet := TTabSheet(PageControl1.Controls[a]);

    if sheet.Caption = namesheet then
    begin
      PageControl1.ActivePageIndex := sheet.PageIndex;
      result := true;
    end;
  end;
end;

procedure TFrmMain.EliminarSheet;
var
  actual: Integer;
begin
  if PageControl1.PageCount = 0 then Exit;

  actual := PageControl1.ActivePageIndex;

  // Basta con liberar el TabSheet, sus hijos (frames, controles, etc.) se liberan solos
  PageControl1.Pages[actual].Free;

  // Ajustar la pestaña activa
  if PageControl1.PageCount > 0 then
  begin
    if actual > PageControl1.PageCount - 1 then
      PageControl1.ActivePageIndex := PageControl1.PageCount - 1
    else
      PageControl1.ActivePageIndex := actual;
  end
  else
    PageControl1.ActivePage := nil;
end;


procedure TFrmMain.OnApagar(Sender: TObject);
begin
  Application.Terminate;
end;



end.
