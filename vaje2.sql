

SELECT naslov, ROUND(ocena) AS 'zaokrozena_ocena'
FROM film
WHERE ocena > 8 AND glasovi > 10000
ORDER BY ocena DESC, naslov;
