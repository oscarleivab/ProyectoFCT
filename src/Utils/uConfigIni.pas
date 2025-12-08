unit uConfigIni;

interface

uses
  System.SysUtils, System.IniFiles, System.IOUtils, System.Classes;

type
  TAppConfig = class
  private
    FHost: string;
    FPort: Integer;
    FDatabase: string;
    FUser: string;
    FPass: string;
    FDefaultLang: string;

    function GetPathIni: string;
    procedure EnsureIniExists;
  public
    procedure LoadConfig;
    procedure SaveConfig;

    property Host: string read FHost write FHost;
    property Port: Integer read FPort write FPort;
    property Database: string read FDatabase write FDatabase;
    property User: string read FUser write FUser;
    property Pass: string read FPass write FPass;
    property DefaultLang: string read FDefaultLang write FDefaultLang;
  end;

var
  AppConfig: TAppConfig;

implementation

{------------------------------------------------------------
  RUTA DEL ARCHIVO config.ini
-------------------------------------------------------------}
function TAppConfig.GetPathIni: string;
begin
  Result := TPath.Combine(ExtractFilePath(ParamStr(0)), 'ini\config.ini');
end;

{------------------------------------------------------------
  CREAR CARPETA Y ARCHIVO INI SI NO EXISTEN
-------------------------------------------------------------}
procedure TAppConfig.EnsureIniExists;
var
  Carpeta: string;
  Ini: TMemIniFile;
  SL: TStringList;
  UTF8Enc: TEncoding;
begin
  Carpeta := TPath.Combine(ExtractFilePath(ParamStr(0)), 'ini');

  // Crear carpeta si no existe
  if not TDirectory.Exists(Carpeta) then
    TDirectory.CreateDirectory(Carpeta);

  // Crear archivo si no existe
  if not TFile.Exists(GetPathIni) then
  begin
    Ini := TMemIniFile.Create('');
    SL := TStringList.Create;
    UTF8Enc := TUTF8Encoding.Create(False); // sin BOM
    try
      Ini.WriteString('Conexion', 'varHost', 'localhost');
      Ini.WriteInteger('Conexion', 'varPort', 5432);
      Ini.WriteString('Conexion', 'varDatabase', '');
      Ini.WriteString('Conexion', 'varUser', 'postgres');
      Ini.WriteString('Conexion', 'varPass', '1234');
      Ini.WriteString('Lang', 'defaultlang', 'es');

      Ini.GetStrings(SL);
      SL.SaveToFile(GetPathIni, UTF8Enc);
    finally
      UTF8Enc.Free;
      SL.Free;
      Ini.Free;
    end;
  end;
end;

{------------------------------------------------------------
  CARGAR CONFIGURACIÓN (Asegura UTF-8)
-------------------------------------------------------------}
procedure TAppConfig.LoadConfig;
var
  SL: TStringList;
  IniMem: TMemIniFile;
begin
  EnsureIniExists;

  SL := TStringList.Create;
  SL.LoadFromFile(GetPathIni, TEncoding.UTF8);

  IniMem := TMemIniFile.Create('');
  try
    IniMem.SetStrings(SL);

    FHost        := IniMem.ReadString('Conexion', 'varHost', 'localhost');
    FPort        := IniMem.ReadInteger('Conexion', 'varPort', 5432);
    FDatabase    := IniMem.ReadString('Conexion', 'varDatabase', '');
    FUser        := IniMem.ReadString('Conexion', 'varUser', '');
    FPass        := IniMem.ReadString('Conexion', 'varPass', '');
    FDefaultLang := IniMem.ReadString('Lang', 'defaultlang', 'es');
  finally
    IniMem.Free;
    SL.Free;
  end;
end;

{------------------------------------------------------------
  GUARDAR CONFIGURACIÓN (UTF-8 sin BOM)
-------------------------------------------------------------}
procedure TAppConfig.SaveConfig;
var
  SL: TStringList;
  IniMem: TMemIniFile;
  UTF8Enc: TEncoding;
begin
  IniMem := TMemIniFile.Create('');
  SL := TStringList.Create;
  UTF8Enc := TUTF8Encoding.Create(False);

  try
    IniMem.WriteString('Conexion', 'varHost', FHost);
    IniMem.WriteInteger('Conexion', 'varPort', FPort);
    IniMem.WriteString('Conexion', 'varDatabase', FDatabase);
    IniMem.WriteString('Conexion', 'varUser', FUser);
    IniMem.WriteString('Conexion', 'varPass', FPass);

    IniMem.WriteString('Lang', 'defaultlang', FDefaultLang);

    IniMem.GetStrings(SL);

    SL.SaveToFile(GetPathIni, UTF8Enc);
  finally
    UTF8Enc.Free;
    SL.Free;
    IniMem.Free;
  end;
end;

{------------------------------------------------------------
  AUTO-CARGAR CONFIG EN EL INICIO
-------------------------------------------------------------}
initialization
  AppConfig := TAppConfig.Create;
  AppConfig.LoadConfig;

finalization
  AppConfig.Free;

end.

