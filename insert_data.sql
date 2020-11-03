INSERT INTO genres(code, libelle) VALUES ('REC','Récit'); 
INSERT INTO genres(code, libelle) VALUES ('POL','Policier'); 
INSERT INTO genres(code, libelle) VALUES ('BD','Bande Dessinée'); 
INSERT INTO genres(code, libelle) VALUES ('INF','Informatique'); 
INSERT INTO genres(code, libelle) VALUES ('THE','Théâtre'); 
INSERT INTO genres(code, libelle) VALUES ('ROM','Roman');

INSERT INTO ouvrages (isbn, titre, auteur, genre, editeur) 
VALUES (2203314168, 'LEFRANC-L''ultimatum', 'Martin, Carin', 'BD', 'Casterman'); 
INSERT INTO ouvrages (isbn, titre, auteur, genre, editeur) 
VALUES (2746021285, 'HTML entraînez-vous pour maîtriser le code source',  
'Luc Van Lancker', 'INF', 'ENI'); 
INSERT INTO ouvrages (isbn, titre, auteur, genre, editeur) 
VALUES (2746026090, ' Oracle 12c SQL, PL/SQL, SQL*Plus', ' J. Gabillaud',  
'INF', 'ENI'); 
INSERT INTO ouvrages (isbn, titre, auteur, genre, editeur) 
VALUES (2266085816, 'Pantagruel', 'François RABELAIS', 'ROM', 'POCKET'); 
INSERT INTO ouvrages (isbn, titre, auteur, genre, editeur) 
VALUES (2266091611, 'Voyage au centre de la terre', 'Jules Verne', 'ROM',  
'POCKET'); 
INSERT INTO ouvrages (isbn, titre, auteur, genre, editeur) 
VALUES (2253010219, 'Le crime de l''Orient Express', 'Agatha Christie',  
'POL', 'Livre de Poche'); 
INSERT INTO ouvrages (isbn, titre, auteur, genre, editeur) 
VALUES (2070400816, 'Le Bourgeois gentilhomme', 'Moliere', 'THE', 'Gallimard'); 
INSERT INTO ouvrages (isbn, titre, auteur, genre, editeur) 
VALUES (2070367177, 'Le curé de Tours', 'Honoré de Balzac', 'ROM', 'Gallimard'); 
INSERT INTO ouvrages (isbn, titre, auteur, genre, editeur) 
VALUES (2080720872, 'Boule de suif', 'Guy de Maupassant', 'REC', 'Flammarion'); 
INSERT INTO ouvrages (isbn, titre, auteur, genre, editeur) 
VALUES (2877065073, 'La gloire de mon père', 'Marcel Pagnol', 'ROM', 'Fallois'); 
INSERT INTO ouvrages (isbn, titre, auteur, genre, editeur) 
VALUES (2020549522, ' L''aventure des manuscrits de la mer morte ', default,  
'REC', 'Seuil'); 
INSERT INTO ouvrages (isbn, titre, auteur, genre, editeur) 
VALUES (2253006327, ' Vingt mille lieues sous les mers ', ' Jules Verne ',  
'ROM', 'LGF'); 
INSERT INTO ouvrages (isbn, titre, auteur, genre, editeur) 
VALUES (2038704015, 'De la terre à la lune', ' Jules Verne', 'ROM', 'Larousse');

select * from ouvrages;

DELETE FROM exemplaires WHERE isbn=2746021285 AND numero=2;

UPDATE exemplaires SET etat='MO' WHERE isbn=2203314168 AND numero=1; 
UPDATE exemplaires SET etat='BO' WHERE isbn=2203314168 AND numero=2; 
INSERT INTO exemplaires(isbn, numero, etat) VALUES (2203314168,3,'NE');

select * from membres;

INSERT INTO membres (numero, nom, prenom, adresse, telephone, mobile, adhesion, duree) 
VALUES (1, 'ALBERT', 'Anne', '13 rue des alpes', 
'0601020304', '0601020304', sysdate-60, 1); 

INSERT INTO membres (numero, nom, prenom, adresse, telephone, mobile, adhesion, duree) 
VALUES (2, 'BERNAUD', 'Barnabé', '6 rue des bécasses', 
'0602030105', '0601020304', sysdate-10, 3); 

INSERT INTO membres (numero, nom, prenom, adresse, telephone, mobile, adhesion, duree) 
VALUES (3, 'CUVARD', 'Camille', '52 rue des cerisiers', 
'0602010509', '0601020304', sysdate-100, 6); 

INSERT INTO membres (numero, nom, prenom, adresse, telephone, mobile, adhesion, duree) 
VALUES (4, 'DUPOND', 'Daniel', '11 rue des daims', 
'0610236515', '0601020304', sysdate-250, 12); 

INSERT INTO membres (numero, nom, prenom, adresse, telephone, mobile, adhesion, duree) 
VALUES (5, 'EVROUX', 'Eglantine', '34 rue des elfes',  
'0658963125', '0601020304', sysdate-150, 6); 

INSERT INTO membres (numero, nom, prenom, adresse, telephone, mobile, adhesion, duree) 
VALUES (6, 'FREGEON', 'Fernand', '11 rue des Francs',  
'0602036987', '0601020304', sysdate-400, 6); 

INSERT INTO membres (numero, nom, prenom, adresse, telephone, mobile, adhesion, duree) 
VALUES (7, 'GORIT', 'Gaston', '96 rue de la glacerie ',  
'0684235781', '0601020304', sysdate-150, 1); 

INSERT INTO membres (numero, nom, prenom, adresse, telephone, mobile, adhesion, duree) 
VALUES (8, 'HEVARD', 'Hector', '12 rue haute', '0608546578', '0601020304',
sysdate-250, 12); 

INSERT INTO membres (numero, nom, prenom, adresse, telephone, mobile, adhesion, duree) 
VALUES (9, 'INGRAND', 'Irène', '54 rue des iris', 
'0605020409', '0601020304', sysdate-50, 12); 

INSERT INTO membres (numero, nom, prenom, adresse, telephone, mobile, adhesion, duree) 
VALUES (10, 'JUSTE', 'Julien', '5 place des Jacobins',  
'0603069876', '0601020304', sysdate-100, 6);
commit;

delete from membres;

select * from membres;
select * from exemplaires;
select * from genres;
select * from genres;
select * from ouvrages;
select * from emprunts;
select * from details;

delete from exemplaires;
ROLLBACK;
commit;























