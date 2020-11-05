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

--Établissez la liste des membres qui ont emprunté un ouvrage depuis 
--strictement plus de deux semaines en indiquant le nom de l'ouvrage.

SELECT m.*, o.titre, sysdate - creele as "Durée en jours"
FROM membres m 
INNER JOIN emprunts em ON m.numero = em.membre
INNER JOIN details d ON em.numero = d.emprunt
INNER JOIN ouvrages o ON d.isbn = o.isbn
WHERE sysdate - creele > 14
AND d.rendule IS NOT NULL;


SELECT ou.genre, COUNT(ex.isbn) AS "Total per genre"
FROM exemplaires ex
INNER JOIN ouvrages ou ON ex.isbn = ou.isbn
GROUP BY ou.genre
ORDER BY 2 DESC;

SELECT AVG(rendule-creele) AS "Duree moyenne"
FROM emprunts em
INNER JOIN details d ON em.numero = d.emprunt
WHERE rendule IS NOT NULL;

SELECT genre, ROUND(AVG(rendule-creele)) AS "Duree moyenne par genre"
FROM emprunts em
INNER JOIN details d ON em.numero = d.emprunt
INNER JOIN ouvrages ou ON d.isbn = ou.isbn
WHERE rendule IS NOT NULL
GROUP BY genre
ORDER BY 2 DESC;


--Établissez la liste des ouvrages loués 
--plus de 10 fois au cours des 12 derniers mois.
SELECT ex.isbn
FROM emprunts em
INNER JOIN details d ON em.numero = d.emprunt
INNER JOIN exemplaires ex ON d.exemplaire = ex.numero
    AND d.isbn = ex.isbn
WHERE MONTHS_BETWEEN(em.creele, sysdate) < 12
GROUP BY ex.isbn
HAVING COUNT(*) > 2;

--Établissez la liste de tous les ouvrages avec à côté de chacun d'eux 
--les numéros d'exemplaires qui existent dans la base.
SELECT ou.*, ex.numero
FROM ouvrages ou 
LEFT OUTER JOIN exemplaires ex ON ou.isbn = ex.isbn;

--Définissez une vue qui permet de connaître pour chaque membre 
--le nombre d'ouvrages empruntés, et donc encore non rendus.
CREATE OR REPLACE VIEW ouvragesEmpruntes AS
    SELECT em.membre, COUNT(*) AS "Nombre Emprunts"
    FROM emprunts em
    INNER JOIN details d On em.numero = d.emprunt
    WHERE d.rendule IS NULL
    GROUP BY em.membre;
    
SELECT * FROM ouvragesEmpruntes;

--Vue qui permet de connaître le nombre d'emprunts par ouvrage :
CREATE OR REPLACE VIEW NombreEmpruntsParOuvrage AS
SELECT isbn, COUNT(*) AS "Nombre Emprunts"
FROM details
GROUP BY isbn
ORDER BY 2 DESC;

SELECT * FROM NombreEmpruntsParOuvrage;

--Nous souhaitons obtenir le nombre de locations par titre et 
--le nombre de locations de chaque exemplaire.
CREATE GLOBAL TEMPORARY TABLE SyntheseEmprunts (
    isbn CHAR(10),
    exemplaire NUMBER(10),
    nombreEmpruntsExemplaire number(10), 
    nombreEmpruntsOuvrage number(10)
)
ON COMMIT PRESERVE ROWS;

INSERT INTO SyntheseEmprunts 
(isbn, exemplaire, nombreEmpruntsExemplaire)
    SELECT isbn, numero, COUNT(*)
    FROM details
    GROUP BY isbn, numero;

UPDATE SyntheseEmprunts
SET nombreempruntsouvrage = (
    SELECT COUNT(*)
    FROM details d
    WHERE d.isbn = SyntheseEmprunts.isbn);

COMMIT;

SELECT * FROM SyntheseEmprunts;

--Liste des genres et des ouvrages qui appartiennent à chaque genre
SELECT g.libelle, ou.titre
FROM ouvrages ou 
INNER JOIN genres g ON ou.genre = g.code
ORDER BY 1, 2;

