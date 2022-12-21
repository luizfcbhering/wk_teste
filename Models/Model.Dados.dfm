object ModelDados: TModelDados
  OldCreateOrder = False
  Height = 211
  Width = 372
  object conWK: TFDConnection
    Params.Strings = (
      'Database=wk_teste'
      'User_Name=wk'
      'Server=localhost'
      'Password=wk@1q2w3e'
      'DriverID=MySQL')
    LoginPrompt = False
    BeforeConnect = conWKBeforeConnect
    Left = 40
    Top = 25
  end
  object linWK: TFDPhysMySQLDriverLink
    Left = 69
    Top = 25
  end
  object qryInc: TFDQuery
    Connection = conWK
    Left = 176
    Top = 25
  end
  object qryAux: TFDQuery
    Connection = conWK
    Left = 232
    Top = 25
  end
  object qryExec: TFDQuery
    Connection = conWK
    Left = 204
    Top = 25
  end
  object qryPedidos: TFDQuery
    Connection = conWK
    UpdateObject = usqlPedidos
    SQL.Strings = (
      'SELECT'
      '    p.*,'
      '    c.nome,'
      '    c.cidade,'
      '    c.uf'
      'FROM pedidos p'
      'JOIN clientes c on c.codigo = p.codigo_cli'
      'WHERE p.codigo =:codigo')
    Left = 56
    Top = 112
    ParamData = <
      item
        Name = 'CODIGO'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
    object qryPedidoscodigo: TIntegerField
      FieldName = 'codigo'
      Origin = 'codigo'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qryPedidoscodigo_cli: TIntegerField
      FieldName = 'codigo_cli'
      Origin = 'codigo_cli'
      Required = True
    end
    object qryPedidosdat_pedido: TDateField
      FieldName = 'dat_pedido'
      Origin = 'dat_pedido'
      Required = True
    end
    object qryPedidosval_pedido: TFMTBCDField
      AutoGenerateValue = arDefault
      FieldName = 'val_pedido'
      Origin = 'val_pedido'
      Precision = 17
      Size = 2
    end
    object qryPedidosnome: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'nome'
      Origin = 'nome'
      ProviderFlags = []
      ReadOnly = True
      Size = 50
    end
    object qryPedidoscidade: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'cidade'
      Origin = 'cidade'
      ProviderFlags = []
      ReadOnly = True
      Size = 50
    end
    object qryPedidosuf: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'uf'
      Origin = 'uf'
      ProviderFlags = []
      ReadOnly = True
      Size = 2
    end
  end
  object qryItensPedido: TFDQuery
    Connection = conWK
    UpdateObject = usqlItensPedido
    SQL.Strings = (
      'SELECT'
      '    pi.*,'
      '    p.descricao'
      'FROM pedidositens pi'
      'JOIN produtos p on p.codigo = pi.codigo_prod'
      'WHERE pi.codigo_ped =:codigo_ped'
      '')
    Left = 184
    Top = 112
    ParamData = <
      item
        Name = 'CODIGO_PED'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
    object qryItensPedidocodigo: TFDAutoIncField
      FieldName = 'codigo'
      Origin = 'codigo'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object qryItensPedidocodigo_ped: TIntegerField
      FieldName = 'codigo_ped'
      Origin = 'codigo_ped'
      Required = True
    end
    object qryItensPedidocodigo_prod: TIntegerField
      FieldName = 'codigo_prod'
      Origin = 'codigo_prod'
      Required = True
    end
    object qryItensPedidoqtd_produto: TIntegerField
      FieldName = 'qtd_produto'
      Origin = 'qtd_produto'
      Required = True
    end
    object qryItensPedidoval_produto: TFMTBCDField
      AutoGenerateValue = arDefault
      FieldName = 'val_produto'
      Origin = 'val_produto'
      Precision = 17
      Size = 2
    end
    object qryItensPedidoval_total: TFMTBCDField
      AutoGenerateValue = arDefault
      FieldName = 'val_total'
      Origin = 'val_total'
      Precision = 17
      Size = 2
    end
    object qryItensPedidodescricao: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'descricao'
      Origin = 'descricao'
      ProviderFlags = []
      ReadOnly = True
      Size = 50
    end
  end
  object usqlPedidos: TFDUpdateSQL
    Connection = conWK
    InsertSQL.Strings = (
      'INSERT INTO pedidos'
      '(codigo, codigo_cli, dat_pedido, val_pedido)'
      
        'VALUES (:new_codigo, :new_codigo_cli, :new_dat_pedido, :new_val_' +
        'pedido)')
    ModifySQL.Strings = (
      'UPDATE pedidos'
      'SET codigo_cli = :new_codigo_cli, dat_pedido = :new_dat_pedido, '
      '  val_pedido = :new_val_pedido'
      'WHERE codigo = :old_codigo')
    DeleteSQL.Strings = (
      'DELETE FROM pedidos'
      'WHERE codigo = :old_codigo')
    FetchRowSQL.Strings = (
      'SELECT codigo, codigo_cli, dat_pedido, val_pedido'
      'FROM pedidos'
      'WHERE codigo = :old_codigo')
    Left = 88
    Top = 112
  end
  object usqlItensPedido: TFDUpdateSQL
    Connection = conWK
    InsertSQL.Strings = (
      'INSERT INTO pedidositens'
      '(codigo_ped, codigo_prod, qtd_produto, val_produto, '
      '  val_total)'
      
        'VALUES (:new_codigo_ped, :new_codigo_prod, :new_qtd_produto, :ne' +
        'w_val_produto, '
      '  :new_val_total)')
    ModifySQL.Strings = (
      'UPDATE pedidositens'
      
        'SET codigo_ped = :new_codigo_ped, codigo_prod = :new_codigo_prod' +
        ', '
      
        '  qtd_produto = :new_qtd_produto, val_produto = :new_val_produto' +
        ', '
      '  val_total = :new_val_total'
      'WHERE codigo = :old_codigo')
    DeleteSQL.Strings = (
      'DELETE FROM pedidositens'
      'WHERE codigo = :old_codigo')
    FetchRowSQL.Strings = (
      
        'SELECT codigo, codigo_ped, codigo_prod, qtd_produto, val_produto' +
        ', val_total'
      'FROM pedidositens'
      'WHERE codigo = :old_codigo')
    Left = 216
    Top = 112
  end
  object qryAux2: TFDQuery
    Connection = conWK
    Left = 260
    Top = 25
  end
end
