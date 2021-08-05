CREATE TABLE [ods].[GM_COMPRAS] (
  [Message_Type] [varchar](50) NULL,
  [Response_Code] [varchar](50) NULL,
  [Card_Acceptor_Location] [varchar](100) NULL,
  [Id_Canal] [varchar](50) NULL,
  [Institucion_Receptora] [varchar](50) NULL,
  [Codigo_Seguimiento] [varchar](50) NULL,
  [TELEFONO] [varchar](50) NULL,
  [MALL] [varchar](12) NULL,
  [MONTO] [float] NULL,
  [CONTADOR] [int] NOT NULL,
  [DIA] [varchar](2) NULL,
  [PERIODO] [varchar](6) NOT NULL
)
ON [PRIMARY]
GO