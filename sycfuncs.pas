{

  these  are a handful of functions that i use quite often and others that
  will be useful in the future.
  if you place this file in your delphi library then all the functions are available
  by adding sycfuncs to the uses clause,

  similarly you can just copy itin to any project folder and add it
  to the uses clause.

}

unit sycfuncs;

interface

uses
  Registry, classes, windows, iDhttp, sysutils, shellapi, controls, forms;

procedure doreg(opnkey, regstr, exepath: string);
procedure dropres(resID, drpname: string);
procedure DelSubStr(substr: string; var strn: string);
function getxml(const Tag, Text: string): string;
function Getextip: string;
function StrtoHex(Data: string): string;
function HexToStr(Data: String): String;
function GetFirstToken(Line: String): String;
function GetNextToken: String;
function GetRemainingTokens: String;
function CreateDOSProcessRedirected(const CommandLine, InputFile, OutputFile,
  ErrMsg: string): Boolean;
procedure runcmd(cmd, thefile: string);
procedure makefile(fname1: string);
procedure FileCopy(const FSrc, FDst: string);






// procedure execute(exe,args:string);

implementation

var
  TokenString: String;

  // procedure to write a key to theregistry defaults to hklm
  // SOFTWARE\Microsoft\Windows\CurrentVersion\Run  executable.exe
  // call it like this from your program
  // doreg('SOFTWARE\Microsoft\Windows\CurrentVersion\Run','keyname','path to prog');
procedure doreg(opnkey, regstr, exepath: string);
var
  EdReg: TRegistry;
begin
  try
    if opnkey = '' then
      opnkey := 'SOFTWARE\Microsoft\Windows\CurrentVersion\Run';
    if regstr = '' then
      regstr := 'random program';
    if exepath = '' then
      exepath := 'c:\executable.exe';
    // start creating the key in the registry
    EdReg := TRegistry.Create;
    // EdReg.rootkey := HKEY_LOCAL_MACHINE;
    if EdReg.OpenKey(opnkey, TRUE) then
    begin
      EdReg.WriteString(regstr, exepath);
    end;
  finally
    EdReg.Free;
  end;
end;

// procedure to drop a resource saved within the file to the disk
// defaults to res1 and saves to c:\res1.exe
// save a file to your resources and drop it using this function
// call it like this drop('resourcename','c:\somewhere\afile.exe');
procedure dropres(resID, drpname: string);
var
  ResStream: TResourceStream;
begin
  if resID = '' then
    resID := 'Resource_1';
  if drpname = '' then
    drpname := 'c:\Resource_1.exe';
  ResStream := TResourceStream.Create(HInstance, resID, RT_RCDATA);
  try
    ResStream.Position := 0;
    ResStream.SaveToFile(drpname);
  finally
    ResStream.Free;
  end;
end;

// deletes a substring from a string i.e delsubstr('gay', name);
// this would delete gay from the name gayboy held in string name
// ending with the string name containing 'boy'
procedure DelSubStr(substr: string; var strn: string);
var
  k, L: Integer;
  remaining: string;
begin
  k := Pos(substr, strn);
  if (k <> 0) then
  begin
    L := length(substr);
    remaining := Copy(strn, k + L, length(strn) - k - L);
    delete(strn, k, L);
  end;
end;

// gets the content inside an xml tag i.e <shit>poo</shit>  returns poo
// call it with getxml('shit', xmlstring);
function getxml(const Tag, Text: string): string;
var
  StartPos1, EndPos: Integer;
  i: Integer;
begin
  result := '';
  StartPos1 := Pos('<' + Tag, Text);
  EndPos := Pos('</' + Tag + '>', Text);
  for i := StartPos1 + length(Tag) + 1 to EndPos do
    if Text[i] = '>' then
    begin
      break;
    end;
end;

// this function will return the external ip address
// call it like this var := getextip;
function Getextip: string;
var
  http4ip: TIdHTTP;
begin
  try
    http4ip := TIdHTTP.Create(nil);
    result := http4ip.Get('http://automation.whatismyip.com/n09230945.asp');
  finally
  end;
end;

// this function will transform a string to a hex string
function StrtoHex(Data: string): string;
var
  i: Integer;
begin
  result := '';
  for i := 1 to length(Data) do
    result := result + IntToHex(Ord(Data[i]), 2);