--Établissez le nombre d'emprunts par ouvrage et par exemplaire.
SELECT isbn, exemplaire, COUNT(*) AS Nombre
FROM details
GROUP BY ROLLUP(isbn, exemplaire)
ORDER BY 3 DESC;

SELECT isbn,
DECODE(GROUPING(exemplaire), 1, 'Tous exemplaires', exemplaire) AS exemplaire,
COUNT(*) AS nombre
FROM details
GROUP BY ROLLUP(isbn, exemplaire);

--Établissez la liste des exemplaires qui n'ont jamais été empruntés 
--au cours des trois derniers mois.
SELECT *
FROM exemplaires ex
WHERE NOT EXISTS(
    SELECT *
    FROM details d
        WHERE MONTHS_BETWEEN(sysdate, rendule) < 3
        AND d.isbn = ex.isbn
        AND d.exemplaire = ex.numero);

--Établissez la liste des ouvrages pour lesquels 
--il n'existe pas d'exemplaires à l'état neuf.
SELECT * FROM ouvrages
WHERE isbn NOT IN (
    SELECT isbn
    FROM exemplaires
    WHERE etat LIKE 'NE');

--Extrayez tous les titres qui contiennent le mot "mer" quelles que 
--soient sa place dans le titre et la casse avec laquelle il est renseigné.
SELECT isbn, titre
FROM ouvrages
WHERE LOWER(titre) LIKE '%mer%';

--Écrivez une requête qui permet de connaître tous les auteurs 
--dont le nom possède la particule "de".
SELECT DISTINCT auteur 
FROM ouvrages 
WHERE REGEXP_LIKE( auteur, 'ˆ[[:alpha:]]*[[:space:]]de[[:space:]][[:alpha:]]+$');

--Affichage détaillé des libellés
SELECT isbn, titre,
CASE genre
    WHEN 'BD' THEN 'Jeunesse'
    WHEN 'INF' THEN 'Professionnel'
    WHEN 'POL' THEN 'Adulte'
    WHEN 'REC' THEN 'Tous'
    WHEN 'ROM' THEN 'Tous'
    WHEN 'THE' THEN 'Tous'
END AS "Public"
FROM ouvrages
ORDER BY 3;

COMMENT ON TABLE membres 
IS 'Descriptifs des membres. Possède le synonyme Abonnes'; 
COMMENT ON TABLE genres 
IS 'Définition des genres possibles des ouvrages'; 
COMMENT ON TABLE ouvrages 
IS 'Description des ouvrages référencés par la bibliothèque'; 
COMMENT ON TABLE exemplaires 
IS 'Définition précise des livres présents dans la bibliothèque'; 
COMMENT ON TABLE emprunts 
IS 'Fiche d''emprunt de livres, toujours associée à un et un seul membre'; 
COMMENT ON TABLE details 
IS 'Chaque ligne correspond à un livre emprunté';

SELECT ouvrages, comments 
FROM USER_TAB_COMMENTS 
WHERE comments is not null;

--afficher un message en fonction du nombre 
--d'exemplaires de chaque ouvrage
select ou.isbn, ou.titre, 
    CASE count(*)
        when 0 then 'Aucun'
        when 1 then 'Peu'
        when 2 then 'Peu'
        when 3 then 'Normal'
        when 4 then 'Normal'
        when 5 then 'Normal'
        else 'Beaucoup'
    end as "Nombre Exemplaires"
from ouvrages ou 
inner join exemplaires ex on  ou.isbn = ex.isbn
group by ou.isbn, ou.titre
order by 2 asc;

--Tableau récapitulatif
SELECT * FROM 
(SELECT isbn, exemplaire, COUNT(*) AS qte  
FROM details GROUP BY isbn, exemplaire) 
PIVOT(SUM(qte) FOR exemplaire IN (1, 2));

--UPDATE ETAT
DECLARE
nb int;
cursor cLesExemplaires is 
    select d.isbn, d.exemplaire, etat, count(*) as nbre
    from details d
    inner join exemplaires ex on d.isbn = ex.isbn
            and d.numero = ex.numero
            group by d.isbn, d.exemplaire, etat;
Vetat exemplaire.etat%TYPE;

