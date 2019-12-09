-- 1. Import tables
-- Create new schema "bonds"
-- 1.1. Create new table listing with primary key ID (it has unique values)

-- DROP TABLE bonds.listing;

CREATE TABLE bonds.listing
(
    "ID" bigint NOT NULL,
    "ISIN" text COLLATE pg_catalog."default",
    "Platform" text COLLATE pg_catalog."default" NOT NULL,
    "Section" text COLLATE pg_catalog."default",
    CONSTRAINT listing_pkey PRIMARY KEY ("ID")
)
TABLESPACE pg_default;
ALTER TABLE bonds.listing
    OWNER to postgres;

-- Preparation of data listing_task.xlsx:
-- save as .csv.  Delimiters by default  " ; "
-- for import use WIN1251 and tick on headers
-- filepathway - add it (according your settings)

COPY  bonds.listing 
FROM '___filepathway___listing.csv' DELIMITERS ';' CSV HEADER;

-- Result: 20680 rows affected 

-- 1.2. Create table quotes with primary key of 2 columns (ID and TIME)
-- Table: bonds.quotes

-- DROP TABLE bonds.quotes;

CREATE TABLE bonds.quotes
(
    "ID" bigint NOT NULL,
    "TIME" date NOT NULL,
    "ACCRUEDINT" real,
    "ASK" real,
    "ASK_SIZE" real,
    "ASK_SIZE_TOTAL" bigint,
    "AVGE_PRCE" real,
    "BID" real,
    "BID_SIZE" real,
    "BID_SIZE_TOTAL" bigint,
    "BOARDID" text COLLATE pg_catalog."default",
    "BOARDNAME" text COLLATE pg_catalog."default",
    "BUYBACKDATE" timestamp without time zone,
    "BUYBACKPRICE" real,
    "CBR_LOMBARD" real,
    "CBR_PLEDGE" real,
    "CLOSE" real,
    "CPN" real,
    "CPN_DATE" timestamp without time zone,
    "CPN_PERIOD" bigint,
    "DEAL_ACC" bigint,
    "FACEVALUE" real,
    "ISIN" text COLLATE pg_catalog."default",
    "ISSUER" text COLLATE pg_catalog."default",
    "ISSUESIZE" bigint,
    "MAT_DATE" date,
    "MPRICE" real,
    "MPRICE2" real,
    "SPREAD" real,
    "VOL_ACC" bigint,
    "Y2O_ASK" real,
    "Y2O_BID" real,
    "YIELD_ASK" real,
    "YIELD_BID" real,
    CONSTRAINT quotes_pkey PRIMARY KEY ("ID", "TIME")
)

TABLESPACE pg_default;

ALTER TABLE bonds.quotes
    OWNER to postgres;

-- Preparation of data quotes.xslx:
-- a) in settings (click on additionals) change separator from « , » (commas) to « . » (dots) and save as .csv,
-- this ‘, ‘ causes the problem while reading column (L) in 24478 th row (sql tries to divide 1 column consisted of ‘Т+ А1-Акции, паи и ДР’ on 2 different columns
-- OR change all ","(commas) on "." (dot) in this column
-- b) column (B) TIME change format of short date
-- c) columns (Y) ISSUESIZE and (AD) VOL_ACC transform to numbers format and hide(delete) numbers after separator
-- d) column BAYBACKDATE consists of dates as well as datetime values, so change on dd.mm.yy hh:mm
-- e) delete sheet fields 

-- While import use WIN1251 and tick on headers 
COPY bonds.quotes
FROM '___filepathway___quotes_task.csv'
DELIMITERS ';' CSV HEADER ENCODING 'WIN 1251';

-- Result: 1047800 rows

-- 1.3. Create table bond_description

-- Table: bonds.bond_description

-- DROP TABLE bonds.bond_description;

