unit uLogin;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Phys.PGDef, FireDAC.Phys.PG, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, IniFiles, uMain,
  Vcl.Imaging.pngimage, Vcl.ExtCtrls, System.Actions, Vcl.ActnList,
  System.ImageList, Vcl.ImgList, Vcl.VirtualImageList, Vcl.BaseImageCollection,
  Vcl.ImageCollection, uDBUtils, uIniUtils, uConfig, uNuevaEmpresa;

type
  {------------------------------------------------------------
    FORMULARIO: TfrmLogin
    ------------------------------------------------------------
    Este formulario realiza el proceso de inicio de sesión:

      - Carga las empresas registradas en bdgevensoftbase
      - Verifica usuario y contraseña almacenados en la tabla empresa
      - Conecta a la base de datos de la empresa seleccionada
      - Si el login tiene éxito → LoginExitoso = True

    Es el formulario que controla el acceso al resto del programa.
  ------------------------------------------------------------}
  TfrmLogin = class(TForm)
    ComboBox1: TComboBox;         // Lista de empresas activas
    Edit1: TEdit;                 // Usuario de login interno
    Edit2: TEdit;                 // Contraseña interna
    Button1: TButton;             // Iniciar sesión
    FDConnection1: TFDConnection; // Conexión a bdgevensoftbase
    FDQuery1: TFDQuery;           // Query auxiliar
    FDPhysPgDriverLink1: TFDPhysPgDriverLink;
    FDQuery2: TFDQuery;           // Query para datos de la empresa seleccionada
    FDConnection2: TFDConnection; // Conexión a la base de datos de la empresa
    Button2: TButton;             // Configuración
    Button3: TButton;             // Salir
    ImageCollection1: TImageCollection;
    VirtualImageList1: TVirtualImageList;
    ActionList1: TActionList;
    Image1: TImage;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    procedure CargarEmpresas;
    procedure ConectarBase;
  public
    LoginExitoso: Boolean;  // Indica al sistema si el login ha sido correcto
  end;

var
  frmLogin: TfrmLogin;

implementation

{$R *.dfm}

{==============================================================}
{  EVENTO: FormCreate                                          }
{--------------------------------------------------------------}
{  Se ejecuta al crear el formulario de login.                 }
{  1. Se conecta a la base bdgevensoftbase usando el INI.      }
{  2. Comprueba si existen empresas registradas.               }
{  3. Si no hay ninguna → abre frmNuevaEmpresa.                }
{  4. Si sí hay → carga empresas en el ComboBox.               }
{==============================================================}
procedure TfrmLogin.FormCreate(Sender: TObject);
begin
  try
    ConectarBase;

    FDQuery1.SQL.Text := 'SELECT COUNT(*) AS total FROM empresa';
    FDQuery1.Open;

    // No existe ninguna empresa → abrir asistente de creación
    if FDQuery1.FieldByName('total').AsInteger = 0 then
    begin
      ShowMessage('No se ha encontrado ninguna empresa en la base de datos.');

      Application.CreateForm(TfrmNuevaEmpresa, frmNuevaEmpresa);
      frmNuevaEmpresa.ShowModal;
      frmNuevaEmpresa.Free;

      CargarEmpresas;
    end
    else
      CargarEmpresas;

  except
    on E: Exception do
      ShowMessage('Error al conectar con la base de datos: ' + E.Message);
  end;
end;

{==============================================================}
{  BOTÓN: Abrir configurador                                   }
{==============================================================}
procedure TfrmLogin.Button2Click(Sender: TObject);
begin
  Application.CreateForm(TfrmConfig, frmConfig);
  frmConfig.ShowModal;
  frmConfig.Free;

  // Recargar conexión con datos nuevos
  ConectarBase;
end;

{==============================================================}
{  BOTÓN: Salir del Login                                      }
{==============================================================}
procedure TfrmLogin.Button3Click(Sender: TObject);
begin
  frmLogin.Close;
