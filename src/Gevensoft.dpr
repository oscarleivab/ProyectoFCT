program GevenSoft;

uses
  Vcl.Forms,
  System.UITypes,
  fMain in 'UI\Shell\fMain.pas' {FrmMain},
  frStatusBar in 'UI\Shell\frStatusBar.pas' {FrameStatusBar: TFrame},
  uConfigIni in 'Utils\uConfigIni.pas',
  dmConnection in 'Data\dmConnection.pas' {DataModuleConnection: TDataModule},
  uSession in 'Utils\uSession.pas',
  uLoginManager in 'Logic\uLoginManager.pas',
  uConnectionUtils in 'Utils\uConnectionUtils.pas',
  frLoginOverlay in 'UI\Shell\frLoginOverlay.pas' {FrameLoginOverlay: TFrame},
  dmImageResources in 'UI\Resources\dmImageResources.pas' {dmImages: TDataModule},
  dmUIActions in 'UI\Resources\dmUIActions.pas' {dmActions: TDataModule},
  uTranslator in 'Services\uTranslator.pas',
  utoashelper in 'Common\utoashelper.pas',
  FrameBase in 'UI\Shell\FrameBase.pas' {FrBase: TFrame},
  faccionusuario in 'UI\Shell\faccionusuario.pas' {Dialogouserfrm},
  FormBase in 'UI\Shell\FormBase.pas' {FBase},
  uColores in 'UI\Resources\uColores.pas',
  uFuncionesglobales in 'Common\uFuncionesglobales.pas',
  uDatabaselib in 'Data\uDatabaselib.pas',
  FrameListado in 'UI\List\FrameListado.pas' {ListadoFrame: TFrame},
  ListadoClientes in 'UI\List\ListadoClientes.pas' {ListadoFrameCliente: TFrame},
  uGridHelper in 'Common\uGridHelper.pas',
  uSQL in 'Data\uSQL.pas',
  uLog in 'Services\uLog.pas',
  FrameEdit in 'UI\Edit\FrameEdit.pas' {FrEdit: TFrame},
  edCliente in 'UI\Edit\edCliente.pas' {FrEdCliente: TFrame},
  ListadoDirecciones in 'UI\List\ListadoDirecciones.pas' {ListadoFrameDirecciones: TFrame},
  edDireccion in 'UI\Edit\edDireccion.pas' {FrEditDireccion: TFrame},
  uinterfaces in 'Common\uinterfaces.pas',
  ListadoDatosBanco in 'UI\List\ListadoDatosBanco.pas' {ListadoFrameDatosBanco: TFrame},
  edDatosBanco in 'UI\Edit\edDatosBanco.pas' {FrEdDatosBanco: TFrame},
  ListadoEmpleado in 'UI\List\ListadoEmpleado.pas' {ListadoFrameEmpleado: TFrame},
  edEmpleado in 'UI\Edit\edEmpleado.pas' {FrEdEmpleado: TFrame},
  ListadoLog in 'UI\List\ListadoLog.pas' {FrListadoLog: TFrame},
  ListadoPermisos in 'UI\List\ListadoPermisos.pas' {ListadoFramePermisos: TFrame},
  edPermisos in 'UI\Edit\edPermisos.pas' {FrEdit1: TFrame},
  edProveedor in 'UI\Edit\edProveedor.pas' {FrEdProveedor: TFrame},
  ListadoProveedores in 'UI\List\ListadoProveedores.pas' {ListadoFrameProveedor: TFrame},
  fConfiguracion in 'UI\Shell\fConfiguracion.pas' {FrConfiguracion: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;

  Application.CreateForm(TDataModuleConnection, DataModuleConnection);
  Application.CreateForm(TdmImages, dmImages);
  Application.CreateForm(TdmActions, dmActions);
  Application.CreateForm(TFrmMain, FrmMain);
  Application.Run;

end.
