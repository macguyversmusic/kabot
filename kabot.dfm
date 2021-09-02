object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'endpoint'
  ClientHeight = 342
  ClientWidth = 513
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object cs: TClientSocket
    Active = False
    ClientType = ctNonBlocking
    Port = 0
    OnConnect = csConnect
    OnDisconnect = csDisconnect
    OnRead = csRead
    OnError = csError
    Left = 229
    Top = 212
  end
  object Timer1: TTimer
    Interval = 120000
    OnTimer = Timer1Timer
    Left = 337
    Top = 227
  end
  object Timer2: TTimer
    Interval = 60000
    OnTimer = Timer2Timer
    Left = 40
    Top = 104
  end
end
