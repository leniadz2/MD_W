CREATE TABLE [bds].[GM_CLIENTE] (
  [document_type] [varchar](50) NULL,
  [document_number] [varchar](50) NULL,
  [first_name] [varchar](50) NULL,
  [second_name] [varchar](50) NULL,
  [first_surname] [varchar](50) NULL,
  [cellphone] [varchar](50) NULL,
  [email] [varchar](50) NULL,
  [affiliate_code] [varchar](50) NULL,
  [status] [varchar](50) NULL,
  [HABILITADO_RECARGA] [varchar](50) NULL,
  [segmento] [varchar](50) NULL,
  [FECNACIMIENTO] [varchar](8) NOT NULL,
  [EDAD] [int] NULL,
  [RANGOEDAD] [varchar](14) NOT NULL,
  [FECHA] [varchar](8) NOT NULL,
  [DOCUMENTO] [varchar](3) NULL,
  [AFILIADOR] [varchar](2) NOT NULL,
  [SALDO] [float] NULL,
  [INFOSALDO] [varchar](2) NOT NULL,
  [HORA] [varchar](2) NULL,
  [MALL] [varchar](12) NULL,
  [GENERO] [varchar](11) NULL,
  [PERIODO] [varchar](6) NOT NULL
)
ON [PRIMARY]
GO