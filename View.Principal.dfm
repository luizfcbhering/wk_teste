object fPrincipal: TfPrincipal
  Left = 0
  Top = 0
  Caption = 'PDV - WK'
  ClientHeight = 425
  ClientWidth = 711
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object grdProdutos: TDBGrid
    Left = 0
    Top = 131
    Width = 711
    Height = 219
    Align = alClient
    DataSource = dsItensPedidos
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    OnKeyDown = grdProdutosKeyDown
    Columns = <
      item
        Expanded = False
        FieldName = 'codigo_prod'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'descricao'
        Width = 315
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'qtd_produto'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'val_produto'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'val_total'
        Visible = True
      end>
  end
  object pnlCabecalho: TPanel
    Left = 0
    Top = 0
    Width = 711
    Height = 66
    Align = alTop
    TabOrder = 0
    object lblCliente: TLabel
      Left = 8
      Top = 15
      Width = 299
      Height = 13
      Caption = 'Cliente: (Digite o c'#243'digo ou nome ou F3 Pesquisar e F4 Limpar)'
    end
    object edtCodigoCliente: TEdit
      Left = 7
      Top = 34
      Width = 46
      Height = 21
      TabOrder = 0
      OnChange = edtCodigoClienteChange
      OnKeyDown = edtCodigoClienteKeyDown
    end
    object edtNomeCliente: TEdit
      Left = 59
      Top = 34
      Width = 350
      Height = 21
      Enabled = False
      TabOrder = 1
      OnKeyDown = edtNomeClienteKeyDown
    end
  end
  object pnlRodape: TPanel
    Left = 0
    Top = 386
    Width = 711
    Height = 39
    Align = alBottom
    TabOrder = 3
    object btnSair: TBitBtn
      Left = 625
      Top = 6
      Width = 75
      Height = 25
      Caption = 'Sair'
      TabOrder = 3
      OnClick = btnSairClick
    end
    object btnGravarPedido: TBitBtn
      Left = 0
      Top = 6
      Width = 115
      Height = 25
      Caption = 'Gravar Pedido (F6)'
      TabOrder = 0
      OnClick = btnGravarPedidoClick
    end
    object btnPesquisar: TBitBtn
      Left = 121
      Top = 6
      Width = 115
      Height = 25
      Caption = 'Localizar Pedido (F7)'
      TabOrder = 1
      OnClick = btnPesquisarClick
    end
    object btnCancelar: TBitBtn
      Left = 240
      Top = 6
      Width = 115
      Height = 25
      Caption = 'Cancelar Pedido (F8)'
      TabOrder = 2
      OnClick = btnCancelarClick
    end
  end
  object pnlDados: TPanel
    Left = 0
    Top = 66
    Width = 711
    Height = 65
    Align = alTop
    Enabled = False
    TabOrder = 1
    object lblProduto: TLabel
      Left = 8
      Top = 10
      Width = 260
      Height = 13
      Caption = 'Produto: (Digite o c'#243'digo ou F3 Pesquisar e F4 Limpar)'
    end
    object lblQtd: TLabel
      Left = 424
      Top = 10
      Width = 18
      Height = 13
      Caption = 'Qtd'
    end
    object lblValUnitario: TLabel
      Left = 476
      Top = 10
      Width = 58
      Height = 13
      Caption = 'Val. Unit'#225'rio'
    end
    object lblValTotal: TLabel
      Left = 555
      Top = 10
      Width = 45
      Height = 13
      Caption = 'Val. Total'
    end
    object btnGravarItem: TBitBtn
      Left = 631
      Top = 27
      Width = 69
      Height = 25
      Caption = 'Gravar'
      NumGlyphs = 2
      TabOrder = 4
      OnClick = btnGravarItemClick
    end
    object edtCodProduto: TEdit
      Left = 8
      Top = 29
      Width = 46
      Height = 21
      TabOrder = 0
      OnKeyDown = edtCodProdutoKeyDown
    end
    object edtNomeProduto: TEdit
      Left = 60
      Top = 29
      Width = 350
      Height = 21
      Color = clBtnFace
      Enabled = False
      TabOrder = 1
    end
    object edtQtd: TEdit
      Left = 424
      Top = 29
      Width = 46
      Height = 21
      TabOrder = 2
      OnExit = edtQtdExit
      OnKeyDown = edtQtdKeyDown
    end
    object edtValUnitario: TEdit
      Left = 476
      Top = 29
      Width = 70
      Height = 21
      Color = clBtnFace
      Enabled = False
      TabOrder = 3
      OnChange = edtCodigoClienteChange
      OnKeyDown = edtCodigoClienteKeyDown
    end
    object edtValTotal: TEdit
      Left = 555
      Top = 29
      Width = 70
      Height = 21
      Color = clBtnFace
      Enabled = False
      TabOrder = 5
      OnChange = edtCodigoClienteChange
      OnKeyDown = edtCodigoClienteKeyDown
    end
  end
  object pnlTotal: TPanel
    Left = 0
    Top = 350
    Width = 711
    Height = 36
    Align = alBottom
    TabOrder = 4
    object lblTotalPedido: TLabel
      Left = 376
      Top = 6
      Width = 324
      Height = 23
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Total: R$ 0,00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 8567170
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
  end
  object mtPedidos: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 576
    Top = 161
    object mtPedidoscodigo: TIntegerField
      FieldName = 'codigo'
      Origin = 'codigo'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object mtPedidoscodigo_cli: TIntegerField
      FieldName = 'codigo_cli'
      Origin = 'codigo_cli'
      Required = True
    end
    object mtPedidosdat_pedido: TDateField
      FieldName = 'dat_pedido'
      Origin = 'dat_pedido'
      Required = True
    end
    object mtPedidosval_pedido: TFMTBCDField
      AutoGenerateValue = arDefault
      FieldName = 'val_pedido'
      Origin = 'val_pedido'
      Precision = 17
      Size = 2
    end
    object mtPedidosnome: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'nome'
      Origin = 'nome'
      ProviderFlags = []
      Size = 50
    end
    object mtPedidoscidade: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'cidade'
      Origin = 'cidade'
      ProviderFlags = []
      Size = 50
    end
    object mtPedidosuf: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'uf'
      Origin = 'uf'
      ProviderFlags = []
      Size = 2
    end
  end
  object mtItensPedidos: TFDMemTable
    IndexFieldNames = 'codigo_ped'
    MasterSource = dsPedidos
    MasterFields = 'codigo'
    DetailFields = 'codigo_ped'
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 576
    Top = 209
    object mtItensPedidoscodigo: TFDAutoIncField
      FieldName = 'codigo'
      Origin = 'codigo'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object mtItensPedidoscodigo_ped: TIntegerField
      FieldName = 'codigo_ped'
      Origin = 'codigo_ped'
      Required = True
    end
    object mtItensPedidoscodigo_prod: TIntegerField
      DisplayLabel = 'C'#243'digo'
      FieldName = 'codigo_prod'
      Origin = 'codigo_prod'
      Required = True
    end
    object mtItensPedidosqtd_produto: TIntegerField
      DisplayLabel = 'Qtd'
      FieldName = 'qtd_produto'
      Origin = 'qtd_produto'
      Required = True
    end
    object mtItensPedidosval_produto: TFMTBCDField
      AutoGenerateValue = arDefault
      DisplayLabel = 'Val. Unit'#225'rio'
      FieldName = 'val_produto'
      Origin = 'val_produto'
      currency = True
      Precision = 17
      Size = 2
    end
    object mtItensPedidosval_total: TFMTBCDField
      AutoGenerateValue = arDefault
      DisplayLabel = 'Val. Total'
      FieldName = 'val_total'
      Origin = 'val_total'
      currency = True
      Precision = 17
      Size = 2
    end
    object mtItensPedidosdescricao: TStringField
      AutoGenerateValue = arDefault
      DisplayLabel = 'Descri'#231#227'o'
      FieldName = 'descricao'
      Origin = 'descricao'
      ProviderFlags = []
      Size = 50
    end
  end
  object dsPedidos: TDataSource
    DataSet = mtPedidos
    Left = 604
    Top = 161
  end
  object dsItensPedidos: TDataSource
    DataSet = mtItensPedidos
    Left = 604
    Top = 209
  end
end
