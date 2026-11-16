-- Star Schema

-- Dimenstion table

-- Dim Customers

drop table if exists dim_customer;
CREATE TABLE dim_customer (
    customer_key SERIAL PRIMARY KEY,
    customer_id VARCHAR(20) UNIQUE NOT NULL,
    gender VARCHAR(20),
    senior_citizen VARCHAR(10),
    partner VARCHAR(10),
    dependents VARCHAR(10)
);

drop table if exists dim_service;
CREATE TABLE dim_service (
    service_key SERIAL PRIMARY KEY,
    phone_service VARCHAR(30),
    multiple_lines VARCHAR(40),
    internet_service VARCHAR(40),
    online_security VARCHAR(40),
    online_backup VARCHAR(40),
    device_protection VARCHAR(40),
    tech_support VARCHAR(40),
    streaming_tv VARCHAR(40),
    streaming_movies VARCHAR(40),
    UNIQUE (
        phone_service,
        multiple_lines,
        internet_service,
        online_security,
        online_backup,
        device_protection,
        tech_support,
        streaming_tv,
        streaming_movies
    )
);


drop table if exists dim_contract;
CREATE TABLE dim_contract (
    contract_key SERIAL PRIMARY KEY,
    contract VARCHAR(30),
    paperless_billing VARCHAR(10),
    payment_method VARCHAR(50),
    UNIQUE (
        contract,
        paperless_billing,
        payment_method
    )
);


INSERT INTO dim_customer (
    customer_id,
    gender,
    senior_citizen,
    partner,
    dependents
)
SELECT DISTINCT
    TRIM(customer_id),
    NULLIF(TRIM(gender), ''),
    senior_citizen,
    NULLIF(TRIM(partner), ''),
    NULLIF(TRIM(dependents), '')
FROM customer_churn_raw
WHERE customer_id IS NOT NULL
  AND TRIM(customer_id) <> '';

  INSERT INTO dim_service (
    phone_service,
    multiple_lines,
    internet_service,
    online_security,
    online_backup,
    device_protection,
    tech_support,
    streaming_tv,
    streaming_movies
)
SELECT DISTINCT
    phone_service,
    multiple_lines,
    internet_service,
    online_security,
    online_backup,
    device_protection,
    tech_support,
    streaming_tv,
    streaming_movies
FROM customer_churn_raw;



INSERT INTO dim_contract (
    contract,
    paperless_billing,
    payment_method
)
SELECT DISTINCT
    contract,
    paperless_billing,
    payment_method
FROM customer_churn_raw;

-- fact Table

CREATE TABLE fact_customer_churn (
    fact_id SERIAL PRIMARY KEY,

    customer_key INT UNIQUE,
    service_key INT,
    contract_key INT,

    tenure INT,
    monthly_charges NUMERIC(10,2),
    total_charges NUMERIC(10,2),

    churn VARCHAR(10),

    FOREIGN KEY (customer_key)
        REFERENCES dim_customer(customer_key),

    FOREIGN KEY (service_key)
        REFERENCES dim_service(service_key),

    FOREIGN KEY (contract_key)
        REFERENCES dim_contract(contract_key)
);


-- Adding data

INSERT INTO fact_customer_churn (
    customer_key,
    service_key,
    contract_key,
    tenure,
    monthly_charges,
    total_charges,
    churn
)
SELECT
    dc.customer_key,
    ds.service_key,
    dct.contract_key,

    NULLIF(TRIM(r.tenure::TEXT), '')::INT,
    NULLIF(TRIM(r.monthly_charges::TEXT), '')::NUMERIC(10,2),
    NULLIF(TRIM(r.total_charges::TEXT), '')::NUMERIC(10,2),

    r.churn

FROM customer_churn_raw as r

JOIN dim_customer dc
    ON TRIM(r.customer_id) = dc.customer_id

JOIN dim_service as ds
    ON r.phone_service IS NOT DISTINCT FROM ds.phone_service
   AND r.multiple_lines IS NOT DISTINCT FROM ds.multiple_lines
   AND r.internet_service IS NOT DISTINCT FROM ds.internet_service
   AND r.online_security IS NOT DISTINCT FROM ds.online_security
   AND r.online_backup IS NOT DISTINCT FROM ds.online_backup
   AND r.device_protection IS NOT DISTINCT FROM ds.device_protection
   AND r.tech_support IS NOT DISTINCT FROM ds.tech_support
   AND r.streaming_tv IS NOT DISTINCT FROM ds.streaming_tv
   AND r.streaming_movies IS NOT DISTINCT FROM ds.streaming_movies

JOIN dim_contract as dct
    ON r.contract IS NOT DISTINCT FROM dct.contract
   AND r.paperless_billing IS NOT DISTINCT FROM dct.paperless_billing
   AND r.payment_method IS NOT DISTINCT FROM dct.payment_method;


