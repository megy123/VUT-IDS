ALTER TABLE Jailer DROP CONSTRAINT Jjail_fk;
ALTER TABLE Customer DROP CONSTRAINT Cjail_fk;
ALTER TABLE Item_order DROP CONSTRAINT customer_fk;
ALTER TABLE Item_order DROP CONSTRAINT first_pastry_EAN;
ALTER TABLE Pastry DROP CONSTRAINT Porder_fk;
ALTER TABLE Jail DROP CONSTRAINT delivery_zone_fk;
ALTER TABLE Jail DROP CONSTRAINT first_shift_fk;
ALTER TABLE Shift DROP CONSTRAINT Sjail_fk;
ALTER TABLE Delivery_zone DROP CONSTRAINT dealer_fk;

ALTER TABLE Dealer_Jailer DROP CONSTRAINT DJdealer_fk;
ALTER TABLE Dealer_Jailer DROP CONSTRAINT DJjailer_fk;

ALTER TABLE Jailer_Shift DROP CONSTRAINT JSjailer_fk;
ALTER TABLE Jailer_Shift DROP CONSTRAINT JSshift_fk;

ALTER TABLE Backed_item_Pastry DROP CONSTRAINT BPbacked_item_fk;
ALTER TABLE Backed_item_Pastry DROP CONSTRAINT BPEAN_fk;

ALTER TABLE Ingredient_Pastry DROP CONSTRAINT IPingredient_fk;
ALTER TABLE Ingredient_Pastry DROP CONSTRAINT IPEAN_fk;

ALTER TABLE Ingredient_Allergern DROP CONSTRAINT IAingredient_fk;
ALTER TABLE Ingredient_Allergern DROP CONSTRAINT IAallergen_name_fk;


DROP TABLE Dealer;
DROP TABLE Jailer;
DROP TABLE Customer;
DROP TABLE Item_order;
DROP TABLE Pastry;
DROP TABLE Ingredient;
DROP TABLE Jail;
DROP TABLE Shift;
DROP TABLE Delivery_zone;
DROP TABLE Allergen;
DROP TABLE Backed_item;

DROP TABLE Dealer_Jailer;
DROP TABLE Jailer_Shift;
DROP TABLE Backed_item_Pastry;
DROP TABLE Ingredient_Pastry;
DROP TABLE Ingredient_Allergern;
