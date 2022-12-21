object ModelPesquisa: TModelPesquisa
  OldCreateOrder = False
  Height = 158
  Width = 324
  object qryProdutos: TFDQuery
    Connection = ModelDados.conWK
    SQL.Strings = (
      'SELECT * FROM produtos')
    Left = 56
    Top = 40
    object qryProdutoscodigo: TFDAutoIncField
      Tag = 1
      DisplayLabel = 'C'#243'digo'
      FieldName = 'codigo'
      Origin = 'codigo'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object qryProdutosdescricao: TStringField
      Tag = 1
      DisplayLabel = 'Produto'
      FieldName = 'descricao'
      Origin = 'descricao'
      Required = True
      Size = 50
    end
    object qryProdutosval_venda: TFMTBCDField
      AutoGenerateValue = arDefault
      FieldName = 'val_venda'
      Origin = 'val_venda'
      Precision = 17
      Size = 2
    end
  end
  object qryPessoas: TFDQuery
    Connection = ModelDados.conWK
    SQL.Strings = (
      'SELECT * FROM clientes')
    Left = 144
    Top = 40
    object qryPessoascodigo: TFDAutoIncField
      Tag = 1
      DisplayLabel = 'C'#243'digo'
      FieldName = 'codigo'
      Origin = 'codigo'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object qryPessoasnome: TStringField
      Tag = 1
      DisplayLabel = 'Nome'
      FieldName = 'nome'
      Origin = 'nome'
      Required = True
      Size = 50
    end
    object qryPessoascidade: TStringField
      Tag = 1
      AutoGenerateValue = arDefault
      DisplayLabel = 'Cidade'
      FieldName = 'cidade'
      Origin = 'cidade'
      Size = 50
    end
    object qryPessoasuf: TStringField
      Tag = 1
      AutoGenerateValue = arDefault
      DisplayLabel = 'UF'
      DisplayWidth = 4
      FieldName = 'uf'
      Origin = 'uf'
      Size = 2
    end
  end
end
