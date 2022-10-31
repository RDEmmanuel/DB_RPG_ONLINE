CREATE DATABASE DB_rpg_online
USE DB_rpg_online

CREATE SCHEMA juego
CREATE SCHEMA objeto
CREATE SCHEMA usuario

CREATE TABLE juego.clases(
	id_clase INT IDENTITY NOT NULL,
	nombre_clase VARCHAR(20) NOT NULL,

	CONSTRAINT PK_clases PRIMARY KEY (id_clase)
)
GO

CREATE TABLE juego.mapas(
	id_mapa INT IDENTITY NOT NULL,
	nombre_mapa VARCHAR(20) NOT NULL,
	tamaño_x INT NOT NULL,
	tamaño_y INT NOT NULL,

	CONSTRAINT PK_mapas PRIMARY KEY (id_mapa)
)
GO

CREATE TABLE juego.npcs_tipos(
	id_tipo INT IDENTITY NOT NULL,
	nombre_tipo VARCHAR(20) NOT NULL,

	CONSTRAINT PK_npcs_tipos PRIMARY KEY (id_tipo)
)
GO

CREATE TABLE juego.tiendas(
	id_tienda INT IDENTITY NOT NULL,
	nombre_tienda VARCHAR(40) NOT NULL,
	cant_slots INT NOT NULL,

	CONSTRAINT PK_tiendas PRIMARY KEY (id_tienda)
)
GO

CREATE TABLE objeto.categorias(
	id_categoria INT IDENTITY NOT NULL,
	titulo_categoria VARCHAR(20) NOT NULL,
	descripcion VARCHAR(100) NOT NULL,

	CONSTRAINT PK_categorias PRIMARY KEY (id_categoria)
)
GO

CREATE TABLE usuario.inventarios(
	id_inventario INT IDENTITY NOT NULL,
	cant_slots INT NOT NULL,

	CONSTRAINT PK_inventarios PRIMARY KEY (id_inventario)
)
GO

CREATE TABLE objeto.items(
	id_item INT IDENTITY NOT NULL,
	id_categoria INT NOT NULL,
	nombre VARCHAR(30) NOT NULL,
	fuerza INT NOT NULL,
	agilidad INT NOT NULL,
	magia INT NOT NULL,
	req_fuerza INT NOT NULL,
	req_agilidad INT NOT NULL,
	req_magia INT NOT NULL,
	req_clase INT NOT NULL,
	req_nivel INT NOT NULL,
	poder_defensa INT NOT NULL,
	poder_ataque INT NOT NULL,
	poder_magico INT NOT NULL,
	descripcion VARCHAR(20) NOT NULL,

	CONSTRAINT PK_items PRIMARY KEY (id_item),
	CONSTRAINT FK_items_categorias FOREIGN KEY (id_categoria) REFERENCES objeto.categorias(id_categoria)

)
GO

CREATE TABLE juego.npcs(
	id_npc INT IDENTITY NOT NULL,
	id_tipo INT NOT NULL,
	nombre_npc VARCHAR(30) NOT NULL,
	vida INT NOT NULL,
	nivel INT NOT NULL,
	experiencia INT NOT NULL,
	fuerza INT NOT NULL,
	agilidad INT NOT NULL,
	magia INT NOT NULL,
	estatico BIT NOT NULL,

	CONSTRAINT PK_npcs PRIMARY KEY (id_npc),
	CONSTRAINT FK_npcs_npcs_tipos FOREIGN KEY (id_tipo) REFERENCES juego.npcs_tipos(id_tipo)
)
GO

CREATE TABLE usuario.cuentas(
	id_usuario INT IDENTITY NOT NULL,
	nombre_usuario VARCHAR(50) NOT NULL,
	contra VARCHAR(50) NOT NULL,
	ip_usuario VARCHAR(100) NOT NULL,

	CONSTRAINT PK_cuentas PRIMARY KEY (id_usuario),
	CONSTRAINT UQ_cuentas_nombre_usuario UNIQUE (nombre_usuario)
)
GO

