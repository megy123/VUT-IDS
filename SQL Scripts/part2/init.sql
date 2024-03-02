/*Tento scrpit blah blah blah*/

CREATE TABLE Dealer (
    id INT,
    name VARCHAR(64),
    surname VARCHAR(64),
    birthDate DATE
);

CREATE TABLE Jailer (
    id INT,
    name VARCHAR(64),
    surname VARCHAR(64),
    birthDate DATE
);

CREATE TABLE Customer (
    id INT,
    name VARCHAR(64),
    surname VARCHAR(64),
    birthDate DATE,
    cellNumber INT,
    cellType VARCHAR(256) /*ENUM ?*/
);

CREATE TABLE Order (
    orderId INT,
    price FLOAT(2),
    deliveryType VARCHAR(256) /*ENUM ?*/
    deliveryDate DATE
);

CREATE TABLE Pastry (
    EAN INT,
    weight INT,/*v gramoch*/
    pastryType INT, /*ENUM :*/
);

/*TODO: oprav v ER z ingredients*/
CREATE TABLE Ingredient (
    id INT,
    amount INT,
    price FLOAT(2),
    alergens STRING[]/*TODO:!!! možno ENUM ?*/
    gluten BOOLEAN
);

CREATE TABLE Jail (
    id INT,
    address VARCHAR(256)/*možno rozšíriť na novú tablu*/
);

CREATE TABLE Shift (
    id INT,
    startTime TIMESTAMP,
    endTime TIMESTAMP
);

CREATE TABLE Delivery_zone (
    id INT
);

/*na id by sa možno dalo použiť ROWID * "You should not use ROWID as the primary key of a table" zdroj Google*/
/*TODO: porieš INTY nesu dobre*/