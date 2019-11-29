--Создание 1 таблицы
DROP TABLE if exists public.listing_task
;

CREATE TABLE public.listing_task
(
   "ID" int NOT NULL,
	"ISIN" text NOT NULL,
	"Platform" text NOT NULL,
	"Section" text NOT NULL,
	CONSTRAINT listing_task_pkey PRIMARY KEY ("ID")
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.listing_task
    OWNER to postgres;
--Загрузка данных в 1 таблицу	
copy public.listing_task  FROM 'C:/Users/Public/listing_task.csv' DELIMITER ';' CSV HEADER ENCODING 'WIN 1251';

--Создание 2 таблицы
DROP TABLE if exists public.bond_description_task
;
CREATE TABLE public.bond_description_task
(
   "ISIN, RegCode, NRDCode" text NOT NULL,
	"FinToolType" text NOT NULL,
	"SecurityType" text,
	"SecurityKind" text,
	"CouponType" text,
	"RateTypeNameRus_NRD" text,
	"CouponTypeName_NRD" text,
	"HaveOffer" boolean NOT NULL,
	"AmortisedMty" boolean NOT NULL,
	"MaturityGroup" text,
	"IsConvertible" boolean NOT NULL,
	"ISIN code" text NOT NULL,
	"Status" text NOT NULL,
	"HaveDefault" boolean NOT NULL,
	---Скрытые столбцы, без них не загружаются данные,а  удалять нельзя по условиям задания
	"IsLombardCBR_NRD" boolean,
	"IsQualified_NRD" boolean,
	"ForMarketBonds_NRD" boolean,
	"MicexList_NRD" text,
	"Basis" text,
	"Basis_NRD" text,
	"Base_Month" text,
	"Base_Year" text,
	"Coupon_Period_Base_ID" smallint,
	"AccruedintCalcType" boolean NOT NULL,
	"IsGuaranteed" boolean NOT NULL,	
	-- Нескртытые столбцы
	"GuaranteeType" text,
	"GuaranteeAmount" text,
	
	-- Скрытые столбцы
	"GuarantVal" bigint,
	"Securitization" text,
	"CouponPerYear" smallint,
	"Cp_Type_ID" smallint,
	"NumCoupons" smallint,
	"NumCoupons_M" smallint,
	"NumCoupons_NRD" smallint,
	"Country" text NOT NULL,
	"FaceFTName" text NOT NULL,
	"FaceFTName_M" smallint NOT NULL,
	"FaceFTName_NRD" text,
	"FaceValue" money NOT NULL,
	"FaceValue_M" smallint NOT NULL,
	"FaceValue_NRD" money,
	"CurrentFaceValue_NRD" money,
	--Нескрытые столбцы
	"BorrowerName" text NOT NULL,
	"BorrowerOKPO" int ,
	"BorrowerSector" text,
	"BorrowerUID" int NOT NULL,
	"IssuerName" text NOT NULL,
	"IssuerName_NRD" text,
	"IssuerOKPO" int,
	"NumGuarantors" smallint NOT NULL,
	"EndMtyDate" date,
	CONSTRAINT bond_description_task_pkey PRIMARY KEY ("ISIN, RegCode, NRDCode")
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;


ALTER TABLE public.bond_description_task
    OWNER to postgres;
--Загрузка данных во 2 таблицу	
copy public.bond_description_task  FROM 'C:/Users/Public/bond_description_task.csv' DELIMITER ';' CSV HEADER ENCODING 'WIN 1251';

--Создание 3 таблицы
DROP TABLE if exists public.quotes_task
;
CREATE TABLE public.quotes_task
(
   "ID" int,
	"TIME" int,
	"ACCRUEDINT" money,
	"ASK" money,
	"ASK_SIZE" int,
	"ASK_SIZE_TOTAL" int,
	"AVGE_PRCE" money,
	"BID" money,
	"BID_SIZE" int,
	"BID_SIZE_TOTAL" int,
	"BOARDID" text,
	"BOARDNAME" text,
	"BUYBACKDATE" money,
	"BUYBACKPRICE" money,
	"CBR_LOMBARD" text,
	"CBR_PLEDGE" money ,
	"CLOSE" money,
	"CPN" money,
	"CPN_DATE" date,
	"CPN_PERIOD" int,
	"DEAL_ACC" int,
	"FACEVALUE" money,
	"ISIN" text,
	"ISSUER" text,
	"ISSUESIZE" bigint,
	"MAT_DATE" date,
	"MPRICE" money,
	"MPRICE2" int,
	"SPREAD" money,
	"VOL_ACC" bigint,
	"Y2O_ASK" money,
	"Y2O_BID" money,
	"YIELD_ASK" money,
	"YIELD_BID" money)
	--CONSTRAINT bond_description_task_pkey PRIMARY KEY ("ISIN, RegCode, NRDCode")

WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.quotes_task
    OWNER to postgres;
--Загрузка данных в 3 таблицу	
copy public.quotes_task 
FROM 'C:/Users/Public/quotes_task.csv' DELIMITER ';' CSV HEADER  ENCODING 'WIN 1251';

