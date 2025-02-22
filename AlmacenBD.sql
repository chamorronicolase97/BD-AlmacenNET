USE [master]
GO
/****** Object:  Database [Almacen]    Script Date: 12/11/2024 01:02:26 ******/
CREATE DATABASE [Almacen]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Almacen_Data', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS01\MSSQL\DATA\Almacen.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'Almacen_Log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS01\MSSQL\DATA\Almacen.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [Almacen] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Almacen].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Almacen] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Almacen] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Almacen] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Almacen] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Almacen] SET ARITHABORT OFF 
GO
ALTER DATABASE [Almacen] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Almacen] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Almacen] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Almacen] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Almacen] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Almacen] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Almacen] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Almacen] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Almacen] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Almacen] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Almacen] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Almacen] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Almacen] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Almacen] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Almacen] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Almacen] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Almacen] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Almacen] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [Almacen] SET  MULTI_USER 
GO
ALTER DATABASE [Almacen] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Almacen] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Almacen] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Almacen] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Almacen] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [Almacen] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [Almacen] SET QUERY_STORE = OFF
GO
USE [Almacen]
GO
/****** Object:  UserDefinedFunction [dbo].[PrecioVenta]    Script Date: 12/11/2024 01:02:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[PrecioVenta](@ProductoID int)
RETURNS int
AS
-- Returns the stock level for the product.
BEGIN
    DECLARE @ret int;
    SELECT @ret = (Costo + ((Costo * Utilidad)/ 100))  from Productos
inner join Categorias on Categorias.CategoriaID = Productos.CategoriaID
where ProductoID = @ProductoID
     IF (@ret IS NULL)
        SET @ret = 0;
    RETURN @ret;
END;
GO
/****** Object:  Table [dbo].[Categorias]    Script Date: 12/11/2024 01:02:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Categorias](
	[CategoriaID] [int] IDENTITY(1,1) NOT NULL,
	[Descripcion] [varchar](50) NOT NULL,
	[Utilidad] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_Categorias] PRIMARY KEY CLUSTERED 
(
	[CategoriaID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Clientes]    Script Date: 12/11/2024 01:02:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Clientes](
	[ClienteID] [int] IDENTITY(1,1) NOT NULL,
	[Denominacion] [varchar](100) NOT NULL,
	[CUIT] [varchar](20) NOT NULL,
	[Domicilio] [varchar](100) NOT NULL,
	[Telefono] [varchar](20) NOT NULL,
	[Email] [varchar](100) NOT NULL,
	[Empleado] [bit] NOT NULL,
	[Preferencial] [bit] NOT NULL,
	[Usuario] [varchar](50) NOT NULL,
	[Contraseña] [varchar](256) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DetallesPedidos]    Script Date: 12/11/2024 01:02:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DetallesPedidos](
	[PedidoID] [int] NOT NULL,
	[ProductoID] [int] NOT NULL,
	[Cantidad] [int] NOT NULL,
	[CostoUnitario] [decimal](12, 2) NOT NULL,
 CONSTRAINT [PK_DetallesPedidos_1] PRIMARY KEY CLUSTERED 
(
	[PedidoID] ASC,
	[ProductoID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DetallesRecepciones]    Script Date: 12/11/2024 01:02:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DetallesRecepciones](
	[ProductoID] [int] NOT NULL,
	[RecepcionID] [int] NOT NULL,
	[Cantidad] [int] NOT NULL,
	[CostoUnitario] [decimal](12, 2) NOT NULL,
	[FechaRecepcion] [datetime] NOT NULL,
 CONSTRAINT [PK_DetallesRecepciones] PRIMARY KEY CLUSTERED 
(
	[ProductoID] ASC,
	[RecepcionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Grupos]    Script Date: 12/11/2024 01:02:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Grupos](
	[GrupoID] [int] IDENTITY(1,1) NOT NULL,
	[Descripcion] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Grupos] PRIMARY KEY CLUSTERED 
(
	[GrupoID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Pedidos]    Script Date: 12/11/2024 01:02:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Pedidos](
	[PedidoID] [int] IDENTITY(2,1) NOT NULL,
	[FechaEntrega] [datetime] NOT NULL,
	[ProveedorID] [int] NOT NULL,
	[PedidoEstadoID] [int] NULL,
 CONSTRAINT [PK_Pedidos] PRIMARY KEY CLUSTERED 
(
	[PedidoID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PedidosEstados]    Script Date: 12/11/2024 01:02:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PedidosEstados](
	[PedidoEstadoID] [int] IDENTITY(1,1) NOT NULL,
	[Descripcion] [varchar](50) NULL,
 CONSTRAINT [PK_PedidosEstados] PRIMARY KEY CLUSTERED 
(
	[PedidoEstadoID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Permisos]    Script Date: 12/11/2024 01:02:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Permisos](
	[PermisoID] [int] IDENTITY(1,1) NOT NULL,
	[CodPermiso] [varchar](50) NOT NULL,
	[Descripcion] [varchar](100) NULL,
 CONSTRAINT [PK_Permisos] PRIMARY KEY CLUSTERED 
(
	[PermisoID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PermisosGrupos]    Script Date: 12/11/2024 01:02:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PermisosGrupos](
	[PermisoGrupoID] [int] IDENTITY(1,1) NOT NULL,
	[PermisoID] [int] NOT NULL,
	[GrupoID] [int] NOT NULL,
 CONSTRAINT [PK_PermisosGrupos] PRIMARY KEY CLUSTERED 
(
	[PermisoGrupoID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Productos]    Script Date: 12/11/2024 01:02:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Productos](
	[ProductoID] [int] IDENTITY(1,1) NOT NULL,
	[Descripcion] [varchar](50) NOT NULL,
	[Costo] [decimal](13, 2) NULL,
	[CodigoDeBarra] [varchar](50) NULL,
	[CategoriaID] [int] NOT NULL,
	[ProveedorID] [int] NOT NULL,
	[Stock] [int] NULL,
 CONSTRAINT [PK_Productos] PRIMARY KEY CLUSTERED 
(
	[ProductoID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Proveedores]    Script Date: 12/11/2024 01:02:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Proveedores](
	[ProveedorID] [int] IDENTITY(1,1) NOT NULL,
	[CUIT] [varchar](20) NOT NULL,
	[RazonSocial] [varchar](50) NOT NULL,
	[Direccion] [varchar](100) NULL,
	[Mail] [varchar](50) NULL,
	[Telefono] [varchar](20) NULL,
 CONSTRAINT [PK_Proveedores] PRIMARY KEY CLUSTERED 
(
	[ProveedorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Recepciones]    Script Date: 12/11/2024 01:02:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Recepciones](
	[RecepcionID] [int] IDENTITY(1,1) NOT NULL,
	[PedidoID] [int] NOT NULL,
	[FechaEntrega] [datetime] NOT NULL,
	[EstadoID] [int] NULL,
 CONSTRAINT [PK_Recepciones] PRIMARY KEY CLUSTERED 
(
	[RecepcionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Usuarios]    Script Date: 12/11/2024 01:02:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Usuarios](
	[UsuarioID] [int] IDENTITY(1,1) NOT NULL,
	[NombreApellido] [varchar](100) NOT NULL,
	[CodUsuario] [varchar](20) NOT NULL,
	[Contraseña] [varchar](256) NOT NULL,
	[GrupoID] [int] NOT NULL,
 CONSTRAINT [PK_Usuario] PRIMARY KEY CLUSTERED 
(
	[UsuarioID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ventas]    Script Date: 12/11/2024 01:02:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ventas](
	[VentaID] [int] IDENTITY(1,1) NOT NULL,
	[ClienteID] [int] NOT NULL,
	[ProductoID] [int] NOT NULL,
	[Fecha] [datetime] NOT NULL,
	[Cantidad] [int] NOT NULL,
	[Importe] [decimal](18, 2) NULL,
 CONSTRAINT [PK_Venta] PRIMARY KEY CLUSTERED 
(
	[VentaID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_CodUsuario]    Script Date: 12/11/2024 01:02:26 ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_CodUsuario] ON [dbo].[Usuarios]
(
	[CodUsuario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Categorias]  WITH CHECK ADD  CONSTRAINT [FK_Categorias_Categorias] FOREIGN KEY([CategoriaID])
REFERENCES [dbo].[Categorias] ([CategoriaID])
GO
ALTER TABLE [dbo].[Categorias] CHECK CONSTRAINT [FK_Categorias_Categorias]
GO
ALTER TABLE [dbo].[DetallesRecepciones]  WITH CHECK ADD  CONSTRAINT [FK_DetallesRecepciones_Recepciones] FOREIGN KEY([RecepcionID])
REFERENCES [dbo].[Recepciones] ([RecepcionID])
GO
ALTER TABLE [dbo].[DetallesRecepciones] CHECK CONSTRAINT [FK_DetallesRecepciones_Recepciones]
GO
ALTER TABLE [dbo].[Pedidos]  WITH CHECK ADD  CONSTRAINT [FK_Pedidos_Estados] FOREIGN KEY([PedidoEstadoID])
REFERENCES [dbo].[PedidosEstados] ([PedidoEstadoID])
GO
ALTER TABLE [dbo].[Pedidos] CHECK CONSTRAINT [FK_Pedidos_Estados]
GO
ALTER TABLE [dbo].[PermisosGrupos]  WITH CHECK ADD  CONSTRAINT [FK_PermisosGrupos_Grupos] FOREIGN KEY([GrupoID])
REFERENCES [dbo].[Grupos] ([GrupoID])
GO
ALTER TABLE [dbo].[PermisosGrupos] CHECK CONSTRAINT [FK_PermisosGrupos_Grupos]
GO
ALTER TABLE [dbo].[Productos]  WITH CHECK ADD  CONSTRAINT [FK_Categorias_Productos] FOREIGN KEY([CategoriaID])
REFERENCES [dbo].[Categorias] ([CategoriaID])
GO
ALTER TABLE [dbo].[Productos] CHECK CONSTRAINT [FK_Categorias_Productos]
GO
ALTER TABLE [dbo].[Productos]  WITH CHECK ADD  CONSTRAINT [FK_Proveedores_Productos] FOREIGN KEY([ProveedorID])
REFERENCES [dbo].[Proveedores] ([ProveedorID])
GO
ALTER TABLE [dbo].[Productos] CHECK CONSTRAINT [FK_Proveedores_Productos]
GO
ALTER TABLE [dbo].[Recepciones]  WITH NOCHECK ADD  CONSTRAINT [FK_PEDIDOS_RECEPCIONES] FOREIGN KEY([PedidoID])
REFERENCES [dbo].[Pedidos] ([PedidoID])
GO
ALTER TABLE [dbo].[Recepciones] NOCHECK CONSTRAINT [FK_PEDIDOS_RECEPCIONES]
GO
ALTER TABLE [dbo].[Recepciones]  WITH CHECK ADD  CONSTRAINT [FK_Recepciones_Estados] FOREIGN KEY([EstadoID])
REFERENCES [dbo].[PedidosEstados] ([PedidoEstadoID])
GO
ALTER TABLE [dbo].[Recepciones] CHECK CONSTRAINT [FK_Recepciones_Estados]
GO
USE [master]
GO
ALTER DATABASE [Almacen] SET  READ_WRITE 
GO
