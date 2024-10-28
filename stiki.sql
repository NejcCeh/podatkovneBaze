--Vrnite naslove filmov in imena glavnih igralcev. Rezultate 
--uredite po imenu igralca in nato še po naslovu filma.
SELECT naslov, ime FROM film
    JOIN vloga ON film.id = vloga.film
    JOIN oseba ON vloga.oseba = oseba.id
WHERE tip = "I" AND mesto = 1
ORDER BY ime, naslov;

--Za vsakega režiserja (izpišite ga z IDjem in imenom)
--izpišite skupno dolžino filmov, ki jih je režiral 
--(brez igranja). Rezultate uredite po imenu režiserja.
SELECT oseba.id, ime, SUM(dolzina) FROM oseba
    JOIN vloga ON vloga.oseba = oseba.id
    JOIN film ON film.id = vloga.film
WHERE vloga.tip = "R"
GROUP BY ime
ORDER BY ime;

--Za vsak žanr (izpišite ga z imenom) izpišite število
--različnih igralcev in število različnih režiserjev, ki
--so sodelovali pri filmih tega žanra. Rezultate uredite
--padajoče po vsoti števila igralcev in števila režiserjev
--(če se nekdo pojavi tako kot igralec kot režiser, se
--tukaj šteje dvakrat).

SELECT naziv, COUNT(DISTINCT(igralec.oseba)) AS st_igralcev, COUNT(DISTINCT(reziser.oseba)) AS st_reziserjev FROM zanr
    JOIN pripada ON pripada.zanr = zanr.id
    JOIN vloga AS igralec ON igralec.film = pripada.film
    JOIN vloga AS reziser ON reziser.film = pripada.film
WHERE igralec.tip = "I" ANd reziser.tip = "R"    
GROUP BY naziv
ORDER BY st_igralcev + st_reziserjev DESC;