unit frLoginOverlay;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.Imaging.pngimage,dmAction, dmImages;

type
  TFrame2 = class(TFrame)
    PanelMask: TPanel;
    Panel2: TPanel;
    PanelCard: TPanel;
    btnAceptar: TButton;
    btnCerrar: TButton;
    cboEmpresa: TComboBox;
    cboUsuario: TComboBox;
    edtPass: TEdit;
    Image1: TImage;
  private
    procedure WireTabOrder;
  public
    constructor Create(AOwner: TComponent); override;
    procedure CenterCard;
    procedure FrameResize(Sender: TObject);
  end;

implementation

{$R *.dfm}

constructor TFrame2.Create(AOwner: TComponent);
begin
  inherited;

  btnAceptar.Default := True;  // Enter = Click en Entrar
  btnCerrar.Cancel   := True;  // Esc   = Click en Salir
  WireTabOrder;
   // Recentrar automáticamente cuando cambie el tamaño
  OnResize := FrameResize;

end;

procedure TFrame2.WireTabOrder;
begin
  cboEmpresa.TabOrder := 0;
  cboUsuario.TabOrder := 1;
  edtPass.TabOrder    := 2;
  btnAceptar.TabOrder := 3;
  btnCerrar.TabOrder  := 4;
end;

procedure TFrame2.FrameResize(Sender: TObject);
begin
  CenterCard;
end;

procedure TFrame2.CenterCard;
begin
  if Assigned(PanelCard) and Assigned(PanelMask) then
  begin
    PanelCard.Left := (PanelMask.ClientWidth  - PanelCard.Width)  div 2;
    PanelCard.Top  := (PanelMask.ClientHeight - PanelCard.Height) div 2;
  end;
end;

end.
