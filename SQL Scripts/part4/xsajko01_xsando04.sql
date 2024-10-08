/*
File:       xsajko01_xsando04.sql
Authors:    Dominik Sajko (xsajko01), Daniela Sándorová (xsando04)
Date:       02.04.2024
Description: This script initializes the database and uploads data.
*/

/* ER DIAGRAM TABLES */

/*
The generalization relationship was broken down into separate tables according to the 4th IDS
presentation (option 2), because it minimizes the complexity of the database.
*/

ALTER TABLE Jailer DROP CONSTRAINT jailer_jail_fk;
ALTER TABLE Customer DROP CONSTRAINT customer_jail_fk;
ALTER TABLE Item_order DROP CONSTRAINT item_order_customer_fk;
ALTER TABLE Jail DROP CONSTRAINT jail_delivery_zone_fk;
ALTER TABLE Shift DROP CONSTRAINT shift_jail_fk;
ALTER TABLE Delivery_zone DROP CONSTRAINT delivery_zone_dealer_fk;

--at least one rels
ALTER TABLE Item_order DROP CONSTRAINT item_order_first_pastry_ean;
ALTER TABLE Pastry DROP CONSTRAINT pastry_first_ingredient;

ALTER TABLE Dealer_Jailer DROP CONSTRAINT dealer_jailer_dealer_fk;
ALTER TABLE Dealer_Jailer DROP CONSTRAINT dealer_jailer_jailer_fk;

ALTER TABLE Jailer_Shift DROP CONSTRAINT jailer_shift_jailer_fk;
ALTER TABLE Jailer_Shift DROP CONSTRAINT jailer_shift_shift_fk;

ALTER TABLE Ingredient_Pastry DROP CONSTRAINT ingredient_pastry_ingredient_fk;
ALTER TABLE Ingredient_Pastry DROP CONSTRAINT ingredient_pastry_ean_fk;
ALTER TABLE Ingredient_Allergen DROP CONSTRAINT ingredient_allergen_ingredient_fk;
ALTER TABLE Ingredient_Allergen DROP CONSTRAINT ingredient_allergen_allergen_name_fk;
ALTER TABLE Item_order DROP CONSTRAINT item_price_validity;
ALTER TABLE Ingredient DROP CONSTRAINT ingredient_price_validity;
ALTER TABLE Ingredient DROP CONSTRAINT ingredient_amount_validity;
ALTER TABLE Shift DROP CONSTRAINT shift_time_validity;



ALTER TABLE Pastry DROP CONSTRAINT pastry_weight_validity;
ALTER TABLE Backed_item DROP CONSTRAINT backed_item_weight_validity;



DROP TABLE Dealer;
DROP TABLE Jailer;
DROP TABLE Customer;
DROP TABLE Item_order;

DROP TABLE Ingredient;
DROP TABLE Jail;
DROP TABLE Shift;
DROP TABLE Delivery_zone;
DROP TABLE Allergen;

DROP TABLE Dealer_Jailer;
DROP TABLE Jailer_Shift;
DROP TABLE Backed_item_Pastry;
DROP TABLE Ingredient_Pastry;
DROP TABLE Ingredient_Allergen;
DROP TABLE Customer_log;

DROP TABLE Pastry;
DROP TABLE Backed_item;

CREATE TABLE Dealer (
    dealer_id INT GENERATED BY DEFAULT ON NULL AS IDENTITY,
    first_name VARCHAR(64) NOT NULL,
    surname VARCHAR(64) NOT NULL,
    birth_date DATE NOT NULL,
    CONSTRAINT dealer_pk PRIMARY KEY (dealer_id)
);

CREATE TABLE Jailer (
    jailer_id INT GENERATED BY DEFAULT ON NULL AS IDENTITY,
    jail_id INT NOT NULL,
    first_name VARCHAR(64) NOT NULL,
    surname VARCHAR(64) NOT NULL,
    birth_date DATE NOT NULL,
    CONSTRAINT jailer_pk PRIMARY KEY (jailer_id)
);

CREATE TABLE Customer (
    customer_id INT GENERATED BY DEFAULT ON NULL AS IDENTITY,
    jail_id INT,
    first_name VARCHAR(64) NOT NULL,
    surname VARCHAR(64) NOT NULL,
    birth_date DATE NOT NULL,
    cell_number INT,
    cell_type VARCHAR(256),
    CONSTRAINT customer_pk PRIMARY KEY (customer_id)
);