CREATE TABLE bonds.bond_description
(
    "ISIN, RegCode, NRDCode" character varying COLLATE pg_catalog."default" NOT NULL,
    "FinToolType" text COLLATE pg_catalog."default",
    "SecurityType" text COLLATE pg_catalog."default",
    "SecurityKind" text COLLATE pg_catalog."default",
    "CouponType" text COLLATE pg_catalog."default",
    "RateTypeNameRus_NRD" text COLLATE pg_catalog."default",
    "CouponTypeName_NRD" text COLLATE pg_catalog."default",
    "HaveOffer" boolean,
    "AmortisedMty" boolean,
    "MaturityGroup" text COLLATE pg_catalog."default",
    "IsConvertible" boolean,
    "ISINCode" text COLLATE pg_catalog."default",
    "Status" text COLLATE pg_catalog."default",
    "HaveDefault" boolean,
    "IsLombardCBR_NRD" boolean,
    "IsQualified_NRD" boolean,
    "ForMarketBonds_NRD" boolean,
    "MicexList_NRD" text COLLATE pg_catalog."default",
    "Basis" text COLLATE pg_catalog."default",
    "Basis_NRD" text COLLATE pg_catalog."default",
    "Base_Month" text COLLATE pg_catalog."default",
    "Base_Year" text COLLATE pg_catalog."default",
    "Coupon_Period_Base_ID" bigint,
    "AccruedintCalcType" boolean,
    "IsGuaranteed" boolean,
    "GuaranteeType" text COLLATE pg_catalog."default",
    "GuaranteeAmount" text COLLATE pg_catalog."default",
    "GuarantVal" bigint,
    "Securitization" text COLLATE pg_catalog."default",
    "CouponPerYear" integer,
    "Cp_Type_ID" integer,
    "NumCoupons" integer,
    "NumCoupons_M" integer,
    "NumCoupons_NRD" integer,
    "Country" text COLLATE pg_catalog."default",
    "FaceFTName" text COLLATE pg_catalog."default",
    "FaceFTName_M" integer,
    "FaceFTName_NRD" text COLLATE pg_catalog."default",
    "FaceValue" real,
    "FaceValue_M" integer,
    "FaceValue_NRD" real,
    "CurrentFaceValue_NRD" real,
    "BorrowerName" text COLLATE pg_catalog."default",
    "BorrowerOKPO" bigint,
    "BorrowerSector" text COLLATE pg_catalog."default",
    "BorrowerUID" bigint,
    "IssuerName" text COLLATE pg_catalog."default",
    "IssuerName_NRD" text COLLATE pg_catalog."default",
    "IssuerOKPO" bigint,
    "NumGuarantors" integer,
    "EndMtyDate" date,
    CONSTRAINT bond_description_pkey PRIMARY KEY ("ISIN, RegCode, NRDCode"),
   
)

TABLESPACE pg_default;
ALTER TABLE bonds.bond_description
    OWNER to postgres;

-- Preapare data in Excel:
-- a) (H) HaveOffer change on numbers format and delete numbers after separator, because in 133th row u have value '01.01.1900' ( = 1 )
-- b) (I) AmortisedMty  change on numbers format and delete numbers after separator, because in 133th row u have value '00.01.1900' ( = 0 ) 00.01.1900
-- c) (K): use formula "\=ЛЕВСИМВ(K133;1)\", cause real value of 00.01.1900 = 0, but it's a text. OR change it on zero
-- d) (AB) GuarantVal change on numbers format and delete numbers after separator
-- e) (AY) EndMtyDate change on format yyyy-mm-dd

-- While import use WIN1251 and tick headers OR

COPY bonds.bond_description
FROM '___filepathway___bond_description_task.csv'
DELIMITERS ';' CSV HEADER ENCODING 'WIN 1251';

-- Result: 2934 rows


-- 2. Add info to listing
-- create empty fiels in listing
alter table bonds.listing
add column "IssuerName" text, 
add column "IssuerName_NRD" text, 
add column "IssuerOKPO" bigint;

