-- 1. naloga
-- a) Izpišite imena in starosti slovenskih kolesarjev
--    (kratica države: si). Podatke uredite padajoče po starosti.

SELECT ime, starost FROM kolesar
    WHERE drzava == "si"
    ORDER BY starost DESC;

-- b) Vrnite vse podatke o ekipah, ki imajo v imenu pomišljaj med besedami
--    (ne znotraj besede). Podatke razvrstite po imenu ekipe.

SELECT * FROM ekipa
    WHERE ime LIKE "% - %"
    ORDER BY ime;

-- 2. naloga
-- a) Za vsako težavnost izpišite skupno dolžino in povprečno višinsko razliko
--    vseh etap te težavnosti.

SELECT tezavnost, SUM(dolzina) AS skupna_dolzina, AVG(visina) AS povprecna_visina FROM etapa
    GROUP BY tezavnost;

-- b) Za vsako etapo izpišite njeno zaporedno številko
--    in čas zadnjega kolesarja, ki je prispel na cilj,
--    v obliki ure:minute:sekunde.
--    Podatke uredite padajoče po izpisanem času.

SELECT etapa, strftime('%H:%M:%S', MAX(cas), 'unixepoch') AS cas_zadnjega FROM rezultat 
    WHERE cas IS NOT NULL
    GROUP BY etapa
    ORDER BY MAX(cas) DESC;

-- 3. naloga
-- a) Za vsakega kolesarja, ki nastopa za ekipo iz svoje države,
--    izpišite ime kolesarja, ime ekipe in ime države.

SELECT kolesar.ime, ekipa.ime as ekipa, ekipa.drzava FROM kolesar
    JOIN ekipa ON ekipa.id = kolesar.ekipa
    WHERE kolesar.drzava == ekipa.drzava;

-- b) Za vsakega kolesarja, ki je končal dirko
--    (tj., v nobeni etapi ni odstopil),
--    izpišite njegovo ime in njegov skupni čas v obliki dni:ure:minute:sekunde.
--    Podatki naj bodo urejeni naraščajoče po skupnem času.

SELECT kolesar.ime, strftime('%w:%H:%M:%S', SUM(rezultat.cas), 'unixepoch', '-4 days') AS skupen_cas FROM kolesar
    JOIN rezultat ON rezultat.kolesar = kolesar.id
    WHERE rezultat.mesto IS NOT NULL
    GROUP BY kolesar.id
    ORDER BY skupen_cas;

-- 4. naloga
-- a) Izbrišite vse države, iz katerih ni nobenega kolesarja ali ekipe.

DELETE FROM drzava
WHERE kratica NOT IN (SELECT ekipa.drzava FROM ekipa UNION SELECT kolesar.drzava FROM kolesar);

-- b) Za vsakega kolesarja, ki je odstopil, dodajte vnose v tabelo rezultat
--    s privzetimi vrednostmi v stolpcih mesto, cas, tocke
--    pri vseh etapah, kjer se ta ni pojavil na štartni listi.

INSERT INTO rezultat (kolesar, etapa, mesto, cas, tocke)
SELECT kolesar.id, etapa.stevilka, NULL, NULL, 0 FROM kolesar
    JOIN etapa ON etapa.stevilka NOT IN (SELECT etapa FROM rezultat WHERE kolesar = kolesar.id)
        WHERE kolesar.id IN (SELECT kolesar FROM rezultat WHERE mesto IS NOT NULL AND cas IS NULL);

-- 5. naloga
-- a) Za Tadeja Pogačarja (kolesar.id = 6)
--    izpišite njegov skupni čas po vsaki etapi
--    - tj., izpišite številko etape in njegov skupni čas do vključno te etape
--    v obliki dni:ure:minute:sekunde.

SELECT etapa.stevilka AS etapa_stevilka, strftime('%w:%H:%M:%S', SUM(rezultat.cas) OVER (PARTITION BY rezultat.kolesar ORDER BY etapa.stevilka), 'unixepoch', '-4 days') AS skupen_cas FROM rezultat
    JOIN etapa ON etapa.stevilka = rezultat.etapa
    WHERE rezultat.kolesar = 6 AND rezultat.cas IS NOT NULL
    GROUP BY etapa.stevilka
    ORDER BY etapa.stevilka; 

-- b) Za vsako etapo najvišje uvrščenemu mlademu kolesarju
--    (tj., takemu, ki ima najmanjšo vrednost v stolpcu mesto)
--    prištejte 5 točk pri tej etapi.

UPDATE rezultat SET tocke = tocke + 5
WHERE (kolesar, etapa) IN (SELECT rezultat.kolesar, rezultat.etapa FROM rezultat
                                JOIN kolesar ON rezultat.kolesar = kolesar.id
                                    WHERE kolesar.mlad = 1 AND rezultat.mesto = (SELECT MIN(mesto) FROM rezultat WHERE etapa = rezultat.etapa));
