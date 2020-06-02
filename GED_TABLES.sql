--------------------------------------------------------
--  File created - Tuesday-June-02-2020   
--------------------------------------------------------
DROP TABLE "HR"."GED_ANN_DOC";
DROP TABLE "HR"."GED_ANN_TYPE";
DROP TABLE "HR"."GED_CARA";
DROP TABLE "HR"."GED_CARA_DOC_BIN";
DROP TABLE "HR"."GED_CLIENTS";
DROP TABLE "HR"."GED_DOC_BIN";
DROP TABLE "HR"."GED_FICHE_DOC_BIN";
DROP TABLE "HR"."GED_REFE";
DROP TABLE "HR"."GED_REFE_DOC_BIN";
DROP TABLE "HR"."GED_STRUCTURE_ARCH";
DROP TABLE "HR"."GED_TYPE";
DROP TABLE "HR"."GED_TYPE_DOC_BIN";
DROP TABLE "HR"."WEB_LOGS";
--------------------------------------------------------
--  DDL for Table GED_ANN_DOC
--------------------------------------------------------

  CREATE TABLE "HR"."GED_ANN_DOC" 
   (	"CODETYPAN" VARCHAR2(20 BYTE), 
	"TEXTANNO" VARCHAR2(300 BYTE), 
	"DATEANNO" DATE, 
	"IDEDOCBI" NUMBER(10,0)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
--------------------------------------------------------
--  DDL for Table GED_ANN_TYPE
--------------------------------------------------------

  CREATE TABLE "HR"."GED_ANN_TYPE" 
   (	"CODETYPAN" VARCHAR2(20 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
--------------------------------------------------------
--  DDL for Table GED_CARA
--------------------------------------------------------

  CREATE TABLE "HR"."GED_CARA" 
   (	"CODECARA" VARCHAR2(20 BYTE), 
	"IDETYPDO" VARCHAR2(20 BYTE), 
	"VALECARA" VARCHAR2(40 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
--------------------------------------------------------
--  DDL for Table GED_CARA_DOC_BIN
--------------------------------------------------------

  CREATE TABLE "HR"."GED_CARA_DOC_BIN" 
   (	"CODECARA" VARCHAR2(20 BYTE), 
	"LIBECARA" VARCHAR2(700 BYTE), 
	"TYPECARA" VARCHAR2(20 BYTE), 
	"DEFAVALE" VARCHAR2(20 BYTE), 
	"CARAOBLI" VARCHAR2(20 BYTE), 
	"ORDECARA" NUMBER, 
	"NOM_TABL" VARCHAR2(20 BYTE), 
	"COLO_CLE" VARCHAR2(20 BYTE), 
	"COLOLIBL" VARCHAR2(20 BYTE), 
	"POIDCARA" NUMBER, 
	"IDEDOCBI" NUMBER(10,0)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
--------------------------------------------------------
--  DDL for Table GED_CLIENTS
--------------------------------------------------------

  CREATE TABLE "HR"."GED_CLIENTS" 
   (	"IDCLIENT" NUMBER, 
	"PRENOM" VARCHAR2(20 BYTE), 
	"NOM" VARCHAR2(20 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
--------------------------------------------------------
--  DDL for Table GED_DOC_BIN
--------------------------------------------------------

  CREATE TABLE "HR"."GED_DOC_BIN" 
   (	"IDEDOCBI" NUMBER(10,0), 
	"LOBDOCBI" BLOB, 
	"IDCLIENT" NUMBER
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" 
 LOB ("LOBDOCBI") STORE AS BASICFILE (
  TABLESPACE "USERS" ENABLE STORAGE IN ROW CHUNK 8192 RETENTION 
  NOCACHE LOGGING 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)) ;
--------------------------------------------------------
--  DDL for Table GED_FICHE_DOC_BIN
--------------------------------------------------------

  CREATE TABLE "HR"."GED_FICHE_DOC_BIN" 
   (	"DESDOCBI" VARCHAR2(20 BYTE), 
	"EXTDOCBI" VARCHAR2(20 BYTE), 
	"CLEDOSAR" VARCHAR2(80 BYTE), 
	"SOUDOCBI" VARCHAR2(20 BYTE), 
	"AUTDOCBI" VARCHAR2(20 BYTE), 
	"DATDOCBI" DATE, 
	"REFDOCBI" VARCHAR2(20 BYTE), 
	"DATERECE" DATE, 
	"VERDOCBI" VARCHAR2(20 BYTE), 
	"RESDOCBI" VARCHAR2(200 BYTE), 
	"NOMBPAGE" NUMBER, 
	"DATEENTR" DATE, 
	"DATETYPA" DATE, 
	"DATECLAS" DATE, 
	"IDEDOCBI" NUMBER(10,0)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
--------------------------------------------------------
--  DDL for Table GED_REFE
--------------------------------------------------------

  CREATE TABLE "HR"."GED_REFE" 
   (	"IDETYPDO" VARCHAR2(20 BYTE), 
	"MOT_CLE" VARCHAR2(20 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
--------------------------------------------------------
--  DDL for Table GED_REFE_DOC_BIN
--------------------------------------------------------

  CREATE TABLE "HR"."GED_REFE_DOC_BIN" 
   (	"MOT_CLE" VARCHAR2(20 BYTE), 
	"IDEDOCBI" NUMBER(10,0)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
--------------------------------------------------------
--  DDL for Table GED_STRUCTURE_ARCH
--------------------------------------------------------

  CREATE TABLE "HR"."GED_STRUCTURE_ARCH" 
   (	"IDENDOSS" VARCHAR2(50 BYTE), 
	"IDEDOSPA" VARCHAR2(50 BYTE), 
	"DESIDOSS" VARCHAR2(50 BYTE), 
	"ORDRAFFI" NUMBER(3,0), 
	"TYPEDOSS" CHAR(2 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
--------------------------------------------------------
--  DDL for Table GED_TYPE
--------------------------------------------------------

  CREATE TABLE "HR"."GED_TYPE" 
   (	"IDETYPDO" VARCHAR2(20 BYTE), 
	"LIBTYPDO" VARCHAR2(20 BYTE), 
	"NOTITYPE" VARCHAR2(20 BYTE), 
	"TEXTNOTI" VARCHAR2(20 BYTE), 
	"NOTI_SMS" VARCHAR2(20 BYTE), 
	"NOTI_MAIL" VARCHAR2(20 BYTE), 
	"NOTI_MSG" VARCHAR2(20 BYTE), 
	"ALERCLAS" VARCHAR2(20 BYTE), 
	"DELALECL" NUMBER
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
  GRANT DELETE, INSERT, SELECT, UPDATE ON "HR"."GED_TYPE" TO "ACHRAF";
--------------------------------------------------------
--  DDL for Table GED_TYPE_DOC_BIN
--------------------------------------------------------

  CREATE TABLE "HR"."GED_TYPE_DOC_BIN" 
   (	"TYPE_DOC" VARCHAR2(20 BYTE), 
	"IDEDOCBI" NUMBER(10,0)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
--------------------------------------------------------
--  DDL for Table WEB_LOGS
--------------------------------------------------------

  CREATE TABLE "HR"."WEB_LOGS" 
   (	"MESS_UID" RAW(32), 
	"MESS_CLT" VARCHAR2(600 BYTE), 
	"MESSERRO" VARCHAR2(1000 BYTE), 
	"TYPEMESS" VARCHAR2(2 BYTE), 
	"OWNER_NAME" VARCHAR2(30 BYTE), 
	"CALLER_NAME" VARCHAR2(30 BYTE), 
	"LINE_NUMBER" NUMBER, 
	"CALLER_TYPE" VARCHAR2(100 BYTE), 
	"DATEERRO" DATE DEFAULT sysdate, 
	"CREATEBY" VARCHAR2(30 BYTE) DEFAULT upper(user)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
--------------------------------------------------------
--  DDL for Sequence GED_CLIENTS_SEQ
--------------------------------------------------------

   CREATE SEQUENCE  "HR"."GED_CLIENTS_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 132 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence GED_DOC_BIN_SEQ
--------------------------------------------------------

   CREATE SEQUENCE  "HR"."GED_DOC_BIN_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 489 CACHE 20 NOORDER  NOCYCLE ;
REM INSERTING into HR.GED_ANN_DOC
SET DEFINE OFF;
Insert into HR.GED_ANN_DOC (CODETYPAN,TEXTANNO,DATEANNO,IDEDOCBI) values ('Avis','C''est mon avis',to_date('26-MAY-20','DD-MON-RR'),487);
Insert into HR.GED_ANN_DOC (CODETYPAN,TEXTANNO,DATEANNO,IDEDOCBI) values ('Decision','Bonne d�cision',to_date('25-MAY-20','DD-MON-RR'),484);
Insert into HR.GED_ANN_DOC (CODETYPAN,TEXTANNO,DATEANNO,IDEDOCBI) values ('Avis','C''est mon avis',to_date('26-MAY-20','DD-MON-RR'),486);
Insert into HR.GED_ANN_DOC (CODETYPAN,TEXTANNO,DATEANNO,IDEDOCBI) values ('Confirmation','Bonne confirmation',to_date('25-MAY-20','DD-MON-RR'),484);
REM INSERTING into HR.GED_ANN_TYPE
SET DEFINE OFF;
Insert into HR.GED_ANN_TYPE (CODETYPAN) values ('Avis');
Insert into HR.GED_ANN_TYPE (CODETYPAN) values ('Confirmation');
Insert into HR.GED_ANN_TYPE (CODETYPAN) values ('Decision');
Insert into HR.GED_ANN_TYPE (CODETYPAN) values ('Refus');
REM INSERTING into HR.GED_CARA
SET DEFINE OFF;
Insert into HR.GED_CARA (CODECARA,IDETYPDO,VALECARA) values ('DTVAL','CN','Date de validit�');
Insert into HR.GED_CARA (CODECARA,IDETYPDO,VALECARA) values ('VIC','CN','Ville Carte Nationale');
Insert into HR.GED_CARA (CODECARA,IDETYPDO,VALECARA) values ('PAC','CN','Pays Carte Nationale');
Insert into HR.GED_CARA (CODECARA,IDETYPDO,VALECARA) values ('NUP','PMC','Numero Permis');
Insert into HR.GED_CARA (CODECARA,IDETYPDO,VALECARA) values ('VIP','PMC','Ville Permis');
Insert into HR.GED_CARA (CODECARA,IDETYPDO,VALECARA) values ('CAT','PMC','Categorie Permis');
Insert into HR.GED_CARA (CODECARA,IDETYPDO,VALECARA) values ('NCIN','CS','Num�ro Carte Identit� Nationale');
Insert into HR.GED_CARA (CODECARA,IDETYPDO,VALECARA) values ('CNE','CS','Code National Etudiant');
Insert into HR.GED_CARA (CODECARA,IDETYPDO,VALECARA) values ('DIP','CS','Diplome Etudiant');
Insert into HR.GED_CARA (CODECARA,IDETYPDO,VALECARA) values ('ADR','CN','Adresse');
Insert into HR.GED_CARA (CODECARA,IDETYPDO,VALECARA) values ('DTN','CN','Date de naissance');
Insert into HR.GED_CARA (CODECARA,IDETYPDO,VALECARA) values ('LN','CN','Lieu de naissance');
REM INSERTING into HR.GED_CARA_DOC_BIN
SET DEFINE OFF;
REM INSERTING into HR.GED_CLIENTS
SET DEFINE OFF;
Insert into HR.GED_CLIENTS (IDCLIENT,PRENOM,NOM) values (131,'khalaf','bouhmadi');
Insert into HR.GED_CLIENTS (IDCLIENT,PRENOM,NOM) values (130,'achraf','zeroual');
REM INSERTING into HR.GED_DOC_BIN
SET DEFINE OFF;
Insert into HR.GED_DOC_BIN (IDEDOCBI,IDCLIENT) values (488,null);
Insert into HR.GED_DOC_BIN (IDEDOCBI,IDCLIENT) values (486,131);
Insert into HR.GED_DOC_BIN (IDEDOCBI,IDCLIENT) values (484,130);
Insert into HR.GED_DOC_BIN (IDEDOCBI,IDCLIENT) values (483,131);
Insert into HR.GED_DOC_BIN (IDEDOCBI,IDCLIENT) values (487,130);
REM INSERTING into HR.GED_FICHE_DOC_BIN
SET DEFINE OFF;
Insert into HR.GED_FICHE_DOC_BIN (DESDOCBI,EXTDOCBI,CLEDOSAR,SOUDOCBI,AUTDOCBI,DATDOCBI,REFDOCBI,DATERECE,VERDOCBI,RESDOCBI,NOMBPAGE,DATEENTR,DATETYPA,DATECLAS,IDEDOCBI) values ('logo_void','.pdf','zeroual#130:logo_void','Source 1','achraf',to_date('26-MAY-20','DD-MON-RR'),'Ref 1',to_date('26-MAY-20','DD-MON-RR'),'Version 1','ssssssssssssssss',1,to_date('26-MAY-20','DD-MON-RR'),to_date('26-MAY-20','DD-MON-RR'),to_date('26-MAY-20','DD-MON-RR'),487);
Insert into HR.GED_FICHE_DOC_BIN (DESDOCBI,EXTDOCBI,CLEDOSAR,SOUDOCBI,AUTDOCBI,DATDOCBI,REFDOCBI,DATERECE,VERDOCBI,RESDOCBI,NOMBPAGE,DATEENTR,DATETYPA,DATECLAS,IDEDOCBI) values ('bac_document','.pdf','bouhmadi#131:bac_document','Source 1','achraf',to_date('25-MAY-20','DD-MON-RR'),'Ref 1',to_date('25-MAY-20','DD-MON-RR'),'Version 1','qqqqqqqqqqqqqqqqqqqqq',1,to_date('25-MAY-20','DD-MON-RR'),to_date('25-MAY-20','DD-MON-RR'),to_date('25-MAY-20','DD-MON-RR'),486);
Insert into HR.GED_FICHE_DOC_BIN (DESDOCBI,EXTDOCBI,CLEDOSAR,SOUDOCBI,AUTDOCBI,DATDOCBI,REFDOCBI,DATERECE,VERDOCBI,RESDOCBI,NOMBPAGE,DATEENTR,DATETYPA,DATECLAS,IDEDOCBI) values ('couverture_medicale','.pdf','zeroual#130:couverture_medicale','Source 1','achraf',to_date('25-MAY-20','DD-MON-RR'),'Ref 1',to_date('25-MAY-20','DD-MON-RR'),'Version 1','kkkkkkkkkkkkkkkk',1,to_date('25-MAY-20','DD-MON-RR'),to_date('25-MAY-20','DD-MON-RR'),to_date('25-MAY-20','DD-MON-RR'),484);
Insert into HR.GED_FICHE_DOC_BIN (DESDOCBI,EXTDOCBI,CLEDOSAR,SOUDOCBI,AUTDOCBI,DATDOCBI,REFDOCBI,DATERECE,VERDOCBI,RESDOCBI,NOMBPAGE,DATEENTR,DATETYPA,DATECLAS,IDEDOCBI) values ('curicculum_vitae','.pdf','orsys#:curicculum_vitae','Source 1','Achraf',to_date('26-MAY-20','DD-MON-RR'),'Ref 1',to_date('26-MAY-20','DD-MON-RR'),'Version 1','oooooooooooooooooooooo',1,to_date('26-MAY-20','DD-MON-RR'),to_date('02-JUN-20','DD-MON-RR'),to_date('02-JUN-20','DD-MON-RR'),488);
Insert into HR.GED_FICHE_DOC_BIN (DESDOCBI,EXTDOCBI,CLEDOSAR,SOUDOCBI,AUTDOCBI,DATDOCBI,REFDOCBI,DATERECE,VERDOCBI,RESDOCBI,NOMBPAGE,DATEENTR,DATETYPA,DATECLAS,IDEDOCBI) values ('carte_nationale','.pdf','bouhmadi#131:carte_nationale','Source 1','achraf',to_date('25-MAY-20','DD-MON-RR'),'Ref 1',to_date('25-MAY-20','DD-MON-RR'),'Version 1','lllllllllllllllllllllllllllllllllllllll',1,to_date('25-MAY-20','DD-MON-RR'),to_date('25-MAY-20','DD-MON-RR'),to_date('25-MAY-20','DD-MON-RR'),483);
REM INSERTING into HR.GED_REFE
SET DEFINE OFF;
Insert into HR.GED_REFE (IDETYPDO,MOT_CLE) values ('CN','CIN');
Insert into HR.GED_REFE (IDETYPDO,MOT_CLE) values ('CS','CNE');
Insert into HR.GED_REFE (IDETYPDO,MOT_CLE) values ('CN','carte');
Insert into HR.GED_REFE (IDETYPDO,MOT_CLE) values ('CN','carte nationale');
Insert into HR.GED_REFE (IDETYPDO,MOT_CLE) values ('CN','cart');
Insert into HR.GED_REFE (IDETYPDO,MOT_CLE) values ('CS','certificat');
Insert into HR.GED_REFE (IDETYPDO,MOT_CLE) values ('CS','scolarit�');
Insert into HR.GED_REFE (IDETYPDO,MOT_CLE) values ('CV','curriculum');
Insert into HR.GED_REFE (IDETYPDO,MOT_CLE) values ('CV','curriculum  vitae');
REM INSERTING into HR.GED_REFE_DOC_BIN
SET DEFINE OFF;
Insert into HR.GED_REFE_DOC_BIN (MOT_CLE,IDEDOCBI) values ('curriculum',487);
Insert into HR.GED_REFE_DOC_BIN (MOT_CLE,IDEDOCBI) values ('curriculum  vitae',487);
Insert into HR.GED_REFE_DOC_BIN (MOT_CLE,IDEDOCBI) values ('CIN',483);
Insert into HR.GED_REFE_DOC_BIN (MOT_CLE,IDEDOCBI) values ('carte',483);
Insert into HR.GED_REFE_DOC_BIN (MOT_CLE,IDEDOCBI) values ('carte nationale',483);
Insert into HR.GED_REFE_DOC_BIN (MOT_CLE,IDEDOCBI) values ('cart',483);
Insert into HR.GED_REFE_DOC_BIN (MOT_CLE,IDEDOCBI) values ('curriculum',488);
Insert into HR.GED_REFE_DOC_BIN (MOT_CLE,IDEDOCBI) values ('curriculum  vitae',488);
REM INSERTING into HR.GED_STRUCTURE_ARCH
SET DEFINE OFF;
Insert into HR.GED_STRUCTURE_ARCH (IDENDOSS,IDEDOSPA,DESIDOSS,ORDRAFFI,TYPEDOSS) values ('bouhmadi#131',null,'bouhmadi#131',null,'S ');
Insert into HR.GED_STRUCTURE_ARCH (IDENDOSS,IDEDOSPA,DESIDOSS,ORDRAFFI,TYPEDOSS) values ('orsys#',null,'orsys',null,'S ');
Insert into HR.GED_STRUCTURE_ARCH (IDENDOSS,IDEDOSPA,DESIDOSS,ORDRAFFI,TYPEDOSS) values ('zeroual#130',null,'zeroual#130',null,'S ');
REM INSERTING into HR.GED_TYPE
SET DEFINE OFF;
Insert into HR.GED_TYPE (IDETYPDO,LIBTYPDO,NOTITYPE,TEXTNOTI,NOTI_SMS,NOTI_MAIL,NOTI_MSG,ALERCLAS,DELALECL) values ('PMC','Permis de conduite',null,null,null,null,null,null,null);
Insert into HR.GED_TYPE (IDETYPDO,LIBTYPDO,NOTITYPE,TEXTNOTI,NOTI_SMS,NOTI_MAIL,NOTI_MSG,ALERCLAS,DELALECL) values ('CV','Curicculum Vitae',null,null,null,null,null,null,null);
Insert into HR.GED_TYPE (IDETYPDO,LIBTYPDO,NOTITYPE,TEXTNOTI,NOTI_SMS,NOTI_MAIL,NOTI_MSG,ALERCLAS,DELALECL) values ('CG','Carte Grise',null,null,null,null,null,null,null);
Insert into HR.GED_TYPE (IDETYPDO,LIBTYPDO,NOTITYPE,TEXTNOTI,NOTI_SMS,NOTI_MAIL,NOTI_MSG,ALERCLAS,DELALECL) values ('CS','Certificat Scolarit�',null,null,null,null,null,null,null);
Insert into HR.GED_TYPE (IDETYPDO,LIBTYPDO,NOTITYPE,TEXTNOTI,NOTI_SMS,NOTI_MAIL,NOTI_MSG,ALERCLAS,DELALECL) values ('CN','Carte Nationale',null,null,null,null,null,null,null);
REM INSERTING into HR.GED_TYPE_DOC_BIN
SET DEFINE OFF;
Insert into HR.GED_TYPE_DOC_BIN (TYPE_DOC,IDEDOCBI) values ('Curicculum Vitae',487);
Insert into HR.GED_TYPE_DOC_BIN (TYPE_DOC,IDEDOCBI) values ('Permis de conduite',484);
Insert into HR.GED_TYPE_DOC_BIN (TYPE_DOC,IDEDOCBI) values ('Curicculum Vitae',488);
Insert into HR.GED_TYPE_DOC_BIN (TYPE_DOC,IDEDOCBI) values ('Carte Nationale',483);
Insert into HR.GED_TYPE_DOC_BIN (TYPE_DOC,IDEDOCBI) values ('Permis de conduite',486);
REM INSERTING into HR.WEB_LOGS
SET DEFINE OFF;
--------------------------------------------------------
--  DDL for Index PK_GED_ANN_TYPE
--------------------------------------------------------

  CREATE UNIQUE INDEX "HR"."PK_GED_ANN_TYPE" ON "HR"."GED_ANN_TYPE" ("CODETYPAN") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
--------------------------------------------------------
--  DDL for Index PK_GED_CARA
--------------------------------------------------------

  CREATE UNIQUE INDEX "HR"."PK_GED_CARA" ON "HR"."GED_CARA" ("CODECARA") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
--------------------------------------------------------
--  DDL for Index GED_CLIENTS_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "HR"."GED_CLIENTS_PK" ON "HR"."GED_CLIENTS" ("IDCLIENT") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
--------------------------------------------------------
--  DDL for Index PK_GED_DOC_BIN
--------------------------------------------------------

  CREATE UNIQUE INDEX "HR"."PK_GED_DOC_BIN" ON "HR"."GED_DOC_BIN" ("IDEDOCBI") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
--------------------------------------------------------
--  DDL for Index GED_FICHE_DOC_BIN_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "HR"."GED_FICHE_DOC_BIN_PK" ON "HR"."GED_FICHE_DOC_BIN" ("IDEDOCBI") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
--------------------------------------------------------
--  DDL for Index PK_GED_STRUCTURE_ARCH
--------------------------------------------------------

  CREATE UNIQUE INDEX "HR"."PK_GED_STRUCTURE_ARCH" ON "HR"."GED_STRUCTURE_ARCH" ("IDENDOSS") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
--------------------------------------------------------
--  DDL for Index PK_GED_TYPE
--------------------------------------------------------

  CREATE UNIQUE INDEX "HR"."PK_GED_TYPE" ON "HR"."GED_TYPE" ("IDETYPDO") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
--------------------------------------------------------
--  DDL for Index GED_TYPE_DOC_BIN_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "HR"."GED_TYPE_DOC_BIN_PK" ON "HR"."GED_TYPE_DOC_BIN" ("IDEDOCBI") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
--------------------------------------------------------
--  DDL for Trigger GED_CLIENTS_BIR
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "HR"."GED_CLIENTS_BIR" 
BEFORE INSERT ON GED_CLIENTS 
FOR EACH ROW

BEGIN
  SELECT GED_CLIENTS_SEQ.NEXTVAL
  INTO   :new.IDCLIENT
  FROM   dual;
END;

/
ALTER TRIGGER "HR"."GED_CLIENTS_BIR" ENABLE;
--------------------------------------------------------
--  DDL for Trigger GED_DOC_BIN_BIR
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "HR"."GED_DOC_BIN_BIR" 
BEFORE INSERT ON GED_DOC_BIN 
FOR EACH ROW

BEGIN
  SELECT GED_DOC_BIN_SEQ.NEXTVAL
  INTO   :new.IDEDOCBI
  FROM   dual;
END;

/
ALTER TRIGGER "HR"."GED_DOC_BIN_BIR" ENABLE;
--------------------------------------------------------
--  DDL for Synonymn DUAL
--------------------------------------------------------

  CREATE OR REPLACE PUBLIC SYNONYM "DUAL" FOR "SYS"."DUAL";
--------------------------------------------------------
--  Constraints for Table GED_ANN_DOC
--------------------------------------------------------

  ALTER TABLE "HR"."GED_ANN_DOC" MODIFY ("CODETYPAN" NOT NULL ENABLE);
 
  ALTER TABLE "HR"."GED_ANN_DOC" MODIFY ("TEXTANNO" NOT NULL ENABLE);
 
  ALTER TABLE "HR"."GED_ANN_DOC" MODIFY ("DATEANNO" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table GED_ANN_TYPE
--------------------------------------------------------

  ALTER TABLE "HR"."GED_ANN_TYPE" ADD CONSTRAINT "PK_GED_ANN_TYPE" PRIMARY KEY ("CODETYPAN")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"  ENABLE;
 
  ALTER TABLE "HR"."GED_ANN_TYPE" MODIFY ("CODETYPAN" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table GED_CARA
--------------------------------------------------------

  ALTER TABLE "HR"."GED_CARA" ADD CONSTRAINT "PK_GED_CARA" PRIMARY KEY ("CODECARA")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"  ENABLE;
 
  ALTER TABLE "HR"."GED_CARA" MODIFY ("CODECARA" NOT NULL ENABLE);
 
  ALTER TABLE "HR"."GED_CARA" MODIFY ("IDETYPDO" NOT NULL ENABLE);
 
  ALTER TABLE "HR"."GED_CARA" MODIFY ("VALECARA" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table GED_CARA_DOC_BIN
--------------------------------------------------------

  ALTER TABLE "HR"."GED_CARA_DOC_BIN" MODIFY ("CODECARA" NOT NULL ENABLE);
 
  ALTER TABLE "HR"."GED_CARA_DOC_BIN" MODIFY ("LIBECARA" NOT NULL ENABLE);
 
  ALTER TABLE "HR"."GED_CARA_DOC_BIN" MODIFY ("IDEDOCBI" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table GED_CLIENTS
--------------------------------------------------------

  ALTER TABLE "HR"."GED_CLIENTS" ADD CONSTRAINT "GED_CLIENTS_PK" PRIMARY KEY ("IDCLIENT")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"  ENABLE;
 
  ALTER TABLE "HR"."GED_CLIENTS" MODIFY ("IDCLIENT" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table GED_DOC_BIN
--------------------------------------------------------

  ALTER TABLE "HR"."GED_DOC_BIN" ADD CONSTRAINT "PK_GED_DOC_BIN" PRIMARY KEY ("IDEDOCBI")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"  ENABLE;
--------------------------------------------------------
--  Constraints for Table GED_FICHE_DOC_BIN
--------------------------------------------------------

  ALTER TABLE "HR"."GED_FICHE_DOC_BIN" ADD CONSTRAINT "GED_FICHE_DOC_BIN_PK" PRIMARY KEY ("IDEDOCBI")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"  ENABLE;
 
  ALTER TABLE "HR"."GED_FICHE_DOC_BIN" MODIFY ("DESDOCBI" NOT NULL ENABLE);
 
  ALTER TABLE "HR"."GED_FICHE_DOC_BIN" MODIFY ("EXTDOCBI" NOT NULL ENABLE);
 
  ALTER TABLE "HR"."GED_FICHE_DOC_BIN" MODIFY ("SOUDOCBI" NOT NULL ENABLE);
 
  ALTER TABLE "HR"."GED_FICHE_DOC_BIN" MODIFY ("AUTDOCBI" NOT NULL ENABLE);
 
  ALTER TABLE "HR"."GED_FICHE_DOC_BIN" MODIFY ("DATDOCBI" NOT NULL ENABLE);
 
  ALTER TABLE "HR"."GED_FICHE_DOC_BIN" MODIFY ("REFDOCBI" NOT NULL ENABLE);
 
  ALTER TABLE "HR"."GED_FICHE_DOC_BIN" MODIFY ("DATERECE" NOT NULL ENABLE);
 
  ALTER TABLE "HR"."GED_FICHE_DOC_BIN" MODIFY ("VERDOCBI" NOT NULL ENABLE);
 
  ALTER TABLE "HR"."GED_FICHE_DOC_BIN" MODIFY ("RESDOCBI" NOT NULL ENABLE);
 
  ALTER TABLE "HR"."GED_FICHE_DOC_BIN" MODIFY ("NOMBPAGE" NOT NULL ENABLE);
 
  ALTER TABLE "HR"."GED_FICHE_DOC_BIN" MODIFY ("DATEENTR" NOT NULL ENABLE);
 
  ALTER TABLE "HR"."GED_FICHE_DOC_BIN" MODIFY ("IDEDOCBI" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table GED_REFE
--------------------------------------------------------

  ALTER TABLE "HR"."GED_REFE" MODIFY ("IDETYPDO" NOT NULL ENABLE);
 
  ALTER TABLE "HR"."GED_REFE" MODIFY ("MOT_CLE" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table GED_REFE_DOC_BIN
--------------------------------------------------------

  ALTER TABLE "HR"."GED_REFE_DOC_BIN" MODIFY ("MOT_CLE" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table GED_STRUCTURE_ARCH
--------------------------------------------------------

  ALTER TABLE "HR"."GED_STRUCTURE_ARCH" ADD CONSTRAINT "PK_GED_STRUCTURE_ARCH" PRIMARY KEY ("IDENDOSS")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"  ENABLE;
 
  ALTER TABLE "HR"."GED_STRUCTURE_ARCH" MODIFY ("IDENDOSS" NOT NULL ENABLE);
 
  ALTER TABLE "HR"."GED_STRUCTURE_ARCH" MODIFY ("DESIDOSS" NOT NULL ENABLE);
 
  ALTER TABLE "HR"."GED_STRUCTURE_ARCH" MODIFY ("TYPEDOSS" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table GED_TYPE
--------------------------------------------------------

  ALTER TABLE "HR"."GED_TYPE" ADD CONSTRAINT "PK_GED_TYPE" PRIMARY KEY ("IDETYPDO")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"  ENABLE;
 
  ALTER TABLE "HR"."GED_TYPE" MODIFY ("IDETYPDO" NOT NULL ENABLE);
 
  ALTER TABLE "HR"."GED_TYPE" MODIFY ("LIBTYPDO" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table GED_TYPE_DOC_BIN
--------------------------------------------------------

  ALTER TABLE "HR"."GED_TYPE_DOC_BIN" ADD CONSTRAINT "GED_TYPE_DOC_BIN_PK" PRIMARY KEY ("IDEDOCBI")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"  ENABLE;
 
  ALTER TABLE "HR"."GED_TYPE_DOC_BIN" MODIFY ("TYPE_DOC" NOT NULL ENABLE);
 
  ALTER TABLE "HR"."GED_TYPE_DOC_BIN" MODIFY ("IDEDOCBI" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table WEB_LOGS
--------------------------------------------------------

  ALTER TABLE "HR"."WEB_LOGS" MODIFY ("DATEERRO" NOT NULL ENABLE);
 
  ALTER TABLE "HR"."WEB_LOGS" MODIFY ("CREATEBY" NOT NULL ENABLE);
