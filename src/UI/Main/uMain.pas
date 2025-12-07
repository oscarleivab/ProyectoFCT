unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ToolWin, Vcl.ActnMan, Vcl.ActnCtrls,
  Vcl.ActnMenus, Vcl.ComCtrls, Vcl.StdCtrls, dmAction, dmImages;

type
  TfrmMain = class(TForm)
    ActionMainMenuBar1: TActionMainMenuBar;
    TabSheetPrincipal: TPageControl;
    TabSheet1: TTabSheet;
    Button1: TButton;
    Button2: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

end.
