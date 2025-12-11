unit uLog;

interface

{$WARN SYMBOL_PLATFORM OFF}

uses
  Classes, SyncObjs, SysUtils, DateUtils, System.Zip, Forms, Winapi.Windows,
  Data.DB, StrUtils, dmConnection, uDatabaselib, FireDAC.Comp.Client, FireDAC.Stan.Def, FireDAC.Stan.Param,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Stan.Intf, FireDAC.Phys,
  FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.UI.Intf, FireDAC.VCLUI.Wait,
  uConfigIni, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.Phys.Intf,
  FireDAC.Stan.Pool, FireDAC.Comp.UI, uFuncionesglobales, uSession;

const
  EXTENSION_LOG = '.log';
  EXTENSION_ERRORES = '.err';
  EXTENSION_SQL = '.sql';
  FORMATO_FICHERO_LOGS = 'yyyymmdd';
  SEPARADOR = ' : ';
  NIVEL_ERROR = 'E';
  NIVEL_DEBUG = 'D';
  conINFO = 0;
  conERROR = 1;
  // constantes para asignar los valores a los datos introducidos a la base de datos y que solo se tenga que cambiar aqui
  //factura:
  idFACT = 123;
  tipoFACT = 'FACT';
  //info
  idINFO = 201;
  tipoINFO = 'INFO';
  //se pueden añadir más segun la necesidad ej: idEXCEL, idREGISTRO, etc...

type

  TTipoMensaje = (tmLog, tmError, tmSQL, tmLogDB);

  TMensaje = record
    Tipo: TTipoMensaje;
    Texto: String;
    NivelLog: string;
    TipoMBD : smallint; // GrabarInfo: 0; GrabarError: 1;
    Fecha: TDateTime;
    SufijoFichero: String;

    USER :string;        // usuario que generó el log
    IdEmpleado: Integer; // id empleado que generó el log

    // nuevos tipos de datos para la base BDLOG
    TipoDoc: string;
    IdDoc: Integer;
    FechaDoc: TDateTime;
  end;

  THiloLogs = class(TThread)
  private
    LastLogFile: string;
    SeccionCritica: TCriticalSection;
    ColaMensajes: array of TMensaje;
    function GetHora(Fecha: TDateTime): String;
    function GetExtension(Tipo: TTipoMensaje): String;
    procedure ProcesarMensaje(Mensaje: TMensaje);
    procedure InsertarMensajeDB(Mensaje: TMensaje);
    function  CompactaLogDB(Dias: Integer = 10): Boolean;
    procedure EscribirEnFichero(FilePath, Texto: String);
    procedure ProcesarTodaLaCola;
    function GetLastLogFile: string;
    procedure ComprimeLogTxt(Fecha: TDateTime);
  protected
    procedure Execute; override;
  public
    RutaLogs: string;
    constructor Create(CreateSuspended: Boolean);
    destructor Destroy; override;
    procedure Add(Mensaje: String; Tipo: TTipoMensaje; NivelLog: string = '';
      Tipombd: smallint=-1; SufijoFicheroLog: String = '';
      TipoDoc: string = ''; IdDoc: Integer = 0);

    class procedure FinalizarHiloLogs(const ESPERAR_TERMINO_THREADS_SEG: cardinal = 10; const SLEEP_MS: cardinal = 100);
  end;

procedure DBLog(Mensaje: string; Tipombd: Smallint; TipoDoc: string = ''; IdDoc: Integer = 0);
function  CompactaDBLog(Dias: Integer = 10): Boolean;
procedure TxtLog(Mensaje: string);
procedure LogE(Mensaje: string);
procedure LogD(Mensaje: string);

implementation

var
  HiloLogs: THiloLogs;
  SeccionCriticaEscrituraEnLog: TCriticalSection;

function CompactaDBLog(Dias: Integer = 10): Boolean;
begin
  Result := HiloLogs.CompactaLogDB(Dias);
end;

procedure DBLog(Mensaje: string; Tipombd: Smallint; TipoDoc: string = ''; IdDoc: Integer = 0);
begin
  HiloLogs.Add(Mensaje, tmLogDB, '', Tipombd, '', TipoDoc, IdDoc);
end;

procedure TxtLog(Mensaje: string);
begin
  HiloLogs.Add(Mensaje, tmLog);