end;

{==============================================================}
{  CONECTAR CON LA BASE DE DATOS PRINCIPAL (bdgevensoftbase)   }
{--------------------------------------------------------------}
{  - Toma los datos desde el archivo INI                       }
{  - Usa uDBUtils.ConfigurarConexion                           }
{==============================================================}
procedure TfrmLogin.ConectarBase;
var
  Host, DBName, User, Pass: string;
  Port: Integer;
begin
  // Obtener datos desde el INI
  LeerDatosConexion(Host, DBName, User, Pass, Port);

  // Conecta a la base de datos mediante el método ConfigurarConexion
  if ConfigurarConexion(FDConnection1, Host, DBName, User, Pass, Port) then
    ShowMessage('Conexión correcta con la base de datos: ' + DBName);
end;

{==============================================================}
{  CARGAR EMPRESAS ACTIVAS EN EL COMBOBOX                      }
{==============================================================}
procedure TfrmLogin.CargarEmpresas;
begin
  ComboBox1.Clear;

  FDQuery1.Close;
  FDQuery1.SQL.Text :=
    'SELECT empresaname FROM empresa WHERE activa = TRUE ORDER BY orden';
  FDQuery1.Open;

  FDQuery1.First;
  for var i := 0 to FDQuery1.RecordCount - 1 do
  begin
    ComboBox1.Items.Add(FDQuery1.FieldByName('empresaname').AsString);
    FDQuery1.Next;
  end;
end;

{==============================================================}
{  BOTÓN: LOGIN                                                }
{--------------------------------------------------------------}
{  Proceso completo:                                           }
{    - Verifica empresa seleccionada                          }
{    - Obtiene datos (host, bdname, userbd, passbd, port)      }
{    - Verifica usuario/contraseña ingresados                 }
{    - Se conecta a la base de datos de la empresa            }
{    - Si funciona → LoginExitoso = True                       }
{==============================================================}
procedure TfrmLogin.Button1Click(Sender: TObject);
var
  user, pass: string;
  BDName, Host: string;
begin
  // Debe seleccionar una empresa
  if ComboBox1.ItemIndex < 0 then
  begin
    ShowMessage('Debe seleccionar una empresa.');
    Exit;
  end;

  // Obtener datos de la empresa
  FDQuery2.Close;
  FDQuery2.SQL.Text :=
    'SELECT "host", bdname, userbd, passbd, port ' +
    'FROM empresa WHERE empresaname = :name';
  FDQuery2.ParamByName('name').AsString := ComboBox1.Text;
  FDQuery2.Open;

  if FDQuery2.IsEmpty then
  begin
    ShowMessage('No se encontró la empresa seleccionada.');
    Exit;
  end;

  // Leer credenciales ingresadas
  user := Trim(Edit1.Text);
  pass := Trim(Edit2.Text);

  // Comprobar credenciales internas
  if (user <> FDQuery2.FieldByName('userbd').AsString) or
     (pass <> FDQuery2.FieldByName('passbd').AsString) then
  begin
    ShowMessage('Usuario o contraseña incorrectos.');
    Exit;
  end;

  // Datos para conectar a la base de la empresa
  Host   := FDQuery2.FieldByName('host').AsString;
  BDName := FDQuery2.FieldByName('bdname').AsString;

  // Conectarse usando usuario PostgreSQL real
  if not ConfigurarConexion(
         FDConnection2,
         Host,
         BDName,
         'postgres',        // Usuario real de PostgreSQL
         '2003',            // Contraseña real
         FDQuery2.FieldByName('port').AsInteger
       ) then
  begin
    ShowMessage('No se pudo conectar con la base de datos ' + ComboBox1.Text);
    Exit;
  end;

  // Todo correcto
  ShowMessage('Conexión realizada con ' + ComboBox1.Text);
  LoginExitoso := True;
  Close;
end;

end.

