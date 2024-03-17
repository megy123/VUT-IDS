--pri refraktorizacii sa mi to pojebalo
ALTER TABLE Jailer DROP CONSTRAINT jailer_jail_fk;
ALTER TABLE Customer DROP CONSTRAINT customer_jail_fk;
ALTER TABLE Item_order DROP CONSTRAINT item_order_customer_fk;
ALTER TABLE Pastry DROP CONSTRAINT pastry_order_fk;
ALTER TABLE Jail DROP CONSTRAINT jail_delivery_zone_fk;
ALTER TABLE Shift DROP CONSTRAINT shift_jail_fk;
ALTER TABLE Delivery_zone DROP CONSTRAINT delivery_zone_dealer_fk;

--at least one rels
ALTER TABLE Item_order DROP CONSTRAINT item_order_first_pastry_ean;
ALTER TABLE Jail DROP CONSTRAINT jail_first_shift_fk;
ALTER TABLE Backed_item DROP CONSTRAINT backed_item_first_pastry;
ALTER TABLE Shift DROP CONSTRAINT shift_first_jailer;
ALTER TABLE Ingredient DROP CONSTRAINT ingredient_first_pastry;
ALTER TABLE Pastry DROP CONSTRAINT pastry_first_ingredient;

ALTER TABLE Dealer_Jailer DROP CONSTRAINT dealer_jailer_dealer_fk;
ALTER TABLE Dealer_Jailer DROP CONSTRAINT dealer_jailer_jailer_fk;

ALTER TABLE Jailer_Shift DROP CONSTRAINT jailer_shift_jailer_fk;
ALTER TABLE Jailer_Shift DROP CONSTRAINT jailer_shift_shift_fk;

ALTER TABLE Backed_item_Pastry DROP CONSTRAINT backed_item_pastry_backed_item_fk;
ALTER TABLE Backed_item_Pastry DROP CONSTRAINT backed_item_pastry_ean_fk;

ALTER TABLE Ingredient_Pastry DROP CONSTRAINT ingredient_pastry_ingredient_fk;
ALTER TABLE Ingredient_Pastry DROP CONSTRAINT ingredient_pastry_ean_fk;

ALTER TABLE Ingredient_Allergen DROP CONSTRAINT ingredient_allergen_ingredient_fk;
ALTER TABLE Ingredient_Allergen DROP CONSTRAINT ingredient_allergen_allergen_name_fk;

ALTER TABLE Item_order DROP CONSTRAINT item_price_validity;
ALTER TABLE Pastry DROP CONSTRAINT pastry_weight_validity;
ALTER TABLE Ingredient DROP CONSTRAINT ingredient_price_validity;
ALTER TABLE Ingredient DROP CONSTRAINT ingredient_amount_validity;
ALTER TABLE Backed_item DROP CONSTRAINT backed_item_weight_validity;
ALTER TABLE Shift DROP CONSTRAINT shift_time_validity;

--table drop
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
DROP TABLE Ingredient_Allergen;
