SELECT naslov, ROUND(ocena) AS 'zaokrozena_ocena'
FROM film
WHERE ocena > 8 AND glasovi > 10000
ORDER BY ocena DESC, naslov;


SELECT naslov, ROUND(ocena)
FROM film
WHERE ROUND(ocena) = (SELECT MIN(ROUND(ocena))FROM film);

---------------------------------------
GRUPIRANJE:
--- Povprečna ocena za filme iz leta 2000
SELECT AVG(ocena)
FROM filmi
WHERE leto = 2000;

--- Povprečna ocena filmov po letih 
SELECT leto, AVG(ocena)
FROM filmi
GROUP BY leto;

--- Povprečna ocena filmov po letih , kjer je bilo vsaj 5 filmov
SELECT leto, AVG(ocena), COUNT(*) AS st_filmov
FROM filmi
GROUP BY leto
HAVING st_filmov > 5;
----------------------------------------