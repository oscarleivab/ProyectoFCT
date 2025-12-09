unit faccionusuario;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,uTranslator;

type
  TDialogouserfrm = class(TForm)
    Panelaccion: TPanel;
    Labelaccionusuario: TLabel;
    Paneleleccion: TPanel;
    Botonsi: TButton;
    Botonno: TButton;
    Botoncancelar: TButton;
    panelaceptar: TPanel;
    botonaceptar: TButton;
    procedure BotonsiClick(Sender: TObject);
    procedure BotonnoClick(Sender: TObject);
    procedure BotoncancelarClick(Sender: TObject);
    procedure botonaceptarClick(Sender: TObject);
  private
    { Private declarations }
    procedure TraducirTexto;
  public
  oprespuesta:integer;
    { Public declarations }
  end;

var
  Dialogouserfrm: TDialogouserfrm;

implementation

{$R *.dfm}

procedure TDialogouserfrm.BotonsiClick(Sender: TObject);
begin
ModalResult := mrYes;
end;

procedure TDialogouserfrm.botonaceptarClick(Sender: TObject);
begin
ModalResult := mrOk;
end;

procedure TDialogouserfrm.BotonnoClick(Sender: TObject);
begin
ModalResult := mrNo;
end;

procedure TDialogouserfrm.BotoncancelarClick(Sender: TObject);
begin
ModalResult := mrCancel;
end;

procedure TDialogouserfrm.TraducirTexto;
begin
botonsi.Caption:=T_('Botones','botonsi');
botonno.Caption:=T_('Botones','botonno');
botoncancelar.Caption := T_('Botones','botoncancelar');
end;



end.