CREATE TABLE Item_order (
    order_id INT NOT NULL,
    customer_id INT NOT NULL,
    first_pastry_EAN INT NOT NULL,
    price FLOAT(2) NOT NULL,
    delivery_type VARCHAR(256) NOT NULL,
    delivery_date DATE,
    CONSTRAINT item_order_pk PRIMARY KEY (order_id),
    CONSTRAINT item_price_validity CHECK (price >= 0)
);

CREATE TABLE Pastry (
    EAN INT NOT NULL,
    name VARCHAR(256) NOT NULL,
    first_ingredient INT,
    pastry_weight INT NOT NULL, -- in grams
    pastry_type VARCHAR(256) NOT NULL,
    CONSTRAINT pastry_pk PRIMARY KEY (EAN),
    CONSTRAINT pastry_weight_validity CHECK (pastry_weight > 0)
);

CREATE TABLE Ingredient (
    ingredient_id INT NOT NULL,
    name VARCHAR(256) NOT NULL,
    amount INT NOT NULL,
    price FLOAT(2) NOT NULL,
    CONSTRAINT ingredient_pk PRIMARY KEY (ingredient_id),
    CONSTRAINT ingredient_price_validity CHECK (price > 0),
    CONSTRAINT ingredient_amount_validity CHECK (amount >= 0)
);

CREATE TABLE Allergen (
    allergen_name VARCHAR(32) NOT NULL,
    CONSTRAINT allergen_pk PRIMARY KEY (allergen_name)
);

CREATE TABLE Jail (
    jail_id INT NOT NULL,
    delivery_zone_id INT NOT NULL,
    address VARCHAR(256) NOT NULL,
    CONSTRAINT jail_pk PRIMARY KEY (jail_id)
);

CREATE TABLE Shift (
    shift_id INT NOT NULL,
    jail_id INT NOT NULL,
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP NOT NULL,
    CONSTRAINT shift_pk PRIMARY KEY (shift_id),
    CONSTRAINT shift_time_validity CHECK (start_time < end_time)
);

CREATE TABLE Delivery_zone (
    delivery_zone_id INT NOT NULL,
    dealer_id INT NOT NULL,
    CONSTRAINT delivery_zone_pk PRIMARY KEY (delivery_zone_id)
);

CREATE TABLE Backed_item (
    backed_item_id INT NOT NULL,
    weight INT NOT NULL,
    CONSTRAINT backed_item_pk PRIMARY KEY (backed_item_id),
    CONSTRAINT backed_item_weight_validity CHECK (weight > 0)
);

CREATE TABLE Customer_log (
    customer_id INT GENERATED BY DEFAULT ON NULL AS IDENTITY,
    jail_address VARCHAR(256),
    first_name VARCHAR(64) NOT NULL,
    surname VARCHAR(64) NOT NULL,
    birth_date DATE NOT NULL,
    cell_number INT,
    cell_type VARCHAR(256),
    CONSTRAINT log_customer_pk PRIMARY KEY (customer_id)
);

/* ASSOCIATIVE TABLES */

CREATE TABLE Dealer_Jailer (
    dealer_id INT NOT NULL,
    jailer_id INT NOT NULL
);

CREATE TABLE Jailer_Shift (
    jailer_id INT NOT NULL,
    shift_id INT NOT NULL,
    CONSTRAINT jailer_shift_pk PRIMARY KEY (jailer_id, shift_id)
);

CREATE TABLE Backed_item_Pastry (
    backed_item_id INT NOT NULL,
    EAN INT NOT NULL,
    CONSTRAINT backed_item_Pastry_pk PRIMARY KEY (backed_item_id, EAN)
);

CREATE TABLE Ingredient_Pastry (
    ingredient_id INT NOT NULL,
    EAN INT NOT NULL,
    CONSTRAINT ingredient_Pastry_pk PRIMARY KEY (ingredient_id, EAN)
);

CREATE TABLE Ingredient_Allergen (
    ingredient_id INT NOT NULL,
    allergen_name VARCHAR(32) NOT NULL
);

/* FOREIGN KEY SET UP */

