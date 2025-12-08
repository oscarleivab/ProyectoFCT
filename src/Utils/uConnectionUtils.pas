unit uConnectionUtils;

interface

uses
  System.SysUtils, FireDAC.Comp.Client;

type
  TConnectionUtils = class
  public
    class function TestConnection(AConnection: TFDConnection): Boolean;
  end;

implementation

class function TConnectionUtils.TestConnection(AConnection: TFDConnection): Boolean;
var
  Q: TFDQuery;
begin
  Result := False;
  if not Assigned(AConnection) then Exit;

  Q := TFDQuery.Create(nil);
  try
    Q.Connection := AConnection;
    Q.SQL.Text := 'select 1';
    Q.Open;
    Result := True;
  except
    Result := False;
  end;
  Q.Free;
end;

end.
