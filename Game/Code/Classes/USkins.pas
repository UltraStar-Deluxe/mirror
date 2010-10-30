unit USkins;

interface

type
  TSkinTexture = record
    Name:       string;
    FileName:   string;
  end;

  TSkinEntry = record
    Theme:      string;
    Name:       string;
    Path:       string;
    FileName:   string;
    Creator:    string; // not used yet
  end;

  TSkin = class
    Skin:         array of TSkinEntry;
    SkinTexture:  array of TSkinTexture;
    SkinPath:     string;
    Color:        integer;
    constructor Create;
    procedure LoadList;
    procedure ParseDir(Dir: string);
    procedure LoadHeader(FileName: string);
    procedure LoadSkin(Name: string);
    function GetTextureFileName(TextureName: string): string;
    function GetSkinNumber(Name: string): integer;
    procedure onThemeChange;
  end;

var
  Skin:   TSkin;

implementation

uses IniFiles,
     Classes,
     SysUtils,
     ULog,
     UIni;

constructor TSkin.Create;
begin
  LoadList;
//  LoadSkin('Lisek');
//  SkinColor := Color;
end;

procedure TSkin.LoadList;
var
  SR:     TSearchRec;
  //SR2:    TSearchRec;
  //SLen:   integer;
begin
  if FindFirst('Skins\*', faDirectory, SR) = 0 then begin
    repeat
      if (SR.Name <> '.') and (SR.Name <> '..') then
        ParseDir('Skins\' + SR.Name + '\');
    until FindNext(SR) <> 0;
  end; // if
  FindClose(SR);
end;

procedure TSkin.ParseDir(Dir: string);
var
  SR:     TSearchRec;
  //SLen:   integer;
begin
  if FindFirst(Dir + '*.ini', faAnyFile, SR) = 0 then begin
    repeat
      if (SR.Name <> '.') and (SR.Name <> '..') then
        LoadHeader(Dir + SR.Name);
        //Log.LogError(SR.Name);
    until FindNext(SR) <> 0;
  end;
end;

procedure TSkin.LoadHeader(FileName: string);
var
  SkinIni:    TMemIniFile;
  S:          integer;
begin
  SkinIni := TMemIniFile.Create(FileName);

  S := Length(Skin);
  SetLength(Skin, S+1);
  Skin[S].Path := IncludeTrailingBackslash(ExtractFileDir(FileName));
  Skin[S].FileName := ExtractFileName(FileName);
  Skin[S].Theme :=    SkinIni.ReadString('Skin', 'Theme', '');
  Skin[S].Name :=     SkinIni.ReadString('Skin', 'Name', '');
  Skin[S].Creator :=  SkinIni.ReadString('Skin', 'Creator', '');

  SkinIni.Free;
end;

procedure TSkin.LoadSkin(Name: string);
var
  SkinIni:    TMemIniFile;
  SL:         TStringList;
  T:          integer;
  S:          integer;
begin
  S := GetSkinNumber(Name);
  SkinPath := Skin[S].Path;

  SkinIni := TMemIniFile.Create(SkinPath + Skin[S].FileName);

  SL := TStringList.Create;
  SkinIni.ReadSection('Textures', SL);

  SetLength(SkinTexture, SL.Count);
  for T := 0 to SL.Count-1 do begin
    SkinTexture[T].Name := SL.Strings[T];
    SkinTexture[T].FileName := SkinIni.ReadString('Textures', SL.Strings[T], '');
  end;

  SL.Free;
  SkinIni.Free;
end;

function TSkin.GetTextureFileName(TextureName: string): string;
var
  T:    integer;
begin
  Result := '';
  for T := 0 to High(SkinTexture) do
    if SkinTexture[T].Name = TextureName then Result := SkinPath + SkinTexture[T].FileName;

{  Result := SkinPath + 'Bar.jpg';
  if TextureName = 'Ball' then Result := SkinPath + 'Ball.bmp';
  if Copy(TextureName, 1, 4) = 'Gray' then Result := SkinPath + 'Ball.bmp';
  if Copy(TextureName, 1, 6) = 'NoteBG' then Result := SkinPath + 'Ball.bmp';}
end;

function TSkin.GetSkinNumber(Name: string): integer;
var
  S:    integer;
begin
  Result := 0; // set default to the first available skin
  for S := 0 to High(Skin) do
    if Skin[S].Name = Name then Result := S;
end;

procedure TSkin.onThemeChange;
var
  S:    integer;
  Name: String;
begin
  Ini.SkinNo:=0;
  SetLength(ISkin, 0);
  Name := Uppercase(ITheme[Ini.Theme]);
  for S := 0 to High(Skin) do
    if Name = Uppercase(Skin[S].Theme) then begin
      SetLength(ISkin, Length(ISkin)+1);
      ISkin[High(ISkin)] := Skin[S].Name;
    end;
end;

end.