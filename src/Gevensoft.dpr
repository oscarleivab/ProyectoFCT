program Gevensoft;

uses
  Vcl.Forms,
  Winapi.Windows,
  dmAction in 'datamodules\dmAction.pas' {DataModule3: TDataModule},
  dmConnection in 'datamodules\dmConnection.pas' {DataModule1: TDataModule},
  dmImages in 'datamodules\dmImages.pas' {DataModule2: TDataModule},
  uDBUtils in 'utils\uDBUtils.pas',
  uIniUtils in 'utils\uIniUtils.pas',
  uLogin in 'forms\Login\uLogin.pas' {frmLogin},
  uNuevaEmpresa in 'forms\Inicio\uNuevaEmpresa.pas' {frmNuevaEmpresa},
  uConfig in 'forms\Config\uConfig.pas' {frmConfig},
  uMain in 'forms\Main\uMain.pas' {frmMain},
  uPostgreSQLInstaller in 'utils\uPostgreSQLInstaller.pas';

{$R *.res}
var
  PrimeraVez: Integer;

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDataModule1, DataModule1);
  {--------------------------------------------------------------
    ⭐ PASO 0: VERIFICAR E INSTALAR POSTGRESQL SI ES NECESARIO
    -------------------------------------------------------------
    - Verifica que PostgreSQL esté instalado
    - Si no está, lo instala desde: utilidades\postgresql-18-windows-x64.exe
    - Si falla o se cancela, cierra la aplicación
  --------------------------------------------------------------}
    if not VerificarPostgreSQL then
    begin
      Application.MessageBox(
        'PostgreSQL es requerido para ejecutar Gevensoft.' + #13#10 +
        'La aplicación se cerrará.',
        'Error - PostgreSQL no disponible',
        MB_OK or MB_ICONERROR
      );
      Exit;
    end;

  {--------------------------------------------------------------
    Paso 1: Verificar existencia del archivo INI y primera ejecucion
    -------------------------------------------------------------
    - Se utiliza la función VerificarOCrearIni del módulo uIniUtils.
    - Esta función centraliza la lógica de comprobación y creación
      del archivo Gevensoft.ini si no existe.
    - Una vez creada comprueba si es la primera ejecución del programa o
      no. Si lo es muestra el formulario uNuevaEmpresa y este cambia el
      valor del archivo .ini a 1 al terminar con la creación de una base
      de datos
  --------------------------------------------------------------}
    // Verificar o crear archivo INI
    VerificarOCrearIni;

    PrimeraVez := LeerPrimeraEjecucion;

    if PrimeraVez = 0 then
    begin
      Application.CreateForm(TfrmNuevaEmpresa, frmNuevaEmpresa);
  Application.CreateForm(TDataModule3, DataModule3);
  Application.CreateForm(TDataModule1, DataModule1);
  Application.CreateForm(TDataModule2, DataModule2);
  frmNuevaEmpresa.ShowModal;

      if not frmNuevaEmpresa.Creada then
      begin
        Application.Terminate;
        Exit;
      end;

      GuardarPrimeraEjecucion(1);

      frmNuevaEmpresa.Free;
    end;

  {--------------------------------------------------------------
    Paso 2: Crear y mostrar el formulario principal (frmMain)
    -------------------------------------------------------------
    - El formulario principal se crea primero y se muestra maximizado.
    - Se desactiva la interacción del usuario (Enabled := False)
      hasta que el login sea exitoso.
    - Esto permite que el Login aparezca encima como una capa modal.
  --------------------------------------------------------------}
  Application.CreateForm(TfrmMain, frmMain);
  frmMain.WindowState := wsMaximized;
  frmMain.Enabled := False;
  frmMain.Show; // Se muestra al usuario como fondo

  {--------------------------------------------------------------
    Paso 3: Crear y mostrar el formulario de Login
    -------------------------------------------------------------
    - El login se muestra centrado en la pantalla.
    - Se ejecuta de forma modal, por lo que el flujo del programa
      se detiene hasta que el usuario cierre el formulario de Login.
  --------------------------------------------------------------}
  Application.CreateForm(TfrmLogin, frmLogin);
  frmLogin.Position := poScreenCenter;
  frmLogin.ShowModal;

  {--------------------------------------------------------------
    Paso 4: Validación del inicio de sesión
    -------------------------------------------------------------
    - Si el login fue exitoso (frmLogin.LoginExitoso = True):
         * Se habilita el formulario principal.
         * Se lleva al frente (BringToFront) para el uso normal.
    - Si el login se cancela o se cierra la ventana:
         * Se cierra la aplicación completamente (Application.Terminate).
  --------------------------------------------------------------}
  if frmLogin.LoginExitoso then
  begin
    frmMain.Enabled := True;
    frmMain.BringToFront;
  end
  else
  begin
    Application.Terminate;
    Exit;
  end;

  {--------------------------------------------------------------
    Paso 5: Iniciar el ciclo principal de la aplicación
    -------------------------------------------------------------
    - Lanza el bucle de mensajes de Windows Forms (Run),
      manteniendo la interfaz activa hasta que el usuario cierre todo.
  --------------------------------------------------------------}
  Application.Run;
end.

