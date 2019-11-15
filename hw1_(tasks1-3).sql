-- 1. Импорт таблиц 
-- Создать новую schema "bonds"
-- 1.1. Создание таблицы listing с первичным ключом ID (имеет уникальные значения)

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

-- Предобработка данных из файла listing_task.xlsx:
-- сохраните его в формате .csv.  Разделители по умолчанию “ ; ”
-- при импорте укажите кодировку WIN1251 и наличие заголовков
-- filepathway - укажите путь к файлу

COPY  bonds.listing 
FROM '___filepathway___listing.csv' 
	DELIMITERS ';' CSV HEADER

-- Результат полной загрузки: 20680 rows affected (таблица из 20680 строк)

-- 1.2. Создание таблицы quotes c первичным ключом из 2 столбцов (ID и TIME)
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

-- Предобработка в Excel до загрузки:
-- a) в настройках excel в параметрах (раздел «Дополнительно») разделитель разрядов с « , » на « . » и сохранить в формате .csv,
-- т.к. ‘, ‘ вызовет проблему при чтении столбца L в районе 24478 строки, поскольку sql попытается разделить один столбец с содержимым ‘Т+ А1-Акции, паи и ДР’ на два
-- ИЛИ чтобы не менять настройки, просто замените все запятые в этом столбце точками
-- b) cтолбец (B) TIME перевести в формат краткой даты
-- c) столбец (Y) ISSUESIZE и (AD) VOL_ACC в числовой и убрать знаки после запятой
-- d) столбец BAYBACKDATE включает в себя как просто даты, так и даты со временем, поэтому изменить формат поля на дд.мм.гг чч:мм
-- e) удалить лист fields 

-- При импорте укажите кодировку WIN1251 и наличие заголовков либо
COPY bonds.quotes_task
FROM '___filepathway___quotes_task.csv'
DELIMITERS ';' CSV HEADER ENCODING 'WIN 1251'
-- Результат: 1047800 строк

-- 1.3. Создание таблицы bond_description
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

-- Предобработка данных в Excel:
-- a) Столбец (H) HaveOffer задать числовой формат и убрать знаки после запятой, т.к. в 133 строке имеется значение 01.01.1900, что является = 1
-- b) Столбец (I) AmortisedMty  задать числовой формат и убрать знаки после запятой, т.к. в 133 строке имеется значение 00.01.1900, что является = 0
-- c) Столбец (K): применить формулу =ЛЕВСИМВ(K133;1), т.к. реально значение 00.01.1900 = 0, но оно в формате текста, а не даты. Либо просто заменить на 0
-- d) столбец (AB) GuarantVal в числовой и убрать знаки после запятой
-- e) столбец (AY) EndMtyDate перевести в формат гггг-мм-дд

-- При импорте укажите кодировку WIN1251 и наличие заголовков либо

COPY bonds.quotes_task
FROM '___filepathway___bond_description_task.csv'
DELIMITERS ';' CSV HEADER ENCODING 'WIN 1251'

-- Результат: 2934 строки


-- 2. Добавление информации в таблицу listing
-- создание пустых полей в таблице listing
alter table bonds.listing
add column "IssuerName" text, 
add column "IssuerName_NRD" text, 
add column "IssuerOKPO" bigint;

-- внесение информации в созданные столбцы об эмитентах из quotes
UPDATE bonds.listing
SET "IssuerName" = bonds.bond_description."IssuerName",
"IssuerName_NRD" = bonds.bond_description."IssuerName_NRD",
"IssuerOKPO" = bonds.bond_description."IssuerOKPO"
FROM bonds.bond_description
WHERE bonds.listing."ISIN" = bonds.bond_description."ISINCode";

-- аналогично создание полей о площадке в листинге
alter table bonds.listing
add column "BOARDID" text, 
add column "BOARDNAME" text
 
 -- внесение информации в созданные столбцы о площадке из bond_description
UPDATE bonds.listing
SET "BOARDID" = bonds.quotes."BOARDID",
"BOARDNAME" = bonds.quotes."BOARDNAME"
FROM bonds.quotes
WHERE bonds.listing."ISIN" = bonds.quotes."ISIN";


-- Результат: в sql вкладке по таблице листинг появятся записи
-- "IssuerName" text COLLATE pg_catalog."default",
-- "IssuerName_NRD" text COLLATE pg_catalog."default",
-- "IssuerOKPO" bigint,
-- "BOARDID" text COLLATE pg_catalog."default",
-- "BOARDNAME" text COLLATE pg_catalog."default"

-- а в таблице listing соотв-но новые поля

-- 3. Материнская таблица - listing, дочерняя - bond_description

-- создание поля идентификатора эмитента
alter table bonds.bond_description add column "Issuer_ID" bigint;
update bonds.bond_description
set "Issuer_ID" = bonds.listing."ID"
from bonds.listing
WHERE bonds.listing."ISIN" = bonds.bond_description."ISINCode";

-- присвоение полю ограничение внешнего ключа
ALTER TABLE bonds.bond_description
ADD CONSTRAINT fr_key_1 FOREIGN KEY ("Issuer_ID") REFERENCES bonds.listing ("ID");

-- Результат появление в sql скрипте таблицы bond_description:
-- CONSTRAINT fr_key_1 FOREIGN KEY ("Issuer_ID")
--       REFERENCES bonds.listing_try ("ID") MATCH SIMPLE
--       ON UPDATE NO ACTION
--       ON DELETE NO ACTION
--       NOT VALID

-- В целом можно сделать внешний включ от bond_description к quotes, но не особо надо, там есть поля с ISIN,
-- через которые можно обратиться к таблицам



