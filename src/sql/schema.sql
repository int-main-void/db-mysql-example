/*
 * example database schema
 */

/* **************************************************
 *  create db
 */

CREATE DATABASE IF NOT EXISTS exampledb;
USE `exampledb`;

/* **************************************************
 *  Create db users
 */


DROP USER IF EXISTS 'exampledb_user'@'%';
CREATE USER IF NOT EXISTS 'exampledb_user'@'%' IDENTIFIED BY 'exampledb17';
GRANT INSERT, UPDATE, SELECT ON exampledb.* TO 'exampledb_user'@'%';

FLUSH PRIVILEGES;

/* **************************************************
 *  USERS schema
 */

CREATE TABLE IF NOT EXISTS exampledb.users (
  id INT UNSIGNED  NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (id),
  
  name              VARCHAR(256),
  email             VARCHAR(256),
  password_digest   TEXT,
  admin             INT DEFAULT 0,

  lock_version INTEGER DEFAULT 0,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,

  UNIQUE INDEX(email)
);

DROP TRIGGER IF EXISTS users_update;

CREATE TRIGGER users_update BEFORE UPDATE ON exampledb.users
FOR EACH ROW SET NEW.updated_at = NOW();


CREATE TABLE IF NOT EXISTS exampledb.user_activations (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (id),
  
  user_id INT UNSIGNED NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users (id),

  remember_digest TEXT,
  activated  boolean DEFAULT false,
  activation_digest TEXT,
  activated_at datetime,
  reset_digest TEXT,
  reset_sent_at DATETIME,

  lock_version INTEGER DEFAULT 0,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

DROP TRIGGER IF EXISTS user_activations_update;

CREATE TRIGGER user_activations_update BEFORE UPDATE ON exampledb.user_activations
FOR EACH ROW SET NEW.updated_at = NOW();


/* **************************************************
 *  Sites schema
 */

CREATE TABLE IF NOT EXISTS exampledb.sites (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (id),

  street1            TEXT,
  street2            TEXT,
  city               TEXT,
  state              TEXT,
  postal_code        TEXT,
  country            TEXT,
  legal_description  TEXT,
  latitude           FLOAT,
  longitude          FLOAT,

  lock_version INTEGER DEFAULT 0,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

DROP TRIGGER IF EXISTS sites_update;

CREATE TRIGGER sites_update BEFORE UPDATE ON exampledb.sites
FOR EACH ROW SET NEW.updated_at = NOW();

/* **************************************************
 *  Organizations Schema
 */

CREATE TABLE IF NOT EXISTS exampledb.organizations(
  id INT UNSIGNED  NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (id),

  primary_site      INT UNSIGNED,
  FOREIGN KEY (site_id) REFERENCES sites (id),

  name         TEXT NOT NULL,
  external_business_id  TEXT, -- opaque external id
  
  lock_version INTEGER DEFAULT 0,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

DROP TRIGGER IF EXISTS organizations_update;

CREATE TRIGGER organizations_update BEFORE UPDATE ON exampledb.organizations
FOR EACH ROW SET NEW.updated_at = NOW();


/* typical roles are business-dependent and may include 'owner', 'employee', 'administrator', etc. */
CREATE TABLE IF NOT EXISTS exampledb.organization_roles(
  id INT UNSIGNED  NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (id),

  organization_id INT UNSIGNED,
  FOREIGN KEY (organization_id) REFERENCES organizations (id),

  name TEXT,

  lock_version INTEGER DEFAULT 0,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

DROP TRIGGER IF EXISTS organization_roles_update;

CREATE TRIGGER organization_roles_update BEFORE UPDATE ON exampledb.organization_roles
FOR EACH ROW SET NEW.updated_at = NOW();


CREATE TABLE IF NOT EXISTS exampledb.organization_roles_users (
  organization_role_id INT UNSIGNED NOT NULL,
  user_id INT UNSIGNED NOT NULL,

  PRIMARY KEY (organization_role_id, user_id),

  FOREIGN KEY (organization_role_id)  REFERENCES organizations  (id),
  FOREIGN KEY (user_id) REFERENCES users (id),

  lock_version INTEGER DEFAULT 0,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

DROP TRIGGER IF EXISTS organization_roles_users_update;

CREATE TRIGGER organization_roles_users_update BEFORE UPDATE ON exampledb.organization_roles_users
FOR EACH ROW SET NEW.updated_at = NOW();

/* **************************************************
 *  Accounting and Payments
 */

CREATE TABLE IF NOT EXISTS exampledb.invoices (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (id),

  integer_amount INT,
  decimal_amount INT UNSIGNED,
  currency TEXT,
  invoice_date DATETIME,

  lock_version INTEGER DEFAULT 0,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

DROP TRIGGER IF EXISTS invoices_update;

CREATE TRIGGER invoices_update BEFORE UPDATE ON exampledb.invoices
FOR EACH ROW SET NEW.updated_at = NOW();


CREATE TABLE IF NOT EXISTS exampledb.payments (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (id),

  integer_amount INT,
  decimal_amount INT UNSIGNED,
  currency TEXT,
  payment_date DATETIME,

  lock_version INTEGER DEFAULT 0,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

DROP TRIGGER IF EXISTS payments_update;

CREATE TRIGGER payments_update BEFORE UPDATE ON exampledb.payments
FOR EACH ROW SET NEW.updated_at = NOW();


CREATE TABLE IF NOT EXISTS exampledb.accounting_transaction (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (id),

  invoice_id INT UNSIGNED NOT NULL,
  FOREIGN KEY (invoice_id) REFERENCES invoices (id),
  payment_id INT UNSIGNED NOT NULL,
  FOREIGN KEY (payment_id) REFERENCES payments (id),

  lock_version INTEGER DEFAULT 0,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

DROP TRIGGER IF EXISTS accounting_transaction_update;

CREATE TRIGGER accounting_transaction_update BEFORE UPDATE ON exampledb.accounting_transaction
FOR EACH ROW SET NEW.updated_at = NOW();