end;

procedure LogE(Mensaje: string);
begin
  HiloLogs.Add(Mensaje, tmLog, NIVEL_ERROR);
end;

procedure LogD(Mensaje: string);
begin
  HiloLogs.Add(Mensaje, tmLog, NIVEL_DEBUG);
end;

class procedure THiloLogs.FinalizarHiloLogs(const ESPERAR_TERMINO_THREADS_SEG: cardinal = 10;
  const SLEEP_MS: cardinal = 100);
var
  i: integer;
  dwExitCode: Cardinal;
begin
  if Assigned(HiloLogs) then
  try
    HiloLogs.Terminate;
    i := 1000 * ESPERAR_TERMINO_THREADS_SEG;
    while (i>0) and Assigned(HiloLogs) do begin
      Sleep(SLEEP_MS);
      Dec(i, SLEEP_MS);
    end;
    if Assigned(HiloLogs) then
    try
      dwExitCode := 0;
      TerminateThread(HiloLogs.Handle, dwExitCode);
    except
    end;
  except
  end;
end;

{ THiloLogs }

constructor THiloLogs.Create(CreateSuspended: Boolean);
begin
  inherited Create(CreateSuspended);
  FreeOnTerminate := true;
  SeccionCritica := TCriticalSection.Create;
  NameThreadForDebugging('HiloLogs');
end;

destructor THiloLogs.Destroy;
begin
  try
    try
      ProcesarTodaLaCola;
    finally
      if Assigned(SeccionCritica) then
        FreeAndNil(SeccionCritica);
    end;
  except
  end;
end;

procedure THiloLogs.Add(Mensaje: String; Tipo: TTipoMensaje; NivelLog: string = '';
  Tipombd: smallint = -1; SufijoFicheroLog: String = '';
  TipoDoc: string = ''; IdDoc: Integer = 0);
begin
  if Assigned(SeccionCritica) then begin
    SeccionCritica.Acquire;
    try
      SetLength(ColaMensajes, Length(ColaMensajes) + 1);
      ColaMensajes[High(ColaMensajes)].Tipo := Tipo;
      ColaMensajes[High(ColaMensajes)].Texto := Mensaje;
      ColaMensajes[High(ColaMensajes)].NivelLog := NivelLog;
      ColaMensajes[High(ColaMensajes)].Fecha := Now;
      ColaMensajes[High(ColaMensajes)].tipombd := Tipombd;

      // Usuario y empleado automáticamente
      ColaMensajes[High(ColaMensajes)].USER := AppSession.UserName;


      ColaMensajes[High(ColaMensajes)].SufijoFichero := SufijoFicheroLog;
      ColaMensajes[High(ColaMensajes)].TipoDoc := TipoDoc;
      ColaMensajes[High(ColaMensajes)].IdDoc := IdDoc;
      ColaMensajes[High(ColaMensajes)].FechaDoc := Now;

      ColaMensajes[High(ColaMensajes)].IdEmpleado := AppSession.UserId;
    finally
      SeccionCritica.Release;
    end;
  end;
end;

procedure THiloLogs.EscribirEnFichero(FilePath, Texto: String);
var
  F: TextFile;
begin
  SeccionCriticaEscrituraEnLog.Acquire;
  try
    AssignFile(F, FilePath);
    try
      if not FileExists(FilePath) then
      begin
        Rewrite(F);
        LastLogFile := ExtractFileName(FilePath);
      end;

      Append(F);
      WriteLn(F, Texto);
    finally
      Close(F);
    end;
  finally
    SeccionCriticaEscrituraEnLog.Release;
  end;
end;

procedure THiloLogs.InsertarMensajeDB(Mensaje: TMensaje);
var
  TR: TFDTransaction;
  spLOG: TFDQuery;
