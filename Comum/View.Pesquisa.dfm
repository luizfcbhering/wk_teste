object ViewPesquisa: TViewPesquisa
  Left = 0
  Top = 0
  Caption = 'Pesquisa'
  ClientHeight = 410
  ClientWidth = 710
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object pnlAcoes: TPanel
    Left = 0
    Top = 375
    Width = 710
    Height = 35
    Align = alBottom
    TabOrder = 2
    object btnOk: TBitBtn
      Left = 518
      Top = 4
      Width = 90
      Height = 25
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 0
    end
    object btnCancelar: TBitBtn
      Left = 614
      Top = 4
      Width = 90
      Height = 25
      Caption = 'Cancelar'
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 1
    end
    object btnCadastro: TBitBtn
      Left = 10
      Top = 4
      Width = 90
      Height = 25
      Caption = 'Cadastro'
      Enabled = False
      NumGlyphs = 2
      TabOrder = 2
    end
  end
  object grbPesquisa: TGroupBox
    Left = 0
    Top = 0
    Width = 710
    Height = 52
    Align = alTop
    Caption = 'Pesquisa'
    TabOrder = 0
    ExplicitTop = -6
    DesignSize = (
      710
      52)
    object lblPesquisa: TLabel
      Left = 7
      Top = 24
      Width = 51
      Height = 13
      Caption = 'Filtrar por:'
    end
    object sbutFiltrar: TSpeedButton
      Left = 655
      Top = 18
      Width = 27
      Height = 24
      Hint = 'Pesquisar registros'
      Anchors = [akRight, akBottom]
      Glyph.Data = {
        36050000424D3605000000000000360400002800000010000000100000000100
        08000000000000010000120B0000120B000000010000070000004D4D4D00A6A6
        4D000000FF00FFFFFF00A64D4D00D3D3D300A6A6A60000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000020200020202
        0202020202020202020202020000020000000000000000000000000000000006
        0503050305030503050000000000000003050305030000000300000000000000
        0503050305000300050000000000000603000000030000000300020200000200
        0503050305030503050002020002020003050305030000000300020202020000
        0003050305000300050002020202000100000000030000000300020202020005
        0003050305030503050002020202000500040404040404040404020202000505
        0100040404040404040402020005050505010002020202020202020001030305
        0505010002020202020200000000000000000000000202020202}
      ParentShowHint = False
      ShowHint = True
      OnClick = sbutFiltrarClick
      ExplicitLeft = 639
    end
    object sbutLimparFiltro: TSpeedButton
      Left = 680
      Top = 18
      Width = 27
      Height = 24
      Hint = 'Limpar todos os filtros'
      Anchors = [akRight, akBottom]
      Glyph.Data = {
        E6040000424DE604000000000000360000002800000014000000140000000100
        180000000000B0040000120B0000120B000000000000000000000000FF0000FF
        0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000
        FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF00
        00FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF
        0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000
        FF0000FF0000FFA6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6
        A6A6A6A6A6A6A6A60000FF0000FF0000FF0000FF0000FFA64D4D0000FF0000FF
        0000FFA6A6A6FFFFFFFFFFFFFFFFFFFFFFFFD3D3D3FFFFFFFFFFFFFFFFFFFFFF
        FFA6A6A60000FF0000FF0000FF0000FFA64E4EA64D4DA64D4D0000FF0000FFA6
        A6A6FFFFFFFFFFFFFFFFFFFFFFFFD3D3D3FFFFFFFFFFFFFFFFFFFFFFFFA6A6A6
        0000FF0000FF0000FFA64D4DA64D4DA64D4DA64D4DA64D4D0000FFA6A6A6FFFF
        FFFFFFFFFFFFFFFFFFFFD3D3D3FFFFFFFFFFFFFFFFFFFFFFFFA6A6A60000FF00
        00FF0000FF0000FF0000FFA64D4D0000FF0000FF0000FFA6A6A6FFFFFFFFFFFF
        FFFFFFFFFFFFD3D3D3FFFFFFFFFFFFFFFFFFFFFFFFA6A6A60000FF0000FF0000
        FF0000FF0000FFA64D4D0000FF0000FF0000FFA6A6A6A6A6A6A6A6A6A6A6A6A6
        A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A60000FF0000FF0000FF0000FF
        0000FFA64D4D0000FF0000FF4D4D4D4D4D4D4D4D4D4D4D4DCACACACACACAA6A6
        A6CACACACACACACACACACACACAA6A6A60000FF0000FF0000FF0000FF0000FFA6
        4D4D0000FF0000FF4D4D4DA6A64DA6A64D4D4D4DCACACACACACAA6A6A6CACACA
        CACACACACACACACACAA6A6A60000FF0000FF0000FF0000FF0000FFA64D4D0000
        FF0000FF4D4D4DA6A64DA6A64D4D4D4DCACACACACACAA6A6A6CACACACACACACA
        CACACACACAA6A6A60000FF0000FF0000FF0000FF0000FFA64D4D0000FF0000FF
        4D4D4DFFFFFFD3D3D34D4D4DCACACACACACAA6A6A6CACACACACACACACACACACA
        CAA6A6A60000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF4D4D4DFF
        FFFFD3D3D34D4D4DA6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6
        0000FF0000FF0000FF0000FF0000FF0000FF0000FF4D4D4DD3D3D3D3D3D3D3D3
        D3A6A64D4D4D4D0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF00
        00FF0000FF0000FF0000FF0000FF4D4D4DA6A64DD3D3D3D3D3D3D3D3D3A6A64D
        A6A64D4D4D4D0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000
        FF0000FF0000FF4D4D4DA6A64DD3D3D3FFFFFFD3D3D3D3D3D3D3D3D3A6A64DA6
        A64D4D4D4D0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF
        4D4D4DA6A64DD3D3D3FFFFFFD3D3D3D3D3D3D3D3D3D3D3D3D3D3D3A6A64DA6A6
        4D4D4D4D0000FF0000FF0000FF0000FF0000FF0000FF0000FF4D4D4DA6A64DD3
        D3D3FFFFFFFFFFFFFFFFFFD3D3D3D3D3D3D3D3D3D3D3D3A6A64DA6A64DA6A64D
        4D4D4D0000FF0000FF0000FF0000FF0000FF0000FF4D4D4D4D4D4D4D4D4D4D4D
        4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D00
        00FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF
        0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000
        FF0000FF0000FF0000FF}
      ParentShowHint = False
      ShowHint = True
      OnClick = sbutLimparFiltroClick
      ExplicitLeft = 650
    end
    object combCampos: TComboBox
      Left = 64
      Top = 20
      Width = 145
      Height = 21
      TabOrder = 0
      Text = 'combCampos'
    end
    object combCondicao: TComboBox
      Left = 215
      Top = 20
      Width = 122
      Height = 21
      ItemIndex = 0
      TabOrder = 1
      Text = 'Iniciado por'
      Items.Strings = (
        'Iniciado por'
        'Igual a'
        'Maior ou igual a'
        'Menor ou igual a'
        'Maior que'
        'Menor que'
        'Diferente de')
    end
    object editFiltro: TEdit
      Left = 343
      Top = 20
      Width = 310
      Height = 21
      Anchors = [akLeft, akTop, akRight, akBottom]
      TabOrder = 2
    end
  end
  object grdPesquisa: TDBGrid
    Left = 0
    Top = 52
    Width = 710
    Height = 323
    Align = alClient
    DataSource = dsoPesquisa
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    OnDblClick = grdPesquisaDblClick
    OnKeyDown = grdPesquisaKeyDown
  end
  object dsoPesquisa: TDataSource
    Left = 448
    Top = 96
  end
end