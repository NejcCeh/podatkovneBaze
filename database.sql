CREATE TABLE stranka (
    id    integer    PRIMARY KEY,
    ime   text       NOT NULL
);

CREATE TABLE narocilo (
    id        integer      PRIMARY KEY,
    kolicina  integer      CHECK (kolicina > 0),
    stranka   integer      REFERENCES stranka(id)    NOT NULL,
    status    varchar(10)  CHECK (status IN ('oddano', 'v obdelavi', 'na poti', 'zaključeno')) DEFAULT 'oddano'
);

DROP TABLE IF EXISTS narocilo;
DROP TABLE IF EXISTS stranka;

INSERT INTO stranka
(ime)
VALUES('Alenak'), ('Branko'), ('Cvetka'), ('David');

INSERT INTO narocilo
(kolicina, stranka, status)
VALUES (500, 2, 'v obdelavi'),
       (300, 3, 'na poti'),
       (800, 2, 'v obdelavi'),
       (150, 1, 'oddano'),
       (400, 4, 'zaključeno'),
       (400, 1, 'na poti');

---------------------------------------------------------------------------------------------------------------

CREATE TABLE ucitelji(
    id       integer    PRIMARY KEY,
    ime      text,
    priimek  text,
    email    text
);

CREATE TABLE predmeti(
    id    integer    PRIMARY KEY,
    ime   text,
    ects  integer
);

ALTER TABLE ucitelji ADD COLUMN kabinet text;

CREATE TABLE vloge(
    id    integer    PRIMARY KEY,
    opis  text       
);

CREATE TABLE izvajalci(
    idpredmeta    integer    REFERENCES predmeti(id),
    iducitelja    integer    REFERENCES ucitelji(id),
    vloga         integer    REFERENCES vloge(id)
);


INSERT INTO vloge (id, opis) VALUES (0, 'predavatelj');
INSERT INTO vloge (id, opis) VALUES (1, 'asistent');

--- 3. 
---prva podnaloga

SELECT kabinet, COUNT(*) AS stevilo_uciteljev
FROM ucitelji
WHERE kabinet IS NOT NULL
GROUP BY kabinet
ORDER BY stevilo_uciteljev DESC;

---druga podnaloga

SELECT 
    u1.ime AS ime1, 
    u1.priimek AS priimek1, 
    u2.ime AS ime2, 
    u2.priimek AS priimek2
FROM 
    ucitelji u1
JOIN 
    ucitelji u2 ON u1.kabinet = u2.kabinet AND u1.id < u2.id
WHERE 
    u1.kabinet IS NOT NULL;

--- tretja podnaloga

SELECT 
    p.ime AS predmet_ime,
    u1.ime AS ucitelj_ime,
    u1.priimek AS ucitelj_priimek,
    u2.ime AS asistent_ime,
    u2.priimek AS asistent_priimek
FROM 
    predmeti p
JOIN 
    izvajalci e1 ON p.id = e1.idpredmeta
JOIN 
    ucitelji u1 ON e1.iducitelja = u1.id
JOIN 
    izvajalci e2 ON p.id = e2.idpredmeta AND e1.iducitelja != e2.iducitelja
JOIN 
    ucitelji u2 ON e2.iducitelja = u2.id AND e2.vloga = 1
WHERE 
    u1.kabinet IS NOT NULL AND u2.kabinet IS NOT NULL;


