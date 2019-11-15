-- 1. ������ ������ 
-- ������� ����� schema "bonds"
-- 1.1. �������� ������� listing � ��������� ������ ID (����� ���������� ��������)

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

-- ������������� ������ �� ����� listing_task.xlsx:
-- ��������� ��� � ������� .csv.  ����������� �� ��������� � ; �
-- ��� ������� ������� ��������� WIN1251 � ������� ����������
-- filepathway - ������� ���� � �����

COPY  bonds.listing 
FROM '___filepathway___listing.csv' 
	DELIMITERS ';' CSV HEADER

-- ��������� ������ ��������: 20680 rows affected (������� �� 20680 �����)

-- 1.2. �������� ������� quotes c ��������� ������ �� 2 �������� (ID � TIME)
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

-- ������������� � Excel �� ��������:
-- a) � ���������� excel � ���������� (������ ��������������) ����������� �������� � � , � �� � . � � ��������� � ������� .csv,
-- �.�. �, � ������� �������� ��� ������ ������� L � ������ 24478 ������, ��������� sql ���������� ��������� ���� ������� � ���������� ��+ �1-�����, ��� � �В �� ���
-- ��� ����� �� ������ ���������, ������ �������� ��� ������� � ���� ������� �������
-- b) c������ (B) TIME ��������� � ������ ������� ����
-- c) ������� (Y) ISSUESIZE � (AD) VOL_ACC � �������� � ������ ����� ����� �������
-- d) ������� BAYBACKDATE �������� � ���� ��� ������ ����, ��� � ���� �� ��������, ������� �������� ������ ���� �� ��.��.�� ��:��
-- e) ������� ���� fields 

-- ��� ������� ������� ��������� WIN1251 � ������� ���������� ����
COPY bonds.quotes_task
FROM '___filepathway___quotes_task.csv'
DELIMITERS ';' CSV HEADER ENCODING 'WIN 1251'
-- ���������: 1047800 �����

-- 1.3. �������� ������� bond_description
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
    "Issuer_ID" bigint,
    CONSTRAINT bond_description_pkey PRIMARY KEY ("ISIN, RegCode, NRDCode"),
   
)

TABLESPACE pg_default;

ALTER TABLE bonds.bond_description
    OWNER to postgres;

-- ������������� ������ � Excel:
-- a) ������� (H) HaveOffer ������ �������� ������ � ������ ����� ����� �������, �.�. � 133 ������ ������� �������� 01.01.1900, ��� �������� = 1
-- b) ������� (I) AmortisedMty  ������ �������� ������ � ������ ����� ����� �������, �.�. � 133 ������ ������� �������� 00.01.1900, ��� �������� = 0
-- c) ������� (K): ��������� ������� =�������(K133;1), �.�. ������� �������� 00.01.1900 = 0, �� ��� � ������� ������, � �� ����. ���� ������ �������� �� 0
-- d) ������� (AB) GuarantVal � �������� � ������ ����� ����� �������
-- e) ������� (AY) EndMtyDate ��������� � ������ ����-��-��

-- ��� ������� ������� ��������� WIN1251 � ������� ���������� ����

COPY bonds.quotes_task
FROM '___filepathway___bond_description_task.csv'
DELIMITERS ';' CSV HEADER ENCODING 'WIN 1251'

-- ���������: 2934 ������


-- 2. ���������� ���������� � ������� listing
-- �������� ������ ����� � ������� listing
alter table bonds.listing
add column "IssuerName" text, 
add column "IssuerName_NRD" text, 
add column "IssuerOKPO" bigint;

-- �������� ���������� � ��������� ������� �� ��������� �� quotes
UPDATE bonds.listing
SET "IssuerName" = bonds.bond_description."IssuerName",
"IssuerName_NRD" = bonds.bond_description."IssuerName_NRD",
"IssuerOKPO" = bonds.bond_description."IssuerOKPO"
FROM bonds.bond_description
WHERE bonds.listing."ISIN" = bonds.bond_description."ISINCode";

-- ���������� �������� ����� � �������� � ��������
alter table bonds.listing
add column "BOARDID" text, 
add column "BOARDNAME" text
 
 -- �������� ���������� � ��������� ������� � �������� �� bond_description
UPDATE bonds.listing
SET "BOARDID" = bonds.quotes."BOARDID",
"BOARDNAME" = bonds.quotes."BOARDNAME"
FROM bonds.quotes
WHERE bonds.listing."ISIN" = bonds.quotes."ISIN";


-- ���������: � sql ������� �� ������� ������� �������� ������
-- "IssuerName" text COLLATE pg_catalog."default",
-- "IssuerName_NRD" text COLLATE pg_catalog."default",
-- "IssuerOKPO" bigint,
-- "BOARDID" text COLLATE pg_catalog."default",
-- "BOARDNAME" text COLLATE pg_catalog."default"

-- � � ������� listing �����-�� ����� ����

-- 3. ����������� ������� - listing, �������� - bond_description

-- �������� ���� �������������� ��������
alter table bonds.bond_description add column "Issuer_ID" bigint;
update bonds.bond_description
set "Issuer_ID" = bonds.listing."ID"
from bonds.listing
WHERE bonds.listing."ISIN" = bonds.bond_description."ISINCode";

-- ���������� ���� ����������� �������� �����
ALTER TABLE bonds.bond_description
ADD CONSTRAINT fr_key_1 FOREIGN KEY ("Issuer_ID") REFERENCES bonds.listing ("ID");

-- ��������� ��������� � sql ������� ������� bond_description:
-- CONSTRAINT fr_key_1 FOREIGN KEY ("Issuer_ID")
--       REFERENCES bonds.listing_try ("ID") MATCH SIMPLE
--       ON UPDATE NO ACTION
--       ON DELETE NO ACTION
--       NOT VALID

-- � ����� ����� ������� ������� ����� �� bond_description � quotes, �� �� ����� ����, ��� ���� ���� � ISIN,
-- ����� ������� ����� ���������� � ��������



