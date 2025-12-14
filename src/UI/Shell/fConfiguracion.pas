unit fConfiguracion;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, uTranslator,dmUIActions;

type
  TFrConfiguracion = class(TFrame)
    btnCerrar: TButton;
    cboidiomac: TComboBox;
    procedure btnCerrarClick(Sender: TObject);
  private
    { Private declarations }
    procedure HookLoginEvents;
    procedure OnIdiomaChange(Sender: TObject);
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TFrConfiguracion.btnCerrarClick(Sender: TObject);
var
  Tab: TFrConfiguracion;
begin
  Tab := TFrConfiguracion(Parent);

  if Assigned(Tab) then
    Tab.Free; // Cierra la pestaña y libera el Frame
end;

procedure TFrConfiguracion.HookLoginEvents;
begin
  cboidiomac.OnChange := OnIdiomaChange;
end;

procedure TFrConfiguracion.OnIdiomaChange(Sender: TObject);
begin
  UseLanguage(cboidiomac.Text);
  TranslateTree(dmActions,'');
end;

end.
