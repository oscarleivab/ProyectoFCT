program Gevensoft;

uses
  Vcl.Forms,
  Winapi.Windows,
  dmAction in 'datamodules\dmAction.pas' {DataModule3: TDataModule},
  dmConnection in 'Data\dmConnection.pas' {W: TDataModule},
  dmImages in 'datamodules\dmImages.pas' {DataModule2: TDataModule},
  uDBUtils in 'Utils\uDBUtils.pas',
  uConfigIni in 'Utils\uConfigIni.pas',
  uLogin in 'UI\Login\uLogin.pas' {frmLogin},
  uNuevaEmpresa in 'UI\Inicio\uNuevaEmpresa.pas' {frmNuevaEmpresa},
  uConfig in 'UI\Config\uConfig.pas' {frmConfig},
  uMain in 'UI\Main\uMain.pas' {frmMain},
  uPostgreSQLInstaller in 'Utils\uPostgreSQLInstaller.pas',
  uSession in 'Utils\uSession.pas',
  uLog in 'Services\uLog.pas',
  uToastHelper in 'Common\uToastHelper.pas',
  FrameBase in 'UI\Main\FrameBase.pas' {Frame1: TFrame},
  uLoginManager in 'UI\Login\uLoginManager.pas',
  frLoginOverlay in 'UI\Login\frLoginOverlay.pas' {Frame2: TFrame},
  uDatabaselib in 'Data\uDatabaselib.pas',
  uTranslator in 'Services\uTranslator.pas',
  uFuncionesglobales in 'Common\uFuncionesglobales.pas',
  uGridHelper in 'Common\uGridHelper.pas',
  uSQL in 'Data\uSQL.pas',
  uConnectionUtils in 'Utils\uConnectionUtils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  //Application.CreateForm(TW, W);
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
  Application.CreateForm(TDataModule2, DataModule2);
  Application.CreateForm(TDataModule3, DataModule3);
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

