unit uClienteModel;

interface

type
  TCliente = class
  private
    FIdCliente: Integer;
    FIdTipoDocumento: Integer;
    FDetalleDocumento: string;
    FCodigoInterno: Integer;
    FNombre: string;
    FApellidos: string;
    FEmpresa: string;
    FEmail: string;
    FObservaciones: string;
    FTelefono1: string;
    FTelefono2: string;
    FIdTarifa: Integer;
    FPersonaContacto: string;
    FUrlWeb: string;
    FUserLogin: string;
    FPassLogin: string;
    FActivo: Boolean;
    FIdPermiso: Integer;

  public
    procedure Clear;
    constructor Create;

    // NUEVO: copiar datos de otro cliente
    procedure Assign(Source: TCliente);

    property IdCliente: Integer read FIdCliente write FIdCliente;
    property IdTipoDocumento: Integer read FIdTipoDocumento write FIdTipoDocumento;
    property DetalleDocumento: string read FDetalleDocumento write FDetalleDocumento;
    property Nombre: string read FNombre write FNombre;
    property Apellidos: string read FApellidos write FApellidos;
    property Empresa: string read FEmpresa write FEmpresa;
    property Email: string read FEmail write FEmail;
    property Observaciones: string read FObservaciones write FObservaciones;
    property Telefono1: string read FTelefono1 write FTelefono1;
    property Telefono2: string read FTelefono2 write FTelefono2;
    property IdTarifa: Integer read FIdTarifa write FIdTarifa;
    property PersonaContacto: string read FPersonaContacto write FPersonaContacto;
    property UrlWeb: string read FUrlWeb write FUrlWeb;
    property UserLogin: string read FUserLogin write FUserLogin;
    property PassLogin: string read FPassLogin write FPassLogin;
    property Activo: Boolean read FActivo write FActivo;
    property IdPermiso: Integer read FIdPermiso write FIdPermiso;
  end;

implementation

procedure TCliente.Clear;
begin
  FIdCliente := 0;
  FIdTipoDocumento := 0;
  FDetalleDocumento := '';
  FCodigoInterno := 0;
  FNombre := '';
  FApellidos := '';
  FEmpresa := '';
  FEmail := '';
  FObservaciones := '';
  FTelefono1 := '';
  FTelefono2 := '';
  FIdTarifa := 0;
  FPersonaContacto := '';
  FUrlWeb := '';
  FUserLogin := '';
  FPassLogin := '';
  FActivo := True;
  FIdPermiso := 0;
end;

constructor TCliente.Create;
begin
  inherited Create;
  Clear;   // inicializa todo vacío
end;

procedure TCliente.Assign(Source: TCliente);
begin
  if Source = nil then Exit;

  Self.FIdCliente        := Source.FIdCliente;
  Self.FIdTipoDocumento  := Source.FIdTipoDocumento;
  Self.FDetalleDocumento := Source.FDetalleDocumento;
  Self.FCodigoInterno    := Source.FCodigoInterno;
  Self.FNombre           := Source.FNombre;
  Self.FApellidos        := Source.FApellidos;
  Self.FEmpresa          := Source.FEmpresa;
  Self.FEmail            := Source.FEmail;
  Self.FObservaciones    := Source.FObservaciones;
  Self.FTelefono1        := Source.FTelefono1;
  Self.FTelefono2        := Source.FTelefono2;
  Self.FIdTarifa         := Source.FIdTarifa;
  Self.FPersonaContacto  := Source.FPersonaContacto;
  Self.FUrlWeb           := Source.FUrlWeb;
  Self.FUserLogin        := Source.FUserLogin;
  Self.FPassLogin        := Source.FPassLogin;
  Self.FActivo           := Source.FActivo;
  Self.FIdPermiso        := Source.FIdPermiso;
end;

end.

