unit ULog;

interface

uses Classes;

type
  TLog = class
    BenchmarkTimeStart:   array[0..7] of real;
    BenchmarkTimeLength:  array[0..7] of real;//TDateTime;

    FileBenchmark:    TextFile;
    FileBenchmarkO:   boolean; // opened
    FileError:        TextFile;
    FileErrorO:       boolean; // opened

    FileSession:      TextFile;
    FileSessionO:     boolean; // opened

    NumErrors:        integer;
    NumSungSongs:     integer;

    Title: String; //Application Title

    //Should Log Files be written
    Enabled:          Boolean;

    // destuctor
    destructor Free;

    // benchmark
    procedure BenchmarkStart(Number: integer);
    procedure BenchmarkEnd(Number: integer);
    procedure LogBenchmark(Text: string; Number: integer);

    // error
    procedure LogError(Text: string); overload;

    //Critical Error (Halt + MessageBox)
    procedure CriticalError(Text: string);

    // voice
    function LogVoice(SoundNr: Integer; Player, Artist, Title, Points: string): string;

    procedure LogSession(names: array of string; points: array of string; Artist, Title, singmode: string);

    // compability
    procedure LogStatus(Log1, Log2: string);
    procedure LogError(Log1, Log2: string); overload;
  end;

var
  Log:    TLog;

implementation
uses UFiles, SysUtils, DateUtils, URecord, UTime, UIni, Windows, UCommandLine;

destructor TLog.Free;
begin
  if FileBenchmarkO then CloseFile(FileBenchmark);
//  if FileAnalyzeO then CloseFile(FileAnalyze);
  if FileErrorO then CloseFile(FileError);
  if FileSessionO then CloseFile(FileSession);

end;

procedure TLog.BenchmarkStart(Number: integer);
begin
  BenchmarkTimeStart[Number] := USTime.GetTime; //Time;
end;

procedure TLog.BenchmarkEnd(Number: integer);
begin
  BenchmarkTimeLength[Number] := USTime.GetTime {Time} - BenchmarkTimeStart[Number];
end;

procedure TLog.LogBenchmark(Text: string; Number: integer);
var
  Minutes:      integer;
  Seconds:      integer;
  Miliseconds:  integer;

  MinutesS:     string;
  SecondsS:     string;
  MilisecondsS: string;

  ValueText:    string;
begin
  if Enabled AND (Params.Benchmark) then begin
    if not FileBenchmarkO then begin
      FileBenchmarkO := true;
      AssignFile(FileBenchmark, LogPath + 'Benchmark.log');
      {$I-}
      Rewrite(FileBenchmark);
      if IOResult = 0 then FileBenchmarkO := true;
      {$I+}

      //If File is opened write Date to Benchmark File
      If (FileBenchmarkO) then
      begin
        WriteLn(FileBenchmark, Title + ' Benchmark File');
        WriteLn(FileBenchmark, 'Date: ' + DatetoStr(Now) + ' Time: ' + TimetoStr(Now));
        WriteLn(FileBenchmark, '-------------------');

        Flush(FileBenchmark);
      end;
    end;

  if FileBenchmarkO then begin
    Miliseconds := Trunc(Frac(BenchmarkTimeLength[Number]) * 1000);
    Seconds := Trunc(BenchmarkTimeLength[Number]) mod 60;
    Minutes := Trunc((BenchmarkTimeLength[Number] - Seconds) / 60);
//    ValueText := FloatToStr(BenchmarkTimeLength[Number]);

