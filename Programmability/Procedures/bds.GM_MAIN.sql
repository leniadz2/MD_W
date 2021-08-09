SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [bds].[GM_MAIN]
AS
  /***************************************************************************************************
  Procedure:          bds.GM_MAIN
  Create Date:        20210809
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
  20210809            dÁlvarez            creación
  
  ***************************************************************************************************/
EXEC ods.GM_CARGA;
EXEC bds.GM_CARGA;

GO