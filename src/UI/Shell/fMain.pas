unit fMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,dmUIActions,
  Vcl.Controls,dmImageResources, Vcl.Forms, Vcl.Dialogs, frStatusBar, frLoginOverlay, uLoginManager, uSession, dmConnection,
  Vcl.StdCtrls,uTranslator, Vcl.ExtCtrls, Vcl.Imaging.pngimage, Vcl.ComCtrls,
  System.Actions, Vcl.ActnList, Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan, uLog,
  Vcl.ToolWin, Vcl.ActnCtrls, Vcl.ActnMenus, uConfigIni, System.UITypes,utoashelper,FormBase,FrameBase,FrameListado,ListadoClientes,ListadoEmpleado,
  ListadoLog, ListadoPermisos, ListadoProveedores;

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
    btnRegistros: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private

    //Objetos
    FrStatusBar: TFrameStatusBar;
    FrLoginOverlay: TFrameLoginOverlay;

    procedure ShowLoginOverlay;
    procedure ShowStatusBarOverlay;
    procedure HideLoginOverlay;
    procedure HookLoginEvents;
    procedure HideMainMenuBar(const AHide: Boolean);


    //Acciones
    Procedure EnlazarAcciones;
    procedure OnLoginEnter(Sender: TObject);
    procedure OnLogOutEnter(Sender: TObject);
    procedure OnApagar(Sender: TObject);
    procedure OnEmpresaChange(Sender: TObject);
    procedure OnIdiomaChange(Sender: TObject);


    //Operaciones
    Procedure Cargarempresaslogin;
    function sheetcreada(namesheet: string): Boolean;
    procedure ApplySessionToUI;

  public
    procedure abrirlistadoCliente;
    procedure abrirlistadoEmpleado;
    procedure abrirlistadoRegistros;
    procedure abrirlistadoPermisos;
    procedure abrirlistadoProveedores;
    Procedure EliminarSheet;

  end;


var
  FrmMain: TFrmMain;

implementation

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
  DBLog('Se ha guardado correctamente el registro.', conINFO, tipoINFO, idINFO);
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

procedure TFrmMain.abrirlistadoCliente;
var
  ListadoCliente: TListadoFrameCliente;
  nuevaTab: TTabSheet;
begin
  if not sheetcreada('Clientes') then
  begin
    nuevaTab := TTabSheet.Create(PageControl1);
    nuevaTab.name := 'TabSheetClientes';
    nuevaTab.ImageIndex:=1;
    TranslateTree(nuevaTab,'FrmMain');

    // Se le asigna el "TPageControl"
    nuevaTab.PageControl := PageControl1;
    ListadoCliente := TListadoFrameCliente.Create(nuevaTab);
    ListadoCliente.Parent := nuevaTab;
    ListadoCliente.Align := Alclient;
    ListadoCliente.doSearch;
    PageControl1.ActivePageIndex := PageControl1.PageCount - 1;
  end;
end;

procedure TFrmMain.abrirlistadoProveedores;
var
  ListadoProveedor: TListadoFrameProveedores;
  nuevaTab: TTabSheet;
begin
  if not sheetcreada('Proveedores') then
  begin
    nuevaTab := TTabSheet.Create(PageControl1);
    nuevaTab.name := 'TabSheetProveedores';
    nuevaTab.ImageIndex:=1;
    TranslateTree(nuevaTab,'FrmMain');

    // Se le asigna el "TPageControl"
    nuevaTab.PageControl := PageControl1;
    ListadoProveedor := TListadoFrameProveedores.Create(nuevaTab);
    ListadoProveedor.Parent := nuevaTab;
    ListadoProveedor.Align := Alclient;
    ListadoProveedor.doSearch;
    PageControl1.ActivePageIndex := PageControl1.PageCount - 1;
  end;
end;

procedure TFrmMain.abrirlistadoPermisos;
var
  ListadoPermisos: TListadoFramePermisos;
  nuevaTab: TTabSheet;
begin
  if not sheetcreada('Permisos') then
  begin
    nuevaTab := TTabSheet.Create(PageControl1);
    nuevaTab.name := 'TabSheetPermisos';
    nuevaTab.ImageIndex:=1;
    TranslateTree(nuevaTab,'FrmMain');

    // Se le asigna el "TPageControl"
    nuevaTab.PageControl := PageControl1;
    ListadoPermisos := TListadoFramePermisos.Create(nuevaTab);
    ListadoPermisos.Parent := nuevaTab;
    ListadoPermisos.Align := Alclient;
    ListadoPermisos.doSearch;
    PageControl1.ActivePageIndex := PageControl1.PageCount - 1;
  end;
end;

 procedure TFrmMain.abrirlistadoEmpleado;
var
  ListadoEmpleado: TListadoFrameEmpleado;
  nuevaTab: TTabSheet;
begin
  if not sheetcreada('Empleados') then
  begin
    nuevaTab := TTabSheet.Create(PageControl1);
    nuevaTab.name := 'TabSheetEmpleado';
    nuevaTab.ImageIndex:=1;
    TranslateTree(nuevaTab,'FrmMain');

    // Se le asigna el "TPageControl"
    nuevaTab.PageControl := PageControl1;
    ListadoEmpleado := TListadoFrameEmpleado.Create(nuevaTab);
    ListadoEmpleado.Parent := nuevaTab;
    ListadoEmpleado.Align := Alclient;
    ListadoEmpleado.doSearch;
    PageControl1.ActivePageIndex := PageControl1.PageCount - 1;
  end;
end;

procedure TFrmMain.abrirlistadoRegistros;
var
  ListadoRegistros: TFrListadoLog;
  nuevaTab: TTabSheet;
begin
  if not sheetcreada('Registros') then
  begin
    nuevaTab := TTabSheet.Create(PageControl1);
    nuevaTab.name := 'TabSheetRegistros';
    nuevaTab.ImageIndex:=1;
    TranslateTree(nuevaTab,'FrmMain');

    // Se le asigna el "TPageControl"
    nuevaTab.PageControl := PageControl1;
    ListadoRegistros := TFrListadoLog.Create(nuevaTab);
    ListadoRegistros.Parent := nuevaTab;
    ListadoRegistros.Align := Alclient;
    ListadoRegistros.doSearch;
    PageControl1.ActivePageIndex := PageControl1.PageCount - 1;
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

function FindFrameByNameInControl(AParent: TWinControl; const AName: string): TFrame;
var
  I: Integer;
  C: TControl;
  SubFrame: TFrame;
begin
  Result := nil;
  if AParent = nil then
    Exit;

  for I := 0 to AParent.ControlCount - 1 do
  begin
    C := AParent.Controls[I];

    // Si es un frame, comprobamos el nombre
    if C is TFrame then
    begin
      if SameText(C.Name, AName) then
        Exit(TFrame(C));
    end;

    // Si es contenedor, buscamos dentro (recursivo)
    if C is TWinControl then
    begin
      SubFrame := FindFrameByNameInControl(TWinControl(C), AName);
      if SubFrame <> nil then
        Exit(SubFrame);
    end;
  end;
end;

procedure TFrmMain.OnApagar(Sender: TObject);
begin
  Application.Terminate;
end;



end.