-- fill in. use info from quotes

UPDATE bonds.listing
SET "IssuerName" = bonds.bond_description."IssuerName",
"IssuerName_NRD" = bonds.bond_description."IssuerName_NRD",
"IssuerOKPO" = bonds.bond_description."IssuerOKPO"
FROM bonds.bond_description
WHERE bonds.listing."ISIN" = bonds.bond_description."ISINCode";

-- the same about square
alter table bonds.listing
add column "BOARDID" text, 
add column "BOARDNAME" text;
 
 -- filling in. use info from bond_description
UPDATE bonds.listing
SET "BOARDID" = bonds.quotes."BOARDID",
"BOARDNAME" = bonds.quotes."BOARDNAME"
FROM bonds.quotes
WHERE bonds.listing."ISIN" = bonds.quotes."ISIN";


-- Result: in sql code of table you'll see some updates :
-- "IssuerName" text COLLATE pg_catalog."default",
-- "IssuerName_NRD" text COLLATE pg_catalog."default",
-- "IssuerOKPO" bigint,
-- "BOARDID" text COLLATE pg_catalog."default",
-- "BOARDNAME" text COLLATE pg_catalog."default"
-- -- Result: updated 8818 rows

-- 3. Main table - listing, daughter - bond_description

-- create field - identification of emitent

alter table bonds.bond_description add column "Issuer_ID" bigint;
update bonds.bond_description
set "Issuer_ID" = bonds.listing."ID"
from bonds.listing
WHERE bonds.listing."ISIN" = bonds.bond_description."ISINCode";

-- make foreign key
ALTER TABLE bonds.bond_description
ADD CONSTRAINT fr_key_1 FOREIGN KEY ("Issuer_ID") REFERENCES bonds.listing ("ID");

-- Add unique ID
INSERT INTO bonds.listing
SELECT b."ID", b."ISIN", b."BOARDNAME", b."BOARDID"
FROM (SELECT DISTINCT bonds.quotes."ID", bonds.quotes."ISIN", bonds.quotes."BOARDNAME", bonds.quotes."BOARDID"
	  FROM bonds.quotes
	  WHERE bonds.quotes."ID" NOT IN (SELECT "ID" 
									  FROM bonds.listing)) as b;

-- Result: 20989
-- Add foreign key

ALTER TABLE bonds.quotes
ADD FOREIGN KEY ("ID") REFERENCES bonds.listing ("ID"); 

-- Result: table listing consists of 20 989 rows

--Note: I am not sure in my actions so I will drop waste columns after checking my home assignment

-- 4. Strange query

SELECT DISTINCT bonds.listing."ISIN", bonds.listing."IssuerName" AS "Issuer",  a."nun_ratio"
FROM bonds.listing
INNER JOIN (SELECT bonds.quotes."ISIN", 
			round(COUNT("BID")::numeric/COUNT(*), 3) as "nun_ratio"
			FROM bonds.quotes
			GROUP BY "ISIN"
		   ) AS a
			ON bonds.listing."ISIN" = a."ISIN"
		   	AND bonds.listing."Platform" = 'Московская Биржа '
		   	AND bonds.listing."Section" =' Основной'
			AND a."nun_ratio" >= 0.9
			AND bonds.listing."IssuerName" NOT IN (SELECT bonds.listing."IssuerName"
													   FROM bonds.listing
													   INNER JOIN (SELECT "ISIN", "nun_ratio"
																   FROM (SELECT bonds.quotes."ISIN",
																		 round(COUNT("BID")::numeric/COUNT(*), 3) as "nun_ratio"
																		 FROM bonds.quotes
																		 GROUP BY "ISIN"
																		) AS b
																   WHERE "nun_ratio" < 0.9
																  ) AS c
													   ON bonds.listing."ISIN" = c."ISIN"
													   WHERE "IssuerName" IS NOT NULL
													  );
-- Result: 234 rows





