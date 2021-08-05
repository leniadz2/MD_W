CREATE TABLE [ods].[GM_CLIENTE] (
  [document_type] [varchar](50) NULL,
  [document_number] [varchar](50) NULL,
  [first_name] [varchar](50) NULL,
  [second_name] [varchar](50) NULL,
  [first_surname] [varchar](50) NULL,
  [cellphone] [varchar](50) NULL,
  [email] [varchar](50) NULL,
  [affiliate_code] [varchar](50) NULL,
  [status] [varchar](50) NULL,
  [segmento] [varchar](50) NULL,
  [FECNACIMIENTO] [varchar](8) NOT NULL,
  [EDAD] [int] NULL,
  [DOCUMENTO] [varchar](3) NULL,
  [FECHA] [varchar](8) NOT NULL,
  [AFILIADOR] [varchar](2) NOT NULL,
  [HORA] [varchar](2) NULL,
  [MALL] [varchar](12) NULL,
  [GENERO] [varchar](11) NULL,
  [PERIODO] [varchar](6) NOT NULL,
  [INFOSALDO] [varchar](2) NOT NULL,
  [SALDO] [float] NULL
)
ON [PRIMARY]
GO