unit utoashelper;

interface

uses
  System.Classes, System.SysUtils, System.StrUtils, System.Generics.Collections,
  Vcl.Controls, Vcl.ExtCtrls, Vcl.Graphics, Vcl.Forms, Vcl.StdCtrls,
  Winapi.Windows, Winapi.Messages, Math;

type
  TToastManager = class;

  TToast = class
  private
    FPanel: TPanel;
    FOwner: TWinControl;
    FManager: TToastManager;
    FTargetTop: Integer;
    FAlpha: Integer;
    FTimerShow, FTimerHide: TTimer;
    FDesactivado: Boolean;
    procedure DoFadeIn(Sender: TObject);
    procedure SafeFreeTimers;
    procedure DoFadeOut(Sender: TObject);
    procedure CloseManual(Sender: TObject);
    procedure InitPanel(const Msg, Estado: string);
  public
    constructor Create(AManager: TToastManager; AOwner: TWinControl; const Msg, Estado: string; DurationMS: Integer = -1); reintroduce;
    destructor Destroy; override;
    property Panel: TPanel read FPanel;
  end;

  TToastManager = class
  private
    FToasts: TObjectList<TToast>;
    FOwner: TWinControl;
    FFormDestroyed: Boolean;
  public
    constructor Create(AOwner: TWinControl);
    destructor Destroy; override;
    procedure Show(const Msg: string; Estado: string = 'success'; DurationMS: Integer = -1);
    procedure RepositionToasts;
    procedure Reset;
    procedure ClearAll;
    procedure RemoveToast(AToast: TToast);
  end;

implementation

{ TToastManager }

constructor TToastManager.Create(AOwner: TWinControl);
begin
  FFormDestroyed := False;
  FOwner := AOwner;
  FToasts := TObjectList<TToast>.Create(False);
end;

destructor TToastManager.Destroy;
begin
  ClearAll;
  FreeAndNil(FToasts);
  inherited;
end;

procedure TToastManager.Reset;
begin
  FFormDestroyed := False;
end;

procedure TToastManager.ClearAll;
begin
  FFormDestroyed := True;
  if Assigned(FToasts) then
  begin
    while FToasts.Count > 0 do
    begin
      FToasts[0].Free;
      FToasts.Delete(0);
    end;
  end;
end;

procedure TToastManager.Show(const Msg: string; Estado: string; DurationMS: Integer);
begin
  if FFormDestroyed or (FOwner = nil) or not FOwner.HandleAllocated then Exit;
  FToasts.Add(TToast.Create(Self, FOwner, Msg, Estado, DurationMS));
  RepositionToasts;
end;

procedure TToastManager.RepositionToasts;
var
  i, TopAcc: Integer;
  T: TToast;
begin
  TopAcc := 70;
  for i := FToasts.Count - 1 downto 0 do
  begin
    T := FToasts[i];
    T.FTargetTop := TopAcc;
    if T.FAlpha = 255 then
      T.Panel.Top := TopAcc;
    TopAcc := TopAcc + T.Panel.Height + 10;
  end;
end;

procedure TToastManager.RemoveToast(AToast: TToast);
begin
  if Assigned(FToasts) and (FToasts.IndexOf(AToast) >= 0) then
  begin
    FToasts.Remove(AToast);
    RepositionToasts;
  end;
end;

{ TToast }

constructor TToast.Create(AManager: TToastManager; AOwner: TWinControl; const Msg, Estado: string; DurationMS: Integer);
begin
  inherited Create;
  FOwner := AOwner;
  FManager := AManager;
  FDesactivado := False;
  InitPanel(Msg, Estado);

  if DurationMS < 0 then
    DurationMS := Max(2500, Length(Msg) * 70);

  FTimerShow := TTimer.Create(nil);
  FTimerShow.Interval := 15;
  FTimerShow.OnTimer := DoFadeIn;
  FAlpha := 0;
  FTimerShow.Enabled := True;

  FTimerHide := TTimer.Create(nil);
  FTimerHide.Interval := DurationMS;
  FTimerHide.OnTimer := DoFadeOut;
  FTimerHide.Enabled := True;
end;

destructor TToast.Destroy;
begin
  SafeFreeTimers;
  if Assigned(FPanel) then
  begin
    FPanel.Parent := nil;
    FreeAndNil(FPanel);
  end;
  inherited;
