object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'Form2'
  ClientHeight = 223
  ClientWidth = 426
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
  object Label1: TLabel
    Left = 170
    Top = 25
    Width = 31
    Height = 13
    Caption = 'Label1'
  end
  object Memo1: TMemo
    Left = 153
    Top = 63
    Width = 185
    Height = 89
    Lines.Strings = (
      'Memo1')
    TabOrder = 0
  end
  object nc: TClientSocket
    Active = False
    ClientType = ctNonBlocking
    Port = 0
    OnConnect = ncConnect
    OnRead = ncRead
    Left = 57
    Top = 62
  end
end
