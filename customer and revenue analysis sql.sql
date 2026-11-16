-- Insights (Sales & Churn Analysis)

-- KPI's

-- Average Monthly Charges

select round(avg(c.monthly_charges),2) as avg_monthly_charges
from fact_customer_churn as c;

-- Average Tenure

select round(avg(c.tenure),2) as avg_tenure
from fact_customer_churn as c;

-- Retaintion Rate

select 
	   round(count(*) filter(where churn = 'No') * 100.0 /
	   count(*),2) as Retaintion_rate
from fact_customer_churn as c;

-- churned monthly charges

select sum(monthly_charges) as churn_monthly_charges
from fact_customer_churn as c
where c.churn = 'Yes';


-- matrix 

select dc.gender,
       dc.senior_citizen,
	   count(*) as total_customers,
	   count(*) filter(where c.churn = 'Yes') as churn_customers,
	   count(*) filter(where c.churn = 'Yes') * 100.0 / 
	   count(*) as churned_rate
from fact_customer_churn as c
join dim_customer as dc
on dc.customer_key = c.customer_key
group by 1,2
order by 3 desc;
	   
       