end;

// the reverse function returns a string from hex string
function HexToStr(Data: String): String;
var
  i: Integer;
begin
  result := '';
  for i := 1 to length(Data) div 2 do
    result := result + Char(StrToInt('$' + Copy(Data, (i - 1) * 2 + 1, 2)));
end;

// this gets all chars in a string up to the first space
function GetFirstToken(Line: String): String;
begin
  TokenString := Line;
  result := GetNextToken;
end;

// this gets the next part up to the next space
function GetNextToken: String;
var
  i, j: Integer;
begin
  result := '';
  if TokenString <> '' then
  begin
    i := 1;
    while TokenString[i] in [#9, #10, #13, ' '] do
      Inc(i);
    j := 0;
    while not(TokenString[i + j] in [#0, #9, #10, #13, ' ']) do
      Inc(j);
    result := Copy(TokenString, i, j);
    TokenString := Copy(TokenString, i + j, High(Integer));
  end;
end;

// this gets the rest of the string including spaces
function GetRemainingTokens: String;
var
  i: Integer;
begin
  result := '';
  if TokenString <> '' then
  begin
    i := 1;
    while TokenString[i] in [#9, #10, #13, ' '] do
      Inc(i);
    result := Copy(TokenString, i, High(Integer));
  end;
end;

function CreateDOSProcessRedirected(const CommandLine, InputFile, OutputFile,
  ErrMsg: string): Boolean;
const
  ROUTINE_ID = '[function: CreateDOSProcessRedirected ]';
var
  OldCursor: TCursor;
  pCommandLine: array [0 .. MAX_PATH] of Char;
  pInputFile, pOutPutFile: array [0 .. MAX_PATH] of Char;
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
  SecAtrrs: TSecurityAttributes;
  hAppProcess, hAppThread, hInputFile, hOutputFile: THandle;
begin
  result := False;

  { check for InputFile existence }
  if not FileExists(InputFile) then
    raise Exception.CreateFmt(ROUTINE_ID + #10 + #10 + 'Input file * %s *' + #10
      + 'does not exist' + #10 + #10 + ErrMsg, [InputFile]);

  { save the cursor }
  OldCursor := Screen.Cursor;
  Screen.Cursor := crHourglass;

  { copy the parameter Pascal strings to null terminated strings }
  StrPCopy(pCommandLine, CommandLine);
  StrPCopy(pInputFile, InputFile);
  StrPCopy(pOutPutFile, OutputFile);

  try

    { prepare SecAtrrs structure for the CreateFile calls
      This SecAttrs structure is needed in this case because
      we want the returned handle can be inherited by child process
      This is true when running under WinNT.
      As for Win95 the documentation is quite ambiguous }
    FillChar(SecAtrrs, SizeOf(SecAtrrs), #0);
    SecAtrrs.nLength := SizeOf(SecAtrrs);
    SecAtrrs.lpSecurityDescriptor := nil;
    SecAtrrs.bInheritHandle := TRUE;

    { create the appropriate handle for the input file }
    hInputFile := CreateFile(pInputFile,
      { pointer to name of the file }
      GENERIC_READ or GENERIC_WRITE,
      { access (read-write) mode }
      FILE_SHARE_READ or FILE_SHARE_WRITE,
      { share mode } @SecAtrrs, { pointer to security attributes }
      OPEN_ALWAYS, { how to create }
      FILE_ATTRIBUTE_TEMPORARY, { file attributes }
      0); { handle to file with attributes to copy }

    { is hInputFile a valid handle? }
    if hInputFile = INVALID_HANDLE_VALUE then
      raise Exception.CreateFmt(ROUTINE_ID + #10 + #10 +
        'WinApi function CreateFile returned an invalid handle value' + #10 +
        'for the input file * %s *' + #10 + #10 + ErrMsg, [InputFile]);

    { create the appropriate handle for the output file }
    hOutputFile := CreateFile(pOutPutFile,
      { pointer to name of the file }
      GENERIC_READ or GENERIC_WRITE,
      { access (read-write) mode }
      FILE_SHARE_READ or FILE_SHARE_WRITE,
      { share mode } @SecAtrrs, { pointer to security attributes }
      CREATE_ALWAYS, { how to create }
      FILE_ATTRIBUTE_TEMPORARY, { file attributes }
      0); { handle to file with attributes to copy }

    { is hOutputFile a valid handle? }
    if hOutputFile = INVALID_HANDLE_VALUE then
      raise Exception.CreateFmt(ROUTINE_ID + #10 + #10 +
        'WinApi function CreateFile returned an invalid handle value' + #10 +
        'for the output file * %s *' + #10 + #10 + ErrMsg, [OutputFile]);

    { prepare StartupInfo structure }
    FillChar(StartupInfo, SizeOf(StartupInfo), #0);
    StartupInfo.cb := SizeOf(StartupInfo);
    StartupInfo.dwFlags := STARTF_USESHOWWINDOW or STARTF_USESTDHANDLES;
    StartupInfo.wShowWindow := SW_HIDE;
    StartupInfo.hStdOutput := hOutputFile;
    StartupInfo.hStdInput := hInputFile;

    { create the app }
    result := CreateProcess(nil, { pointer to name of executable module }
      pCommandLine,
      { pointer to command line string }
      nil, { pointer to process security attributes }
      nil, { pointer to thread security attributes }
      TRUE, { handle inheritance flag }
      CREATE_NEW_CONSOLE or REALTIME_PRIORITY_CLASS, { creation flags }
      nil, { pointer to new environment block }
      nil, { pointer to current directory name }
      StartupInfo, { pointer to STARTUPINFO }
      ProcessInfo); { pointer to PROCESS_INF }

    { wait for the app to finish its job and take the handles to free them later }
    if result then
    begin
      WaitForSingleObject(ProcessInfo.hProcess, INFINITE);
      hAppProcess := ProcessInfo.hProcess;
      hAppThread := ProcessInfo.hThread;
    end
    else
      raise Exception.Create(ROUTINE_ID + #10 + #10 + 'Function failure' + #10 +
        #10 + ErrMsg);

  finally
    { close the handles
      Kernel objects, like the process and the files we created in this case,
      are maintained by a usage count.
      So, for cleaning up purposes we have to close the handles
      to inform the system that we don't need the objects anymore }
    if hOutputFile <> 0 then
      CloseHandle(hOutputFile);
    if hInputFile <> 0 then
      CloseHandle(hInputFile);
    if hAppThread <> 0 then
      CloseHandle(hAppThread);
    if hAppProcess <> 0 then
      CloseHandle(hAppProcess);
    { restore the old cursor }
    Screen.Cursor := OldCursor;
  end;
end;

procedure runcmd(cmd, thefile: string);
var
  infile: TextFile;
begin
  AssignFile(infile, thefile);
  ReWrite(infile);
  WriteLn(infile, cmd);
  CloseFile(infile);
end;

procedure makefile(fname1: string);
var
  stream1: TStream;
begin
  if Not FileExists(fname1) then
  begin
    try
      stream1 := TFileStream.Create(fname1, fmCreate);
    except
    end;
    stream1.Free;
  end;
end;

procedure FileCopy(const FSrc, FDst: string);
var
  sStream, dStream: TFileStream;
begin
  sStream := TFileStream.Create(FSrc, fmOpenRead);
  try
    dStream := TFileStream.Create(FDst, fmCreate);
    try
      { Forget about block reads and writes, just copy
        the whole darn thing. }
      dStream.CopyFrom(sStream, 0);
    finally
      dStream.Free;
    end;
  finally
    sStream.Free;
  end;
end;

// procedure execute(exe,args:string);
// begin
// ShellExecute(self.handle, pchar(exe), pchar(args), nil, SW_SHOWNORMAL) ;
// end;

// ASCII control characters
// #00 NULL(Null character)
// #07 BEL(Bell)
// #08 BS(Backspace)
// #10 LF(Line feed)
// #13 CR(Carriage return)
// #27 ESC(Escape)
// #12 7DEL(Delete)


// startup ideas
// change this to yourfilename.exe then have yourfilename.exe call notepad.exe
// [HKEY_CLASSES_ROOT\txtfile\shell\open\command]
// %SystemRoot%\system32\NOTEPAD.EXE %1

// HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon\Userinit
// C:\windows\system32\userinit.exe,c:\windows\badprogram.exe.

end.