{    ValueText := FloatToStr(
      SecondOf(BenchmarkTimeLength[Number]) + MilliSecondOf(BenchmarkTimeLength[Number])/1000
      );
    if MinuteOf(BenchmarkTimeLength[Number]) >= 1 then
      ValueText := IntToStr(MinuteOf(BenchmarkTimeLength[Number])) + ':' + ValueText;
    WriteLn(FileBenchmark, Text + ': ' + ValueText + ' seconds');}

    if (Minutes = 0) and (Seconds = 0) then begin
      MilisecondsS := IntToStr(Miliseconds);
      ValueText := MilisecondsS + ' miliseconds';
    end;

    if (Minutes = 0) and (Seconds >= 1) then begin
      MilisecondsS := IntToStr(Miliseconds);
      while Length(MilisecondsS) < 3 do MilisecondsS := '0' + MilisecondsS;

      SecondsS := IntToStr(Seconds);

      ValueText := SecondsS + ',' + MilisecondsS + ' seconds';
    end;

    if Minutes >= 1 then begin
      MilisecondsS := IntToStr(Miliseconds);
      while Length(MilisecondsS) < 3 do MilisecondsS := '0' + MilisecondsS;

      SecondsS := IntToStr(Seconds);
      while Length(SecondsS) < 2 do SecondsS := '0' + SecondsS;

      MinutesS := IntToStr(Minutes);

      ValueText := MinutesS + ':' + SecondsS + ',' + MilisecondsS + ' minutes';
    end;

    WriteLn(FileBenchmark, Text + ': ' + ValueText);
    Flush(FileBenchmark);
    end;
  end;
end;

procedure TLog.LogError(Text: string);
begin
  if Enabled AND (not FileErrorO) then begin
    FileErrorO := true;
    NumErrors := 0;
    AssignFile(FileError, LogPath + 'Error.log');
    {$I-}
    Rewrite(FileError);
    if IOResult = 0 then FileErrorO := true;
    {$I+}

    //If File is opened write Date to Error File
    If (FileErrorO) then
    begin
      WriteLn(FileError, Title + ' Error Log');
      WriteLn(FileError, 'Date: ' + DatetoStr(Now) + ' Time: ' + TimetoStr(Now));
      WriteLn(FileError, '-------------------');

      Flush(FileError);
    end;
  end;

  if FileErrorO then begin
    try
      Inc(NumErrors);
      WriteLn(FileError, IntToStr(NumErrors) + ') ' + Text);
      WriteLn(FileError, '');
      Flush(FileError);
    except
      FileErrorO := false;
    end;
  end;
end;

function TLog.LogVoice(SoundNr: Integer; Player, Artist, Title, Points: string): string;
type
  TRiffHeader = record
    riff: Array[0..3] OF Char;
    filesize: LongInt;
    typeStr: Array[0..3] OF Char;
  end;

  TChunkRec = record
    id: Array[0..3] OF Char;
    size: LongInt;
  end;

  TWaveFormatRec = record
    tag: Word;
    channels: Word;
    samplesPerSec: LongInt;
    bytesPerSec: LongInt;
    blockAlign: Word;
    bitsPerSample: Word;
  end;

  TWAVHeader = record { WAV Format }
    riffHdr: TRiffHeader;
    fmtChunk: TChunkRec;
    fmt: TWaveFormatRec;
    dataChunk: TChunkRec;
    { data follows here }
  end;

procedure HeadInit(var Header: TWAVHeader);
begin
  with Header do
  begin
    with riffHdr do
    begin
      riff := 'RIFF';
      typeStr := 'WAVE';
    end;
    with fmtChunk do
    begin
      id := 'fmt ';
      size := 16;
    end;
    with fmt do
    begin
        //its 16 bit, 44.1kHz Mono
      tag := 1; channels := 1;
      samplesPerSec := 44100;
      bytesPerSec := 44100*2;
      blockAlign := 2;
      bitsPerSample := 16;
    end;
    with dataChunk do
    begin
      id := 'data';
    end;
  end;
end;


var
  FS:           TFileStream;
  FileName:     string;
  Num:          integer;
  BL:           integer;
  Header:       TWAVHeader;
  s:            LongInt;

begin
  for Num := 1 to 9999 do begin
    FileName := IntToStr(Num);
    while Length(FileName) < 4 do FileName := '0' + FileName;
    //FileName := RecordingsPath + Artist + '_' +
    //  Title + '_P' + Points + '_' + FileName + '_' + Player + '.wav'; //some characters are not allowed; TODO
    FileName := RecordingsPath + 'V_' + FileName + '.wav';
    if not FileExists(FileName) then break
  end;

  HeadInit(Header);
  s := 0;
  for BL := 0 to High(Sound[SoundNr].BufferLong) do
    s := s + Sound[SoundNr].BufferLong[BL].Size;

  if (s=0) then
    exit;

  Header.Datachunk.size := s;
  //FileSize = DataSize + HeaderSize
  Header.riffHdr.FileSize := Header.Datachunk.size + sizeof(Header)-8;

  FS := TFileStream.Create(FileName, fmCreate);
  FS.Write(Header, sizeof(header));

  for BL := 0 to High(Sound[SoundNr].BufferLong) do
  begin
    Sound[SoundNr].BufferLong[BL].Seek(0, soBeginning);
    FS.CopyFrom(Sound[SoundNr].BufferLong[BL], Sound[SoundNr].BufferLong[BL].Size);
  end;

  FS.Free;
  LogVoice := FileName;
