-- Verifying data

-- Total Records

select count(*) as total_records
from customer_churn_raw;

-- Check duplicate customers

select
    customer_id,
    count(*) as record_count
from customer_churn_raw
group by customer_id
having count(*) > 1;

-- Check missing and blank customers

select *
from customer_churn_raw
where customer_id is null
   or trim(customer_id) = '';

-- Understand churn distribution

select
    c.churn,
    count(*)::int as customer_count
from customer_churn_raw as c
group by c.churn
order by 2 desc;

-- Exercise

-- Find the total number of customers in the dataset.

select count(*)::int
from customer_churn_raw as c;

-- Find the number of unique customer IDs.

select count(distinct c.customer_id)::int as unique_customers
from customer_churn_raw as c;

-- Find all distinct values in the Contract column.

select distinct c.contract
from customer_churn_raw as c;

-- Find customers whose TotalCharges column is blank.

select *
from customer_churn_raw as c
where c.total_charges::text = ''
or c.total_charges is null;

-- Find the minimum and maximum tenure.

select min(c.tenure),
       max(c.tenure)
from customer_churn_raw as c;

-- Find the number of Churn = Yes and Churn = No customers.

select c.churn,
       count(*)
from customer_churn_raw as c
group by c.churn;


select *
from customer_churn_raw





