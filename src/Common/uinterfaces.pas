unit uinterfaces;

interface

type
  // Interfaz que deben implementar los listados
  IListadoRefrescable = interface
    ['{F1B1FDFF-7A1A-4C8D-AE7E-123456789ABC}']
    procedure ActualizarRegistro(AId: Integer);
  end;

implementation

end.
