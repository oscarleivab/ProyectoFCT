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

{ TAppConfig }

procedure TAppConfig.LoadConfig;
var
  SL: TStringList;
  IniMem: TMemIniFile;
  PathIni, DirIni: string;
  UTF8Enc: TEncoding;
begin
  DirIni := TPath.Combine(ExtractFilePath(ParamStr(0)), 'ini');
  PathIni := TPath.Combine(DirIni, 'config.ini');

  // Crear carpeta "ini" si no existe
  if not TDirectory.Exists(DirIni) then
    TDirectory.CreateDirectory(DirIni);

  // Si NO existe el archivo, crearlo con valores por defecto
  if not TFile.Exists(PathIni) then
  begin
    SL := TStringList.Create;
    UTF8Enc := TUTF8Encoding.Create(False); // sin BOM
    try
      SL.Add('[Conexion]');
      SL.Add('varHost=localhost');
      SL.Add('varPort=5432');
      SL.Add('varDatabase=bdgevensoftbase');
      SL.Add('varUser=postgres');
      SL.Add('varPass=2003');
      SL.Add('');
      SL.Add('[Lang]');
      SL.Add('defaultlang=Español');

      SL.SaveToFile(PathIni, UTF8Enc);
    finally
      UTF8Enc.Free;
      SL.Free;
    end;
  end;

  // === Cargar el archivo de configuración ===

  SL := TStringList.Create;
  try
    SL.LoadFromFile(PathIni, TEncoding.UTF8);

    IniMem := TMemIniFile.Create('');
    try
      IniMem.SetStrings(SL);

      FHost        := IniMem.ReadString('Conexion', 'varHost', 'localhost');
      FPort        := IniMem.ReadInteger('Conexion', 'varPort', 5432);
      FDatabase    := IniMem.ReadString('Conexion', 'varDatabase', 'bdgevensoftbase');
      FUser        := IniMem.ReadString('Conexion', 'varUser', 'postgres');
      FPass        := IniMem.ReadString('Conexion', 'varPass', '2003');
      FDefaultLang := IniMem.ReadString('Lang',      'defaultlang', 'Español');
    finally
      IniMem.Free;
    end;

  finally
    SL.Free;
  end;
end;


procedure TAppConfig.SaveConfig;
var
  SL: TStringList;
  IniMem: TMemIniFile;
  PathIni: string;
  UTF8Enc: TEncoding;
begin
  PathIni := TPath.Combine(ExtractFilePath(ParamStr(0)), 'ini\config.ini');

  IniMem := TMemIniFile.Create('');
  SL := TStringList.Create;
  UTF8Enc := TUTF8Encoding.Create(False); // False = sin BOM
  try
    // Escribir los valores actuales
    IniMem.WriteString('Conexion', 'varHost', FHost);
    IniMem.WriteInteger('Conexion', 'varPort', FPort);
    IniMem.WriteString('Conexion', 'varDatabase', FDatabase);
    IniMem.WriteString('Conexion', 'varUser', FUser);
    IniMem.WriteString('Conexion', 'varPass', FPass);
    IniMem.WriteString('lang', 'defaultlang', FDefaultLang);

    // Guardar a StringList
    IniMem.GetStrings(SL);

    // Grabar el archivo INI en UTF-8
    SL.SaveToFile(PathIni, UTF8Enc);
  finally
    UTF8Enc.Free;
    SL.Free;
    IniMem.Free;
  end;
end;

initialization
  AppConfig := TAppConfig.Create;
  AppConfig.loadconfig;

finalization
  AppConfig.Free;

end.

