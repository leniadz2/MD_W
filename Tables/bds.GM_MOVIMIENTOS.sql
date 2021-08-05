CREATE TABLE [bds].[GM_MOVIMIENTOS] (
  [DATE] [varchar](50) NULL,
  [AMOUNT] [float] NULL,
  [COMMISSION] [float] NULL,
  [CANAL] [varchar](50) NULL,
  [ACTOR] [varchar](11) NOT NULL,
  [TIPO] [varchar](8) NOT NULL,
  [AMBITO] [varchar](7) NOT NULL,
  [SALDOBILL] [float] NULL,
  [SALDOTARJ] [float] NULL,
  [AFILIADO] [varchar](12) NULL,
  [PERIODO] [varchar](6) NOT NULL
)
ON [PRIMARY]
GO