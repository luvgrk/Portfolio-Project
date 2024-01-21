Create Database if not exists SalesDataWalmart; 

Create Table if not exists Sales(
Invoice_ID	Varchar(30) NOT NULL PRIMARY KEY,
Branch	Varchar(5) NOT NULL,
City Varchar(30) NOT NULL,
Customer_type Varchar(30) NOT NULL,
Gender Varchar(10) NOT NULL,
Productline	Varchar(100) NOT NULL,
Unit_price Decimal(10,2) NOT NULL,
Quantity INT NOT NULL,	
VAT Float(6,4) NOT NULL,
Total Decimal(12,4) NOT NULL,	
Date Datetime NOT NULL,
Time time NOT NULL,
Payment	Varchar(15) NOT NULL,
cogs Decimal(10,2) NOT NULL,	
gross_margin_pct Float(11,9) NOT NULL,
gross_income Decimal(12,4) NOT NULL,
Rating float(2,1) NOT NULL
);



-- -------------------------
-- Feature Enginnering---

-- time_of_day 

Select time, 
(Case When time Between '00:00:00' And '12:00:00' Then "Morning"
	  When time Between'12:01:00' And '16:00:00' Then "Afternoon"
      Else "Evening"
      End
) As time_of_date
From Sales
Order by time; 

Alter Table sales Add Column time_of_day varchar(20);
Alter Table sales
Drop Column time_of_day;

Update Sales
Set time_of_day = (
Case When time Between '00:00:00' And '12:00:00' Then "Morning"
	  When time Between'12:01:00' And '16:00:00' Then "Afternoon"
      Else "Evening"
      End);
      
-- day_name
Select date, dayname(date)
From Sales;

Alter Table sales Add Column day_name varchar(20);
Update Sales
Set day_name = dayname(date); 

-- Month_name
Select date, Monthname(date)
From Sales;

Alter Table sales Add Column month_name varchar(10);
Update Sales
Set month_name = Monthname(date); 


-- ----------------------------
-- ----------------------------


-- Generic

-- How many unique city does the data have?
Select 
	Distinct City
From Sales;

Select 
	Distinct branch
From Sales;

Select 
	Distinct City, Branch
From Sales;


-- ------------------------------
-- ------------------------------


-- product

-- How many unique product lines does the data have? 
Select
	Count(Distinct productline)
From Sales;

-- What is the most common payment method?
Select payment,
Count(payment) as cnt
From Sales
Group by payment
Order by cnt DESC;

-- What is the most selling product line?
Select Productline,
Count(productline) as cnt
From Sales
Group by productline
Order by cnt DESC; 

-- What is the total revenue by month
Select 
	month_name as month, sum(total) as total_sales
From Sales
Group by month_name
Order by total_sales DESC; 

-- What month has the largest COGS? 
Select 
	month_name as month, sum(cogs)as total_cogs
From Sales
Group by month_name
Order by total_cogs DESC; 

-- What product line had the largest revenue?
Select
	productline, sum(total) as total_revenue
From Sales
Group by productline
Order by total_revenue DESC; 

-- What is the city with the largest revenue?
Select 
	City, sum(total) as total_revenue
From Sales
Group by City
Order by total_revenue DESC; 

-- What product line had the largest VAT? 
Select
	productline, AVG(VAT) as avg_tax
From Sales
Group by productline
Order by avg_tax DESC; 

-- Fetch each product line and add a column to those product line shoing "good" and "bad" 


-- Which brach sold more products than average product sold?
Select 
	branch, avg(quantity) as qty
From Sales
Group by branch 
Having avg(quantity) > (Select avg(quantity) from Sales); 

-- What is the most common product line by gender?
Select Gender,
	   productline,
	   Count(gender) as total_cnt
From Sales
Group by Gender, Productline
Order by total_cnt DESC;

-- What is the average rating of each product line?
Select 
	AVG(rating) as AVG_rating, 
    productline
From Sales
Group by productline 
Order by AVG_rating DESC;


-- ---------------------
-- ---------------------
-- Sales 

-- Number of sales made in each time of the day per weekday

Select time_of_day, 
	   count(quantity) as total_sales
From Sales
Group by time_of_day
Order by total_sales DESC;

-- Which of the customer types brings the most revenue?
Select customer_type, 
	   sum(Total) as revenue
From Sales
Group by customer_type
Order by revenue DESC;

-- Which city has the largest tax percent/ VAT (Value Added Tax)?
Select City,
	   AVG(VAT) as VAT
From Sales
Group by City
Order by VAT DESC;

-- Which customer type pays the most in VAT?
Select customer_type,
	   AVG(VAT) as VAT
From Sales
Group by customer_type
Order by VAT DESC;

-- ----------------------
-- ----------------------
-- Customer


-- How many unique customer types does the data have?
Select 
	Distinct Customer_type
From Sales;

-- How many unique payment methods does the data have?
Select 
	Distinct payment
From Sales;

-- What is the most common customer type?
 Select Customer_type,
	count(Customer_type)
From Sales
Group by Customer_type;

-- Which customer type buys the most?
 Select Customer_type,
	count(Customer_type)
From Sales
Group by Customer_type;

-- What is the gender of most of the customers?
 Select gender,
	count(gender)
From Sales
Group by gender;

-- What is the gender distribution per branch?
 Select Branch,gender,count(gender)
From Sales
Group by Branch,gender
Order by Branch;

-- Which time of the day do customers give most ratings?
Select time_of_day, avg(rating) as avg_rating
From Sales
Group by time_of_day
Order by avg(rating) DESC;


-- Which time of the day do customers give most ratings per branch?
Select time_of_day, Branch, avg(rating) as avg_rating
From Sales
Group by time_of_day, Branch
Order by avg(rating) DESC;

-- Which day of the week has the best avg ratings?
Select day_name, avg(rating) as avg_rating
From Sales
Group by day_name
Order by avg(rating) DESC;

-- Which day of the week has the best average ratings per branch?
Select day_name, Branch, avg(rating) as avg_rating
From Sales
Group by day_name, Branch
Order by avg(rating) DESC;