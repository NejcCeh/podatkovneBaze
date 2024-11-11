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