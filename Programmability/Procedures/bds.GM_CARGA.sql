SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [bds].[GM_CARGA]
AS
  /***************************************************************************************************
  Procedure:          bds.GM_CARGA
  Create Date:        20210805
  Author:             dÁlvarez
  Description:        todo el proceso de tablas GMONEY en bds
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
  20210809            dÁlvarez            ajustes
  
  ***************************************************************************************************/

TRUNCATE TABLE bds.GM_CLIENTE;

INSERT INTO bds.GM_CLIENTE
SELECT DISTINCT
       document_type
      ,document_number
      ,first_name
      ,second_name
      ,first_surname
      ,cellphone
      ,email
      ,affiliate_code
      ,status
      ,HABILITADO_RECARGA
      --,segmento
      ,CASE 
         WHEN EDAD >=  0 AND EDAD < 18 THEN '0'
         WHEN EDAD >= 18 AND EDAD < 21 THEN 'A'
         WHEN EDAD >= 21 AND EDAD < 26 THEN 'B'
         WHEN EDAD >= 26 AND EDAD < 31 THEN 'C'
         WHEN EDAD >= 31 AND EDAD < 41 THEN 'D'
         WHEN EDAD >= 41 AND EDAD < 51 THEN 'E'
         WHEN EDAD >= 51 AND EDAD < 61 THEN 'F'
         WHEN EDAD >= 61 AND EDAD < 99 THEN 'G'
         ELSE 'No definido'      
       END AS SEGMENTO
      ,FECNACIMIENTO
      ,EDAD
      ,CASE 
         WHEN EDAD >=  0 AND EDAD < 18 THEN '00.0   [---17['
         WHEN EDAD >= 18 AND EDAD < 21 THEN '18.0   [18-20['
         WHEN EDAD >= 21 AND EDAD < 26 THEN '21.0   [21-25['
         WHEN EDAD >= 26 AND EDAD < 31 THEN '26.0   [26-30['
         WHEN EDAD >= 31 AND EDAD < 41 THEN '31.0   [31-40['
         WHEN EDAD >= 41 AND EDAD < 51 THEN '41.0   [41-50['
         WHEN EDAD >= 51 AND EDAD < 61 THEN '51.0   [51-60['
         WHEN EDAD >= 61 AND EDAD < 99 THEN '61.0   [61-++['
         ELSE 'No definido'      
       END AS RANGOEDAD
      ,FECHA
      ,DOCUMENTO
      ,AFILIADOR
      ,SALDO
      ,INFOSALDO
      ,HORAHH AS HORA
      ,ISNULL(MALL,'Otros')
      ,GENERO
      ,PERIODO
  FROM ods.GM_CLIENTE;

TRUNCATE TABLE bds.GM_MOVIMIENTOS;

INSERT INTO bds.GM_MOVIMIENTOS
SELECT gm.DATE
      ,gm.AMOUNT
      ,gm.COMMISSION
      ,gm.CANAL
      ,gm.ACTOR
      ,gm.TIPO
      ,gm.AMBITO
      ,IIF(gm.AMBITO = 'Externo',IIF(gm.TIPO = 'Cash In',AMOUNT-COMMISSION,-AMOUNT),IIF(gm.TIPO = 'Cash In',AMOUNT,-AMOUNT)) AS SALDOBILL
      ,IIF(gm.AMBITO = 'Externo',IIF(gm.TIPO = 'Cash In',AMOUNT,-AMOUNT),IIF(gm.TIPO = 'Cash In',-AMOUNT-COMMISSION,0)) AS SALDOTARJ
      ,ISNULL(gm.AFILIADO,'Otros')
      ,gm.PERIODO
  FROM ods.GM_MOVIMIENTOS gm;

TRUNCATE TABLE bds.GM_COMPRAS;

INSERT INTO bds.GM_COMPRAS
SELECT gc.Message_Type
      ,gc.Response_Code
      ,gc.Card_Acceptor_Location
      ,gc.Id_Canal
      ,gc.Institucion_Receptora
      ,gc.Codigo_Seguimiento
      ,gc.TELEFONO
      ,ISNULL(gc.MALL,'Otros')
      ,gc.MONTO
      ,gc.CONTADOR
      ,gc.DIA
      ,gc.PERIODO
  FROM ods.GM_COMPRAS gc;

GO