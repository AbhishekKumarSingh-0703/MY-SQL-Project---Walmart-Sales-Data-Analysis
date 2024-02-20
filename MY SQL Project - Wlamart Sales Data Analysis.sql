Create database if not exists Walmart_Project;
use  Walmart_project;
Create table if not exists Sales(
invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
);
Select*from Sales;

#---------------------------------------------------------------------------------------------------------------------------------------------------
#---------------------------------------time_of_day-------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------------------------------------------------------
SELECT 
  time,
  CASE 
    WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
    WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
    ELSE 'Evening'
  END AS time_of_day
FROM sales;

Alter table sales
add column time_of_day varchar(20);
update sales 
set
time_of_day = (CASE 
    WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
    WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
    ELSE 'Evening'
  END);

#---------------------------------------------day_name----------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------------------------------------------------------
SELECT 
  date,
  dayname(date) as day_name 
  from Sales;
  Alter table sales
  add column day_name varchar(10);
  update  sales
  set day_name = dayname(date);
  Select*from sales;
  
  #------------------------------------------------------------Month name ------------------------------------------------------------------------
  #-----------------------------------------------------------------------------------------------------------------------------------------------
  select date,
  monthname(date)
from sales;  
alter table sales
add column month_name varchar(10);
update sales
set month_name = monthname(date);
select*from sales;

#------------------------------------------------------------------------------------------------------------------------------------------------#
#--------------------------------------------------------Business Questions----------------------------------------------------------------------#
#                                          1- How many unique cities does the data have ?

select distinct city
from sales;

#                                               2 - In which city is each branch?
select distinct branch
from sales;


select distinct city, branch
from sales;


#----------------------------------------------------------Product--------------------------------------------------------------------------------#
#                                           1 - How many unique product lines does the data have?

select count(distinct product_line)
from sales;


#                                                2 -What is the most common payment method?
select payment,
count(payment) as cnt
from sales
group by payment
order by cnt desc;


#                                                  3-  What is the most selling product line?

select product_line ,count(product_line) as cnt
from sales
group by product_line 
order by cnt desc;
 
 
#                                                      4-What is the total revenue by month?

select sum(total) as total_revenue , month_name
from sales
group by month_name
order by total_revenue desc;


#                                                         5--What month had the largest COGS?

select sum(cogs) as cogs, month_name as month
from sales
group by month
order by cogs desc ;


#                                                         6- What product line had the largest revenue?

select product_line, sum(total) as total_revenue
from sales
group by product_line
order by total_revenue desc;


#                                                         7-What is the city with the largest revenue?

select city,branch, sum(total) as total_revenue
from sales
group by city, branch
order by total_revenue desc;


#                                                 8--What product line had the largest VAT?

select product_line, sum(gross_income) as vat 
from sales
group by product_line
order by vat desc;



#                                               9--Which branch sold more products than average product sold?

select branch, sum(quantity) as qty
from sales
group by branch
having sum(quantity) > (select avg(quantity)from sales);


#                                                   10---What is the most common product line by gender?

select product_line, count(gender) as total_cnt, gender
from sales
group by gender,product_line
order by total_cnt desc;


#                                                   11---What is the average rating of each product line?

select product_line, avg(rating)
from sales
group by product_line;


#---------------------------------------------------------------------SALES---------------------------------------------------------------------
#                                                1-Number of sales made in each time of the day per weekday

select count(*) as total_sales,time_of_day
from sales 

group by time_of_day
order by total_sales desc;



#                                                2-Which of the customer types brings the most revenue?

select customer_type,sum(total) as revenue
from sales
group by customer_type
order by revenue desc ;


#                                                    3-Which city has the largest tax percent/ VAT (Value Added Tax)?

select city, sum(tax_pct) as tax
from sales
group by city
order by tax desc;

#                                                     4-Which customer type pays the most in VAT?

select customer_type, sum(tax_pct)
from sales
group by customer_type;

#--------------------------------------------------------------------Customer-----------------------------------------------------------------------------
#                                              1-How many unique customer types does the data have?

select distinct (customer_type)
from sales;


#                                               2-How many unique payment methods does the data have?

select distinct (payment) as payment_method
from sales;


#                                                3-Which customer type buys the most?

select customer_type, count(*) as cust_cnt
from sales
group by customer_type;

#                                                 4-What is the gender distribution per branch?

select branch,
count(case when gender = 'Male' then 1 end) as Male_count,
count(case when gender = 'Female' then 1 end) as Female_count
      from sales
      group by branch;


#                                                   5-Which time of the day do customers give most ratings?

select sum(rating) as rating,time_of_day
from sales
group by time_of_day
order by rating desc;


#                                                     6-Which day fo the week has the best avg ratings?

select day_name,avg(rating) as avg_rating
from sales
group by day_name
order by avg_rating desc;


#                                                   7-Which day of the week has the best average ratings per branch?

select day_name,avg(rating) as avg_rating
from sales
where branch = 'A'
group by day_name
order by avg_rating desc;