end;

procedure TToast.InitPanel(const Msg, Estado: string);
var
  Icon, MsgLbl, CloseLbl: TLabel;
  BaseColor: TColor;
begin
  if not Assigned(FOwner) or not FOwner.HandleAllocated then Exit;

  FPanel := TPanel.Create(FOwner);
  FPanel.StyleElements := FPanel.StyleElements - [seClient];
  with FPanel do
  begin
    Parent := FOwner;
    Visible := True;
    BevelOuter := bvNone;
    BorderStyle := bsNone;
    Height := 30;
    Width := 320;
    Font.Color := clWhite;
    Left := FOwner.ClientWidth - Width - 20;
    Top := 70;
  end;

  if Estado = 'error' then BaseColor := $000044FF
  else if Estado = 'warning' then BaseColor := $000096F7
  else BaseColor := $0028A745; // cambio de colores en el mensaje

  FPanel.Color := BaseColor;

  Icon := TLabel.Create(FPanel);
  Icon.StyleElements := [];
  Icon.Parent := FPanel;
  Icon.Font.Name := 'Segoe UI Symbol';
  Icon.Font.Size := 12;
  Icon.Font.Style := [fsBold];
  Icon.Font.Color := clWhite;
  Icon.Caption := IfThen(Estado = 'error', '⛔',
                    IfThen(Estado = 'warning', '⚠', '✔'));
  Icon.Left := 10;
  Icon.Top := 6;

  MsgLbl := TLabel.Create(FPanel);
  MsgLbl.StyleElements := [];
  MsgLbl.Parent := FPanel;
  MsgLbl.Caption := Msg;
  MsgLbl.Font.Color := clWhite;
  MsgLbl.Font.Style := [fsBold];
  MsgLbl.Left := 40;
  MsgLbl.Top := 7;
  MsgLbl.WordWrap := True;
  MsgLbl.AutoSize := False; // se desactiva el autosize para añadir un ancho personalizado
  MsgLbl.Width := FPanel.Width - 70;   // margen para el icono y la X
  MsgLbl.Height := 0;                 // autoajuste
  MsgLbl.AutoSize := True; // se vuelve a activar el autosize para que el label ajuste su altura

  // Ajustar altura del panel según la altura del texto
  FPanel.Height := Max(30, MsgLbl.Height + 14);

  CloseLbl := TLabel.Create(FPanel);
  CloseLbl.StyleElements := [];
  CloseLbl.Parent := FPanel;
  CloseLbl.Caption := '✖';
  CloseLbl.Font.Name := 'Segoe UI Symbol';
  CloseLbl.Font.Color := clWhite;
  CloseLbl.Font.Size := 10;
  CloseLbl.Font.Style := [fsBold];
  CloseLbl.Cursor := crHandPoint;
  CloseLbl.Top := 4;
  CloseLbl.Left := FPanel.Width - 20;
  CloseLbl.OnClick := CloseManual;

  SetWindowLong(FPanel.Handle, GWL_EXSTYLE,
    GetWindowLong(FPanel.Handle, GWL_EXSTYLE) or WS_EX_LAYERED);
  SetLayeredWindowAttributes(FPanel.Handle, 0, 0, LWA_ALPHA);
end;

procedure TToast.DoFadeIn(Sender: TObject);
begin
  Inc(FAlpha, 15);
  if FAlpha >= 255 then
  begin
    FAlpha := 255;
    FTimerShow.Enabled := False;
    FreeAndNil(FTimerShow);
  end;

  FPanel.Top := Max(FTargetTop, FPanel.Top - 4);
  SetLayeredWindowAttributes(FPanel.Handle, 0, FAlpha, LWA_ALPHA);
end;

procedure TToast.SafeFreeTimers;
begin
  if Assigned(FTimerShow) then
    FreeAndNil(FTimerShow);
  if Assigned(FTimerHide) then
    FreeAndNil(FTimerHide);
end;

procedure TToast.DoFadeOut(Sender: TObject);
begin
  if FDesactivado or (FPanel = nil) then Exit;
  FDesactivado := True;
  SafeFreeTimers;
  if Assigned(FManager) then
    FManager.RemoveToast(Self);
  Free;
end;

procedure TToast.CloseManual(Sender: TObject);
begin
  DoFadeOut(nil);
end;

end.

