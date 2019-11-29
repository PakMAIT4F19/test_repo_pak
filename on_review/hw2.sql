
-- Инофрмация об эмитентах из bond_description 
SELECT DISTINCT "ISIN, RegCode, NRDCode", "IssuerName", "IssuerName_NRD", "IssuerOKPO"
FROM public.bond_description_task;
--Добавление столбцов в листинг
ALTER TABLE public.listing_task ADD  "IssuerName" text, 
ADD "IssuerName_NRD" text,
ADD "IssuerOKPO" text;
--ДОбавление значений в созданные столбцы из другой таблицы
UPDATE public.listing_task
SET "IssuerName"=public.bond_description_task."IssuerName",
"IssuerName_NRD"=public.bond_description_task."IssuerName_NRD",
"IssuerOKPO"=public.bond_description_task."IssuerOKPO"
FROM public.bond_description_task
WHERE public.bond_description_task."ISIN code"=public.listing_task."ISIN";

-- и информация о плащадках из quotes
SELECT "BOARDID","BOARDNAME"
FROM public.quotes_task;
--- Поместить инфу в листинг
--Создание столбцов
ALTER TABLE public.listing_task 
ADD  "BOARDID" text, 
ADD "BOARDNAME" text;
--Поместить информацию в столбцы
UPDATE public.listing_task
SET "BOARDNAME"=public.quotes_task."BOARDNAME",
"BOARDID"=public.quotes_task."BOARDID"
FROM public.quotes_task
WHERE public.quotes_task."ID"=public.listing_task."ID";