/* ER tables */
ALTER TABLE Jailer ADD CONSTRAINT jailer_jail_fk FOREIGN KEY (jail_id) REFERENCES Jail(jail_id);
ALTER TABLE Customer ADD CONSTRAINT customer_jail_fk FOREIGN KEY (jail_id) REFERENCES Jail(jail_id);
ALTER TABLE Item_order ADD CONSTRAINT item_order_customer_fk FOREIGN KEY (customer_id) REFERENCES Customer(customer_id);
ALTER TABLE Jail ADD CONSTRAINT jail_delivery_zone_fk FOREIGN KEY (delivery_zone_id) REFERENCES Delivery_zone(delivery_zone_id);
ALTER TABLE Shift ADD CONSTRAINT shift_jail_fk FOREIGN KEY (jail_id) REFERENCES Jail(jail_id);
ALTER TABLE Delivery_zone ADD CONSTRAINT delivery_zone_dealer_fk FOREIGN KEY (dealer_id) REFERENCES Dealer(dealer_id);

/* Associative tables */
ALTER TABLE Dealer_Jailer ADD CONSTRAINT dealer_jailer_dealer_fk FOREIGN KEY (dealer_id) REFERENCES Dealer(dealer_id);
ALTER TABLE Dealer_Jailer ADD CONSTRAINT dealer_jailer_jailer_fk FOREIGN KEY (jailer_id) REFERENCES Jailer(jailer_id);

ALTER TABLE Jailer_Shift ADD CONSTRAINT jailer_shift_jailer_fk FOREIGN KEY (jailer_id) REFERENCES Jailer(jailer_id);
ALTER TABLE Jailer_Shift ADD CONSTRAINT jailer_shift_shift_fk FOREIGN KEY (shift_id) REFERENCES Shift(shift_id);

ALTER TABLE Backed_item_Pastry ADD CONSTRAINT backed_item_backed_item_fk FOREIGN KEY (backed_item_id) REFERENCES Backed_item(backed_item_id);
ALTER TABLE Backed_item_Pastry ADD CONSTRAINT backed_item_ean_fk FOREIGN KEY (EAN) REFERENCES Pastry(EAN);

ALTER TABLE Ingredient_Pastry ADD CONSTRAINT ingredient_pastry_ingredient_fk FOREIGN KEY (ingredient_id) REFERENCES Ingredient(ingredient_id);
ALTER TABLE Ingredient_Pastry ADD CONSTRAINT ingredient_pastry_ean_fk FOREIGN KEY (EAN) REFERENCES Pastry(EAN);

ALTER TABLE Ingredient_Allergen ADD CONSTRAINT ingredient_allergen_ingredient_fk FOREIGN KEY (ingredient_id) REFERENCES Ingredient(ingredient_id);
ALTER TABLE Ingredient_Allergen ADD CONSTRAINT ingredient_allergen_allergen_name_fk FOREIGN KEY (allergen_name) REFERENCES Allergen(allergen_name);

/* At least one cardinality */
ALTER TABLE Pastry ADD CONSTRAINT pastry_first_ingredient FOREIGN KEY (first_ingredient) REFERENCES Ingredient(ingredient_id);
ALTER TABLE Item_order ADD CONSTRAINT item_order_first_pastry_EAN FOREIGN KEY (first_pastry_EAN) REFERENCES Pastry(EAN);



/* INSERT DATA TO DATABASE */

-- Dealers
INSERT INTO Dealer (dealer_id, first_name, surname, birth_date)
VALUES (101,'Marian','Kotleba',TO_DATE('1977-04-07', 'YYYY-MM-DD'));
INSERT INTO Dealer (dealer_id, first_name, surname, birth_date)
VALUES (102,'Martin','Beluský',TO_DATE('1987-04-17', 'YYYY-MM-DD'));

-- Delivery Zones
INSERT INTO Delivery_zone (delivery_zone_id, dealer_id)
VALUES (201,101);

-- Jail
INSERT INTO Jail (jail_id, delivery_zone_id, address)
VALUES (1, 201, 'Gucmanova 670, 920 41 Leopoldov, Slovensko');

-- Shift
INSERT INTO Shift (shift_id, jail_id, start_time, end_time)
VALUES (301, 1, TO_TIMESTAMP('2024-03-20 08:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-03-20 16:00:00', 'YYYY-MM-DD HH24:MI:SS'));

-- Jailers
INSERT INTO Jailer (jailer_id,jail_id, first_name, surname, birth_date)
VALUES (401,1,'Richard','Sulík',TO_DATE('1968-01-12', 'YYYY-MM-DD'));
INSERT INTO Jailer (jailer_id,jail_id, first_name, surname, birth_date)
VALUES (402,1,'Branislav','Gröhling',TO_DATE('1975-04-06', 'YYYY-MM-DD'));

