unit dmConnection;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  Data.DB, FireDAC.Comp.Client, uIniUtils, uDBUtils, FireDAC.Phys.PGDef,
  FireDAC.Phys.PG;

type
  TDataModule1 = class(TDataModule)
    FDConnection1: TFDConnection;
    FDConnection2: TFDConnection;
  private
    procedure ConfigurarConexionINI;
  public
    function Conectar(BaseDatos: string = ''): Boolean;
  end;

var
  DataModule1: TDataModule1;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TDataModule1.ConfigurarConexionINI;
var
  Host, BDName, User, Pass: string;
  Port: Integer;
begin
  LeerDatosConexion(Host, BDName, User, Pass, Port);

  ConfigurarConexion(FDConnection1, Host, BDName, User, Pass, Port);
end;

function TDataModule1.Conectar(BaseDatos: string): Boolean;
begin
  ConfigurarConexionINI;
  FDConnection1.Connected;
  Result := FDConnection1.Connected;
end;

end.
