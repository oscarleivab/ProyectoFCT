unit uSession;

interface

type
  TPermisosUsuario = record
    // CLIENTES
    CrearCliente: Boolean;
    EditarCliente: Boolean;
    ListarCliente: Boolean;

    // PROVEEDORES
    CrearProveedor: Boolean;
    EditarProveedor: Boolean;
    ListarProveedor: Boolean;

    // EMPLEADOS
    CrearEmpleado: Boolean;
    EditarEmpleado: Boolean;
    ListarEmpleado: Boolean;
  end;

  TSession = record
    CompanyId: Integer;
    CompanyName: string;
    UserId: Integer;
    UserName: string;
    UserPermissions: TPermisosUsuario;
  end;

var
  AppSession: TSession;

implementation

end.