-- Dealer_Jailer
INSERT INTO Dealer_Jailer (dealer_id, jailer_id)
VALUES (101, 402);
INSERT INTO Dealer_Jailer (dealer_id, jailer_id)
VALUES (102, 401);

-- Jailer_Shift
INSERT INTO Jailer_Shift (jailer_id, shift_id)
VALUES (401, 301);


-- Customers
INSERT INTO Customer (customer_id,jail_id, first_name, surname, birth_date, cell_number, cell_type)
VALUES (501,1,'Peter', 'Pellegrini',TO_DATE('1975-10-06', 'YYYY-MM-DD'),1,'solitary');
INSERT INTO Customer (customer_id,jail_id, first_name, surname, birth_date, cell_number, cell_type)
VALUES (503,1,'Denisa', 'Sakova',TO_DATE('1976-04-17', 'YYYY-MM-DD'),3,'solitary');
INSERT INTO Customer (customer_id,jail_id, first_name, surname, birth_date, cell_number, cell_type)
VALUES (502,1,'Matúš', 'Šutaj Eštok',TO_DATE('1987-02-04', 'YYYY-MM-DD'),2,'double');


-- Allergen
INSERT INTO Allergen (allergen_name)
VALUES ('gluten');

-- Ingredients
INSERT INTO Ingredient (ingredient_id, name, amount, price)
VALUES (601, 'whole-wheat flour', 1000, 2.99);

-- Ingredient_Allergen
INSERT INTO Ingredient_Allergen (ingredient_id, allergen_name)
VALUES (601, 'gluten');

-- Pastry
INSERT INTO Pastry (EAN, name, first_ingredient, pastry_weight, pastry_type)
VALUES (123456789, 'bread', 601, 100, 'whole-wheat');

-- Ingredient_Pastry
INSERT INTO Ingredient_Pastry (ingredient_id, EAN)
VALUES (601, 123456789);

-- Item Orders
INSERT INTO Item_order (order_id, customer_id, first_pastry_EAN, price, delivery_type, delivery_date)
VALUES (1, 501, 123456789, 2.99, 'express', TO_DATE('2024-03-25', 'YYYY-MM-DD'));

-- Backed Item
INSERT INTO Backed_item (backed_item_id, weight)
VALUES (1, 200);

-- Backed_item_Pastry
INSERT INTO Backed_item_Pastry (backed_item_id, EAN)
VALUES (1, 123456789);

COMMIT;

-- customer is looking for a pastry with their favorite ingredient (joining two tables)
SELECT p.name as ingredient_name FROM Pastry p  JOIN Ingredient i on p.first_ingredient = i.ingredient_id
WHERE i.name = 'whole-wheat flour';

-- dealer checking the address of a customer they're delivering to
SELECT address as jail_address from Customer c JOIN Jail j on c.jail_id = j.jail_id
WHERE c.surname = 'Pellegrini';

-- customer is checking if their favorite pastry contains any allergens (joining four tables - instead of three as in the assignment)
SELECT DISTINCT A.allergen_name as allergen FROM Allergen A JOIN Ingredient_Allergen IA ON A.allergen_name = IA.allergen_name JOIN Ingredient_Pastry IP ON IA.ingredient_id = IP.ingredient_id JOIN Pastry P ON IP.EAN = P.EAN
WHERE P.name = 'bread';

-- dealer was proposed to deliver to a new zone - they are checking what type of cells are in the
SELECT J.address as address, c.cell_type, COUNT(*) as count FROM  Customer c JOIN Jail J on c.jail_id = J.jail_id JOIN Delivery_zone Dz on J.delivery_zone_id = Dz.delivery_zone_id JOIN Dealer D on Dz.dealer_id = D.dealer_id
WHERE Dz.delivery_zone_id = 201
GROUP BY c.cell_type, J.address;

-- jailer wants to know his oldest customer's birthdate
SELECT DISTINCT max(C.birth_date) as oldest_customer FROM Customer C JOIN Jail J on C.jail_id = J.jail_id JOIN Jailer J2 on J.jail_id = J2.jail_id
GROUP BY J2.jailer_id HAVING J2.jailer_id = 401;