begin
  SeccionCriticaEscrituraEnLog.Acquire;
  try
    TR := CrearTransaccion;
    spLOG := CrearQuery(TR);
    try
      try
        spLOG.SQL.Add('INSERT INTO LOGBD(tipo, observaciones, "USER", id_empleado, tipodoc, iddoc, fechahora)');
        spLOG.SQL.Add('VALUES (:TIPO, :OBSERVACIONES, :USER, :IDEMPLEADO, :TIPODOC, :IDDOC, :FECHAHORA)');

        spLOG.Transaction.StartTransaction;
        spLOG.ParamByName('TIPO').AsInteger := Mensaje.tipombd;
        spLOG.ParamByName('OBSERVACIONES').AsString := LeftStr(Mensaje.Texto, 255);
        spLOG.ParamByName('USER').AsString := Mensaje.USER;
        spLOG.ParamByName('IDEMPLEADO').AsInteger := Mensaje.IdEmpleado;
        spLOG.ParamByName('TIPODOC').AsString := Mensaje.TipoDoc;
        spLOG.ParamByName('IDDOC').AsInteger := Mensaje.IdDoc;

        if Mensaje.FechaDoc > 0 then
          spLOG.ParamByName('FECHAHORA').AsDateTime := Mensaje.FechaDoc
        else
          spLOG.ParamByName('FECHAHORA').Clear;

        spLOG.ExecSQL;
        spLOG.Transaction.Commit;
      except
        on E: Exception do begin
          Add('[Error al grabar DBLog -> '+E.Message+']: ' + mensaje.Texto
                + ' USER: ' + mensaje.USER, tmLog);
          if (spLOG.Transaction.Active) then
            spLOG.Transaction.Rollback;
        end;
      end;
    finally
      Destruirquery(spLOG);
      DestruirTransaccion(TR);
    end;
  finally
    SeccionCriticaEscrituraEnLog.Release;
  end;
end;

procedure THiloLogs.Execute;
begin
  inherited;
  while Assigned(Self) and not Terminated do begin
    try
      try
        if Length(ColaMensajes) > 0 then
          ProcesarTodaLaCola;
      except
      end;
    finally
      Sleep(300);
    end;
  end;
  ProcesarTodaLaCola;
end;

function THiloLogs.GetExtension(Tipo: TTipoMensaje): String;
begin
  case Tipo of
    tmLog: Result := EXTENSION_LOG;
    tmError: Result := EXTENSION_ERRORES;
    tmSQL: Result := EXTENSION_SQL;
  end;
end;

function THiloLogs.GetHora(Fecha: TDateTime): String;
begin
  Result := FormatDateTime('hh:nn:ss.zzz', Fecha);
end;

function THiloLogs.GetLastLogFile: string;
var
  Files: TSearchRec;
  LocatedFiles: Integer;
begin
  Result := '';
  LocatedFiles := SysUtils.FindFirst(RutaLogs+'*.log', faArchive, Files);
  if LocatedFiles = 0 then
  begin
    repeat
    until SysUtils.FindNext(Files) <> 0;
    SysUtils.FindClose(Files);
    Result := Files.Name;
  end;
end;

procedure THiloLogs.ComprimeLogTxt(Fecha: TDateTime);
var
  MesActual, MesUltimoFichero: Word;
  Files: TSearchRec;
  LocatedFiles: Integer;
  ZipFile: TZipFile;
  FicherosZip: TStringList;
  ZipFileName: string;
  i: Integer;
  RutaBackup: string;
begin
  SeccionCriticaEscrituraEnLog.Acquire;
  try
    MesActual := MonthOf(Fecha);
    if LastLogFile.IsEmpty then
      MesUltimoFichero := MesActual
    else
      MesUltimoFichero := StrToInt(Copy(LastLogFile, 5, 2));

    if MesActual <> MesUltimoFichero then
    begin
      try
        LocatedFiles := SysUtils.FindFirst(RutaLogs+Copy(LastLogFile, 1, 6)+'*.log', faArchive, Files);
        if LocatedFiles = 0 then
        begin
          FicherosZip := TStringList.Create;
          repeat
            FicherosZip.Add(Files.Name);
          until SysUtils.FindNext(Files) <> 0;
          SysUtils.FindClose(Files);

          RutaBackup := RutaLogs + 'Backup\';
          if not DirectoryExists(RutaBackup) then
            MkDir(RutaBackup);

          ZipFile := TZipFile.Create;
          ZipFileName := RutaBackup + Copy(LastLogFile, 1, 6) + '.zip';
          ZipFile.Open(ZipFileName, zmWrite);
          try
            for i := 0 to FicherosZip.Count-1 do
            begin
              ZipFile.Add(RutaLogs + FicherosZip[i]);
              SysUtils.DeleteFile(RutaLogs + FicherosZip[i]);
            end;
            ZipFile.Close;
          finally
            ZipFile.Free;
          end;

          LastLogFile := '';
        end;
      except
      end;
    end;
  finally
    SeccionCriticaEscrituraEnLog.Release;
  end;
