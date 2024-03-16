/*
File:       xsajko01_xsando04.sql
Authors:    Dominik Sajko (xsajko01), Daniela Sándorová (xsando04)
Date:       xx.03.2024
Descrition: This script initializes the database and uploads data.
*/

-- ER DIAGRAM TABLES

/*
The generalization relationship was broken down into separate tables according to the 4th IDS 
presentation (option 2), because it minimizes the complexity of the database.
*/
CREATE TABLE Dealer (
    dealer_id INT not null,
    name VARCHAR(64) not null,
    surname VARCHAR(64) not null,
    birth_date DATE not null,
    CONSTRAINT dealer_pk PRIMARY KEY (dealer_id)
);

CREATE TABLE Jailer (
    jailer_id INT not null,
    jail_id INT not null,
    name VARCHAR(64) not null,
    surname VARCHAR(64) not null,
    birth_date DATE not null,
    CONSTRAINT jailer_pk PRIMARY KEY (jailer_id)
);

CREATE TABLE Customer (
    customer_id INT not null,
    jail_id INT not null,
    name VARCHAR(64) not null,
    surname VARCHAR(64) not null,
    birth_date DATE not null,
    cell_number INT,
    cell_type VARCHAR(256),
    CONSTRAINT customer_pk PRIMARY KEY (customer_id)
);

CREATE TABLE Item_order (
    order_id INT not null,
    customer_id INT not null,
    first_pastry_EAN INT not null,
    price FLOAT(2) not null,
    delivery_type VARCHAR(256) not null,
    delivery_date DATE,
    CONSTRAINT order_pk PRIMARY KEY (order_id)
);

CREATE TABLE Pastry (
    EAN INT not null,
    order_id INT not null,
    weight INT not null, -- in grams
    pastry_type VARCHAR(256) not null,
    CONSTRAINT pastry_pk PRIMARY KEY (EAN)
);

CREATE TABLE Ingredient (
    ingredient_id INT not null,
    amount INT not null,
    price FLOAT(2) not null,
    CONSTRAINT ingredient_pk PRIMARY KEY (ingredient_id)
);

CREATE TABLE Allergen (
    allergen_name VARCHAR(32) not null,
    CONSTRAINT allergen_pk PRIMARY KEY (allergen_name)
);

CREATE TABLE Jail (
    jail_id INT not null,
    first_shift_id INT not null,
    delivery_zone_id INT not null,
    address VARCHAR(256) not null,
    CONSTRAINT jail_id PRIMARY KEY (jail_id)
);

CREATE TABLE Shift (
    shift_id INT not null,
    jail_id INT not null,
    start_time TIMESTAMP not null,
    end_time TIMESTAMP not null,
    CONSTRAINT shift_pk PRIMARY KEY (shift_id)
);

CREATE TABLE Delivery_zone (
    delivery_zone_id INT not null,
    dealer_id INT not null,
    CONSTRAINT delivery_zone_pk PRIMARY KEY (delivery_zone_id)
);

CREATE TABLE Backed_item (
    backed_item_id INT not null,
    weight INT not null,
    CONSTRAINT backed_item_pk PRIMARY KEY (backed_item_id)
);

-- ASSOCIATIVE TABLES

CREATE TABLE Dealer_Jailer (
    dealer_id INT not null,
    jailer_id INT not null
);

CREATE TABLE Jailer_Shift (
    jailer_id INT not null,
    shift_id INT not null
);

CREATE TABLE Backed_item_Pastry (
    backed_item_id INT not null,
    EAN INT not null
);

CREATE TABLE Ingredient_Pastry (
    ingredient_id INT not null,
    EAN INT not null
);

CREATE TABLE Ingredient_Allergern (
    ingredient_id INT not null,
    allergen_name VARCHAR(32) not null
);

-- FOREIGN KEY SET UP

-- ER tables
ALTER TABLE Jailer ADD CONSTRAINT Jjail_fk FOREIGN KEY (jail_id) REFERENCES Jail(jail_id);
ALTER TABLE Customer ADD CONSTRAINT Cjail_fk FOREIGN KEY (jail_id) REFERENCES Jail(jail_id);
ALTER TABLE Item_order ADD CONSTRAINT customer_fk FOREIGN KEY (customer_id) REFERENCES Customer(customer_id);
ALTER TABLE Pastry ADD CONSTRAINT Porder_fk FOREIGN KEY (order_id) REFERENCES Item_order(order_id) UNIQUE (order_id, EAN);
ALTER TABLE Item_order ADD CONSTRAINT first_pastry_EAN FOREIGN KEY (order_id, first_pastry_EAN) REFERENCES Pastry(order_id, EAN);/* 1..* */
ALTER TABLE Jail ADD CONSTRAINT delivery_zone_fk FOREIGN KEY (delivery_zone_id) REFERENCES Delivery_zone(delivery_zone_id);
ALTER TABLE Shift ADD CONSTRAINT Sjail_fk FOREIGN KEY (jail_id) REFERENCES Jail(jail_id) UNIQUE (jail_id, shift_id);
ALTER TABLE Jail ADD CONSTRAINT first_shift_fk FOREIGN KEY (jail_id, first_shift_id) REFERENCES Shift(jail_id, shift_id);/* 1..* */
ALTER TABLE Delivery_zone ADD CONSTRAINT dealer_fk FOREIGN KEY (dealer_id) REFERENCES Dealer(dealer_id);

--
ALTER TABLE Dealer_Jailer ADD CONSTRAINT DJdealer_fk FOREIGN KEY (dealer_id) REFERENCES Dealer(dealer_id);
ALTER TABLE Dealer_Jailer ADD CONSTRAINT DJjailer_fk FOREIGN KEY (jailer_id) REFERENCES Jailer(jailer_id);

--
ALTER TABLE Jailer_Shift ADD CONSTRAINT JSjailer_fk FOREIGN KEY (jailer_id) REFERENCES Jailer(jailer_id);
ALTER TABLE Jailer_Shift ADD CONSTRAINT JSshift_fk FOREIGN KEY (shift_id) REFERENCES Shift(shift_id);

--
ALTER TABLE Backed_item_Pastry ADD CONSTRAINT BPbacked_item_fk FOREIGN KEY (backed_item_id) REFERENCES Backed_item(backed_item_id);
ALTER TABLE Backed_item_Pastry ADD CONSTRAINT BPEAN_fk FOREIGN KEY (EAN) REFERENCES Pastry(EAN);

--
ALTER TABLE Ingredient_Pastry ADD CONSTRAINT IPingredient_fk FOREIGN KEY (ingredient_id) REFERENCES Ingredient(ingredient_id);
ALTER TABLE Ingredient_Pastry ADD CONSTRAINT IPEAN_fk FOREIGN KEY (EAN) REFERENCES Pastry(EAN);

--
ALTER TABLE Ingredient_Allergern ADD CONSTRAINT IAingredient_fk FOREIGN KEY (ingredient_id) REFERENCES Ingredient(ingredient_id);
ALTER TABLE Ingredient_Allergern ADD CONSTRAINT IAallergen_name_fk FOREIGN KEY (allergen_name) REFERENCES Allergen(allergen_name);

-- INSERT DATA TO database

--tu bude Danka kúzliť
--čáry máry