BEGIN
    for Vexemplaire in clesExemplaires
        loop
            if (Vexemplaire.nbre <= 10)
                then vetat := 'NE';
                else if (Vexemplaire.nbre <= 25)
                    then vetat := 'BO';
                    else if (Vexemplaire.nbre <= 40)
                        then vetat := 'MO';
                        else
                            vetat := 'MA';
                        end if;
                    end if;
                end if;
        update exemplaires set etat = Vetat 
        where isbn = Vexemplaire.isbn
        and numero = Vexemplaire.exemplaire;
    end loop;
end;
/

--la liste des trois membres qui ont emprunté le plus d'ouvrages 
--au cours des dix derniers mois et établissez également la liste 
--des trois membres qui en ont emprunté le moins.
SET SERVEROUTPUT ON

DECLARE
    CURSOR ccroissant IS 
        SELECT e.membre, count(*) nb
        from emprunts e 
        inner join details d on e.numero = d.emprunt
        where months_between(sysdate, creele) <= 10
        group by e.membre
        order by 2 asc;
        
    CURSOR cdecroissant IS
        select membre, nb from
            (select e.membre, count(*) NB
            from emprunts e
            inner join details d on e.numero = d.emprunt
            where months_between(sysdate, creele) <= 10
            group by e.membre
            order by 2 desc) R
            where rownum <= 3;
            
    vreception ccroissant%rowtype;
    i number;
    vmembre membre%rowtype;
    
BEGIN
    DBMS_OUTPUT.PUT_LINE('Les plus faibles emprunteurs');
    OPEN ccroissant;
    for i in 1..3 loop
        fetch ccroissant into vreception;
        if ccroissant%notfound
            then exit;
        end if;
        select * into vmembre
            from membres
            where numero = vreception.membre;
         dbms_output.put_line(i||') '||vmembre.numero||' '||vmembre.nom);
         end loop;
         close ccroissant;
         dbms_output.put_line('Les gros emprunteurs');
         --autre methode
         for vrec in cdecroissant loop
         select * into vmembre
         from membres
         where numero = vrec.membre;
         dbms_output.put_line(cdecroissant%ROWCOUNT||')'||vmembre.numero||' '||vmembre.nom);
         end loop;
         end;
         /
    



SET SERVEROUTPUT ON 
 
DECLARE 
  CURSOR ccroissant IS SELECT e.membre, COUNT(*) nb 
    FROM emprunts e INNER JOIN details d ON e.numero=d.emprunt 
        WHERE months_between(sysdate, creele)<=10 
    GROUP BY e.membre 
    ORDER BY 2 ASC; 
CURSOR cdecroissant IS  
SELECT membre,nb FROM  
( SELECT e.membre, COUNT(*) NB 
    FROM emprunts e INNER JOIN details d ON e.numero=d.emprunt 
        WHERE months_between(sysdate, creele)<=10 
    GROUP BY e.membre 
    ORDER BY 2 DESC ) R 
    WHERE rownum <= 3; 
 
  vreception ccroissant%rowtype; 
  i number; 
  vmembre membres%rowtype; 
BEGIN 
  DBMS_OUTPUT.PUT_LINE('Les plus faibles emprunteurs'); 
  OPEN ccroissant; 
  FOR i IN 1..3 LOOP 
    FETCH ccroissant INTO vreception; 
    IF ccroissant%NOTFOUND  
      THEN EXIT; 
    END IF; 
    SELECT * INTO vmembre  
      FROM membres  
      WHERE numero=vreception.membre; 
    DBMS_OUTPUT.PUT_LINE(i||')  '||vmembre.numero||' '||vmembre.nom); 
  END LOOP; 
  CLOSE ccroissant; 
  DBMS_OUTPUT.PUT_LINE('Les gros emprunteurs'); 
-- autre methode 
  FOR vrec IN cdecroissant LOOP 
  SELECT * INTO vmembre  
      FROM membres  
      WHERE numero=vrec.membre; 
    DBMS_OUTPUT.PUT_LINE(cdecroissant%ROWCOUNT||')  
'||vmembre.numero||' '||vmembre.nom); 
  END LOOP; 
END;
/



--un bloc PL/SQL qui permet de connaître 
--les cinq ouvrages les plus empruntés.

















