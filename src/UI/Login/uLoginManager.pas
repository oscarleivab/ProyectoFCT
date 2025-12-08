unit uLoginManager;

interface

uses
  System.SysUtils, System.Classes,System.StrUtils, Data.DB,
  FireDAC.Comp.Client, FireDAC.Stan.Param,
  dmConnection, uSession,uDatabaselib;

type
  TLoginManager = class
  public
    // BD principal ? combo de empresas
    //class procedure LoadCompanies(ATarget: TStrings);

    // Conecta a la BD de empresa y carga empleados activos en el combo
    //class procedure ConnectCompanyAndLoadEmployees(ACompanyId: Integer; ATarget: TStrings; out ACompanyName: string);

    // Valida empleado (en BD de empresa)
    //class function ValidateEmployee(AEmployeeId: Integer; const APassword: string): Boolean;
  end;

implementation

end.