-- jailer checks which dealer delivers to a specific customer
SELECT DISTINCT D.first_name, D.surname FROM Dealer D JOIN Delivery_zone Dz on D.dealer_id = Dz.dealer_id JOIN Jail J on Dz.delivery_zone_id = J.delivery_zone_id JOIN Jailer J2 on J.jail_id = J2.jail_id JOIN Customer C2 on J.jail_id = C2.jail_id
WHERE EXISTS( SELECT C.customer_id FROM Customer C JOIN Jail J3 on C.jail_id = J3.jail_id JOIN Jailer J4 on J3.jail_id = J4.jail_id
                         WHERE C.customer_id = '501' AND J4.jailer_id = 401);

-- dealer wants to know which customers are in solitary
SELECT C.first_name, C.surname FROM Customer C
WHERE C.customer_id IN (SELECT C1.customer_id FROM Customer C1 WHERE C1.cell_type = 'solitary');


--PART 4

-- TRIGGERS
--add jailer to "Jailer Log", which logs all jailers in the database
CREATE OR REPLACE TRIGGER LogTrigger
    AFTER INSERT ON Customer
    FOR EACH ROW
BEGIN
        INSERT INTO Customer_log (customer_id, jail_address, first_name, surname, birth_date, cell_number, cell_type)
        VALUES (:new.customer_id, (SELECT address FROM Jail WHERE Jail.jail_id = :new.jail_id), :new.first_name, :new.surname, :new.birth_date, :new.cell_number, :new.cell_type);
END;
/
INSERT INTO Customer (customer_id,jail_id, first_name, surname, birth_date, cell_number, cell_type)
VALUES (504 ,1, 'Adam', 'Rabatin',TO_DATE('1999-09-01', 'YYYY-MM-DD'),5,'solitary');
SELECT * FROM Customer_log;

--insert test jailer into newly created jail
CREATE OR REPLACE TRIGGER TestJailer
    AFTER INSERT ON Jail
    FOR EACH ROW
BEGIN
    INSERT INTO Jailer (jail_id, first_name, surname, birth_date)
    VALUES (:new.jail_id,'TestJailer','TestJailer',TO_DATE('1900-01-01', 'YYYY-MM-DD'));
END;
/
INSERT INTO Jail (jail_id, delivery_zone_id, address)
VALUES (5, 201, 'Purkyňova 93 Brno, Česko');
SELECT * FROM Jailer WHERE jail_id = 5;

-- PROCEDURES
--checks orders and deletes orders that were already delivered
CREATE OR REPLACE PROCEDURE remove_outdated_orders
IS
    table_does_not_exist EXCEPTION;
    PRAGMA EXCEPTION_INIT(table_does_not_exist, -00942);
BEGIN
    DECLARE CURSOR outdated_order_delete IS
            SELECT delivery_date FROM Item_order;
            v_deli_date  Item_order.delivery_date%TYPE;
    BEGIN
        OPEN outdated_order_delete;
        LOOP
            FETCH outdated_order_delete INTO v_deli_date;
        EXIT WHEN outdated_order_delete%NOTFOUND;
            DELETE FROM Item_order WHERE v_deli_date < CURRENT_DATE;
        END LOOP;
        CLOSE outdated_order_delete;
    EXCEPTION
        WHEN table_does_not_exist THEN
            dbms_output.put_line('\"Item_order\" table does not exists!');
    END;
END remove_outdated_orders;
/
--execute procedure
begin 
    remove_outdated_orders;
end;
/
--display results
SELECT CURRENT_DATE FROM dual;
SELECT * FROM Item_order;--this should be empty with current inputs

--assigns shifts for a day to jailers
CREATE OR REPLACE PROCEDURE auto_assign_shift
IS
BEGIN
    DECLARE CURSOR auto_assign_shift_cursor IS
            SELECT jail_id FROM Jail;
            v_jail_id  Jail.jail_id%TYPE;
            v_count number;
            id_counter number;
            v_selected_jailer_id number;
    BEGIN
        OPEN auto_assign_shift_cursor;
        LOOP
            FETCH auto_assign_shift_cursor INTO v_jail_id;
        EXIT WHEN auto_assign_shift_cursor%NOTFOUND;
            SELECT COUNT(*) INTO v_count FROM Shift WHERE 
                jail_id = v_jail_id AND 
                SYSTIMESTAMP BETWEEN start_time AND end_time;
            IF
                v_count <= 0
            THEN
                SELECT MAX(SHIFT_ID) INTO id_counter FROM Shift;
                id_counter := id_counter + 1;

                INSERT INTO Shift (shift_id, jail_id, start_time, end_time)
                    VALUES (id_counter, v_jail_id, CAST(TRUNC(CURRENT_DATE) AS TIMESTAMP) + interval '8' hour,
                                                   CAST(TRUNC(CURRENT_DATE) AS TIMESTAMP) + interval '20' hour);
                SELECT jailer_id INTO v_selected_jailer_id FROM jailer WHERE jail_id = v_jail_id FETCH FIRST 1 ROW ONLY;
                INSERT INTO Jailer_Shift (jailer_id, shift_id)
                    VALUES (v_selected_jailer_id, id_counter);
            END IF;
        END LOOP;
        CLOSE auto_assign_shift_cursor;
    END;
