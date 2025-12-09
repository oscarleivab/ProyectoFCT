unit EditCliente;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FrameEdit, Vcl.StdCtrls, Vcl.ExtCtrls, System.Math,
  uClienteModel, uClientesService, Vcl.WinXCtrls, utoashelper, uTranslator,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

type
  // NUEVO: evento para avisar al listado
  TOnClienteGuardado = procedure(const AIdCliente: Integer) of object;

  TFrEditCliente = class(TFrEdit)
    ScrollBox1: TScrollBox;
    Panel5: TPanel;
    GroupBox1: TGroupBox;
    idedit: TEdit;
    tipodocbox: TComboBox;
    documentoedit: TEdit;
    labelnombre: TLabel;
    labelapellidos: TLabel;
    labelempresa: TLabel;
    Empresaedit: TEdit;
    apellidosedit: TEdit;
    nombreedit: TEdit;
    labelcodigo: TLabel;
    labeltipo: TLabel;
    labeldocumento: TLabel;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    labeltelefono1: TLabel;
    telefono1edit: TEdit;
    labeltelefono2: TLabel;
    telefono2edit: TEdit;
    labelcontacto: TLabel;
    labelemail: TLabel;
    emailedit: TEdit;
    personacontacto: TEdit;
    GroupBox5: TGroupBox;
    observacionesmemo: TMemo;
    GroupBox6: TGroupBox;
    GroupBox7: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    usuarioedit: TEdit;
    Passwordedit: TEdit;
    webedit: TEdit;
    labeltarifa: TLabel;
    tipotarifabox: TComboBox;
    labelpermiso: TLabel;
    grupopermisobox: TComboBox;
    activocheck: TToggleSwitch;
    procedure ScrollBox1MouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure ScrollBox1MouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure paneltopClick(Sender: TObject);
  private
    Cliente: TCliente;
    FOnClienteGuardado: TOnClienteGuardado;
  public
    property OnClienteGuardado: TOnClienteGuardado
      read FOnClienteGuardado write FOnClienteGuardado;

    Procedure Cargardatos(Id: Integer); Override;
    Procedure Grabardatos;
    Procedure CargarClienteEnFormulario;
    Procedure CargarFormularioEnCliente;
    Procedure DoAdd; Override;
    Procedure DoSave; Override;

  protected
     procedure Notification(AComponent: TComponent; Operation: TOperation); override;

  end;

var
  FrEditCliente: TFrEditCliente;

implementation

{$R *.dfm}

procedure TFrEditCliente.CargarFormularioEnCliente;
begin
  Cliente.IdCliente        := StrToIntDef(idEdit.Text, 0);
  Cliente.Nombre           := nombreedit.Text;
  Cliente.Apellidos        := apellidosedit.Text;
  Cliente.IdTipoDocumento  := tipodocbox.ItemIndex;
  Cliente.DetalleDocumento := documentoedit.Text;
  Cliente.Empresa          := EmpresaEdit.Text;
  Cliente.Telefono1        := Telefono1Edit.Text;
  Cliente.Telefono2        := Telefono2Edit.Text;
  Cliente.Email            := EmailEdit.Text;
  Cliente.PersonaContacto  := PersonaContacto.Text;
  Cliente.UserLogin        := UsuarioEdit.Text;
  Cliente.PassLogin        := PasswordEdit.Text;
  Cliente.UrlWeb           := WebEdit.Text;
  Cliente.IdTarifa         := TipoTarifaBox.ItemIndex;
  Cliente.IdPermiso        := GrupoPermisoBox.ItemIndex;
  Cliente.Observaciones    := observacionesmemo.Text;
  Cliente.Activo           := activocheck.State = tssOn;
end;

procedure TFrEditCliente.CargarClienteEnFormulario;
begin
  idEdit.Text                 := Cliente.IdCliente.ToString;
  nombreEdit.Text             := Cliente.Nombre;
  apellidosEdit.Text          := Cliente.Apellidos;
  tipoDocBox.ItemIndex        := Cliente.IdTipoDocumento;
  documentoEdit.Text          := Cliente.DetalleDocumento;
  empresaEdit.Text            := Cliente.Empresa;
  telefono1Edit.Text          := Cliente.Telefono1;
  telefono2Edit.Text          := Cliente.Telefono2;
  emailEdit.Text              := Cliente.Email;
  personaContacto.Text        := Cliente.PersonaContacto;
  usuarioEdit.Text            := Cliente.UserLogin;
  passwordEdit.Text           := Cliente.PassLogin;
  webEdit.Text                := Cliente.UrlWeb;
  tipoTarifaBox.ItemIndex     := Cliente.IdTarifa;
  grupoPermisoBox.ItemIndex   := Cliente.IdPermiso;
  observacionesmemo.Text      := Cliente.Observaciones;
  if Cliente.Activo then
  activoCheck.State := tssOn
else
  activoCheck.State := tssOff;

end;

procedure TFrEditCliente.Cargardatos(Id: Integer);
begin
  try
    FreeAndNil(Cliente);

    if Id = 0 then
      Cliente := TCliente.Create
    else
      Cliente := TClientesService.Cargardatos(Id);

    CargarClienteEnFormulario;

  except
    on E: Exception do
      MostrarToast(T_('Errores','errorload') + ' ' + E.Message, 'error');
  end;
end;

procedure TFrEditCliente.DoAdd;
begin
  Cargardatos(0);
end;

procedure TFrEditCliente.DoSave;
begin
  Grabardatos;
end;

procedure TFrEditCliente.Grabardatos;
begin
  try
    CargarFormularioEnCliente;

    // guarda y vuelve con id (si es nuevo)
    Cliente.IdCliente := TClientesService.Grabardatos(Cliente);

    MostrarToast(T_('info','saveok'), 'ok');

    // AVISA al listado
    if Assigned(FOnClienteGuardado) then
      FOnClienteGuardado(Cliente.IdCliente);

  except
    on E: Exception do
      MostrarToast(T_('Errores','errorsave') + ' ' + E.Message, 'error');
  end;
end;

procedure TFrEditCliente.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) then
  begin
    // Si el componente que se va es el dueño del callback,
    // anulamos el evento para evitar AV.
    if Assigned(FOnClienteGuardado) and (TMethod(FOnClienteGuardado).Data = AComponent) then
      FOnClienteGuardado := nil;
  end;
end;

procedure TFrEditCliente.paneltopClick(Sender: TObject);
begin
  inherited;
  paneltop.color:=clred;
end;

procedure TFrEditCliente.ScrollBox1MouseWheelDown(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  inherited;
  ScrollBox1.VertScrollBar.Position:=ScrollBox1.VertScrollBar.Position+35;
end;

procedure TFrEditCliente.ScrollBox1MouseWheelUp(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  inherited;
  ScrollBox1.VertScrollBar.Position:=ScrollBox1.VertScrollBar.Position-35;
end;

end.

