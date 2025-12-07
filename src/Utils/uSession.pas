unit uSession;

interface

type
  TSession = record
    CompanyId: Integer;
    CompanyName: string;
    UserId: Integer;
    UserName: string;
  end;

var
  AppSession: TSession;

implementation

end.