end;

procedure TLog.LogSession(names: array of string; points: array of string; Artist, Title, singmode: string);
var
  Num:      integer;
  FileName: string;
  I:        integer;
  Year, Month, Day:     word;
  Hour, Min, Sec, MSec: word;
  timestamp:  integer;
  datestr:    string;
  timestr:    string;

  function Fill(w: word): string;
  begin
    Result := '';
    if (w<10) then
      Result := '0';

    Result := Result + IntToStr(w);
  end;

begin
  timestamp := DateTimeToUnix(Now());
  DecodeDate(UnixToDateTime(timestamp), Year, Month, Day);
  DecodeTime(UnixToDateTime(timestamp), Hour, Min, Sec, MSec);

  datestr := IntToStr(Year) + Fill(Month) + Fill(Day);
  timestr := Fill(Hour) + Fill(Min) + Fill(Sec);

  if not FileSessionO then
  begin
    FileSessionO := false;
    NumSungSongs := 0;
    FileName := SessionLogPath + 'Session_' + datestr + '-' + timestr + '.log';

    if FileExists(FileName) then
    begin
      for Num := 1 to 9999 do
      begin
        FileName := IntToStr(Num);
        while Length(FileName) < 4 do FileName := '0' + FileName;
        FileName := SessionLogPath + 'Session_' + datestr + '-' + timestr + '_' + FileName + '.log';
        if not FileExists(FileName) then break
      end;
    end;

    AssignFile(FileSession, FileName);
    {$I-}
    Rewrite(FileSession);
    if IOResult = 0 then FileSessionO := true;
    {$I+}

    //If File is opened write Date to File
    If (FileSessionO) then
    begin
      WriteLn(FileSession, 'Session Log');
      WriteLn(FileSession, 'Date: ' + IntToStr(Year) + '-' + Fill(Month) + '-' + Fill(Day) +
         ' Time: ' + Fill(Hour) + ':' + Fill(Min) + ':' + Fill(Sec));

      Flush(FileSession);
    end;
  end;

  if FileSessionO then
  begin
    try
      Inc(NumSungSongs);
      WriteLn(FileSession, '');
      WriteLn(FileSession, '');
      WriteLn(FileSession, '#----------------------------------------------------------------');
      WriteLn(FileSession, '# ' + IntToStr(NumSungSongs) + ') ' + 'Date: ' + IntToStr(Year) + '-' + Fill(Month) + '-' + Fill(Day) +
        ' Time: ' + Fill(Hour) + ':' + Fill(Min) + ':' + Fill(Sec));
      WriteLn(FileSession, '# Sing mode: ' + singmode);
      WriteLn(FileSession, '#----------------------------------------------------------------');
      WriteLn(FileSession, '# Song: ' + Artist + ' - ' + Title + ':');
      for I := 0 to Length(names) - 1 do
      begin
        WriteLn(FileSession, '# ' + names[I] + ' - ' + points[I]);
      end;
      WriteLn(FileSession, '#-----------------------------------------------------------------');
      Flush(FileSession);
    except
      FileSessionO := false;
    end;
  end;
end;

procedure TLog.LogStatus(Log1, Log2: string);
begin
  //Just for Debugging
  //Comment for Release
    //LogAnalyze (Log2 + ': ' + Log1);
end;

procedure TLog.LogError(Log1, Log2: string);
begin
//asd
end;

procedure TLog.CriticalError(Text: string);
begin
  //Write Error to Logfile:
  LogError (Text);

  //Show Errormessage
  Messagebox(0, PChar(Text), PChar(Title), MB_ICONERROR or MB_OK);

  //Exit Application
  Halt;
end;

end.

