object Form1: TForm1
  Left = 192
  Top = 114
  BorderStyle = bsSingle
  Caption = 'IRC Translator'
  ClientHeight = 426
  ClientWidth = 680
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 680
    Height = 426
    ActivePage = TabSheet2
    Align = alClient
    Style = tsFlatButtons
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'IRC window'
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 672
        Height = 395
        Align = alClient
        BevelInner = bvRaised
        BevelOuter = bvLowered
        TabOrder = 0
        object Label7: TLabel
          Left = 12
          Top = 111
          Width = 111
          Height = 20
          Caption = 'TALKING ON '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clHighlight
          Font.Height = -16
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label8: TLabel
          Left = 139
          Top = 111
          Width = 121
          Height = 20
          Caption = 'TALKING ON #'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clHighlight
          Font.Height = -16
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object RichEdit1: TRichEdit
          Left = 2
          Top = 2
          Width = 551
          Height = 103
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Terminal'
          Font.Style = [fsBold]
          ParentFont = False
          ScrollBars = ssVertical
          TabOrder = 0
        end
        object Edit1: TEdit
          Left = 2
          Top = 331
          Width = 709
          Height = 21
          TabOrder = 1
          OnKeyDown = Edit1KeyDown
        end
        object RichEdit2: TRichEdit
          Left = 2
          Top = 136
          Width = 551
          Height = 189
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          Lines.Strings = (
            'RichEdit2')
          ParentFont = False
          TabOrder = 2
        end
        object translate: TCheckBox
          Left = 559
          Top = 5
          Width = 97
          Height = 17
          Caption = 'translate on/off'
          TabOrder = 3
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'server setup'
      ImageIndex = 1
      object GroupBox1: TGroupBox
        Left = 0
        Top = 0
        Width = 672
        Height = 395
        Align = alClient
        TabOrder = 0
        object Label1: TLabel
          Left = 48
          Top = 24
          Width = 28
          Height = 13
          Caption = 'Nick :'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label2: TLabel
          Left = 33
          Top = 52
          Width = 43
          Height = 13
          Caption = 'Alt-Nick :'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label3: TLabel
          Left = 22
          Top = 80
          Width = 54
          Height = 13
          Caption = 'Realname :'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label4: TLabel
          Left = 45
          Top = 108
          Width = 31
          Height = 13
          Caption = 'eMail :'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label5: TLabel
          Left = 39
          Top = 136
          Width = 37
          Height = 13
          Caption = 'Server :'
        end
        object Label6: TLabel
          Left = 207
          Top = 136
          Width = 3
          Height = 13
          Caption = ':'
        end
        object Edit2: TEdit
          Left = 80
          Top = 20
          Width = 121
          Height = 21
          TabOrder = 0
          Text = 'yournick'
        end
        object Edit3: TEdit
          Left = 80
          Top = 48
          Width = 121
          Height = 21
          TabOrder = 1
          Text = 'yournick_'
        end
        object Edit4: TEdit
          Left = 80
          Top = 76
          Width = 121
          Height = 21
          TabOrder = 2
          Text = 'realname'
        end
        object Edit5: TEdit
          Left = 80
          Top = 104
          Width = 121
          Height = 21
          TabOrder = 3
          Text = 'you@mail'
        end
        object Edit6: TEdit
          Left = 80
          Top = 132
          Width = 121
          Height = 21
          TabOrder = 4
          Text = 'lidingo.se.EU.UnderNet.org'
        end
        object Edit7: TEdit
          Left = 216
          Top = 132
          Width = 57
          Height = 21
          TabOrder = 5
          Text = '6667'
        end
        object Button1: TButton
          Left = 281
          Top = 128
          Width = 97
          Height = 25
          Caption = 'set connection'
          TabOrder = 6
          OnClick = Button1Click
        end
        object Button2: TButton
          Left = 384
          Top = 128
          Width = 75
          Height = 25
          Caption = 'disconnect'
          TabOrder = 7
          OnClick = Button2Click
        end
      end
    end
  end
  object Button3: TButton
    Left = 270
    Top = 3
    Width = 75
    Height = 21
    Caption = 'join channel'
    TabOrder = 1
    OnClick = Button3Click
  end
  object chanedit: TEdit
    Left = 351
    Top = 2
    Width = 121
    Height = 21
    TabOrder = 2
    Text = '#hackinganonymous'
    OnClick = chaneditClick
  end
  object Panel2: TPanel
    Left = 563
    Top = 55
    Width = 109
    Height = 297
    TabOrder = 3
    object Label9: TLabel
      Left = 16
      Top = 2
      Width = 74
      Height = 13
      Caption = 'From Language'
    end
    object Label10: TLabel
      Left = 16
      Top = 151
      Width = 64
      Height = 13
      Caption = 'To Language'
    end
  end
  object Edit8: TEdit
    Left = 579
    Top = 85
    Width = 58
    Height = 21
    TabOrder = 4
    Text = 'Edit8'
  end
  object Edit9: TEdit
    Left = 579
    Top = 225
    Width = 58
    Height = 21
    TabOrder = 5
    Text = 'Edit8'
  end
  object cs: TClientSocket
    Active = False
    ClientType = ctNonBlocking
    Port = 0
    OnConnect = csConnect
    OnDisconnect = csDisconnect
    OnRead = csRead
    OnError = csError
    Left = 8
    Top = 408
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 45000
    OnTimer = Timer1Timer
    Left = 48
    Top = 408
  end
  object MainMenu1: TMainMenu
    Left = 224
    Top = 64
    object Main1: TMenuItem
      Caption = 'Main'
      object Start1: TMenuItem
        Caption = 'Start'
        OnClick = Start1Click
      end
      object Stop1: TMenuItem
        Caption = 'Stop'
        OnClick = Stop1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Caption = 'Exit'
      end
    end
    object N2: TMenuItem
      Caption = '?'
      object About1: TMenuItem
        Caption = 'About'
      end
    end
  end
end
