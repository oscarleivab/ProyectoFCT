unit dmAction;

interface

uses
  System.SysUtils, System.Classes, Vcl.PlatformDefaultStyleActnCtrls,
  System.Actions, Vcl.ActnList, Vcl.ActnMan, dmImages;

type
  TDataModule3 = class(TDataModule)
    ActionManager1: TActionManager;
    actLogin: TAction;
    actLogout: TAction;
    actApagar: TAction;
    procedure actLoginExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DataModule3: TDataModule3;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TDataModule3.actLoginExecute(Sender: TObject);
begin
  // prueba
end;

end.
