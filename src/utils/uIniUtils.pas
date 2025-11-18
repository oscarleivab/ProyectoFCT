unit uIniUtils;

interface

uses
  System.SysUtils, System.IniFiles, Vcl.Dialogs, System.Classes;

{------------------------------------------------------------
  MÓDULO: uIniUtils
  ------------------------------------------------------------
  Este módulo gestiona todo lo relacionado con el archivo de
  configuración "Gevensoft.ini".

  Aquí se centraliza:
    - Lectura y escritura de los datos de conexión.
    - Comprobación de primera ejecución.
    - Creación automática del archivo INI si no existe.
    - Acceso a la ruta del archivo INI.
-------------------------------------------------------------}

{ Funciones de conexión }
procedure LeerDatosConexion(var Servidor, BaseDatos, Usuario, Clave: string; var Puerto: Integer);
procedure GuardarDatosConexion(Servidor, BaseDatos, Usuario, Clave: string; Puerto: Integer);

{ Primera ejecución del sistema }
function LeerPrimeraEjecucion: Integer;
procedure GuardarPrimeraEjecucion(Valor: Integer);

{ Funciones generales }
function RutaIni: string;
procedure VerificarOCrearIni;

implementation

{------------------------------------------------------------
  FUNCIÓN: RutaIni
  ------------------------------------------------------------
  Devuelve la ruta física del archivo "Gevensoft.ini" ubicado
  en el mismo directorio donde está el ejecutable.

  IncludeTrailingPathDelimiter añade automáticamente la barra
  final "\" si fuese necesario.
-------------------------------------------------------------}
function RutaIni: string;
begin
  Result := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) +
            'ini\' +         // carpeta del ejecutable
            'Gevensoft.ini'; // nombre del archivo
end;

{------------------------------------------------------------
  FUNCIÓN: LeerPrimeraEjecucion
  ------------------------------------------------------------
  Obtiene el valor [SYSTEM] PrimeraEjecucion del archivo INI.

  0 → primera vez que se ejecuta el programa
  1 → el programa ya fue iniciado al menos una vez
-------------------------------------------------------------}
function LeerPrimeraEjecucion: Integer;
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(RutaIni);
  try
    Result := Ini.ReadInteger('SYSTEM', 'PrimeraEjecucion', 0);
  finally
    Ini.Free;
  end;
end;

{------------------------------------------------------------
  PROCEDIMIENTO: LeerDatosConexion
  ------------------------------------------------------------
  Lee los valores dentro de la sección [DATABASE] del INI.
  Devuelve: servidor, base de datos, usuario, contraseña, puerto.

  Si no existe el INI, muestra un mensaje de error.
-------------------------------------------------------------}
procedure LeerDatosConexion(var Servidor, BaseDatos, Usuario, Clave: string; var Puerto: Integer);
var
  Ini: TIniFile;
  Ruta: string;
begin
  Ruta := RutaIni;

  if not FileExists(Ruta) then
  begin
    ShowMessage('No se encontró el archivo Gevensoft.ini.');
    Exit;
  end;

  Ini := TIniFile.Create(Ruta);
  try
    Servidor  := Ini.ReadString('DATABASE', 'Server',   'localhost');
    BaseDatos := Ini.ReadString('DATABASE', 'Database', 'bdgevensoftbase');
    Usuario   := Ini.ReadString('DATABASE', 'User',     'postgres');
    Clave     := Ini.ReadString('DATABASE', 'Password', '2003');
    Puerto    := Ini.ReadInteger('DATABASE', 'Port',    5432);
  finally
    Ini.Free;
  end;
end;

{------------------------------------------------------------
  PROCEDIMIENTO: GuardarDatosConexion
  ------------------------------------------------------------
  Guarda los valores dentro del archivo INI en la sección
  [DATABASE].

  Si el archivo no existe se creará automáticamente.
-------------------------------------------------------------}
procedure GuardarDatosConexion(Servidor, BaseDatos, Usuario, Clave: string; Puerto: Integer);
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(RutaIni);
  try
    Ini.WriteString('DATABASE', 'Server',   Servidor);
    Ini.WriteString('DATABASE', 'Database', BaseDatos);
    Ini.WriteString('DATABASE', 'User',     Usuario);
    Ini.WriteString('DATABASE', 'Password', Clave);
    Ini.WriteInteger('DATABASE', 'Port',    Puerto);
  finally
    Ini.Free;
  end;

  ShowMessage('Datos guardados correctamente.');
end;

{------------------------------------------------------------
  PROCEDIMIENTO: VerificarOCrearIni
  ------------------------------------------------------------
  Comprueba si el archivo INI existe.

  - Si NO existe → lo crea con valores por defecto
  - Incluye el valor PrimeraEjecucion en 0
-------------------------------------------------------------}
procedure VerificarOCrearIni;
var
  Ruta: string;
  Ini: TIniFile;
begin
  Ruta := RutaIni;

  if not FileExists(Ruta) then
  begin
    Ini := TIniFile.Create(Ruta);
    try
      // Valores por defecto para la base principal
      Ini.WriteString('DATABASE', 'Server',   'localhost');
      Ini.WriteString('DATABASE', 'Database', 'bdgevensoftbase');
      Ini.WriteString('DATABASE', 'User',     'postgres');
      Ini.WriteString('DATABASE', 'Password', '2003');
      Ini.WriteInteger('DATABASE', 'Port',    5432);

      // Marca de primera ejecución
      Ini.WriteInteger('SYSTEM', 'PrimeraEjecucion', 0);
    finally
      Ini.Free;
    end;

    ShowMessage('Archivo Gevensoft.ini creado automáticamente en: ' + Ruta);
  end;
end;

{------------------------------------------------------------
  PROCEDIMIENTO: GuardarPrimeraEjecucion
  ------------------------------------------------------------
  Cambia el valor de PrimeraEjecucion en el INI.
  Se usa para indicar que el sistema ya fue iniciado una vez.
-------------------------------------------------------------}
procedure GuardarPrimeraEjecucion(Valor: Integer);
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(RutaIni);
  try
    Ini.WriteInteger('SYSTEM', 'PrimeraEjecucion', Valor);
  finally
    Ini.Free;
  end;
end;

end.