end;

procedure THiloLogs.ProcesarMensaje(Mensaje: TMensaje);
var
  Path, TextoLog: String;
begin
  try
    with Mensaje do begin
      if Mensaje.Tipo = tmLogDB then
      begin
        InsertarMensajeDB(Mensaje);
      end
      else
      begin
        ComprimeLogTxt(Fecha);

        if Pos('Log\', RutaLogs) <= 0 then
          RutaLogs := ExtractFilePath(Application.ExeName) + 'Log\';

        Path := RutaLogs + FormatDateTime(FORMATO_FICHERO_LOGS, Fecha) + SufijoFichero + GetExtension(Tipo);

        TextoLog := Format('%s %s%s%s%s', [
          GetHora(Fecha),
          IfThen(NivelLog = '', '', NivelLog + SEPARADOR),
          Texto,
          IfThen(TipoDoc <> '', Format(' [TipoDoc:%s, IdDoc:%d, FechaDoc:%s]', [
            TipoDoc, IdDoc, FormatDateTime('yyyy-mm-dd hh:nn:ss', FechaDoc)
          ]), ''),
          IfThen(Mensaje.USER <> '', ' [USER: ' + Mensaje.USER + ']', '')
        ]);

        EscribirEnFichero(Path, TextoLog);
      end;
    end;
  except
  end;
end;

procedure THiloLogs.ProcesarTodaLaCola;
var
  i: Integer;
begin
  try
    if Assigned(SeccionCritica) then begin
      SeccionCritica.Acquire;
      try
        if Assigned(ColaMensajes) and (ColaMensajes <> nil) and (Length(ColaMensajes) > 0) then
        begin
          i:=0;
          while i < Length(ColaMensajes) do
          begin
            ProcesarMensaje(ColaMensajes[i]);
            inc(i);
          end;
        end;
        SetLength(ColaMensajes, 0);
      finally
        SeccionCritica.Release;
      end;
    end;
  except
  end;
end;

function THiloLogs.CompactaLogDB(Dias: Integer = 10): Boolean;
var
  Fecha: TDateTime;
  Tr: TFDTransaction;
  qEjecutarSQL: TFDQuery;
begin
  Result := False;
  Fecha := Now - Dias;

  Tr := CrearTransaccion;
  qEjecutarSQL := Crearquery(Tr);
  try
    try
      if not qEjecutarSQL.Transaction.Active then
        qEjecutarSQL.Transaction.StartTransaction;

      qEjecutarSQL.SQL.Clear;
      qEjecutarSQL.SQL.Add('DELETE FROM LOGBD');
      qEjecutarSQL.SQL.Add('WHERE ' +
        '(LOGBD.FECHAHORA < ' + QuotedStr(FormatDateTime('mm/dd/yyyy', Fecha)) + ' )');
      qEjecutarSQL.ExecSQL;

      if qEjecutarSQL.Transaction.Active then
        qEjecutarSQL.Transaction.Commit;

      Result := True;
    except
      on E: Exception do begin
        add('[CompactaLogDB] - ' + E.Message,tmLog);
        if qEjecutarSQL.Transaction.Active then
          qEjecutarSQL.Transaction.Rollback;
      end;
    end;
  finally
    DestruirQuery(qEjecutarSQL);
    DestruirTransaccion(Tr);
  end;
end;

initialization
  SeccionCriticaEscrituraEnLog := TCriticalSection.Create;

  HiloLogs := THiloLogs.Create(False);
  HiloLogs.RutaLogs := ExtractFilePath(Application.ExeName) + 'Log\';
  try
    if not DirectoryExists(HiloLogs.RutaLogs) then
      MkDir(HiloLogs.RutaLogs);
  except
  end;

  HiloLogs.LastLogFile := HiloLogs.GetLastLogFile;

finalization
  if Assigned(HiloLogs) then
    HiloLogs.Free;

  SeccionCriticaEscrituraEnLog.Free;

end.

