INSERT INTO stranka(ime)
VALUES ("Erik"), ("Fani"), ("Gala");

UPDATE narocilo
SET status = "na poti"
WHERE id = 3;

INSERT INTO narocilo(kolicina, stranka, status)
VALUES (200, (SELECT id FROM stranka WHERE ime LIKE "Gala"), "v obdelavi");


DELETE FROM narocilo
WHERE stranka = (SELECT id FROM stranka WHERE ime LIKE "Alenka");

DELETE FROM stranka
WHERE ime = "Alenka";

--- 5
INSERT INTO narocilo(kolicina, stranka)
---v insert pošljemo rezultat poizvedbe s selectom
SELECT 100 * id, id FROM stranka WHERE id NOT IN (
SELECT DISTINCT stranka FROM narocilo);



SELECT * FROM narocilo