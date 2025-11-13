unit uNuevaEmpresa;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys,
  FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client, FireDAC.Comp.DataSet,
  uDBUtils, uIniUtils, FireDAC.Phys.PGDef, FireDAC.Phys.PG;

type
  {------------------------------------------------------------
    FORMULARIO: TfrmNuevaEmpresa
    ------------------------------------------------------------
    Este formulario se muestra solo cuando:

       - Primera ejecución del sistema, o
       - La base de datos primaria no contiene ninguna empresa.

    Su función es permitir registrar una nueva empresa y crear:

      - Una nueva base de datos
      - Un usuario de inicio de sesión dentro de esa base
      - La tabla "empleado"
      - El registro de la empresa en "bdgevensoftbase"
  ------------------------------------------------------------}
  TfrmNuevaEmpresa = class(TForm)
    Edit1: TEdit;  // Nombre de la empresa
    Edit2: TEdit;  // Nombre de la base de datos a crear
    Edit3: TEdit;  // Usuario de inicio de sesión interno
    Edit4: TEdit;  // Contraseña del usuario interno
    Button1: TButton; // Crear empresa
    Button2: TButton; // Continuar sin crear
    FDQuery1: TFDQuery;
    FDConnection1: TFDConnection;
    FDPhysPgDriverLink1: TFDPhysPgDriverLink;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    procedure CrearNuevaBaseDatos;
  public
    Creada: Boolean;  // Indica al Login si se ha creado una empresa o no
  end;

var
  frmNuevaEmpresa: TfrmNuevaEmpresa;

implementation

{$R *.dfm}

{=========================================}
{   BOTÓN: CREAR EMPRESA                  }
{=========================================}
procedure TfrmNuevaEmpresa.Button1Click(Sender: TObject);
begin
  try
    CrearNuevaBaseDatos;
    ShowMessage('Empresa creada correctamente.');

    Creada := True;   // Para que Login sepa que ya puede continuar
    Close;
  except
    on E: Exception do
      ShowMessage('Error al crear la empresa: ' + E.Message);
  end;
end;

