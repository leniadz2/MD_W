SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [ods].[GM_CARGA]
AS
  /***************************************************************************************************
  Procedure:          ods.GM_CARGA
  Create Date:        20210805
  Author:             dÁlvarez
  Description:        todo el proceso de tablas GMONEY en ods
  Call by:            tbd
  Affected table(s):  varias
  Used By:            BI
  Parameter(s):       none
  Log:                none
  Prerequisites:      tbd
  ****************************************************************************************************
  SUMMARY OF CHANGES
  Date(YYYYMMDD)      Author              Comments
  ------------------- ------------------- ------------------------------------------------------------
  20210805            dÁlvarez            creación
  
  ***************************************************************************************************/

TRUNCATE TABLE ods.GM_SALDO;

INSERT INTO ods.GM_SALDO
SELECT CONCAT(RIGHT(CONCAT('00000000',NÚMERO_DE_DOCUMENTO),8),RIGHT(CONCAT('000000000',CELULAR),9)) AS DNI_CELULAR,
       CONCAT(SUBSTRING(FECHA_DE_NACIMIENTO,7,4),SUBSTRING(FECHA_DE_NACIMIENTO,1,2),SUBSTRING(FECHA_DE_NACIMIENTO,4,2)) AS FECNACIMIENTO,
       DATEDIFF(YY, CONVERT(DATETIME, CONCAT(SUBSTRING(FECHA_DE_NACIMIENTO,7,4),SUBSTRING(FECHA_DE_NACIMIENTO,1,2),SUBSTRING(FECHA_DE_NACIMIENTO,4,2))), GETDATE()) -
       CASE 
           WHEN DATEADD(YY,DATEDIFF(YY, CONVERT(DATETIME, CONCAT(SUBSTRING(FECHA_DE_NACIMIENTO,7,4),SUBSTRING(FECHA_DE_NACIMIENTO,1,2),SUBSTRING(FECHA_DE_NACIMIENTO,4,2))), GETDATE()),CONVERT(DATETIME, CONCAT(SUBSTRING(FECHA_DE_NACIMIENTO,7,4),SUBSTRING(FECHA_DE_NACIMIENTO,1,2),SUBSTRING(FECHA_DE_NACIMIENTO,4,2)))) > GETDATE() THEN 1
           ELSE 0
       END AS EDAD,
       CONVERT(float, SALDO_ACTUAL)*1.0 AS SALDO
  FROM stg.GM_CONC_SLD;


TRUNCATE TABLE ods.GM_CLIENTE;

INSERT INTO ods.GM_CLIENTE
SELECT gc.document_type   ,
       gc.document_number ,
       gc.first_name      ,
       gc.second_name     ,
       gc.first_surname   ,
       gc.cellphone       ,
       gc.email           ,
       gc.affiliate_code  ,
       gc.status          ,
       gc.segmento        ,
       CONCAT(SUBSTRING(RIGHT(CONCAT('0',birth_date),19),7,4),SUBSTRING(RIGHT(CONCAT('0',birth_date),19),1,2),SUBSTRING(RIGHT(CONCAT('0',birth_date),19),4,2)) AS FECNACIMIENTO,
       DATEDIFF(YY, CONVERT(DATETIME, CONCAT(SUBSTRING(RIGHT(CONCAT('0',birth_date),19),7,4),SUBSTRING(RIGHT(CONCAT('0',birth_date),19),1,2),SUBSTRING(RIGHT(CONCAT('0',birth_date),19),4,2))), GETDATE()) -
       CASE 
           WHEN DATEADD(YY,DATEDIFF(YY, CONVERT(DATETIME, CONCAT(SUBSTRING(RIGHT(CONCAT('0',birth_date),19),7,4),SUBSTRING(RIGHT(CONCAT('0',birth_date),19),1,2),SUBSTRING(RIGHT(CONCAT('0',birth_date),19),4,2))), GETDATE()),CONVERT(DATETIME, CONCAT(SUBSTRING(RIGHT(CONCAT('0',birth_date),19),7,4),SUBSTRING(RIGHT(CONCAT('0',birth_date),19),1,2),SUBSTRING(RIGHT(CONCAT('0',birth_date),19),4,2)))) > GETDATE() THEN 1
           ELSE 0
       END AS EDAD,
       CASE
         WHEN gc.document_type IS NULL THEN NULL
         WHEN gc.document_type = 'Documento Nacional de Identidad' THEN 'DNI'
       END AS DOCUMENTO,
       CONCAT(SUBSTRING(gc.created_at,7,4),SUBSTRING(gc.created_at,1,2),SUBSTRING(gc.created_at,4,2)) AS FECHA,
       IIF(gc.affiliate_code IS NULL,'NO','SI') AS AFILIADOR,
       SUBSTRING(gc.created_at,12,2) AS HORA,
       CASE
         WHEN gc.affiliate_code IS NULL THEN NULL
         WHEN LEFT(gc.affiliate_code,1) = 'S' THEN 'Mall del Sur'
         WHEN LEFT(gc.affiliate_code,1) = 'P' THEN 'Plaza Norte'
         ELSE 'Otros'
       END AS MALL,
       CASE
         WHEN gc.gender IS NULL THEN NULL
         WHEN gc.gender = '1' THEN 'Masculino'
         WHEN gc.gender = '0' THEN 'Femenino'
         ELSE 'Sin definir'
       END AS GENERO,
       CONCAT(SUBSTRING(gc.created_at,7,4),SUBSTRING(gc.created_at,1,2)) AS PERIODO,
       IIF(gs.SALDO IS NULL,'NO','SI') AS INFOSALDO,
       IIF(gs.SALDO IS NULL,0,gs.SALDO) AS SALDO
  FROM stg.GM_CUST gc 
         LEFT JOIN ods.GM_SALDO gs
           ON CONCAT(gc.DOCUMENT_NUMBER,gc.CELLPHONE) = gs.DNI_CELULAR

