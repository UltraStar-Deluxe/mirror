unit UScreenOptions;

interface

uses
  UMenu, SDL, SysUtils, UDisplay, UMusic, UFiles, UIni, UThemes;

type
  TScreenOptions = class(TMenu)
    public
      TextDescription:    integer;
      constructor Create; override;
      function ParseInput(PressedKey: Cardinal; ScanCode: byte; PressedDown: Boolean): Boolean; override;
      procedure onShow; override;
      procedure InteractNext; override;
      procedure InteractPrev; override;
      procedure SetAnimationProgress(Progress: real); override;
  end;

const
  ID='ID_006';   //for help system
  
implementation

uses UGraphic, UHelp, ULog;

function TScreenOptions.ParseInput(PressedKey: Cardinal; ScanCode: byte; PressedDown: Boolean): Boolean;
begin
  Result := true;
  If (PressedDown) Then
  begin // Key Down
    case PressedKey of
      SDLK_TAB:
        begin
          ScreenPopupHelp.ShowPopup();
        end;
        
      SDLK_Q:
        begin
          Result := false;
        end;
      SDLK_ESCAPE,
      SDLK_BACKSPACE:
        begin
          Ini.Save;
          Music.PlayBack;
          FadeTo(@ScreenMain);
        end;
      SDLK_RETURN:
        begin
          if SelInteraction = 0 then begin
            Music.PlayStart;
            FadeTo(@ScreenOptionsGame);
          end;

          if SelInteraction = 1 then begin
            Music.PlayStart;
            FadeTo(@ScreenOptionsGraphics);
          end;

          if SelInteraction = 2 then begin
            Music.PlayStart;
            FadeTo(@ScreenOptionsSound);
          end;

          if SelInteraction = 3 then begin
            Music.PlayStart;
            FadeTo(@ScreenOptionsLyrics);
          end;

          if SelInteraction = 4 then begin
            Music.PlayStart;
            FadeTo(@ScreenOptionsThemes);
          end;

          if SelInteraction = 5 then begin
            Music.PlayStart;
            FadeTo(@ScreenOptionsRecord);
          end;

          if SelInteraction = 6 then begin
            Music.PlayStart;
            FadeTo(@ScreenOptionsAdvanced);
          end;

          if SelInteraction = 7 then begin
            Ini.Save;
            Music.PlayBack;
            FadeTo(@ScreenMain);
          end;
        end;
      SDLK_DOWN:    InteractInc;
      SDLK_UP:      InteractDec;
      SDLK_RIGHT:   InteractNext;
      SDLK_LEFT:    InteractPrev;
    end;
  end;
end;

constructor TScreenOptions.Create;
var
  I:    integer;
begin
  inherited Create;

  TextDescription := AddText(Theme.Options.TextDescription);

  LoadFromTheme(Theme.Options);

  AddButton(Theme.Options.ButtonGame);
  if (Length(Button[0].Text)=0) then
    AddButtonText(14, 20, Theme.Options.Description[0]);

  AddButton(Theme.Options.ButtonGraphics);
  if (Length(Button[1].Text)=0) then
    AddButtonText(14, 20, Theme.Options.Description[1]);

  AddButton(Theme.Options.ButtonSound);
  if (Length(Button[2].Text)=0) then
    AddButtonText(14, 20, Theme.Options.Description[2]);

  AddButton(Theme.Options.ButtonLyrics);
  if (Length(Button[3].Text)=0) then
    AddButtonText(14, 20, Theme.Options.Description[3]);

  AddButton(Theme.Options.ButtonThemes);
  if (Length(Button[4].Text)=0) then
    AddButtonText(14, 20, Theme.Options.Description[4]);

  AddButton(Theme.Options.ButtonRecord);
  if (Length(Button[5].Text)=0) then
    AddButtonText(14, 20, Theme.Options.Description[5]);

  AddButton(Theme.Options.ButtonAdvanced);
  if (Length(Button[6].Text)=0) then
    AddButtonText(14, 20, Theme.Options.Description[6]);

  AddButton(Theme.Options.ButtonExit);
  if (Length(Button[7].Text)=0) then
    AddButtonText(14, 20, Theme.Options.Description[7]);

  Interaction := 0;
end;

procedure TScreenOptions.onShow;
begin
  if not Help.SetHelpID(ID) then
    Log.LogError('No Entry for Help-ID ' + ID + ' (ScreenOptions)');
end;

procedure TScreenOptions.InteractNext;
begin
  inherited InteractNext;
  Text[TextDescription].Text := Theme.Options.Description[Interaction];
end;

procedure TScreenOptions.InteractPrev;
begin
  inherited InteractPrev;
  Text[TextDescription].Text := Theme.Options.Description[Interaction];
end;


procedure TScreenOptions.SetAnimationProgress(Progress: real);
begin
  Button[0].Texture.ScaleW := Progress;
  Button[1].Texture.ScaleW := Progress;
  Button[2].Texture.ScaleW := Progress;
  Button[3].Texture.ScaleW := Progress;
  Button[4].Texture.ScaleW := Progress;
  Button[5].Texture.ScaleW := Progress;
  Button[6].Texture.ScaleW := Progress;
  Button[7].Texture.ScaleW := Progress;
end;

end.