-- Insights (Executive Overview)

-- Churn Customers

select count(*) filter(where churn = 'No') as churn_customers,
       count(*) as total_customers,
	  round(count(*) filter(where churn = 'No') * 100  / count(*),2)
from fact_customer_churn;

-- Churned Customer Contract

select dc.contract,
       count(*) filter(where c.churn = 'Yes') as churn_customers,
       count(*) as total_customers,
	  round(count(*) filter(where c.churn = 'Yes') * 100  / count(*),2) as churn_pct
from fact_customer_churn as c
join dim_contract as dc
on dc.contract_key = c.contract_key
group by 1
order by 3 desc;

-- churn by tenure

select c.churn,
       sum(c.tenure) as total_tenure
from fact_customer_churn as c
group by c.churn;


-- churn customer by Internet Service

select ds.internet_service,
       count(*) filter(where c.churn = 'Yes') as churn_customers,
       count(*) as total_customers,
	  round(count(*) filter(where c.churn = 'Yes') * 100  / count(*),2) as churn_pct
from fact_customer_churn as c
join dim_service as ds
on ds.service_key = c.service_key
group by 1
order by 3 desc;

-- Total Customer by Payment_method and churn

select dc.payment_method,
	   count(*) filter(where c.churn = 'Yes') as churn_customers,
	   count(*) filter(where c.churn = 'No') as retained_customers,
	   count(*) as total_customers,
	  round(count(*) filter(where c.churn = 'Yes') * 100  / count(*),2) as churn_pct,
	  round(count(*) filter(where c.churn = 'No') * 100  / count(*),2) as retained_pct  
from dim_contract as dc
join fact_customer_churn as c
on dc.contract_key = c.contract_key
group by 1
order by 2 desc;

