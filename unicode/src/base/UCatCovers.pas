{* UltraStar Deluxe - Karaoke Game
 *
 * UltraStar Deluxe is the legal property of its developers, whose names
 * are too numerous to list here. Please refer to the COPYRIGHT
 * file distributed with this source distribution.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; see the file COPYING. If not, write to
 * the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA 02110-1301, USA.
 *
 * $URL$
 * $Id$
 *}

unit UCatCovers;
/////////////////////////////////////////////////////////////////////////
//                   UCatCovers by Whiteshark                          //
//          Class for listing and managing the Category Covers         //
/////////////////////////////////////////////////////////////////////////

interface

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

{$I switches.inc}

uses
  UIni,
  UPath;

type
  TCatCovers = class
    protected
      cNames:    array [0..high(ISorting)] of array of UTF8String;
      cFiles:    array [0..high(ISorting)] of array of IPath;
    public
      constructor Create;
      procedure Load; //Load Cover aus Cover.ini and Cover Folder
      procedure LoadPath(const CoversPath: IPath);
      procedure Add(Sorting: integer; const Name: UTF8String; const Filename: IPath); //Add a Cover
      function  CoverExists(Sorting: integer; const Name: UTF8String): boolean; //Returns True when a cover with the given Name exists
      function  GetCover(Sorting: integer; const Name: UTF8String): IPath; //Returns the Filename of a Cover
  end;

var
  CatCovers: TCatCovers;

implementation

uses
  IniFiles,
  SysUtils,
  Classes,
  UFilesystem,
  ULog,
  UMain,
  UUnicodeUtils,
  UPathUtils;

constructor TCatCovers.Create;
begin
  inherited;
  Load;
end;

procedure TCatCovers.Load;
var
  I: integer;
begin
  for I := 0 to CoverPaths.Count-1 do
    LoadPath(CoverPaths[I] as IPath);
end;

(**
 * Load Cover from Cover.ini and Cover Folder
 *)
procedure TCatCovers.LoadPath(const CoversPath: IPath);
var
  Ini: TMemIniFile;
  List: TStringlist;
  I, J: Integer;
  Filename: IPath;
  Name, TmpName: UTF8String;
  CatCover: IPath;
  Iter: IFileIterator;
  FileInfo: TFileInfo;
begin
  Ini := nil;
  List := nil;

  try
    Ini  := TMemIniFile.Create(CoversPath.Append('covers.ini').ToNative);
    List := TStringlist.Create;

    //Add every Cover in Covers Ini for Every Sorting option
    for I := 0 to High(ISorting) do
    begin
      Ini.ReadSection(ISorting[I], List);

      for J := 0 to List.Count - 1 do
      begin
        CatCover := Path(Ini.ReadString(ISorting[I], List.Strings[J], 'NoCover.jpg'));
        Add(I, List.Strings[J], CoversPath.Append(CatCover));
      end;
    end;
  finally
    Ini.Free;
    List.Free;
  end;

  //Add Covers from Folder
  Iter := FileSystem.FileFind(CoversPath.Append('*.jpg'), 0);
  while Iter.HasNext do
  begin
    FileInfo := Iter.Next;

    //Add Cover if it doesn't exist for every Section
    Filename := CoversPath.Append(FileInfo.Name);
    Name := FileInfo.Name.SetExtension('').ToUTF8;

    for I := 0 to high(ISorting) do
    begin
      TmpName := Name;
      if ((I = sTitle) or (I = sTitle2)) and (UTF8Pos('Title', TmpName) <> 0) then
        UTF8Delete(TmpName, UTF8Pos('Title', TmpName), 5)
      else if (I = sArtist) or (I = sArtist2) and (UTF8Pos('Artist', TmpName) <> 0) then
        UTF8Delete(TmpName, UTF8Pos('Artist', TmpName), 6);

      if not CoverExists(I, TmpName) then
        Add(I, TmpName, Filename);
    end;
  end;
end;

  //Add a Cover
procedure TCatCovers.Add(Sorting: integer; const Name: UTF8String; const Filename: IPath);
begin
  if Filename.IsFile then //If Exists -> Add
  begin
    SetLength(CNames[Sorting], Length(CNames[Sorting]) + 1);
    SetLength(CFiles[Sorting], Length(CNames[Sorting]) + 1);

    CNames[Sorting][high(cNames[Sorting])] := UTF8Uppercase(Name);
    CFiles[Sorting][high(cNames[Sorting])] := FileName;
  end;
end;

  //Returns True when a cover with the given Name exists
function TCatCovers.CoverExists(Sorting: integer; const Name: UTF8String): boolean;
var
  I: Integer;
  UpperName: UTF8String;
begin
  Result := False;
  UpperName := UTF8Uppercase(Name); //Case Insensitiv

  for I := 0 to high(cNames[Sorting]) do
  begin
    if (cNames[Sorting][I] = UpperName) then //Found Name
    begin
      Result := true;
      break; //Break For Loop
    end;
  end;
end;

  //Returns the Filename of a Cover
function TCatCovers.GetCover(Sorting: integer; const Name: UTF8String): IPath;
var
  I: Integer;
  UpperName: UTF8String;
  NoCoverPath: IPath; 
begin
  Result := PATH_NONE;
  UpperName := UTF8Uppercase(Name);

  for I := 0 to high(cNames[Sorting]) do
  begin
    if cNames[Sorting][I] = UpperName then
    begin
      Result := cFiles[Sorting][I];
      Break;
    end;
  end;

  //No Cover
  if (Result.IsUnset) then
  begin
    for I := 0 to CoverPaths.Count-1 do
    begin
      NoCoverPath := (CoverPaths[I] as IPath).Append('NoCover.jpg');
      if (NoCoverPath.IsFile) then
      begin
        Result := NoCoverPath;
        Break;
      end;
    end;
  end;
end;

end.