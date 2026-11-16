-- Data cleaning

-- Find duplicate customer_id

select
    c.customer_id,
    count(*) as duplicate_count
from customer_churn_raw as c
group by c.customer_id
having count(*) > 1;

-- Find all duplicated records

select
    *,
    count(*) as duplicate_count
from customer_churn_raw as c
group by
    c.customer_id,
    c.gender,
    c.senior_citizen,
    c.partner,
    c.dependents,
    c.tenure,
    c.phone_service,
    c.multiple_lines,
    c.internet_service,
    c.online_security,
    c.online_backup,
    c.device_protection,
    c.tech_support,
    c.streaming_tv,
    c.streaming_movies,
    c.contract,
    c.paperless_billing,
    c.payment_method,
    c.monthly_charges,
    c.total_charges,
    c.churn
having count(*) > 1;

-- Missing value Identification.

SELECT
    COUNT(*) AS total_records,

    COUNT(*) FILTER (
        WHERE c.customer_id IS NULL
    ) AS missing_customer_id,

    COUNT(*) FILTER (
        WHERE c.gender IS NULL
    ) AS missing_gender,

    COUNT(*) FILTER (
        WHERE c.tenure IS NULL
    ) AS missing_tenure,

    COUNT(*) FILTER (
        WHERE c.monthly_charges IS NULL
    ) AS missing_monthly_charges,

    COUNT(*) FILTER (
        WHERE c.total_charges IS NULL
    ) AS missing_total_charges,

    COUNT(*) FILTER (
        WHERE c.churn IS NULL
    ) AS missing_churn

FROM customer_churn_raw as c;


-- Invalid numeric values

-- tenure

select *
from customer_churn_raw as c
where c.tenure < 0;

-- monthly_charges

select *
from customer_churn_raw as c
where c.monthly_charges < 0;

-- total_charges

select *
from customer_churn_raw as c
where c.total_charges < 0;

-- checking usually high values

select *
from customer_churn_raw as c
where c.monthly_charges > 1000
   or c.total_charges > 100000;


-- standardize gender column

update customer_churn_raw
set gender =
    CASE
        WHEN LOWER(TRIM(gender)) = 'male'
            THEN 'Male'

        WHEN LOWER(TRIM(gender)) = 'female'
            THEN 'Female'

        ELSE NULL
    END;


-- standardize dependents column

update customer_churn_raw
set dependents =
    CASE
        WHEN LOWER(TRIM(dependents)) = 'male'
            THEN 'Male'

        WHEN LOWER(TRIM(dependents)) = 'female'
            THEN 'Female'

        ELSE NULL
    END;


SELECT distinct dependents
FROM customer_churn_raw
where phone_service is null;





