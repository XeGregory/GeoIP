object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'ip-api.com'
  ClientHeight = 228
  ClientWidth = 431
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object EditHost: TEdit
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 425
    Height = 23
    Align = alTop
    TabOrder = 0
    ExplicitLeft = -2
    ExplicitTop = -14
    ExplicitWidth = 612
  end
  object BtnSearch: TButton
    AlignWithMargins = True
    Left = 3
    Top = 32
    Width = 425
    Height = 25
    Align = alTop
    Caption = 'Search'
    TabOrder = 1
    OnClick = BtnSearchClick
    ExplicitLeft = 525
    ExplicitTop = 8
    ExplicitWidth = 85
  end
  object MemoOut: TMemo
    AlignWithMargins = True
    Left = 3
    Top = 63
    Width = 425
    Height = 162
    Align = alClient
    TabOrder = 2
    ExplicitTop = 39
    ExplicitWidth = 612
    ExplicitHeight = 382
  end
end