CREATE TABLE usuario.personajes(
	id_usuario INT NOT NULL,
	id_personaje INT IDENTITY NOT NULL,
	nombre_personaje VARCHAR(50) NOT NULL,
	id_clase INT NOT NULL,
	id_inventario INT NOT NULL,
	vida FLOAT NOT NULL,
	mana FLOAT NOT NULL,
	nivel INT NOT NULL,
	experiencia FLOAT NOT NULL,
	fuerza INT NOT NULL,
	agilidad INT NOT NULL,
	magia INT NOT NULL,
	oro INT NOT NULL,
	
	CONSTRAINT PK_personajes PRIMARY KEY (id_usuario,id_personaje),
	CONSTRAINT UQ_personajes_nombre_personaje UNIQUE (nombre_personaje),
	CONSTRAINT FK_personajes_cuentas FOREIGN KEY (id_usuario) REFERENCES usuario.cuentas(id_usuario),
	CONSTRAINT FK_personajes_clases FOREIGN KEY (id_clase) REFERENCES juego.clases(id_clase),
	CONSTRAINT FK_personajes_inventarios FOREIGN KEY (id_inventario) REFERENCES usuario.inventarios(id_inventario)
)
GO

CREATE TABLE juego.mapas_personajes(
	id_usuario INT NOT NULL,
	id_personaje INT NOT NULL,
	id_mapa INT NOT NULL,
	coord_x INT NOT NULL,
	coord_y INT NOT NULL,

	CONSTRAINT PK_mapas_personajes PRIMARY KEY (id_usuario, id_personaje, id_mapa),
	CONSTRAINT FK_mapas_personajes_personajes FOREIGN KEY (id_usuario, id_personaje) REFERENCES usuario.personajes(id_usuario, id_personaje),
	CONSTRAINT FK_mapas_personajes_mapas FOREIGN KEY (id_mapa) REFERENCES juego.mapas(id_mapa)
)
GO

CREATE TABLE juego.mapas_npcs(
	id_mapa INT IDENTITY NOT NULL,
	id_npc INT NOT NULL,
	coord_x INT NOT NULL,
	coord_y INT NOT NULL,
	
	CONSTRAINT PK_mapas_npcs PRIMARY KEY (id_mapa, id_npc),
	CONSTRAINT FK_mapas_npcs_mapas FOREIGN KEY (id_mapa) REFERENCES juego.mapas(id_mapa),
	CONSTRAINT FK_mapas_npcs_npcs FOREIGN KEY (id_npc) REFERENCES juego.npcs(id_npc)
)
GO

CREATE TABLE juego.tiendas_items(
	id_tienda INT NOT NULL,
	id_item INT NOT NULL,
	precio FLOAT NOT NULL,
	cantidad INT NOT NULL,
	
	CONSTRAINT PK_tiendas_items PRIMARY KEY (id_tienda, id_item),
	CONSTRAINT FK_tiendas_items_tiendas FOREIGN KEY (id_tienda) REFERENCES juego.tiendas(id_tienda),
	CONSTRAINT FK_tiendas_items_items FOREIGN KEY (id_item) REFERENCES objeto.items(id_item)
)
GO

CREATE TABLE juego.inventarios_items(
	id_inventario INT NOT NULL,
	id_item INT NOT NULL,
	slot INT NOT NULL,
	cantidad INT NOT NULL,
	
	CONSTRAINT PK_inventarios_items PRIMARY KEY (id_inventario, id_item),
	CONSTRAINT FK_inventarios_items_inventarios FOREIGN KEY (id_inventario) REFERENCES usuario.inventarios(id_inventario),
	CONSTRAINT FK_inventarios_items_items FOREIGN KEY (id_item) REFERENCES objeto.items(id_item)
)
GO

ALTER TABLE juego.clases 
	ADD CONSTRAINT UQ_clases_nombre_clase UNIQUE (nombre_clase)

ALTER TABLE juego.mapas
	ADD CONSTRAINT UQ_mapas_nombe_mapa UNIQUE (nombre_mapa)

ALTER TABLE juego.npcs_tipos
	ADD CONSTRAINT UQ_npcs_tipos_nombre_tipo UNIQUE (nombre_tipo)

ALTER TABLE objeto.items
	ADD CONSTRAINT UQ_items_nombre UNIQUE (nombre)

ALTER TABLE objeto.categorias
	ADD CONSTRAINT UQ_categorias_titulo_categoria UNIQUE (titulo_categoria)

ALTER TABLE juego.tiendas_items
	ALTER COLUMN precio INT NOT NULL


