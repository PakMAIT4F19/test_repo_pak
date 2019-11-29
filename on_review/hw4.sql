--Имена эмитентов, чьи облигации торгующихся на Московской бирже в режиме основных торгов
--По каждой облигации доля дней, 
--когда котировка не существовала бы, составляла не более 10% от наблюдений


--имена эмитентов, чьи облигации торгуются на московской бирже в режиме основных торгов
SELECT "IssuerName",public.listing_task."ISIN"
FROM public.listing_task

INNER JOIN public.quotes_task ON public.quotes_task."ID"=public.listing_task."ID"
WHERE "Platform"='Московская Биржа' AND public.quotes_task."BOARDID"='EQCC' AND public.quotes_task."BOARDID"='Main';


--тут бы подзапросом с найденным nunratio
-- Число наблюдений для каждой облигации, где нет цены
SELECT "ID", count("BID")
FROM public.quotes_task
WHERE "BID"='0'
GROUP BY "ID"
;

	
	--Число наблюдений по каждой облигации
SELECT "ID", count ("BID")
FROM public.quotes_task
GROUP BY "ID"; 

--Попытка найти nun ratio. Видимо у каких-то облигаций нет цен, а на ноль делить нельзя
SELECT "ID", (count("BID"='0'))/(count("BID")) as nunratio
FROM public.quotes_task
GROUP BY "ID";

 SELECT  distinct "CPN_DATE", "ID", "BID"
 FROM public.quotes_task
 GROUP BY "ID"
 GROUP BY "CPN_DATE";


