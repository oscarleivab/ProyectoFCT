unit uDBUtils;

interface

uses
  System.SysUtils, FireDAC.Comp.Client, Vcl.Dialogs, System.Variants;

{------------------------------------------------------------
  MÓDULO: uDBUtils
  ------------------------------------------------------------
  Este módulo centraliza toda la lógica relacionada con:

    - Conexiones con FireDAC
    - Creación de consultas (TFDQuery)
    - Ejecución de consultas SQL genéricas
    - Verificación de registros
    - Obtención de valores de una tabla
-------------------------------------------------------------}

function ConfigurarConexion(FDConn: TFDConnection; Servidor, BaseDatos, Usuario, Clave: string;
                            Puerto: Integer = 5432): Boolean;

function CrearQuery(Conexion: TFDConnection): TFDQuery;

implementation

{------------------------------------------------------------
  FUNCIÓN: ConfigurarConexion
  ------------------------------------------------------------
  Configura un TFDConnection con los parámetros recibidos.

  - Asigna host, usuario, contraseña, puerto, etc.
  - Intenta conectarse automáticamente.
  - Si falla muestra un error claro.
-------------------------------------------------------------}
function ConfigurarConexion(FDConn: TFDConnection; Servidor, BaseDatos, Usuario, Clave: string;
                            Puerto: Integer): Boolean;
begin
  Result := False;

  FDConn.Connected := False;
  FDConn.Params.Clear;

  FDConn.DriverName := 'PG';
  FDConn.Params.Values['Server']   := Servidor;
  FDConn.Params.Values['Database'] := BaseDatos;
  FDConn.Params.Values['User_Name']:= Usuario;
  FDConn.Params.Values['Password'] := Clave;
  FDConn.Params.Values['Port']     := IntToStr(Puerto);

  try
    FDConn.Connected := True;
    Result := True;

  except
    on E: Exception do
      ShowMessage('❌ No se pudo conectar: ' + E.Message);
  end;
end;

{------------------------------------------------------------
  FUNCIÓN: CrearQuery
  ------------------------------------------------------------
  Crea y devuelve un TFDQuery asociado a una conexión.

  - Se usa para no depender de FDQuery colocadas en formularios.
-------------------------------------------------------------}
function CrearQuery(Conexion: TFDConnection): TFDQuery;
begin
  Result := TFDQuery.Create(nil);
  Result.Connection := Conexion;
end;
end.