{=========================================}
{   BOTÓN: CONTINUAR SIN CREAR            }
{=========================================}
procedure TfrmNuevaEmpresa.Button2Click(Sender: TObject);
begin
  if MessageDlg(
       '¿Seguro que desea cancelar el proceso?',
       mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    Creada := False;
    Close;
  end;
end;

{=========================================}
{   CREAR NUEVA BASE DE DATOS             }
{=========================================}
procedure TfrmNuevaEmpresa.CrearNuevaBaseDatos;
var
  ConnGeneral, ConnNueva: TFDConnection;
  Q: TFDQuery;
begin
  {------------------------------------------------------------
    VALIDACIÓN DE CAMPOS
    Se requieren:
      - Nombre de empresa
      - Nombre de la nueva base de datos
      - Usuario y contraseña para login interno
  ------------------------------------------------------------}
  if (Trim(Edit1.Text) = '') or
     (Trim(Edit2.Text) = '') or
     (Trim(Edit3.Text) = '') then
    raise Exception.Create('Debe completar todos los campos.');

  {------------------------------------------------------------
    1. CONECTAR A LA BASE GENERAL
       bdgevensoftbase → controla las empresas registradas.
  ------------------------------------------------------------}
  // 1. Intentar conectar a la base general bdgevensoftbase
  ConnGeneral := TFDConnection.Create(nil);
  try
    if not ConfigurarConexion(ConnGeneral,
          'localhost', 'bdgevensoftbase', 'postgres', '2003', 5432) then
    begin
      // No existe la BD general → crearla automáticamente
      ShowMessage('La base general "bdgevensoftbase" no existe. Se creará automáticamente.');

      // Crear conexión temporal al servidor sin base de datos
      var ConnTemp := TFDConnection.Create(nil);
      try
        if not ConfigurarConexion(ConnTemp,
              'localhost', 'postgres', 'postgres', '2003', 5432) then
          raise Exception.Create('No fue posible conectarse al servidor PostgreSQL para crear la base general.');

        // Crear la base bdgevensoftbase
        var QTemp := CrearQuery(ConnTemp);
        try
          QTemp.SQL.Text := 'CREATE DATABASE bdgevensoftbase';
          QTemp.ExecSQL;
        finally
          QTemp.Free;
        end;

      finally
        ConnTemp.Free;
      end;

      // Reintentar conexión ahora que ya está creada
      if not ConfigurarConexion(ConnGeneral,
            'localhost', 'bdgevensoftbase', 'postgres', '2003', 5432) then
        raise Exception.Create('La base general fue creada, pero no se pudo conectar.');

      // Crear la tabla empresa si no existe
      var QTabla: TFDQuery;
      QTabla := CrearQuery(ConnGeneral);
      try
        QTabla.SQL.Text :=
          'CREATE TABLE IF NOT EXISTS empresa (' +
          'id SERIAL PRIMARY KEY, ' +
          'bdname VARCHAR(100) NOT NULL, ' +
          'orden INTEGER NOT NULL DEFAULT 0, ' +
          'host VARCHAR(100) NOT NULL, ' +
          'port INTEGER NOT NULL DEFAULT 5432, ' +
          'userbd VARCHAR(100) NOT NULL, ' +
          'passbd VARCHAR(100) NOT NULL, ' +
          'empresaname VARCHAR(100) NOT NULL, ' +
          'activa BOOLEAN NOT NULL DEFAULT TRUE' +
          ');';
        QTabla.ExecSQL;
      finally
        QTabla.Free;
      end;
    end;

    {------------------------------------------------------------
      2. CREAR LA NUEVA BASE DE DATOS
    ------------------------------------------------------------}
    Q := CrearQuery(ConnGeneral);
    try
      Q.SQL.Text := 'CREATE DATABASE "' + Edit2.Text + '"';
      Q.ExecSQL;
    finally
      Q.Free;
    end;

    {------------------------------------------------------------
      3. CONEXIÓN A LA BASE DE DATOS RECIÉN CREADA
    ------------------------------------------------------------}
    ConnNueva := TFDConnection.Create(nil);
    try
      if not ConfigurarConexion(ConnNueva,
            'localhost', Edit2.Text, 'postgres', '2003', 5432) then
        raise Exception.Create('No se pudo conectar a la nueva base.');

      {------------------------------------------------------------
        4. CREAR TABLA empleado EN LA BASE NUEVA
      ------------------------------------------------------------}
      Q := CrearQuery(ConnNueva);
      try
        Q.SQL.Text :=
          'CREATE TABLE empleado (' +
          'id SERIAL PRIMARY KEY, ' +
          'usuario VARCHAR(50), ' +
          'password VARCHAR(50), ' +
          'nombre VARCHAR(100)' +
          ');';
        Q.ExecSQL;

        {------------------------------------------------------------
          5. INSERTAR EMPLEADO INICIAL (ADMIN)
        ------------------------------------------------------------}
        Q.SQL.Text :=
          'INSERT INTO empleado (usuario, password, nombre) ' +
          'VALUES (:u, :p, :n)';
        Q.ParamByName('u').AsString := Edit3.Text;          // Usuario login
        Q.ParamByName('p').AsString := Edit4.Text;          // Contraseña login
        Q.ParamByName('n').AsString := Edit1.Text + ' Admin';
        Q.ExecSQL;
      finally
        Q.Free;
      end;

      {------------------------------------------------------------
        6. REGISTRAR LA EMPRESA EN bdgevensoftbase
      ------------------------------------------------------------}
      Q := CrearQuery(ConnGeneral);
      try
        Q.SQL.Text :=
          'INSERT INTO empresa (empresaname, host, bdname, userbd, passbd, port, activa, orden) ' +
          'VALUES (:n, :h, :b, :u, :p, 5432, TRUE, 1)';
        Q.ParamByName('n').AsString := Edit1.Text;   // Nombre empresa
        Q.ParamByName('h').AsString := 'localhost';
        Q.ParamByName('b').AsString := Edit2.Text;   // Nombre base nueva
        Q.ParamByName('u').AsString := Edit3.Text;   // Usuario login interno
        Q.ParamByName('p').AsString := Edit4.Text;   // Contraseña login interna
        Q.ExecSQL;
      finally
        Q.Free;
      end;

    finally
      ConnNueva.Free;
    end;

  finally
    ConnGeneral.Free;
  end;
end;

end.

