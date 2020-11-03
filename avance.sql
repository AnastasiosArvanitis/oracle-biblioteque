ALTER TABLE membres ENABLE ROW MOVEMENT;
ALTER TABLE details ENABLE ROW MOVEMENT;

SELECT * FROM EMPRUNTS;

ALTER TABLE emprunts
ADD (etat CHAR(2) DEFAULT 'EC');

ALTER TABLE emprunts ADD CONSTRAINT
ck_emprunts_etat CHECK (etat in('EC', 'RE'));

UPDATE emprunts SET etat = 'RE' 
WHERE etat = 'EC' AND numero NOT IN (
    SELECT emprunt 
    FROM details
    WHERE rendule IS NULL
);

COMMIT;

INSERT INTO details(emprunt, numero, isbn, exemplaire, rendule) VALUES  
(7,2,2038704015,1,sysdate-136); 
INSERT INTO details(emprunt, numero, isbn, exemplaire, rendule) VALUES  
(8,2,2038704015,1,sysdate-127); 
INSERT INTO details(emprunt, numero, isbn, exemplaire, rendule) VALUES  
(11,2,2038704015,1,sysdate-95); 
INSERT INTO details(emprunt, numero, isbn, exemplaire, rendule) VALUES 
(15,2,2038704015,1,sysdate-54); 
INSERT INTO details(emprunt, numero, isbn, exemplaire, rendule) VALUES  
(16,3,2038704015,1,sysdate-43); 
INSERT INTO details(emprunt, numero, isbn, exemplaire, rendule) VALUES  
(17,2,2038704015,1,sysdate-36); 
INSERT INTO details(emprunt, numero, isbn, exemplaire, rendule) VALUES  
(18,2,2038704015,1,sysdate-24); 
INSERT INTO details(emprunt, numero, isbn, exemplaire, rendule) VALUES  
(19,2,2038704015,1,sysdate-13); 
INSERT INTO details(emprunt, numero, isbn, exemplaire, rendule) VALUES  
(20,3,2038704015,1,sysdate-3);

UPDATE exemplaires SET etat='NE' WHERE isbn=2038704015 AND numero=1;

commit;

CREATE TABLE tempoExemplaires AS 
    SELECT isbn, exemplaire, COUNT(*) AS Locations
    FROM details
    GROUP BY isbn, exemplaire;

MERGE INTO exemplaires e
USING (
    SELECT isbn, exemplaire, locations
    FROM tempoExemplaires) t
    ON (t.isbn = e.isbn AND t.exemplaire = e.numero)
    WHEN MATCHED THEN
        UPDATE SET etat = 'BO'
        WHERE t.locations BETWEEN 11 AND 25
        DELETE WHERE t.locations > 60;

COMMIT;

--DROP TABLE tempoExemplaires











