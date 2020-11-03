CREATE TABLE genres (
    code CHAR(5) CONSTRAINT pk_genres PRIMARY KEY,
    libelle VARCHAR(80) NOT NULL
);

select * from genres;

CREATE TABLE ouvrages (
    isbn NUMBER(10) CONSTRAINT pk_ouvrages PRIMARY KEY,
    titre VARCHAR2(200) NOT NULL,
    auteur VARCHAR2(80),
    genre CHAR(5) NOT NULL
    CONSTRAINT fk_ouvrages_genres REFERENCES genres(code),
    editeur VARCHAR2(80)
);

select * from ouvrages;

CREATE TABLE exemplaires (
    isbn NUMBER(10),
    numero NUMBER(3),
    etat CHAR(5),
    CONSTRAINT pk_exemplaires PRIMARY KEY(isbn, numero),
    CONSTRAINT fk_exemplaires_ouvrages
        FOREIGN KEY(isbn) REFERENCES ouvrages(isbn),
    CONSTRAINT ck_exemplaires_etat CHECK
        (etat in ('NE', 'BO', 'MO', 'MA'))
);

select * from exemplaires;
 
CREATE TABLE membres (
    numero NUMBER(6) CONSTRAINT pk_membres PRIMARY KEY,
    nom VARCHAR2(80) NOT NULL,
    prenom VARCHAR2(80) NOT NULL,
    adresse VARCHAR2(200) NOT NULL,
    telephone CHAR(10) NOT NULL,
    adhesion DATE NOT NULL,
    duree NUMBER(2) NOT NULL
    CONSTRAINT ck_membres_duree CHECK (duree >= 0)
);

select * from membres;

CREATE TABLE emprunts (
    numero NUMBER(10) CONSTRAINT pk_emprunts PRIMARY KEY,
    membre NUMBER(6) CONSTRAINT fk_emprunts_membres
        REFERENCES membres(numero),
    creele DATE DEFAULT SYSDATE
);

select * from emprunts;

CREATE TABLE detailsemprunts (
    emprunt NUMBER(10) CONSTRAINT fk_details_emprunts 
        REFERENCES emprunts (numero),
    numero NUMBER(3),
    isbn NUMBER(10),
    exemplaire NUMBER(3),
    rendule DATE,
    CONSTRAINT pk_detailsemprunts PRIMARY KEY (emprunt, numero),
    CONSTRAINT fk_detailsemprunts_exemplaire
        FOREIGN KEY(isbn, exemplaire) REFERENCES exemplaires(isbn, numero)
);

select * from details;

CREATE SEQUENCE seq_membre START WITH 1 INCREMENT BY 1;

ALTER TABLE membres 
ADD CONSTRAINT uq_membres UNIQUE (nom, prenom, telephone);

ALTER TABLE membres ADD mobile CHAR(10);
ALTER TABLE membres ADD CONSTRAINT ck_membres_mobile
CHECK (mobile LIKE '06%' OR mobile LIKE '07%');

CREATE INDEX idx_ouvrages_genre ON ouvrages(genre); 
CREATE INDEX idx_emplaires_isbn ON exemplaires(isbn); 
CREATE INDEX idx_emprunts_membre ON emprunts(membre); 
CREATE INDEX idx_details_emprunt ON detailsemprunts(emprunt); 
CREATE INDEX idx_details_exemplaire ON detailsemprunts(isbn, exemplaire);

ALTER TABLE detailsemprunts DROP CONSTRAINT fk_details_emprunts;

ALTER TABLE detailsemprunts ADD CONSTRAINT
fk_details_emprunts FOREIGN KEY(emprunt)
REFERENCES emprunts(numero) ON DELETE CASCADE;

ALTER TABLE exemplaires MODIFY (
etat CHAR(2) DEFAULT 'NE');

CREATE SYNONYM abonnes FOR membres;

RENAME detailsemprunts TO details;

COMMIT;























