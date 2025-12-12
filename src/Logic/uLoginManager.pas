unit uLoginManager;

interface

uses
  System.SysUtils, System.Classes,System.StrUtils, Data.DB,
  FireDAC.Comp.Client, FireDAC.Stan.Param,
  dmConnection, uSession,uDatabaselib,uFuncionesGlobales;

type
  TLoginManager = class
  public
    // BD principal ? combo de empresas
    class procedure LoadCompanies(ATarget: TStrings);

    // Conecta a la BD de empresa y carga empleados activos en el combo
    class procedure ConnectCompanyAndLoadEmployees(ACompanyId: Integer; ATarget: TStrings; out ACompanyName: string);

    // Valida empleado (en BD de empresa)
    class function ValidateEmployee(AEmployeeId: Integer; const APassword: string): Boolean;

    // Valida los permisos de los usuarios
    class procedure LoadUserPermissions(AUserId: Integer);
  end;

implementation

{ Empresas en BD principal }

class procedure TLoginManager.LoadCompanies(ATarget: TStrings);
var
  Q: TFDQuery;
begin
  ATarget.Clear;

  Q := TFDQuery.Create(nil);
  try
    Q.Connection := DataModuleConnection.FDConnectionMain;
    Q.SQL.Text :=
      'SELECT id, empresaname '+
      'FROM empresa '+
      'WHERE activa = TRUE '+
      'ORDER BY empresaname';

    DataModuleConnection.OpenQueryWithReconnect(Q);

    while not Q.Eof do
    begin
      ATarget.AddObject(
        Q.FieldByName('empresaname').AsString,
        TObject(NativeInt(Q.FieldByName('id').AsInteger))
      );
      Q.Next;
    end;
  finally
    Q.Free;
  end;
end;

{ Conexión a empresa + empleados }
class procedure TLoginManager.ConnectCompanyAndLoadEmployees(ACompanyId: Integer; ATarget: TStrings; out ACompanyName: string);
var
  Q: TFDQuery;
begin
  ATarget.Clear;
  ACompanyName := '';

  if ACompanyId = 0 then Exit;

  // 1) Conectar a la BD de empresa usando empresa.userbd/passbd
  DataModuleConnection.ConnectToCompanyDatabase(ACompanyId, ACompanyName);

  // 2) Cargar empleados activos (BD empresa)
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := DataModuleConnection.FDConnectionCompany;
    Q.SQL.Text :=
      'SELECT id, user_login, nombre, apellidos '+
      'FROM empleado '+
      'WHERE COALESCE(activo, TRUE) = TRUE '+
      'ORDER BY UPPER(user_login)';
    DataModuleConnection.OpenQueryWithReconnect(Q);

    while not Q.Eof do
    begin
      // Mostramos user_login; guardamos id en Objects
      ATarget.AddObject(
        Q.FieldByName('user_login').AsString,
        TObject(NativeInt(Q.FieldByName('id').AsInteger))
      );
      Q.Next;
    end;
  finally
    Q.Free;
  end;
end;

{ Validación en tabla empleado }

class function TLoginManager.ValidateEmployee(AEmployeeId: Integer; const APassword: string): Boolean;
var
  Q: TFDQuery;
  PassDB, UserLogin, Nombre, Apellidos: string;
begin
  Result := false;
  if (AEmployeeId = 0) or (APassword = '') then Exit;

  Q := TFDQuery.Create(nil);
  try
    Q.Connection := DataModuleConnection.FDConnectionCompany;
    Q.SQL.Text :=
      'SELECT user_login, pass_login, nombre, apellidos '+
      'FROM empleado '+
      'WHERE id = :id AND COALESCE(activo, TRUE) = TRUE';
    Q.ParamByName('id').AsInteger := AEmployeeId;
    DataModuleConnection.OpenQueryWithReconnect(Q);

    if Q.IsEmpty then
      Exit;

    UserLogin := Q.FieldByName('user_login').AsString;
    PassDB    := Q.FieldByName('pass_login').AsString;
    Nombre    := Q.FieldByName('nombre').AsString;
    Apellidos := Q.FieldByName('apellidos').AsString;

    // TODO: migrar a hash (bcrypt/argon2). De momento: texto plano, case-sensitive.
    if GetSHA256(APassword) = PassDB then
    begin
      AppSession.UserId      := AEmployeeId;
      AppSession.UserName    := IfThen(Trim(Nombre + ' ' + Apellidos) <> '',
                                       Trim(Nombre + ' ' + Apellidos),
                                       UserLogin);

      TLoginManager.LoadUserPermissions(AEmployeeId);
      Result := True;
    end;
  finally
    Q.Free;
  end;
end;

class procedure TLoginManager.LoadUserPermissions(AUserId: Integer);
var
  Q: TFDQuery;
  PermisosId: Integer;
begin
  FillChar(AppSession.UserPermissions, SizeOf(AppSession.UserPermissions), 0);

  // 1) Obtener id_permisos del empleado
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := DataModuleConnection.FDConnectionCompany;
    Q.SQL.Text := 'SELECT id_permiso FROM empleado WHERE id = :id';
    Q.ParamByName('id').AsInteger := AUserId;
    DataModuleConnection.OpenQueryWithReconnect(Q);

    if Q.IsEmpty then
      Exit;

    PermisosId := Q.FieldByName('id_permiso').AsInteger;
  finally
    Q.Free;
  end;

  // 2) Cargar permisos usando id_permisos
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := DataModuleConnection.FDConnectionCompany;
    Q.SQL.Text := 'SELECT * FROM permisos WHERE id = :id';
    Q.ParamByName('id').AsInteger := PermisosId;
    DataModuleConnection.OpenQueryWithReconnect(Q);

    if not Q.IsEmpty then
    begin
      with AppSession.UserPermissions do
      begin
        CrearCliente     := Q.FieldByName('ccrearcliente').AsBoolean;
        EditarCliente    := Q.FieldByName('ceditarcliente').AsBoolean;
        ListarCliente    := Q.FieldByName('clistarcliente').AsBoolean;

        CrearProveedor   := Q.FieldByName('ccrearproveedor').AsBoolean;
        EditarProveedor  := Q.FieldByName('ceditarproveedor').AsBoolean;
        ListarProveedor  := Q.FieldByName('clistarproveedor').AsBoolean;

        CrearEmpleado    := Q.FieldByName('ccrearempleado').AsBoolean;
        EditarEmpleado   := Q.FieldByName('ceditarempleado').AsBoolean;
        ListarEmpleado   := Q.FieldByName('clistarempleado').AsBoolean;
      end;
    end;
  finally
    Q.Free;
  end;
end;



end.

