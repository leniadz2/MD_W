SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [stg].[GM_CARGA]
AS
  /***************************************************************************************************
  Procedure:          stg.GM_CARGA
  Create Date:        20210805
  Author:             dÁlvarez
  Description:        todo el proceso de tablas GMONEY en stg
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

/*GM_SWDM
  acumulado mes*/
DELETE MD_W.stg.GM_SWDM
  WHERE Local_Transaction_Date LIKE CONCAT(LEFT(CONVERT(VARCHAR, GETDATE(), 23),7),'%');
  --WHERE Local_Transaction_Date LIKE '2021-08%';

/*GM_CONC_SLD
  acumulado total*/
TRUNCATE TABLE stg.GM_CONC_SLD;

/*GM_CONC_MOV
  solo el día*/

/*GM_CONC_CNL
  solo el día*/

/*GM_TARJ
  acumulado total*/
TRUNCATE TABLE stg.GM_TARJ;

/*GM_CUST
  acumulado total*/
TRUNCATE TABLE stg.GM_CUST;

GO