--SELECT COUNT(*) FROM stg.GM_CUST;--10075
--SELECT COUNT(*) FROM ods.GM_CLIENTE;--10493

TRUNCATE TABLE ods.GM_COMPRAS;

INSERT INTO ods.GM_COMPRAS
SELECT gs.Message_Type
      ,gs.Response_Code
      ,gs.Card_Acceptor_Location
      ,gs.Id_Canal
      ,gs.Institucion_Receptora
      ,gs.Codigo_Seguimiento
      ,gt.CELULAR AS TELEFONO
      ,gc.MALL AS MALL
      ,IIF(SUBSTRING(gs.Message_Type,1,4)='0400',CONVERT(float, gs.Transaction_Amount)*-1.0,CONVERT(float, gs.Transaction_Amount)*1.0) AS MONTO
      ,IIF(SUBSTRING(gs.Message_Type,1,4)='0400',-1,1) AS CONTADOR
      ,SUBSTRING(gs.Local_Transaction_Date,9,2) AS DIA
      ,CONCAT(SUBSTRING(gs.Local_Transaction_Date,1,4),SUBSTRING(gs.Local_Transaction_Date,6,2)) AS PERIODO
  FROM stg.GM_SWDM gs
         LEFT JOIN stg.GM_TARJ gt ON gs.Codigo_Seguimiento = gt.CODIGO_DE_SEGUIMIENTO
         LEFT JOIN ods.GM_CLIENTE gc ON RIGHT(gt.CELULAR,9) = gc.cellphone


TRUNCATE TABLE ods.GM_MOVIMIENTOS;

INSERT INTO ods.GM_MOVIMIENTOS
SELECT gcm.DATE,
       CONVERT(float, gcm.AMOUNT)*1.0 AS AMOUNT,
       CONVERT(float, gcm.COMMISSION)*1.0 AS COMMISSION,
       gcc.COD_CANAL AS CANAL,
       IIF(gcm.MERCHANT_CODE IS NULL,
           IIF(gcm.DESTINATION_MOBILE IS NULL,
               'A tarjeta',   
               IIF(SUBSTRING(gcm.DESTINATION_MOBILE,3,1) <> '0',
                   'A billetera',
                   IIF(LEFT(gcm.DESTINATION_MOBILE,2) = '51',
                       'A BCP',
                       'Prymera')
                  )
              ),
           'Locatario') AS ACTOR,
       CASE gcm.TRANSACTION_TYPE
         WHEN '1' THEN 'Cash Out'
         WHEN '2' THEN 'Cash In'
         ELSE 'P2P'
       END AS TIPO,
       IIF(gcm.MERCHANT_CODE IS NULL,
           IIF(gcm.DESTINATION_MOBILE IS NULL,
               'Interno',   
               'Externo'
              ),
           'Externo') AS AMBITO,
       gc.MALL AS AFILIADO,
       CONCAT(SUBSTRING(DATE,7,4),SUBSTRING(DATE,1,2)) AS PERIODO
  FROM stg.GM_CONC_MOV gcm
         LEFT JOIN stg.GM_CONC_CNL gcc ON gcm.TRANSACTION_ID = gcc.REF_NUMBER
         LEFT JOIN ods.GM_CLIENTE gc ON RIGHT(gcm.MOBILE_NUMBER,9) = gc.cellphone;

GO