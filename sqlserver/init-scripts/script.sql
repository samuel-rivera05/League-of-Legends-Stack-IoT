USE [master]
GO
/****** Object:  Database [Reto0f1]    Script Date: 14/10/2025 8:12:22 ******/
-- Simplified CREATE DATABASE for Linux containers (avoid Windows file paths)
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'Reto0f1')
BEGIN
    CREATE DATABASE [Reto0f1];
END
GO
ALTER DATABASE [Reto0f1] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Reto0f1].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Reto0f1] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Reto0f1] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Reto0f1] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Reto0f1] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Reto0f1] SET ARITHABORT OFF 
GO
ALTER DATABASE [Reto0f1] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Reto0f1] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Reto0f1] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Reto0f1] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Reto0f1] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Reto0f1] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Reto0f1] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Reto0f1] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Reto0f1] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Reto0f1] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Reto0f1] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Reto0f1] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Reto0f1] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Reto0f1] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Reto0f1] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Reto0f1] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Reto0f1] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Reto0f1] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [Reto0f1] SET  MULTI_USER 
GO
ALTER DATABASE [Reto0f1] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Reto0f1] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Reto0f1] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Reto0f1] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Reto0f1] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [Reto0f1] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [Reto0f1] SET QUERY_STORE = ON
GO
ALTER DATABASE [Reto0f1] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [Reto0f1]
GO
/****** Object:  Table [dbo].[Disputa]    Script Date: 14/10/2025 8:12:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Disputa](
	[match_id] [varchar](50) NOT NULL,
	[player_id] [int] NOT NULL,
	[champion_id] [int] NOT NULL,
	[kills] [int] NOT NULL,
	[deaths] [int] NOT NULL,
	[assists] [int] NOT NULL,
	[kda] [varchar](50) NOT NULL,
	[resultado] [varchar](50) NOT NULL,
	[teamId] [int] NOT NULL,
	[role] [varchar](50) NOT NULL,
	[visionScore] [int] NOT NULL,
	[goldEarned] [int] NOT NULL,
	[participation_id] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_Disputa] PRIMARY KEY CLUSTERED 
(
	[participation_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[personaje]    Script Date: 14/10/2025 8:12:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[personaje](
	[campeon] [varchar](50) NOT NULL,
	[champion_id] [int] NOT NULL,
 CONSTRAINT [PK_personaje] PRIMARY KEY CLUSTERED 
(
	[champion_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vista_estadisticas_campeones]    Script Date: 14/10/2025 8:12:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vista_estadisticas_campeones] AS
SELECT 
    p.campeon AS nombre_campeon,
    COUNT(d.participation_id) AS veces_usado,
    ROUND(AVG(d.kills), 2) AS promedio_kills,
    ROUND(AVG(d.deaths), 2) AS promedio_deaths,
    ROUND(AVG(d.assists), 2) AS promedio_assists,
    ROUND(SUM(CASE WHEN d.resultado = 'Win' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS porcentaje_victorias
FROM Disputa d
JOIN personaje p ON d.champion_id = p.champion_id
GROUP BY p.campeon;

GO
/****** Object:  Table [dbo].[Partida]    Script Date: 14/10/2025 8:12:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Partida](
	[match_id] [varchar](50) NOT NULL,
	[fecha] [datetime] NOT NULL,
	[duracion_min] [int] NOT NULL,
	[modo] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Partida] PRIMARY KEY CLUSTERED 
(
	[match_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vista_resumen_partidas]    Script Date: 14/10/2025 8:12:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vista_resumen_partidas] AS
SELECT 
    pa.match_id,
    pa.fecha,
    pa.modo,
    pa.duracion_min,
    SUM(CASE WHEN d.resultado = 'Win' THEN 1 ELSE 0 END) AS jugadores_ganadores,
    SUM(CASE WHEN d.resultado = 'Lose' THEN 1 ELSE 0 END) AS jugadores_perdedores
FROM Partida pa
JOIN Disputa d ON pa.match_id = d.match_id
GROUP BY pa.match_id, pa.fecha, pa.modo, pa.duracion_min;

GO
/****** Object:  Table [dbo].[Jugador]    Script Date: 14/10/2025 8:12:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Jugador](
	[jugador] [varchar](50) NOT NULL,
	[player_id] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_Juagdor] PRIMARY KEY CLUSTERED 
(
	[player_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[Vista_DetallePartidasJugador]    Script Date: 14/10/2025 8:12:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Vista_DetallePartidasJugador] AS
SELECT
    P.fecha,
    P.modo,
    P.duracion_min,
    J.jugador AS NombreJugador,
    Per.campeon AS NombreCampeon,
    D.kills,
    D.deaths,
    D.assists,
    D.kda,
    D.resultado,
    D.teamId,
    D.role,
    D.visionScore,
    D.goldEarned,
    D.match_id
FROM dbo.Disputa AS D
JOIN dbo.Jugador AS J ON D.player_id = J.player_id
JOIN dbo.Personaje AS Per ON D.champion_id = Per.champion_id
JOIN dbo.Partida AS P ON D.match_id = P.match_id;
GO
/****** Object:  View [dbo].[vista_economia_y_vision]    Script Date: 14/10/2025 8:12:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vista_economia_y_vision] AS
SELECT 
    j.jugador AS nombre_jugador,
    ROUND(AVG(d.goldEarned), 2) AS promedio_oro,
    ROUND(AVG(d.visionScore), 2) AS promedio_vision
FROM Disputa d
JOIN Jugador j ON d.player_id = j.player_id
GROUP BY j.jugador;

GO
/****** Object:  View [dbo].[vista_participaciones_detalle]    Script Date: 14/10/2025 8:12:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vista_participaciones_detalle] AS
SELECT 
    pa.match_id,
    pa.fecha,
    pa.modo,
    j.jugador AS nombre_jugador,
    p.campeon AS nombre_campeon,
    d.teamId,
    d.role,
    d.kills,
    d.deaths,
    d.assists,
    d.kda,
    d.resultado,
    d.goldEarned,
    d.visionScore
FROM Disputa d
JOIN Partida pa ON d.match_id = pa.match_id
JOIN Jugador j ON d.player_id = j.player_id
JOIN personaje p ON d.champion_id = p.champion_id;

GO
SET IDENTITY_INSERT [dbo].[Disputa] ON 

INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7561824434', 1, 1, 6, 5, 2, N'6/5/2', N'Lose', 100, N'TOP', 22, 13289, 1)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7561824434', 2, 2, 2, 4, 4, N'2/4/4', N'Lose', 100, N'JUNGLE', 27, 11922, 2)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7561824434', 3, 3, 8, 8, 3, N'8/8/3', N'Lose', 100, N'MIDDLE', 18, 12263, 3)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7561824434', 4, 4, 7, 7, 6, N'7/7/6', N'Lose', 100, N'BOTTOM', 28, 12983, 4)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7561824434', 5, 5, 1, 11, 10, N'1/11/10', N'Lose', 100, N'UTILITY', 58, 8431, 5)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7561824434', 6, 6, 3, 6, 1, N'3/6/1', N'Win', 200, N'TOP', 24, 14298, 6)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7561824434', 7, 7, 4, 4, 3, N'4/4/3', N'Win', 200, N'JUNGLE', 22, 12285, 7)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7561824434', 8, 8, 21, 2, 4, N'21/2/4', N'Win', 200, N'MIDDLE', 28, 19868, 8)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7561824434', 9, 9, 4, 6, 10, N'4/6/10', N'Win', 200, N'BOTTOM', 20, 13879, 9)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7561824434', 10, 10, 2, 6, 5, N'2/6/5', N'Win', 200, N'UTILITY', 46, 9480, 10)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7561773936', 11, 11, 2, 12, 5, N'2/12/5', N'Lose', 100, N'TOP', 20, 14342, 11)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7561773936', 12, 12, 4, 8, 5, N'4/8/5', N'Lose', 100, N'JUNGLE', 32, 14369, 12)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7561773936', 13, 13, 6, 8, 7, N'6/8/7', N'Lose', 100, N'MIDDLE', 21, 15272, 13)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7561773936', 14, 14, 13, 10, 9, N'13/10/9', N'Lose', 100, N'BOTTOM', 31, 18982, 14)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7561773936', 15, 15, 7, 8, 15, N'7/8/15', N'Lose', 100, N'UTILITY', 79, 14789, 15)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7561773936', 1, 1, 17, 2, 13, N'17/2/13', N'Win', 200, N'TOP', 27, 21195, 16)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7561773936', 16, 16, 14, 7, 9, N'14/7/9', N'Win', 200, N'JUNGLE', 58, 21037, 17)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7561773936', 17, 17, 7, 2, 17, N'7/2/17', N'Win', 200, N'MIDDLE', 31, 16018, 18)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7561773936', 18, 18, 4, 14, 13, N'4/14/13', N'Win', 200, N'BOTTOM', 28, 14216, 19)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7561773936', 19, 19, 4, 8, 17, N'4/8/17', N'Win', 200, N'UTILITY', 76, 12739, 20)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7561293544', 20, 20, 13, 1, 2, N'13/1/2', N'Win', 100, N'TOP', 13, 13311, 21)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7561293544', 21, 21, 7, 3, 2, N'7/3/2', N'Win', 100, N'JUNGLE', 20, 10205, 22)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7561293544', 22, 22, 0, 1, 5, N'0/1/5', N'Win', 100, N'MIDDLE', 2, 10036, 23)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7561293544', 23, 23, 2, 3, 5, N'2/3/5', N'Win', 100, N'BOTTOM', 19, 8813, 24)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7561293544', 24, 24, 4, 1, 11, N'4/1/11', N'Win', 100, N'UTILITY', 53, 8829, 25)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7561293544', 1, 25, 0, 8, 1, N'0/8/1', N'Lose', 200, N'TOP', 12, 6355, 26)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7561293544', 25, 26, 3, 5, 1, N'3/5/1', N'Lose', 200, N'JUNGLE', 18, 7602, 27)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7561293544', 26, 27, 2, 3, 2, N'2/3/2', N'Lose', 200, N'MIDDLE', 11, 8641, 28)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7561293544', 27, 9, 2, 6, 1, N'2/6/1', N'Lose', 200, N'BOTTOM', 13, 7523, 29)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7561293544', 28, 28, 2, 4, 4, N'2/4/4', N'Lose', 200, N'UTILITY', 54, 5976, 30)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7561222989', 1, 29, 6, 11, 4, N'6/11/4', N'Lose', 100, N'TOP', 29, 13629, 31)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7561222989', 29, 30, 8, 9, 7, N'8/9/7', N'Lose', 100, N'JUNGLE', 36, 15265, 32)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7561222989', 30, 31, 13, 11, 4, N'13/11/4', N'Lose', 100, N'MIDDLE', 55, 15497, 33)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7561222989', 31, 4, 7, 5, 7, N'7/5/7', N'Lose', 100, N'BOTTOM', 43, 19223, 34)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7561222989', 28, 32, 2, 3, 13, N'2/3/13', N'Lose', 100, N'UTILITY', 105, 13459, 35)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7561222989', 32, 33, 6, 6, 19, N'6/6/19', N'Win', 200, N'TOP', 28, 15173, 36)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7561222989', 33, 34, 6, 9, 16, N'6/9/16', N'Win', 200, N'JUNGLE', 31, 16492, 37)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7561222989', 34, 3, 14, 3, 7, N'14/3/7', N'Win', 200, N'MIDDLE', 18, 18852, 38)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7561222989', 35, 9, 11, 10, 16, N'11/10/16', N'Win', 200, N'BOTTOM', 35, 21165, 39)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7561222989', 36, 35, 2, 8, 26, N'2/8/26', N'Win', 200, N'UTILITY', 80, 12283, 40)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7561167671', 1, 29, 13, 5, 8, N'13/5/8', N'Win', 100, N'TOP', 17, 16823, 41)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7561167671', 37, 36, 16, 7, 6, N'16/7/6', N'Win', 100, N'JUNGLE', 24, 16684, 42)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7561167671', 38, 37, 12, 7, 6, N'12/7/6', N'Win', 100, N'MIDDLE', 15, 13273, 43)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7561167671', 39, 4, 3, 7, 15, N'3/7/15', N'Win', 100, N'BOTTOM', 18, 10219, 44)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7561167671', 28, 38, 3, 7, 25, N'3/7/25', N'Win', 100, N'UTILITY', 71, 10125, 45)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7561167671', 40, 39, 3, 10, 9, N'3/10/9', N'Lose', 200, N'TOP', 15, 8799, 46)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7561167671', 41, 40, 8, 8, 6, N'8/8/6', N'Lose', 200, N'JUNGLE', 25, 12992, 47)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7561167671', 42, 41, 9, 13, 4, N'9/13/4', N'Lose', 200, N'MIDDLE', 8, 11704, 48)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7561167671', 43, 14, 9, 6, 6, N'9/6/6', N'Lose', 200, N'BOTTOM', 24, 12697, 49)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7561167671', 44, 16, 4, 10, 14, N'4/10/14', N'Lose', 200, N'UTILITY', 68, 11193, 50)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7560039046', 45, 7, 5, 0, 2, N'5/0/2', N'Win', 100, N'TOP', 8, 8471, 51)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7560039046', 46, 42, 2, 2, 4, N'2/2/4', N'Win', 100, N'JUNGLE', 10, 5775, 52)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7560039046', 47, 43, 8, 2, 2, N'8/2/2', N'Win', 100, N'MIDDLE', 1, 7074, 53)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7560039046', 48, 4, 3, 2, 7, N'3/2/7', N'Win', 100, N'BOTTOM', 8, 5520, 54)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7560039046', 49, 44, 1, 4, 11, N'1/4/11', N'Win', 100, N'UTILITY', 25, 4895, 55)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7560039046', 1, 29, 1, 4, 0, N'1/4/0', N'Lose', 200, N'TOP', 7, 4160, 56)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7560039046', 50, 45, 1, 4, 6, N'1/4/6', N'Lose', 200, N'JUNGLE', 4, 4361, 57)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7560039046', 51, 46, 4, 6, 0, N'4/6/0', N'Lose', 200, N'MIDDLE', 6, 5517, 58)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7560039046', 52, 14, 2, 1, 4, N'2/1/4', N'Lose', 200, N'BOTTOM', 6, 5105, 59)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7560039046', 28, 39, 2, 4, 4, N'2/4/4', N'Lose', 200, N'UTILITY', 20, 4630, 60)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7559991512', 1, 29, 8, 5, 4, N'8/5/4', N'Lose', 100, N'TOP', 10, 11305, 61)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7559991512', 53, 47, 3, 8, 10, N'3/8/10', N'Lose', 100, N'JUNGLE', 19, 8826, 62)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7559991512', 54, 48, 2, 5, 2, N'2/5/2', N'Lose', 100, N'MIDDLE', 20, 8551, 63)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7559991512', 55, 49, 4, 8, 6, N'4/8/6', N'Lose', 100, N'BOTTOM', 10, 10677, 64)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7559991512', 28, 39, 6, 11, 11, N'6/11/11', N'Lose', 100, N'UTILITY', 62, 10663, 65)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7559991512', 56, 25, 4, 7, 1, N'4/7/1', N'Win', 200, N'TOP', 10, 10568, 66)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7559991512', 57, 42, 10, 6, 6, N'10/6/6', N'Win', 200, N'JUNGLE', 25, 13343, 67)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7559991512', 58, 50, 3, 4, 14, N'3/4/14', N'Win', 200, N'MIDDLE', 15, 10071, 68)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7559991512', 59, 23, 5, 6, 10, N'5/6/10', N'Win', 200, N'BOTTOM', 35, 11475, 69)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7559991512', 60, 3, 15, 0, 5, N'15/0/5', N'Win', 200, N'UTILITY', 64, 12235, 70)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7559943091', 1, 51, 1, 6, 0, N'1/6/0', N'Lose', 100, N'TOP', 7, 5792, 71)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7559943091', 61, 42, 1, 3, 1, N'1/3/1', N'Lose', 100, N'JUNGLE', 8, 7129, 72)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7559943091', 62, 52, 1, 8, 0, N'1/8/0', N'Lose', 100, N'MIDDLE', 9, 6435, 73)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7559943091', 63, 14, 2, 8, 0, N'2/8/0', N'Lose', 100, N'BOTTOM', 8, 8124, 74)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7559943091', 28, 38, 0, 6, 3, N'0/6/3', N'Lose', 100, N'UTILITY', 40, 4701, 75)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7559943091', 64, 53, 4, 2, 4, N'4/2/4', N'Win', 200, N'TOP', 11, 7030, 76)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7559943091', 65, 54, 12, 1, 5, N'12/1/5', N'Win', 200, N'JUNGLE', 20, 10088, 77)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7559943091', 66, 55, 10, 1, 3, N'10/1/3', N'Win', 200, N'MIDDLE', 11, 9368, 78)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7559943091', 67, 49, 4, 1, 7, N'4/1/7', N'Win', 200, N'BOTTOM', 9, 8249, 79)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7559943091', 68, 56, 1, 0, 13, N'1/0/13', N'Win', 200, N'UTILITY', 35, 6118, 80)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7558728446', 1, 1, 3, 8, 7, N'3/8/7', N'Lose', 100, N'TOP', 17, 12615, 81)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7558728446', 69, 19, 8, 6, 12, N'8/6/12', N'Lose', 100, N'JUNGLE', 19, 13003, 82)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7558728446', 70, 25, 12, 12, 8, N'12/12/8', N'Lose', 100, N'MIDDLE', 19, 15849, 83)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7558728446', 71, 57, 1, 11, 9, N'1/11/9', N'Lose', 100, N'BOTTOM', 13, 9415, 84)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7558728446', 28, 58, 6, 12, 6, N'6/12/6', N'Lose', 100, N'UTILITY', 93, 10466, 85)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7558728446', 72, 59, 7, 6, 8, N'7/6/8', N'Win', 200, N'TOP', 17, 13208, 86)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7558728446', 73, 60, 19, 6, 7, N'19/6/7', N'Win', 200, N'JUNGLE', 25, 18444, 87)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7558728446', 74, 61, 15, 10, 13, N'15/10/13', N'Win', 200, N'MIDDLE', 15, 13599, 88)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7558728446', 75, 62, 7, 4, 13, N'7/4/13', N'Win', 200, N'BOTTOM', 19, 14366, 89)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7558728446', 76, 63, 1, 4, 28, N'1/4/28', N'Win', 200, N'UTILITY', 50, 9454, 90)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7558660105', 77, 64, 2, 8, 8, N'2/8/8', N'Win', 100, N'TOP', 6, 10163, 91)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7558660105', 78, 65, 22, 4, 4, N'22/4/4', N'Win', 100, N'JUNGLE', 17, 20177, 92)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7558660105', 79, 17, 6, 5, 10, N'6/5/10', N'Win', 100, N'MIDDLE', 23, 12221, 93)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7558660105', 80, 4, 3, 7, 16, N'3/7/16', N'Win', 100, N'BOTTOM', 26, 12328, 94)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7558660105', 81, 16, 4, 4, 12, N'4/4/12', N'Win', 100, N'UTILITY', 79, 12177, 95)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7558660105', 1, 1, 6, 6, 1, N'6/6/1', N'Lose', 200, N'TOP', 19, 13656, 96)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7558660105', 82, 47, 0, 10, 9, N'0/10/9', N'Lose', 200, N'JUNGLE', 16, 10169, 97)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7558660105', 83, 15, 4, 8, 11, N'4/8/11', N'Lose', 200, N'MIDDLE', 18, 11720, 98)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7558660105', 84, 14, 15, 8, 4, N'15/8/4', N'Lose', 200, N'BOTTOM', 16, 17618, 99)
GO
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7558660105', 28, 38, 3, 5, 11, N'3/5/11', N'Lose', 200, N'UTILITY', 76, 8829, 100)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7558559682', 1, 1, 11, 5, 12, N'11/5/12', N'Win', 100, N'TOP', 30, 21812, 101)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7558559682', 85, 42, 16, 7, 9, N'16/7/9', N'Win', 100, N'JUNGLE', 40, 21289, 102)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7558559682', 86, 66, 3, 15, 16, N'3/15/16', N'Win', 100, N'MIDDLE', 15, 12579, 103)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7558559682', 87, 67, 13, 5, 16, N'13/5/16', N'Win', 100, N'BOTTOM', 34, 18637, 104)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7558559682', 28, 68, 1, 6, 32, N'1/6/32', N'Win', 100, N'UTILITY', 100, 11998, 105)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7558559682', 88, 51, 14, 6, 4, N'14/6/4', N'Lose', 200, N'TOP', 26, 25537, 106)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7558559682', 89, 69, 9, 13, 8, N'9/13/8', N'Lose', 200, N'JUNGLE', 25, 16151, 107)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7558559682', 90, 70, 10, 7, 6, N'10/7/6', N'Lose', 200, N'MIDDLE', 36, 16176, 108)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7558559682', 91, 71, 2, 10, 6, N'2/10/6', N'Lose', 200, N'BOTTOM', 37, 15704, 109)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7558559682', 92, 72, 3, 8, 8, N'3/8/8', N'Lose', 200, N'UTILITY', 79, 10763, 110)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7557363001', 93, 21, 3, 3, 1, N'3/3/1', N'Lose', 100, N'TOP', 4, 5599, 111)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7557363001', 94, 39, 3, 4, 0, N'3/4/0', N'Lose', 100, N'JUNGLE', 6, 5100, 112)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7557363001', 95, 73, 0, 2, 3, N'0/2/3', N'Lose', 100, N'BOTTOM', 7, 4405, 113)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7557363001', 96, 23, 2, 7, 0, N'2/7/0', N'Lose', 100, N'BOTTOM', 8, 4367, 114)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7557363001', 97, 52, 0, 5, 0, N'0/5/0', N'Lose', 100, N'UTILITY', 0, 2577, 115)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7557363001', 1, 1, 2, 3, 1, N'2/3/1', N'Win', 200, N'TOP', 7, 4896, 116)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7557363001', 98, 74, 1, 3, 6, N'1/3/6', N'Win', 200, N'JUNGLE', 10, 5684, 117)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7557363001', 99, 75, 9, 2, 2, N'9/2/2', N'Win', 200, N'MIDDLE', 6, 7493, 118)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7557363001', 100, 76, 6, 0, 4, N'6/0/4', N'Win', 200, N'BOTTOM', 1, 7404, 119)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7557363001', 101, 77, 3, 0, 3, N'3/0/3', N'Win', 200, N'UTILITY', 20, 5311, 120)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7556681211', 1, 1, 6, 6, 9, N'6/6/9', N'Win', 100, N'TOP', 16, 12300, 121)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7556681211', 102, 42, 26, 9, 10, N'26/9/10', N'Win', 100, N'JUNGLE', 19, 20616, 122)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7556681211', 103, 8, 12, 8, 8, N'12/8/8', N'Win', 100, N'MIDDLE', 15, 12962, 123)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7556681211', 104, 78, 7, 6, 11, N'7/6/11', N'Win', 100, N'BOTTOM', 16, 14511, 124)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7556681211', 105, 79, 0, 3, 25, N'0/3/25', N'Win', 100, N'UTILITY', 39, 10303, 125)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7556681211', 106, 80, 4, 12, 4, N'4/12/4', N'Lose', 200, N'TOP', 16, 11570, 126)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7556681211', 107, 81, 2, 10, 6, N'2/10/6', N'Lose', 200, N'JUNGLE', 18, 9955, 127)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7556681211', 108, 82, 6, 12, 3, N'6/12/3', N'Lose', 200, N'MIDDLE', 13, 10583, 128)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7556681211', 109, 49, 15, 8, 5, N'15/8/5', N'Lose', 200, N'BOTTOM', 13, 18638, 129)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7556681211', 110, 72, 5, 9, 10, N'5/9/10', N'Lose', 200, N'UTILITY', 36, 9947, 130)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7555385541', 1, 83, 7, 10, 1, N'7/10/1', N'Win', 100, N'TOP', 21, 11248, 131)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7555385541', 111, 26, 17, 0, 7, N'17/0/7', N'Win', 100, N'JUNGLE', 24, 17892, 132)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7555385541', 112, 84, 0, 8, 3, N'0/8/3', N'Win', 100, N'MIDDLE', 17, 14073, 133)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7555385541', 113, 71, 5, 3, 15, N'5/3/15', N'Win', 100, N'BOTTOM', 13, 14029, 134)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7555385541', 114, 37, 10, 6, 9, N'10/6/9', N'Win', 100, N'UTILITY', 71, 11726, 135)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7555385541', 115, 85, 9, 5, 3, N'9/5/3', N'Lose', 200, N'TOP', 14, 13599, 136)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7555385541', 116, 74, 5, 8, 3, N'5/8/3', N'Lose', 200, N'JUNGLE', 11, 13016, 137)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7555385541', 117, 3, 5, 4, 5, N'5/4/5', N'Lose', 200, N'MIDDLE', 32, 11912, 138)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7555385541', 118, 57, 6, 12, 3, N'6/12/3', N'Lose', 200, N'BOTTOM', 17, 11594, 139)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7555385541', 119, 47, 2, 10, 14, N'2/10/14', N'Lose', 200, N'UTILITY', 39, 9064, 140)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7555319259', 120, 2, 14, 6, 13, N'14/6/13', N'Win', 100, N'TOP', 13, 15675, 141)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7555319259', 121, 81, 9, 5, 20, N'9/5/20', N'Win', 100, N'JUNGLE', 21, 13378, 142)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7555319259', 122, 41, 10, 11, 12, N'10/11/12', N'Win', 100, N'MIDDLE', 26, 11675, 143)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7555319259', 123, 57, 7, 10, 12, N'7/10/12', N'Win', 100, N'BOTTOM', 23, 13282, 144)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7555319259', 124, 86, 9, 3, 13, N'9/3/13', N'Win', 100, N'UTILITY', 55, 11847, 145)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7555319259', 1, 25, 7, 9, 5, N'7/9/5', N'Lose', 200, N'TOP', 15, 10948, 146)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7555319259', 125, 30, 22, 7, 4, N'22/7/4', N'Lose', 200, N'JUNGLE', 16, 17685, 147)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7555319259', 126, 13, 0, 12, 9, N'0/12/9', N'Lose', 200, N'MIDDLE', 16, 8383, 148)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7555319259', 127, 4, 6, 11, 8, N'6/11/8', N'Lose', 200, N'BOTTOM', 18, 9434, 149)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7555319259', 128, 87, 0, 10, 18, N'0/10/18', N'Lose', 200, N'UTILITY', 64, 7556, 150)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7555279076', 1, 83, 20, 3, 5, N'20/3/5', N'Win', 100, N'TOP', 11, 14710, 151)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7555279076', 129, 77, 7, 1, 19, N'7/1/19', N'Win', 100, N'JUNGLE', 14, 12518, 152)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7555279076', 130, 88, 3, 5, 4, N'3/5/4', N'Win', 100, N'MIDDLE', 12, 7161, 153)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7555279076', 131, 89, 11, 4, 9, N'11/4/9', N'Win', 100, N'BOTTOM', 9, 11330, 154)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7555279076', 132, 72, 3, 3, 17, N'3/3/17', N'Win', 100, N'UTILITY', 37, 8468, 155)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7555279076', 133, 20, 1, 8, 3, N'1/8/3', N'Lose', 200, N'TOP', 10, 6848, 156)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7555279076', 134, 21, 6, 10, 6, N'6/10/6', N'Lose', 200, N'JUNGLE', 18, 10713, 157)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7555279076', 135, 50, 3, 7, 4, N'3/7/4', N'Lose', 200, N'MIDDLE', 9, 8110, 158)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7555279076', 136, 14, 5, 10, 2, N'5/10/2', N'Lose', 200, N'BOTTOM', 8, 8890, 159)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7555279076', 137, 35, 1, 9, 6, N'1/9/6', N'Lose', 200, N'UTILITY', 27, 6395, 160)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7554682269', 138, 90, 3, 3, 2, N'3/3/2', N'Lose', 100, N'TOP', 16, 10525, 161)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7554682269', 139, 46, 2, 4, 3, N'2/4/3', N'Lose', 100, N'JUNGLE', 23, 9695, 162)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7554682269', 140, 13, 1, 1, 3, N'1/1/3', N'Lose', 100, N'MIDDLE', 20, 8894, 163)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7554682269', 141, 91, 5, 6, 4, N'5/6/4', N'Lose', 100, N'BOTTOM', 25, 11194, 164)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7554682269', 142, 87, 2, 5, 7, N'2/5/7', N'Lose', 100, N'UTILITY', 66, 7580, 165)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7554682269', 1, 83, 2, 4, 8, N'2/4/8', N'Win', 200, N'TOP', 21, 9517, 166)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7554682269', 143, 92, 5, 1, 6, N'5/1/6', N'Win', 200, N'JUNGLE', 40, 11590, 167)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7554682269', 144, 37, 4, 2, 6, N'4/2/6', N'Win', 200, N'MIDDLE', 19, 10683, 168)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7554682269', 145, 93, 4, 3, 10, N'4/3/10', N'Win', 200, N'BOTTOM', 13, 12474, 169)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7554682269', 28, 94, 4, 3, 13, N'4/3/13', N'Win', 200, N'UTILITY', 78, 8892, 170)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7554620738', 1, 83, 10, 4, 9, N'10/4/9', N'Win', 100, N'TOP', 16, 13050, 171)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7554620738', 146, 95, 10, 10, 13, N'10/10/13', N'Win', 100, N'JUNGLE', 18, 12507, 172)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7554620738', 147, 52, 10, 9, 7, N'10/9/7', N'Win', 100, N'MIDDLE', 19, 10941, 173)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7554620738', 148, 18, 10, 1, 12, N'10/1/12', N'Win', 100, N'BOTTOM', 26, 13430, 174)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7554620738', 28, 96, 5, 4, 22, N'5/4/22', N'Win', 100, N'UTILITY', 79, 11308, 175)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7554620738', 149, 80, 1, 8, 6, N'1/8/6', N'Lose', 200, N'TOP', 11, 8260, 176)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7554620738', 150, 97, 4, 9, 13, N'4/9/13', N'Lose', 200, N'JUNGLE', 13, 10410, 177)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7554620738', 151, 20, 7, 13, 5, N'7/13/5', N'Lose', 200, N'MIDDLE', 12, 11540, 178)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7554620738', 152, 98, 8, 5, 1, N'8/5/1', N'Lose', 200, N'BOTTOM', 12, 11340, 179)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7554620738', 153, 99, 8, 10, 14, N'8/10/14', N'Lose', 200, N'JUNGLE', 70, 10077, 180)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7553244863', 154, 59, 0, 2, 0, N'0/2/0', N'Lose', 100, N'TOP', 4, 4103, 181)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7553244863', 155, 100, 1, 4, 1, N'1/4/1', N'Lose', 100, N'JUNGLE', 15, 5141, 182)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7553244863', 156, 37, 1, 4, 0, N'1/4/0', N'Lose', 100, N'MIDDLE', 3, 4013, 183)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7553244863', 157, 23, 1, 4, 0, N'1/4/0', N'Lose', 100, N'BOTTOM', 10, 4677, 184)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7553244863', 158, 101, 0, 2, 1, N'0/2/1', N'Lose', 100, N'UTILITY', 17, 3503, 185)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7553244863', 1, 25, 2, 0, 0, N'2/0/0', N'Win', 200, N'TOP', 6, 5386, 186)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7553244863', 159, 74, 6, 0, 2, N'6/0/2', N'Win', 200, N'JUNGLE', 9, 7274, 187)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7553244863', 160, 15, 2, 2, 4, N'2/2/4', N'Win', 200, N'MIDDLE', 7, 6461, 188)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7553244863', 161, 14, 4, 1, 2, N'4/1/2', N'Win', 200, N'BOTTOM', 10, 6640, 189)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7553244863', 28, 87, 2, 0, 5, N'2/0/5', N'Win', 200, N'UTILITY', 25, 4889, 190)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7553188574', 1, 1, 7, 4, 5, N'7/4/5', N'Win', 100, N'TOP', 19, 14349, 191)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7553188574', 162, 21, 12, 3, 10, N'12/3/10', N'Win', 100, N'JUNGLE', 34, 15628, 192)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7553188574', 163, 40, 10, 9, 14, N'10/9/14', N'Win', 100, N'MIDDLE', 29, 12744, 193)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7553188574', 164, 102, 14, 7, 9, N'14/7/9', N'Win', 100, N'BOTTOM', 35, 14263, 194)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7553188574', 28, 94, 2, 2, 14, N'2/2/14', N'Win', 100, N'UTILITY', 82, 9735, 195)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7553188574', 165, 22, 9, 6, 5, N'9/6/5', N'Lose', 200, N'TOP', 18, 17194, 196)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7553188574', 166, 42, 7, 11, 7, N'7/11/7', N'Lose', 200, N'JUNGLE', 23, 11765, 197)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7553188574', 167, 103, 4, 12, 8, N'4/12/8', N'Lose', 200, N'MIDDLE', 18, 10632, 198)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7553188574', 168, 89, 3, 4, 8, N'3/4/8', N'Lose', 200, N'BOTTOM', 12, 10887, 199)
GO
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7553188574', 169, 39, 2, 12, 8, N'2/12/8', N'Lose', 200, N'UTILITY', 68, 8502, 200)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7553114006', 170, 1, 17, 13, 8, N'17/13/8', N'Lose', 100, N'TOP', 9, 16614, 201)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7553114006', 171, 81, 7, 12, 10, N'7/12/10', N'Lose', 100, N'JUNGLE', 23, 13132, 202)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7553114006', 172, 13, 10, 7, 7, N'10/7/7', N'Lose', 100, N'MIDDLE', 28, 13432, 203)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7553114006', 173, 93, 7, 7, 13, N'7/7/13', N'Lose', 100, N'BOTTOM', 19, 12443, 204)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7553114006', 174, 99, 3, 14, 15, N'3/14/15', N'Lose', 100, N'UTILITY', 41, 9850, 205)
INSERT [dbo].[Disputa] ([match_id], [player_id], [champion_id], [kills], [deaths], [assists], [kda], [resultado], [teamId], [role], [visionScore], [goldEarned], [participation_id]) VALUES (N'EUW1_7553114006', 1, 104, 9, 8, 19, N'9/8/19', N'Win', 200, N'TOP', 17, 13670, 206)਍䤀一匀䔀刀吀 嬀搀戀漀崀⸀嬀䐀椀猀瀀甀琀愀崀 ⠀嬀洀愀琀挀栀开椀搀崀Ⰰ 嬀瀀氀愀礀攀爀开椀搀崀Ⰰ 嬀挀栀愀洀瀀椀漀渀开椀搀崀Ⰰ 嬀欀椀氀氀猀崀Ⰰ 嬀搀攀愀琀栀猀崀Ⰰ 嬀愀猀猀椀猀琀猀崀Ⰰ 嬀欀搀愀崀Ⰰ 嬀爀攀猀甀氀琀愀搀漀崀Ⰰ 嬀琀攀愀洀䤀搀崀Ⰰ 嬀爀漀氀攀崀Ⰰ 嬀瘀椀猀椀漀渀匀挀漀爀攀崀Ⰰ 嬀最漀氀搀䔀愀爀渀攀搀崀Ⰰ 嬀瀀愀爀琀椀挀椀瀀愀琀椀漀渀开椀搀崀⤀ 嘀䄀䰀唀䔀匀 ⠀一✀䔀唀圀㄀开㜀㔀㔀㌀㄀㄀㐀　　㘀✀Ⰰ ㄀㜀㔀Ⰰ ㈀㄀Ⰰ ㄀㠀Ⰰ ㄀㄀Ⰰ ㄀㘀Ⰰ 一✀㄀㠀⼀㄀㄀⼀㄀㘀✀Ⰰ 一✀圀椀渀✀Ⰰ ㈀　　Ⰰ 一✀䨀唀一䜀䰀䔀✀Ⰰ ㄀㜀Ⰰ ㄀㤀㈀㄀㘀Ⰰ ㈀　㜀⤀ഀ਀䤀一匀䔀刀吀 嬀搀戀漀崀⸀嬀䐀椀猀瀀甀琀愀崀 ⠀嬀洀愀琀挀栀开椀搀崀Ⰰ 嬀瀀氀愀礀攀爀开椀搀崀Ⰰ 嬀挀栀愀洀瀀椀漀渀开椀搀崀Ⰰ 嬀欀椀氀氀猀崀Ⰰ 嬀搀攀愀琀栀猀崀Ⰰ 嬀愀猀猀椀猀琀猀崀Ⰰ 嬀欀搀愀崀Ⰰ 嬀爀攀猀甀氀琀愀搀漀崀Ⰰ 嬀琀攀愀洀䤀搀崀Ⰰ 嬀爀漀氀攀崀Ⰰ 嬀瘀椀猀椀漀渀匀挀漀爀攀崀Ⰰ 嬀最漀氀搀䔀愀爀渀攀搀崀Ⰰ 嬀瀀愀爀琀椀挀椀瀀愀琀椀漀渀开椀搀崀⤀ 嘀䄀䰀唀䔀匀 ⠀一✀䔀唀圀㄀开㜀㔀㔀㌀㄀㄀㐀　　㘀✀Ⰰ ㄀㜀㘀Ⰰ 㔀㈀Ⰰ ㄀㐀Ⰰ 㜀Ⰰ 㘀Ⰰ 一✀㄀㐀⼀㜀⼀㘀✀Ⰰ 一✀圀椀渀✀Ⰰ ㈀　　Ⰰ 一✀䴀䤀䐀䐀䰀䔀✀Ⰰ ㄀㐀Ⰰ ㄀㐀㌀㘀㘀Ⰰ ㈀　㠀⤀ഀ਀䤀一匀䔀刀吀 嬀搀戀漀崀⸀嬀䐀椀猀瀀甀琀愀崀 ⠀嬀洀愀琀挀栀开椀搀崀Ⰰ 嬀瀀氀愀礀攀爀开椀搀崀Ⰰ 嬀挀栀愀洀瀀椀漀渀开椀搀崀Ⰰ 嬀欀椀氀氀猀崀Ⰰ 嬀搀攀愀琀栀猀崀Ⰰ 嬀愀猀猀椀猀琀猀崀Ⰰ 嬀欀搀愀崀Ⰰ 嬀爀攀猀甀氀琀愀搀漀崀Ⰰ 嬀琀攀愀洀䤀搀崀Ⰰ 嬀爀漀氀攀崀Ⰰ 嬀瘀椀猀椀漀渀匀挀漀爀攀崀Ⰰ 嬀最漀氀搀䔀愀爀渀攀搀崀Ⰰ 嬀瀀愀爀琀椀挀椀瀀愀琀椀漀渀开椀搀崀⤀ 嘀䄀䰀唀䔀匀 ⠀一✀䔀唀圀㄀开㜀㔀㔀㌀㄀㄀㐀　　㘀✀Ⰰ ㄀㜀㜀Ⰰ 㜀㄀Ⰰ 㠀Ⰰ 㘀Ⰰ ㄀㐀Ⰰ 一✀㠀⼀㘀⼀㄀㐀✀Ⰰ 一✀圀椀渀✀Ⰰ ㈀　　Ⰰ 一✀䈀伀吀吀伀䴀✀Ⰰ ㄀㤀Ⰰ ㄀㔀㄀㈀㤀Ⰰ ㈀　㤀⤀ഀ਀䤀一匀䔀刀吀 嬀搀戀漀崀⸀嬀䐀椀猀瀀甀琀愀崀 ⠀嬀洀愀琀挀栀开椀搀崀Ⰰ 嬀瀀氀愀礀攀爀开椀搀崀Ⰰ 嬀挀栀愀洀瀀椀漀渀开椀搀崀Ⰰ 嬀欀椀氀氀猀崀Ⰰ 嬀搀攀愀琀栀猀崀Ⰰ 嬀愀猀猀椀猀琀猀崀Ⰰ 嬀欀搀愀崀Ⰰ 嬀爀攀猀甀氀琀愀搀漀崀Ⰰ 嬀琀攀愀洀䤀搀崀Ⰰ 嬀爀漀氀攀崀Ⰰ 嬀瘀椀猀椀漀渀匀挀漀爀攀崀Ⰰ 嬀最漀氀搀䔀愀爀渀攀搀崀Ⰰ 嬀瀀愀爀琀椀挀椀瀀愀琀椀漀渀开椀搀崀⤀ 嘀䄀䰀唀䔀匀 ⠀一✀䔀唀圀㄀开㜀㔀㔀㌀㄀㄀㐀　　㘀✀Ⰰ ㄀㜀㠀Ⰰ ㄀㔀Ⰰ 㐀Ⰰ ㄀㈀Ⰰ ㈀㘀Ⰰ 一✀㐀⼀㄀㈀⼀㈀㘀✀Ⰰ 一✀圀椀渀✀Ⰰ ㈀　　Ⰰ 一✀唀吀䤀䰀䤀吀夀✀Ⰰ 㔀㤀Ⰰ ㄀㄀　㘀㈀Ⰰ ㈀㄀　⤀ഀ਀䤀一匀䔀刀吀 嬀搀戀漀崀⸀嬀䐀椀猀瀀甀琀愀崀 ⠀嬀洀愀琀挀栀开椀搀崀Ⰰ 嬀瀀氀愀礀攀爀开椀搀崀Ⰰ 嬀挀栀愀洀瀀椀漀渀开椀搀崀Ⰰ 嬀欀椀氀氀猀崀Ⰰ 嬀搀攀愀琀栀猀崀Ⰰ 嬀愀猀猀椀猀琀猀崀Ⰰ 嬀欀搀愀崀Ⰰ 嬀爀攀猀甀氀琀愀搀漀崀Ⰰ 嬀琀攀愀洀䤀搀崀Ⰰ 嬀爀漀氀攀崀Ⰰ 嬀瘀椀猀椀漀渀匀挀漀爀攀崀Ⰰ 嬀最漀氀搀䔀愀爀渀攀搀崀Ⰰ 嬀瀀愀爀琀椀挀椀瀀愀琀椀漀渀开椀搀崀⤀ 嘀䄀䰀唀䔀匀 ⠀一✀䔀唀圀㄀开㜀㔀㔀㌀　㔀㌀㠀㈀㠀✀Ⰰ ㄀㜀㤀Ⰰ 㘀Ⰰ ㈀Ⰰ 㔀Ⰰ 　Ⰰ 一✀㈀⼀㔀⼀　✀Ⰰ 一✀䰀漀猀攀✀Ⰰ ㄀　　Ⰰ 一✀吀伀倀✀Ⰰ 㐀Ⰰ 㐀㐀　㈀Ⰰ ㈀㄀㄀⤀ഀ਀䤀一匀䔀刀吀 嬀搀戀漀崀⸀嬀䐀椀猀瀀甀琀愀崀 ⠀嬀洀愀琀挀栀开椀搀崀Ⰰ 嬀瀀氀愀礀攀爀开椀搀崀Ⰰ 嬀挀栀愀洀瀀椀漀渀开椀搀崀Ⰰ 嬀欀椀氀氀猀崀Ⰰ 嬀搀攀愀琀栀猀崀Ⰰ 嬀愀猀猀椀猀琀猀崀Ⰰ 嬀欀搀愀崀Ⰰ 嬀爀攀猀甀氀琀愀搀漀崀Ⰰ 嬀琀攀愀洀䤀搀崀Ⰰ 嬀爀漀氀攀崀Ⰰ 嬀瘀椀猀椀漀渀匀挀漀爀攀崀Ⰰ 嬀最漀氀搀䔀愀爀渀攀搀崀Ⰰ 嬀瀀愀爀琀椀挀椀瀀愀琀椀漀渀开椀搀崀⤀ 嘀䄀䰀唀䔀匀 ⠀一✀䔀唀圀㄀开㜀㔀㔀㌀　㔀㌀㠀㈀㠀✀Ⰰ ㄀㠀　Ⰰ 㐀㔀Ⰰ 　Ⰰ ㄀Ⰰ ㄀Ⰰ 一✀　⼀㄀⼀㄀✀Ⰰ 一✀䰀漀猀攀✀Ⰰ ㄀　　Ⰰ 一✀䨀唀一䜀䰀䔀✀Ⰰ 㐀Ⰰ ㌀㐀㄀㈀Ⰰ ㈀㄀㈀⤀ഀ਀䤀一匀䔀刀吀 嬀搀戀漀崀⸀嬀䐀椀猀瀀甀琀愀崀 ⠀嬀洀愀琀挀栀开椀搀崀Ⰰ 嬀瀀氀愀礀攀爀开椀搀崀Ⰰ 嬀挀栀愀洀瀀椀漀渀开椀搀崀Ⰰ 嬀欀椀氀氀猀崀Ⰰ 嬀搀攀愀琀栀猀崀Ⰰ 嬀愀猀猀椀猀琀猀崀Ⰰ 嬀欀搀愀崀Ⰰ 嬀爀攀猀甀氀琀愀搀漀崀Ⰰ 嬀琀攀愀洀䤀搀崀Ⰰ 嬀爀漀氀攀崀Ⰰ 嬀瘀椀猀椀漀渀匀挀漀爀攀崀Ⰰ 嬀最漀氀搀䔀愀爀渀攀搀崀Ⰰ 嬀瀀愀爀琀椀挀椀瀀愀琀椀漀渀开椀搀崀⤀ 嘀䄀䰀唀䔀匀 ⠀一✀䔀唀圀㄀开㜀㔀㔀㌀　㔀㌀㠀㈀㠀✀Ⰰ ㄀㠀㄀Ⰰ 㠀㠀Ⰰ 㔀Ⰰ ㄀Ⰰ 　Ⰰ 一✀㔀⼀㄀⼀　✀Ⰰ 一✀䰀漀猀攀✀Ⰰ ㄀　　Ⰰ 一✀䴀䤀䐀䐀䰀䔀✀Ⰰ 　Ⰰ 㐀㤀㈀㘀Ⰰ ㈀㄀㌀⤀ഀ਀䤀一匀䔀刀吀 嬀搀戀漀崀⸀嬀䐀椀猀瀀甀琀愀崀 ⠀嬀洀愀琀挀栀开椀搀崀Ⰰ 嬀瀀氀愀礀攀爀开椀搀崀Ⰰ 嬀挀栀愀洀瀀椀漀渀开椀搀崀Ⰰ 嬀欀椀氀氀猀崀Ⰰ 嬀搀攀愀琀栀猀崀Ⰰ 嬀愀猀猀椀猀琀猀崀Ⰰ 嬀欀搀愀崀Ⰰ 嬀爀攀猀甀氀琀愀搀漀崀Ⰰ 嬀琀攀愀洀䤀搀崀Ⰰ 嬀爀漀氀攀崀Ⰰ 嬀瘀椀猀椀漀渀匀挀漀爀攀崀Ⰰ 嬀最漀氀搀䔀愀爀渀攀搀崀Ⰰ 嬀瀀愀爀琀椀挀椀瀀愀琀椀漀渀开椀搀崀⤀ 嘀䄀䰀唀䔀匀 ⠀一✀䔀唀圀㄀开㜀㔀㔀㌀　㔀㌀㠀㈀㠀✀Ⰰ ㄀㠀㈀Ⰰ 㠀㤀Ⰰ ㄀Ⰰ ㈀Ⰰ 　Ⰰ 一✀㄀⼀㈀⼀　✀Ⰰ 一✀䰀漀猀攀✀Ⰰ ㄀　　Ⰰ 一✀䈀伀吀吀伀䴀✀Ⰰ 　Ⰰ ㈀㐀㜀㜀Ⰰ ㈀㄀㐀⤀ഀ਀䤀一匀䔀刀吀 嬀搀戀漀崀⸀嬀䐀椀猀瀀甀琀愀崀 ⠀嬀洀愀琀挀栀开椀搀崀Ⰰ 嬀瀀氀愀礀攀爀开椀搀崀Ⰰ 嬀挀栀愀洀瀀椀漀渀开椀搀崀Ⰰ 嬀欀椀氀氀猀崀Ⰰ 嬀搀攀愀琀栀猀崀Ⰰ 嬀愀猀猀椀猀琀猀崀Ⰰ 嬀欀搀愀崀Ⰰ 嬀爀攀猀甀氀琀愀搀漀崀Ⰰ 嬀琀攀愀洀䤀搀崀Ⰰ 嬀爀漀氀攀崀Ⰰ 嬀瘀椀猀椀漀渀匀挀漀爀攀崀Ⰰ 嬀最漀氀搀䔀愀爀渀攀搀崀Ⰰ 嬀瀀愀爀琀椀挀椀瀀愀琀椀漀渀开椀搀崀⤀ 嘀䄀䰀唀䔀匀 ⠀一✀䔀唀圀㄀开㜀㔀㔀㌀　㔀㌀㠀㈀㠀✀Ⰰ ㄀㠀㌀Ⰰ ㄀㘀Ⰰ 　Ⰰ 　Ⰰ ㄀Ⰰ 一✀　⼀　⼀㄀✀Ⰰ 一✀䰀漀猀攀✀Ⰰ ㄀　　Ⰰ 一✀唀吀䤀䰀䤀吀夀✀Ⰰ 㜀Ⰰ ㈀㜀㠀㠀Ⰰ ㈀㄀㔀⤀ഀ਀䤀一匀䔀刀吀 嬀搀戀漀崀⸀嬀䐀椀猀瀀甀琀愀崀 ⠀嬀洀愀琀挀栀开椀搀崀Ⰰ 嬀瀀氀愀礀攀爀开椀搀崀Ⰰ 嬀挀栀愀洀瀀椀漀渀开椀搀崀Ⰰ 嬀欀椀氀氀猀崀Ⰰ 嬀搀攀愀琀栀猀崀Ⰰ 嬀愀猀猀椀猀琀猀崀Ⰰ 嬀欀搀愀崀Ⰰ 嬀爀攀猀甀氀琀愀搀漀崀Ⰰ 嬀琀攀愀洀䤀搀崀Ⰰ 嬀爀漀氀攀崀Ⰰ 嬀瘀椀猀椀漀渀匀挀漀爀攀崀Ⰰ 嬀最漀氀搀䔀愀爀渀攀搀崀Ⰰ 嬀瀀愀爀琀椀挀椀瀀愀琀椀漀渀开椀搀崀⤀ 嘀䄀䰀唀䔀匀 ⠀一✀䔀唀圀㄀开㜀㔀㔀㌀　㔀㌀㠀㈀㠀✀Ⰰ ㄀Ⰰ ㄀Ⰰ 㔀Ⰰ ㈀Ⰰ ㄀Ⰰ 一✀㔀⼀㈀⼀㄀✀Ⰰ 一✀圀椀渀✀Ⰰ ㈀　　Ⰰ 一✀吀伀倀✀Ⰰ ㌀Ⰰ 㔀㠀　㜀Ⰰ ㈀㄀㘀⤀ഀ਀䤀一匀䔀刀吀 嬀搀戀漀崀⸀嬀䐀椀猀瀀甀琀愀崀 ⠀嬀洀愀琀挀栀开椀搀崀Ⰰ 嬀瀀氀愀礀攀爀开椀搀崀Ⰰ 嬀挀栀愀洀瀀椀漀渀开椀搀崀Ⰰ 嬀欀椀氀氀猀崀Ⰰ 嬀搀攀愀琀栀猀崀Ⰰ 嬀愀猀猀椀猀琀猀崀Ⰰ 嬀欀搀愀崀Ⰰ 嬀爀攀猀甀氀琀愀搀漀崀Ⰰ 嬀琀攀愀洀䤀搀崀Ⰰ 嬀爀漀氀攀崀Ⰰ 嬀瘀椀猀椀漀渀匀挀漀爀攀崀Ⰰ 嬀最漀氀搀䔀愀爀渀攀搀崀Ⰰ 嬀瀀愀爀琀椀挀椀瀀愀琀椀漀渀开椀搀崀⤀ 嘀䄀䰀唀䔀匀 ⠀一✀䔀唀圀㄀开㜀㔀㔀㌀　㔀㌀㠀㈀㠀✀Ⰰ ㄀㠀㐀Ⰰ 㔀㐀Ⰰ ㄀Ⰰ ㄀Ⰰ ㌀Ⰰ 一✀㄀⼀㄀⼀㌀✀Ⰰ 一✀圀椀渀✀Ⰰ ㈀　　Ⰰ 一✀䨀唀一䜀䰀䔀✀Ⰰ 㔀Ⰰ ㌀㠀㐀㐀Ⰰ ㈀㄀㜀⤀ഀ਀䤀一匀䔀刀吀 嬀搀戀漀崀⸀嬀䐀椀猀瀀甀琀愀崀 ⠀嬀洀愀琀挀栀开椀搀崀Ⰰ 嬀瀀氀愀礀攀爀开椀搀崀Ⰰ 嬀挀栀愀洀瀀椀漀渀开椀搀崀Ⰰ 嬀欀椀氀氀猀崀Ⰰ 嬀搀攀愀琀栀猀崀Ⰰ 嬀愀猀猀椀猀琀猀崀Ⰰ 嬀欀搀愀崀Ⰰ 嬀爀攀猀甀氀琀愀搀漀崀Ⰰ 嬀琀攀愀洀䤀搀崀Ⰰ 嬀爀漀氀攀崀Ⰰ 嬀瘀椀猀椀漀渀匀挀漀爀攀崀Ⰰ 嬀最漀氀搀䔀愀爀渀攀搀崀Ⰰ 嬀瀀愀爀琀椀挀椀瀀愀琀椀漀渀开椀搀崀⤀ 嘀䄀䰀唀䔀匀 ⠀一✀䔀唀圀㄀开㜀㔀㔀㌀　㔀㌀㠀㈀㠀✀Ⰰ ㄀㠀㔀Ⰰ 㔀㠀Ⰰ ㄀Ⰰ 㐀Ⰰ 　Ⰰ 一✀㄀⼀㐀⼀　✀Ⰰ 一✀圀椀渀✀Ⰰ ㈀　　Ⰰ 一✀䴀䤀䐀䐀䰀䔀✀Ⰰ ㄀Ⰰ ㌀㌀㤀　Ⰰ ㈀㄀㠀⤀ഀ਀䤀一匀䔀刀吀 嬀搀戀漀崀⸀嬀䐀椀猀瀀甀琀愀崀 ⠀嬀洀愀琀挀栀开椀搀崀Ⰰ 嬀瀀氀愀礀攀爀开椀搀崀Ⰰ 嬀挀栀愀洀瀀椀漀渀开椀搀崀Ⰰ 嬀欀椀氀氀猀崀Ⰰ 嬀搀攀愀琀栀猀崀Ⰰ 嬀愀猀猀椀猀琀猀崀Ⰰ 嬀欀搀愀崀Ⰰ 嬀爀攀猀甀氀琀愀搀漀崀Ⰰ 嬀琀攀愀洀䤀搀崀Ⰰ 嬀爀漀氀攀崀Ⰰ 嬀瘀椀猀椀漀渀匀挀漀爀攀崀Ⰰ 嬀最漀氀搀䔀愀爀渀攀搀崀Ⰰ 嬀瀀愀爀琀椀挀椀瀀愀琀椀漀渀开椀搀崀⤀ 嘀䄀䰀唀䔀匀 ⠀一✀䔀唀圀㄀开㜀㔀㔀㌀　㔀㌀㠀㈀㠀✀Ⰰ ㄀㠀㘀Ⰰ ㄀　㔀Ⰰ 　Ⰰ 　Ⰰ ㈀Ⰰ 一✀　⼀　⼀㈀✀Ⰰ 一✀圀椀渀✀Ⰰ ㈀　　Ⰰ 一✀䈀伀吀吀伀䴀✀Ⰰ 㔀Ⰰ ㌀㘀㐀㘀Ⰰ ㈀㄀㤀⤀ഀ਀䤀一匀䔀刀吀 嬀搀戀漀崀⸀嬀䐀椀猀瀀甀琀愀崀 ⠀嬀洀愀琀挀栀开椀搀崀Ⰰ 嬀瀀氀愀礀攀爀开椀搀崀Ⰰ 嬀挀栀愀洀瀀椀漀渀开椀搀崀Ⰰ 嬀欀椀氀氀猀崀Ⰰ 嬀搀攀愀琀栀猀崀Ⰰ 嬀愀猀猀椀猀琀猀崀Ⰰ 嬀欀搀愀崀Ⰰ 嬀爀攀猀甀氀琀愀搀漀崀Ⰰ 嬀琀攀愀洀䤀搀崀Ⰰ 嬀爀漀氀攀崀Ⰰ 嬀瘀椀猀椀漀渀匀挀漀爀攀崀Ⰰ 嬀最漀氀搀䔀愀爀渀攀搀崀Ⰰ 嬀瀀愀爀琀椀挀椀瀀愀琀椀漀渀开椀搀崀⤀ 嘀䄀䰀唀䔀匀 ⠀一✀䔀唀圀㄀开㜀㔀㔀㌀　㔀㌀㠀㈀㠀✀Ⰰ ㄀㠀㜀Ⰰ ㌀Ⰰ ㈀Ⰰ ㄀Ⰰ 　Ⰰ 一✀㈀⼀㄀⼀　✀Ⰰ 一✀圀椀渀✀Ⰰ ㈀　　Ⰰ 一✀唀吀䤀䰀䤀吀夀✀Ⰰ ㄀㄀Ⰰ ㌀㄀㔀㈀Ⰰ ㈀㈀　⤀ഀ਀䤀一匀䔀刀吀 嬀搀戀漀崀⸀嬀䐀椀猀瀀甀琀愀崀 ⠀嬀洀愀琀挀栀开椀搀崀Ⰰ 嬀瀀氀愀礀攀爀开椀搀崀Ⰰ 嬀挀栀愀洀瀀椀漀渀开椀搀崀Ⰰ 嬀欀椀氀氀猀崀Ⰰ 嬀搀攀愀琀栀猀崀Ⰰ 嬀愀猀猀椀猀琀猀崀Ⰰ 嬀欀搀愀崀Ⰰ 嬀爀攀猀甀氀琀愀搀漀崀Ⰰ 嬀琀攀愀洀䤀搀崀Ⰰ 嬀爀漀氀攀崀Ⰰ 嬀瘀椀猀椀漀渀匀挀漀爀攀崀Ⰰ 嬀最漀氀搀䔀愀爀渀攀搀崀Ⰰ 嬀瀀愀爀琀椀挀椀瀀愀琀椀漀渀开椀搀崀⤀ 嘀䄀䰀唀䔀匀 ⠀一✀䔀唀圀㄀开㜀㔀㔀㄀㤀㄀㌀㈀㤀　✀Ⰰ ㄀