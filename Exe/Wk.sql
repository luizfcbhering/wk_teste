drop table if exists pedidositens;
CREATE TABLE pedidositens (
	codigo int not null primary key auto_increment,
    codigo_ped int not null,
    codigo_prod int not null,
    qtd_produto int not null,
    val_produto decimal(17,2),
	val_total decimal(17,2)    
);

drop table if exists pedidos;
CREATE TABLE pedidos (
	codigo int not null primary key,
    codigo_cli int not null,
    dat_pedido date not null,
    val_pedido decimal(17,2)
);

drop table if exists clientes;
CREATE TABLE clientes (
	codigo int not null primary key auto_increment,
    nome varchar(50) not null,
    cidade varchar(50),
    uf varchar(2)
);
INSERT INTO `clientes` VALUES (1,'CLIENTE 1','BELO HORIZONTE','MG'),(2,'CLIENTE 2','BELO HORIZONTE','MG'),(3,'CLIENTE 3','CONTAGEM','MG'),(4,'CLIENTE 4','BETIM','MG'),(5,'CLIENTE 5','SANTA LUZIA','MG'),(6,'CLIENTE 6','SABARA','MG'),(7,'CLIENTE 7','SETE LAGOAS','MG'),(8,'CLIENTE 8','SÃO JOÃO DEL REI','MG'),(9,'CLIENTE 9','TIRADENTES','MG'),(10,'CLIENTE 10','BELO HORIZONTE','MG'),(11,'CLIENTE 11','CONTAGEM','MG'),(12,'CLIENTE 12','BETIM','MG'),(13,'CLIENTE 13','SANTA LUZIA','MG'),(14,'CLIENTE 14','SABARA','MG'),(15,'CLIENTE 15','SETE LAGOAS','MG'),(16,'CLIENTE 16','SÃO JOÃO DEL REI','MG'),(17,'CLIENTE 17','TIRADENTES','MG'),(18,'CLIENTE 18','SÃO PAULO','SP'),(19,'CLIENTE 19','FLORIANOPOLIS','SC'),(20,'CLIENTE 20','CURITIBA','PR');

drop table if exists produtos;
CREATE TABLE produtos (
	codigo int not null primary key auto_increment,
    descricao varchar(50) not null,
    val_venda decimal(17,2)
);
INSERT INTO `produtos` VALUES (1,'PRODUTO 1',1.56),(2,'PRODUTO 2',7.96),(3,'PRODUTO 3',0.89),(4,'PRODUTO 4',5.69),(5,'PRODUTO 5',4.98),(6,'PRODUTO 6',1.00),(7,'PRODUTO 7',7.56),(8,'PRODUTO 8',1.55),(9,'PRODUTO 9',1.22),(10,'PRODUTO 10',9.89),(11,'PRODUTO 11',3.87),(12,'PRODUTO 12',11.56),(13,'PRODUTO 13',12.37),(14,'PRODUTO 14',21.51),(15,'PRODUTO 15',13.56),(16,'PRODUTO 16',15.60),(17,'PRODUTO 17',2.56),(18,'PRODUTO 18',4.77),(19,'PRODUTO 19',6.88),(20,'PRODUTO 20',8.99);

ALTER TABLE pedidos ADD INDEX fk_pedidos_clientes_idx (codigo_cli ASC);
ALTER TABLE pedidos ADD CONSTRAINT fk_pedidos_clientes FOREIGN KEY (codigo_cli) REFERENCES clientes (codigo) ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE pedidositens ADD INDEX fk_pedidositens_produto_idx (codigo_prod ASC);
ALTER TABLE pedidositens ADD CONSTRAINT fk_pedidositens_produto FOREIGN KEY (codigo_prod) REFERENCES produtos (codigo) ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE pedidositens ADD INDEX fk_pedidositens_pedidos_idx (codigo_ped ASC);
ALTER TABLE pedidositens ADD CONSTRAINT fk_pedidositens_pedidos FOREIGN KEY (codigo_ped) REFERENCES pedidos (codigo) ON DELETE CASCADE ON UPDATE CASCADE;

drop user if exists wk;
CREATE USER wk IDENTIFIED BY 'wk@1q2w3e';
GRANT ALL ON wk_teste.* TO wk WITH GRANT OPTION;
