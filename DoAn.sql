USE [master]
GO
/****** Object:  Database [GenZFashion]    Script Date: 9/10/2025 10:04:15 PM ******/
CREATE DATABASE [GenZFashion]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'GenZFashion', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS01\MSSQL\DATA\GenZFashion.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'GenZFashion_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS01\MSSQL\DATA\GenZFashion_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [GenZFashion] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [GenZFashion].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [GenZFashion] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [GenZFashion] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [GenZFashion] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [GenZFashion] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [GenZFashion] SET ARITHABORT OFF 
GO
ALTER DATABASE [GenZFashion] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [GenZFashion] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [GenZFashion] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [GenZFashion] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [GenZFashion] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [GenZFashion] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [GenZFashion] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [GenZFashion] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [GenZFashion] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [GenZFashion] SET  ENABLE_BROKER 
GO
ALTER DATABASE [GenZFashion] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [GenZFashion] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [GenZFashion] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [GenZFashion] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [GenZFashion] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [GenZFashion] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [GenZFashion] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [GenZFashion] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [GenZFashion] SET  MULTI_USER 
GO
ALTER DATABASE [GenZFashion] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [GenZFashion] SET DB_CHAINING OFF 
GO
ALTER DATABASE [GenZFashion] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [GenZFashion] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [GenZFashion] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [GenZFashion] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [GenZFashion] SET QUERY_STORE = OFF
GO
USE [GenZFashion]
GO
/****** Object:  Table [dbo].[Account]    Script Date: 9/10/2025 10:04:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Account](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[UsersID] [bigint] NULL,
	[Email] [varchar](35) NULL,
	[Username] [varchar](255) NULL,
	[Password] [varchar](255) NULL,
	[AccountRole] [nvarchar](10) NULL,
	[IsActive] [bit] NULL,
	[Creation_date] [datetime] NULL,
	[Edit_Date] [datetime] NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Brand]    Script Date: 9/10/2025 10:04:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Brand](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](255) NULL,
	[Note] [nvarchar](255) NULL,
	[Status] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CartItem]    Script Date: 9/10/2025 10:04:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CartItem](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[customer_id] [int] NULL,
	[variation_id] [int] NULL,
	[quantity] [int] NULL,
	[status] [int] NULL,
 CONSTRAINT [PK_CartItem] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Category]    Script Date: 9/10/2025 10:04:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Category](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NULL,
	[Status] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Contact]    Script Date: 9/10/2025 10:04:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Contact](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[fullName] [nvarchar](50) NULL,
	[email] [varchar](50) NULL,
	[phone] [int] NULL,
	[content] [nvarchar](max) NULL,
 CONSTRAINT [PK_Contact] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Customer]    Script Date: 9/10/2025 10:04:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customer](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NULL,
	[Address] [nvarchar](100) NULL,
	[Phone] [nvarchar](10) NULL,
	[Note] [nvarchar](50) NULL,
	[Status] [bit] NULL,
	[Creation_date] [date] NULL,
	[Edit_Date] [date] NULL,
 CONSTRAINT [PK_Customer] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Employee]    Script Date: 9/10/2025 10:04:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Employee](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](20) NULL,
	[Phone] [nvarchar](10) NULL,
	[Creation_date] [date] NULL,
	[Edit_Date] [date] NULL,
 CONSTRAINT [PK_Employee] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Images]    Script Date: 9/10/2025 10:04:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Images](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Entity_ID] [int] NULL,
	[Model] [varchar](15) NULL,
	[Cd_Images] [varchar](255) NULL,
	[Set_Default] [bit] NULL,
 CONSTRAINT [PK_Images] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderLine]    Script Date: 9/10/2025 10:04:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderLine](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[OderID] [int] NULL,
	[VariationID] [int] NULL,
	[VariationName] [nvarchar](50) NULL,
	[Marterial] [nvarchar](50) NULL,
	[Quantity] [int] NULL,
	[Unit_Price] [decimal](14, 2) NULL,
	[Price] [decimal](14, 2) NULL,
	[Status] [bit] NULL,
	[Creation_date] [date] NULL,
	[Edit_Date] [date] NULL,
 CONSTRAINT [PK_OrderLine] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PaymentMethod]    Script Date: 9/10/2025 10:04:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PaymentMethod](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Type] [nvarchar](255) NULL,
	[Note] [nvarchar](255) NULL,
	[Status] [bit] NULL,
 CONSTRAINT [PK_PaymentMethod] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PayOsClient]    Script Date: 9/10/2025 10:04:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PayOsClient](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[OderID] [bigint] NULL,
	[OrderCode] [bigint] NOT NULL,
	[Amount] [int] NOT NULL,
	[Status] [nvarchar](50) NULL,
	[CheckoutUrl] [nvarchar](2048) NULL,
	[CreationDate] [datetime2](7) NOT NULL,
	[PaymentDate] [datetime2](7) NULL,
	[Description] [nvarchar](max) NULL,
 CONSTRAINT [PK_PayOsClient] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[POSOder]    Script Date: 9/10/2025 10:04:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[POSOder](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[CustomerID] [int] NULL,
	[Address] [nvarchar](50) NULL,
	[Total_Amount] [decimal](14, 2) NULL,
	[Total_Payment] [decimal](14, 2) NULL,
	[PaymentMethod] [int] NULL,
	[Note] [nvarchar](255) NULL,
	[Status] [int] NULL,
	[Order_Time] [datetime] NULL,
	[Payment_Time] [datetime] NULL,
	[Type_Oder] [int] NULL,
 CONSTRAINT [PK_POSOder] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Product]    Script Date: 9/10/2025 10:04:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Product](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](255) NULL,
	[CategoryID] [int] NULL,
	[BrandID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Role]    Script Date: 9/10/2025 10:04:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Role](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](10) NULL,
 CONSTRAINT [PK_Role] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[user_roles]    Script Date: 9/10/2025 10:04:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[user_roles](
	[user_id] [bigint] NOT NULL,
	[role_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[user_id] ASC,
	[role_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Variation]    Script Date: 9/10/2025 10:04:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Variation](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[SKU] [varchar](50) NULL,
	[ProductID] [int] NULL,
	[Name] [nvarchar](100) NULL,
	[Price] [decimal](12, 2) NULL,
	[Quantity] [int] NULL,
	[Color] [varchar](10) NULL,
	[Material] [nvarchar](25) NULL,
	[Size] [varchar](30) NULL,
	[Description] [nvarchar](max) NULL,
	[Sold] [int] NULL,
	[Status] [bit] NULL,
 CONSTRAINT [PK__Variatio__3214EC27B11F52D7] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[ReturnRequest] ADD  DEFAULT (getdate()) FOR [RequestDate]
GO
ALTER TABLE [dbo].[ReturnRequest] ADD  DEFAULT ((0)) FOR [Status]
GO
ALTER TABLE [dbo].[Voucher] ADD  DEFAULT (newid()) FOR [Code]
GO
ALTER TABLE [dbo].[user_roles]  WITH CHECK ADD FOREIGN KEY([role_id])
REFERENCES [dbo].[Role] ([ID])
ON DELETE CASCADE
GO
/****** Object:  StoredProcedure [dbo].[usp_UpdateSoldOnOrderLine]    Script Date: 9/10/2025 10:04:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_UpdateSoldOnOrderLine]
AS
BEGIN
    SET NOCOUNT ON;

    -- Cập nhật cột Sold trong bảng Variation
    UPDATE v
    SET v.Sold = (
        SELECT SUM(ol.Quantity)
        FROM [dbo].[OrderLine] ol
        WHERE ol.VariationID = v.ID AND ol.Status = 1
    )
    FROM [dbo].[Variation] v
    WHERE v.ID IN (
        SELECT DISTINCT VariationID
        FROM [dbo].[OrderLine] -- Lấy tất cả các VariationID hiện có trong OrderLine để cập nhật
    );
END;
GO
/****** Object:  Trigger [dbo].[trg_UpdateSoldOnOrderLine]    Script Date: 9/10/2025 10:04:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[trg_UpdateSoldOnOrderLine]
ON [dbo].[OrderLine]
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Cập nhật cột Sold trong bảng Variation
    UPDATE v
    SET v.Sold = (
        SELECT SUM(ol.Quantity)
        FROM [dbo].[OrderLine] ol
        WHERE ol.VariationID = v.ID AND ol.Status = 1
    )
    FROM [dbo].[Variation] v
    WHERE v.ID IN (
        SELECT DISTINCT VariationID
        FROM inserted
    );
END;
GO
ALTER TABLE [dbo].[OrderLine] ENABLE TRIGGER [trg_UpdateSoldOnOrderLine]
GO
/****** Object:  Trigger [dbo].[trg_UpdateTotalAmountAndPayment]    Script Date: 9/10/2025 10:04:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create TRIGGER [dbo].[trg_UpdateTotalAmountAndPayment]
ON [dbo].[OrderLine]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @OrderID INT;
    DECLARE @TotalAmount DECIMAL(12, 2);

    -- Xử lý cả INSERT / UPDATE / DELETE chung
    IF EXISTS (SELECT 1 FROM inserted) OR EXISTS (SELECT 1 FROM deleted)
    BEGIN
        -- Ưu tiên lấy OrderID từ inserted, nếu không có thì lấy từ deleted
        SELECT TOP 1 @OrderID = OderID FROM inserted;
        IF @OrderID IS NULL
            SELECT TOP 1 @OrderID = OderID FROM deleted;

        -- Tính tổng số tiền
        SELECT @TotalAmount = ISNULL(SUM(Price), 0)
        FROM OrderLine
        WHERE OderID = @OrderID;

        -- Gán tổng số tiền vào cả Total_Amount và Total_Payment
        UPDATE POSOder
        SET Total_Amount = @TotalAmount,
            Total_Payment = @TotalAmount
        WHERE ID = @OrderID;
    END
END;
GO
ALTER TABLE [dbo].[OrderLine] ENABLE TRIGGER [trg_UpdateTotalAmountAndPayment]
GO
/****** Object:  Trigger [dbo].[trg_UpdateStatusOnZeroQuantity]    Script Date: 9/10/2025 10:04:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[trg_UpdateStatusOnZeroQuantity]
ON [dbo].[Variation]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Cập nhật Status thành 0 khi số lượng = 0
    UPDATE v
    SET v.Status = 0
    FROM [dbo].[Variation] v
    INNER JOIN inserted i ON v.ID = i.ID
    WHERE i.Quantity = 0;
    
    -- Cập nhật Status thành 1 khi số lượng > 0
    UPDATE v
    SET v.Status = 1
    FROM [dbo].[Variation] v
    INNER JOIN inserted i ON v.ID = i.ID
    WHERE i.Quantity > 0;
END;
GO
ALTER TABLE [dbo].[Variation] ENABLE TRIGGER [trg_UpdateStatusOnZeroQuantity]

--Seeder
-- Account
INSERT INTO Account (UsersID, Email, Username, Password, AccountRole, IsActive, Creation_date, Edit_Date) VALUES
(1, 'user1@example.com', 'user1', '$2a$10$W9Qv7Y/dqQDQ/d/hNEM72.qj3s1C..HQaBpcPTH/XQPM7NACmNcCO', N'ADMIN', 1, GETDATE(), GETDATE())

-- Brand
INSERT INTO Brand (Name, Note, Status) VALUES
(N'Nike', N'Giày thể thao', 1),
(N'Adidas', N'Giày chạy bộ', 1),
(N'Puma', N'Giày bóng đá', 1),
(N'Converse', N'Giày thời trang', 1),
(N'Vans', N'Giày trượt ván', 1),
(N'New Balance', N'Giày đi bộ', 1),
(N'Reebok', N'Giày phòng gym', 1),
(N'Under Armour', N'Giày thể hình', 1),
(N'Skechers', N'Giày đi bộ', 1),
(N'Asics', N'Giày chạy bộ', 1);

-- Category
INSERT INTO Category (Name, Status) VALUES
(N'Giày Nam', 1),
(N'Giày Nữ', 1),
(N'Giày Thể Thao', 1),
(N'Giày Chạy Bộ', 1),
(N'Giày Thời Trang', 1),
(N'Giày Công Sở', 1),
(N'Giày Trẻ Em', 1),
(N'Dép', 1),
(N'Sandal', 1),
(N'Giày Leo Núi', 1);

-- Employee
INSERT INTO Employee (Name, Phone, Creation_date, Edit_Date) VALUES
(N'Nguyen Van A', '0911111111', GETDATE(), GETDATE())


-- PaymentMethod
INSERT INTO PaymentMethod (Type, Note, Status) VALUES
(N'Thanh toán tiền mặt', N'Trả tiền mặt khi nhận hàng', 1),
(N'Thanh toán qua thẻ', N'Sử dụng thẻ ATM nội địa', 1),
(N'Thanh toán qua thẻ quốc tế', N'Sử dụng Visa, MasterCard', 1),
(N'Thanh toán qua ví điện tử', N'MoMo, ZaloPay', 1),
(N'Thanh toán ngân hàng', N'Chuyển khoản trực tiếp', 1),
(N'Thanh toán COD', N'Thanh toán khi nhận hàng', 1),
(N'Thanh toán QR', N'Sử dụng mã QR', 1),
(N'Thanh toán PayPal', N'Sử dụng PayPal', 1),
(N'Thanh toán Apple Pay', N'Sử dụng Apple Pay', 1),
(N'Thanh toán Google Pay', N'Sử dụng Google Pay', 1);

-- Product
INSERT INTO Product (Name, CategoryID, BrandID) VALUES
(N'Sản phẩm 1', 1, 1),
(N'Sản phẩm 2', 2, 2),
(N'Sản phẩm 3', 3, 3),
(N'Sản phẩm 4', 4, 4),
(N'Sản phẩm 5', 5, 5),
(N'Sản phẩm 6', 6, 6),
(N'Sản phẩm 7', 7, 7),
(N'Sản phẩm 8', 8, 8),
(N'Sản phẩm 9', 9, 9),
(N'Sản phẩm 10', 10, 10);


-- Role
INSERT INTO Role (Name) VALUES
('ADMIN'),
('USER'),
('CUSTOMER')



