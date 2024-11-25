-- Vrnite tabelo imen in priimkov vseh oseb, ki jim je ime Matija

SELECT ime,priimek FROM osebe
    WHERE ime LIKE "Matija";

-- Vrnite tabelo imen in priimkov vseh oseb, urejeno po priimku

SELECT ime, priimek FROM osebe
    ORDER BY priimek;

-- Vrnite imena vseh predmetov na praktični matematiki (smer: 1PrMa)

SELECT ime FROM predmeti
    WHERE smer LIKE "1PrMa";

-- Vrnite vse podatke o skupinah z manj kot eno uro

SELECT * FROM skupine
    WHERE ure < 1;

-- Vrnite število vseh predmetov na posamezni smeri

SELECT COUNT(ime), smer FROM predmeti
    GROUP BY smer;

-- Vrnite imena tistih predmetov, ki se pojavljajo na več smereh

SELECT ime from (SELECT ime, COUNT(smer) AS st FROM predmeti
    GROUP BY ime
    )
    WHERE st > 1;
    
-- Vrnite imena in vse pripadajoče smeri tistih predmetov, ki se pojavljajo na več smereh

SELECT * FROM (SELECT ime, smer from (SELECT ime, smer, COUNT(smer) AS st FROM predmeti
GROUP BY ime
    )
    WHERE st > 1)
    ORDER BY ime;

-- Vrnite skupno število ur vsake osebe

SELECT osebe.ime, osebe.priimek, COUNT(ure) FROM skupine
    JOIN osebe ON skupine.učitelj = osebe.id
    GROUP BY osebe.id;
    
-- Vrnite imena in priimke vseh predavateljev,
-- torej tistih, ki imajo kakšno skupino tipa P

SELECT ime, priimek FROM osebe
    JOIN skupine ON skupine.učitelj = osebe.id
    WHERE skupine.tip LIKE "P";

-- Vrnite imena in priimke vseh predavateljev,
-- ki izvajajo tako predavanja (tip P) kot vaje (tipa V ali L)

SELECT učitelj, tip, st FROM (SELECT učitelj, tip, COUNT(tip) AS st FROM skupine
GROUP BY učitelj)
    WHERE st > 1
    ORDER BY učitelj;
    

-- Vrnite imena in smeri vseh predmetov, ki imajo kakšen seminar

SELECT DISTINCT ime, smer FROM predmeti
    JOIN dodelitve ON predmeti.id = dodelitve.predmet
    JOIN skupine ON skupine.id = dodelitve.skupina
    WHERE skupine.tip == "S";

-- Vsem predmetom na smeri 2PeMa spremenite smer na PeMa

UPDATE predmeti SET smer = "PeMa"
    WHERE smer LIKE "2PeMa";

-- Izbrišite vse predmete, ki niso dodeljeni nobeni skupini

DELETE FROM predmeti
WHERE id NOT IN (SELECT predmet FROM dodelitve);


-- Za vsak predmet, ki se pojavi tako na prvi kot drugi stopnji
-- (smer se začne z 1 oz. 2), dodajte nov predmet z istim imenom
-- in smerjo 0Mate (stolpca id ne nastavljajte, ker se bo samodejno
-- določil)
INSERT INTO predmeti
(ime, smer)
SELECT DISTINCT p1.ime, '0Mate' FROM predmeti AS p1
    JOIN predmeti AS p2 ON p1.ime = p2.ime
WHERE p1.smer LIKE '1%' AND p2.smer LIKE '2%';

-- Za vsako smer izpišite število različnih oseb, ki na njej poučujejo

SELECT smer, COUNT(DISTINCT učitelj) AS st_ucitelj FROM predmeti
    JOIN dodelitve ON predmeti.id = dodelitve.predmet
    JOIN skupine ON dodelitve.skupina = skupine.id
GROUP BY smer;


-- Vrnite pare ID-jev tistih oseb, ki sodelujejo pri vsaj dveh
-- predmetih (ne glede na tip skupine), pri čemer naj bo prvi ID
-- v paru manjši od drugega, pari pa naj se ne ponavljajo

SELECT s1.učitelj, s2.učitelj FROM skupine AS s1
    JOIN dodelitve AS d1 ON s1.id = d1.skupina
    JOIN dodelitve AS d2 USING(predmet)
    JOIN skupine AS s2 ON d2.skupina = s2.id
WHERE s1.učitelj < s2.učitelj
GROUP BY s1.učitelj, s2.učitelj
HAVING COUNT(DISTINCT predmet) >= 2
;

-- Za vsako osebo (izpišite jo z ID-jem, imenom in priimkom) vrnite
-- skupno število ur vaj (tako avditornih kot laboratorijskih),
-- pri čemer naj bo to enako 0, če oseba ne izvaja nobenih vaj

SELECT osebe.id, ime, priimek, COALESCE(SUM(ure), 0) AS st_ur FROM osebe
    LEFT JOIN skupine ON osebe.id = skupine.učitelj AND tip IN ('V', 'L')
GROUP BY osebe.id, ime, priimek
;


-- Vrnite ID-je, imena in smeri predmetov, za katere se izvaja
-- seminar, ne pa tudi avditorne ali laboratorijske vaje
WITH nova AS (SELECT predmeti.id, predmeti.ime, smer FROM predmeti 
    INNER JOIN skupine ON skupine.id = predmeti.id)

DELETE FROM nova
WHERE tip LIKE "S" AND tip NOT LIKE "V" AND tip NOT LIKE "L";  AND
    