END auto_assign_shift;
/
--execute procedure
begin 
    auto_assign_shift;
end;
/
--display results
SELECT * FROM Shift NATURAL JOIN Jailer_Shift NATURAL JOIN Jailer;

-- INDEX
--CREATE INDEX idx_item_order_price ON Item_order(price);
SELECT order_id, price
FROM Item_order
WHERE price BETWEEN 10 AND 50;

-- EXPLAIN PLAN

-- proposed optimalization
--CREATE INDEX idx_customers_customer_id ON Customer(customer_id);
--CREATE INDEX idx_orders_customer_id ON Item_order(customer_id);

EXPLAIN PLAN FOR
SELECT c.customer_id, c.surname, COUNT(o.order_id) AS order_count
FROM Customer c
JOIN Item_order o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.surname;
-- DataGrip view
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

-- PRIVILEGES
GRANT ALL ON ALLERGEN TO XSAJKO01;
GRANT ALL ON BACKED_ITEM TO XSAJKO01;
GRANT ALL ON BACKED_ITEM_PASTRY TO XSAJKO01;
GRANT ALL ON CUSTOMER TO XSAJKO01;
GRANT ALL ON CUSTOMER_LOG TO XSAJKO01;
GRANT ALL ON DEALER TO XSAJKO01;
GRANT ALL ON DEALER_JAILER TO XSAJKO01;
GRANT ALL ON DELIVERY_ZONE TO XSAJKO01;
GRANT ALL ON INGREDIENT TO XSAJKO01;
GRANT ALL ON INGREDIENT_ALLERGEN TO XSAJKO01;
GRANT ALL ON INGREDIENT_PASTRY TO XSAJKO01;
GRANT ALL ON ITEM_ORDER TO XSAJKO01;
GRANT ALL ON JAIL TO XSAJKO01;
GRANT ALL ON JAILER TO XSAJKO01;
GRANT ALL ON JAILER_SHIFT TO XSAJKO01;
GRANT ALL ON PASTRY TO XSAJKO01;
GRANT ALL ON SHIFT TO XSAJKO01;

-- MATERIALIZED VIEW FOR MEGY
CREATE MATERIALIZED VIEW megy_view
AS
SELECT c.customer_id, c.surname, COUNT(o.order_id) AS order_count
FROM Customer c
JOIN Item_order o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.surname;

-- megy would execute this
-- SELECT * FROM megy_view;

-- COMPLEX SELECT
-- print order_id and price category (<10<50<)
INSERT INTO Item_order (order_id, customer_id, first_pastry_EAN, price, delivery_type, delivery_date)
VALUES (10, 501, 123456789, 5.99, 'express', TO_DATE('2024-08-15', 'YYYY-MM-DD'));
INSERT INTO Item_order (order_id, customer_id, first_pastry_EAN, price, delivery_type, delivery_date)
VALUES (11, 501, 123456789, 25.45, 'express', TO_DATE('2024-09-20', 'YYYY-MM-DD'));
INSERT INTO Item_order (order_id, customer_id, first_pastry_EAN, price, delivery_type, delivery_date)
VALUES (12, 501, 123456789, 156.12, 'express', TO_DATE('2024-09-03', 'YYYY-MM-DD'));
SELECT Item_order.order_id, 
       (CASE WHEN EXISTS (SELECT * FROM Item_order IOT WHERE Item_order.price < 10 AND Item_order.order_id = IOT.order_id) THEN 'LOW'
             WHEN EXISTS (SELECT * FROM Item_order IOT WHERE Item_order.price > 50 AND Item_order.order_id = IOT.order_id) THEN 'HIGH'
             ELSE 'MEDIUM'
        END) AS price_category
    FROM Item_order;