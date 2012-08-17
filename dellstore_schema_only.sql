--
-- PostgreSQL database dump
--

SET client_encoding = 'LATIN1';
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: new_customer(character varying, character varying, character varying, character varying, character varying, character varying, integer, character varying, integer, character varying, character varying, integer, character varying, character varying, character varying, character varying, integer, integer, character varying); Type: FUNCTION; Schema: public; Owner: chriskl
--

CREATE FUNCTION new_customer(firstname_in character varying, lastname_in character varying, address1_in character varying, address2_in character varying, city_in character varying, state_in character varying, zip_in integer, country_in character varying, region_in integer, email_in character varying, phone_in character varying, creditcardtype_in integer, creditcard_in character varying, creditcardexpiration_in character varying, username_in character varying, password_in character varying, age_in integer, income_in integer, gender_in character varying, OUT customerid_out integer) RETURNS integer
    AS '
  DECLARE
    rows_returned INT;
  BEGIN
    SELECT COUNT(*) INTO rows_returned FROM CUSTOMERS WHERE USERNAME = username_in;
    IF rows_returned = 0 THEN
	    INSERT INTO CUSTOMERS
	      (
	      FIRSTNAME,
	      LASTNAME,
	      EMAIL,
	      PHONE,
	      USERNAME,
	      PASSWORD,
	      ADDRESS1,
	      ADDRESS2,
	      CITY,
	      STATE,
	      ZIP,
	      COUNTRY,
	      REGION,
	      CREDITCARDTYPE,
	      CREDITCARD,
	      CREDITCARDEXPIRATION,
	      AGE,
	      INCOME,
	      GENDER
	      )
	    VALUES
	      (
	      firstname_in,
	      lastname_in,
	      email_in,
	      phone_in,
	      username_in,
	      password_in,
	      address1_in,
	      address2_in,
	      city_in,
	      state_in,
	      zip_in,
	      country_in,
	      region_in,
	      creditcardtype_in,
	      creditcard_in,
	      creditcardexpiration_in,
	      age_in,
	      income_in,
	      gender_in
	      )
	     ;
    select currval(pg_get_serial_sequence(''customers'', ''customerid'')) into customerid_out;
  ELSE 
  	customerid_out := 0;
  END IF;
END
'
    LANGUAGE plpgsql;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: categories; Type: TABLE; Schema: public; Owner: chriskl; Tablespace: 
--

CREATE TABLE categories (
    category serial NOT NULL,
    categoryname character varying(50) NOT NULL
);


--
-- Name: categories_category_seq; Type: SEQUENCE SET; Schema: public; Owner: chriskl
--

SELECT pg_catalog.setval(pg_catalog.pg_get_serial_sequence('categories', 'category'), 16, true);


--
-- Name: cust_hist; Type: TABLE; Schema: public; Owner: chriskl; Tablespace: 
--

CREATE TABLE cust_hist (
    customerid integer NOT NULL,
    orderid integer NOT NULL,
    prod_id integer NOT NULL
);


--
-- Name: customers; Type: TABLE; Schema: public; Owner: chriskl; Tablespace: 
--

CREATE TABLE customers (
    customerid serial NOT NULL,
    firstname character varying(50) NOT NULL,
    lastname character varying(50) NOT NULL,
    address1 character varying(50) NOT NULL,
    address2 character varying(50),
    city character varying(50) NOT NULL,
    state character varying(50),
    zip integer,
    country character varying(50) NOT NULL,
    region smallint NOT NULL,
    email character varying(50),
    phone character varying(50),
    creditcardtype integer NOT NULL,
    creditcard character varying(50) NOT NULL,
    creditcardexpiration character varying(50) NOT NULL,
    username character varying(50) NOT NULL,
    "password" character varying(50) NOT NULL,
    age smallint,
    income integer,
    gender character varying(1)
);


--
-- Name: customers_customerid_seq; Type: SEQUENCE SET; Schema: public; Owner: chriskl
--

SELECT pg_catalog.setval(pg_catalog.pg_get_serial_sequence('customers', 'customerid'), 20000, true);


--
-- Name: inventory; Type: TABLE; Schema: public; Owner: chriskl; Tablespace: 
--

CREATE TABLE inventory (
    prod_id integer NOT NULL,
    quan_in_stock integer NOT NULL,
    sales integer NOT NULL
);


--
-- Name: orderlines; Type: TABLE; Schema: public; Owner: chriskl; Tablespace: 
--

CREATE TABLE orderlines (
    orderlineid integer NOT NULL,
    orderid integer NOT NULL,
    prod_id integer NOT NULL,
    quantity smallint NOT NULL,
    orderdate date NOT NULL
);


--
-- Name: orders; Type: TABLE; Schema: public; Owner: chriskl; Tablespace: 
--

CREATE TABLE orders (
    orderid serial NOT NULL,
    orderdate date NOT NULL,
    customerid integer,
    netamount numeric(12,2) NOT NULL,
    tax numeric(12,2) NOT NULL,
    totalamount numeric(12,2) NOT NULL
);


--
-- Name: orders_orderid_seq; Type: SEQUENCE SET; Schema: public; Owner: chriskl
--

SELECT pg_catalog.setval(pg_catalog.pg_get_serial_sequence('orders', 'orderid'), 12000, true);


--
-- Name: products; Type: TABLE; Schema: public; Owner: chriskl; Tablespace: 
--

CREATE TABLE products (
    prod_id serial NOT NULL,
    category integer NOT NULL,
    title character varying(50) NOT NULL,
    actor character varying(50) NOT NULL,
    price numeric(12,2) NOT NULL,
    special smallint,
    common_prod_id integer NOT NULL
);


--
-- Name: products_prod_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chriskl
--

SELECT pg_catalog.setval(pg_catalog.pg_get_serial_sequence('products', 'prod_id'), 10000, true);


--
-- Name: reorder; Type: TABLE; Schema: public; Owner: chriskl; Tablespace: 
--

CREATE TABLE reorder (
    prod_id integer NOT NULL,
    date_low date NOT NULL,
    quan_low integer NOT NULL,
    date_reordered date,
    quan_reordered integer,
    date_expected date
);
