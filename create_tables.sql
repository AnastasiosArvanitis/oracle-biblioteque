CREATE TABLE genres (
    code CHAR(5) CONSTRAINT pk_genres PRIMARY KEY,
    libelle VARCHAR(80) NOT NULL
);

CREATE TABLE ouvrages (
    isbn NUMBER(10) CONSTRAINT pk_ouvrages PRIMARY KEY,
    titre VARCHAR2(200) NOT NULL,
    auteur VARCHAR2(80),
    genre CHAR(5) NOT NULL
    CONSTRAINT fk_ouvrages_genres REFERENCES genres(code),
    editeur VARCHAR2(80)
);

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

CREATE TABLE emprunts (
    numero NUMBER(10) CONSTRAINT pk_emprunts PRIMARY KEY,
    membre NUMBER(6) CONSTRAINT fk_emprunts_membres
        REFERENCES membres(numero),
    creele DATE DEFAULT SYSDATE
);

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