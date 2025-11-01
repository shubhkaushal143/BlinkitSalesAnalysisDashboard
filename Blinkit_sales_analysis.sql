-- Blinkit Sales Data Analysis Using Diffrent Metrices

select * from blinkit_data

update blinkit_data
set Item_Fat_Content = 
case 
When Item_Fat_Content IN ('LF', 'low fat') THEN 'Low Fat'
when Item_Fat_Content = 'reg' then 'Regular'
else Item_Fat_Content
end

-- 1.The overall revenue generated from all items sold.
select cast(sum(Total_Sales)/1000000 as decimal(10,2)) as Total_revenue_in_Millions
from blinkit_data


-- 2.The average revenue per sale.
select cast(avg(Total_Sales) as int) as Average_sales
from blinkit_data

-- 3.The total count of different items sold.
select count(*) as No_of_Items from blinkit_data

-- 4.Average customer rating for items sold. 
select cast(AVG(rating) as decimal (10,2)) as avg_customer_rating 
from blinkit_data


-- 5.Total Sales, Average Sales,Average rating by Fat Content.
select Item_Fat_Content, 
cast(sum(Total_Sales)as decimal(10,2)) as Total_Sales,
cast(avg(Total_Sales) as decimal(10,2)) as Average_sales,
cast(AVG(rating) as decimal (10,2)) as Avg_customer_rating 
from blinkit_data
group by Item_Fat_Content 
order by Total_Sales DESC
  
-- 6.Total Sales, Average Sales,Average rating by Item Type
select Item_Type, 
concat(cast(sum(Total_Sales)/1000 as decimal(10,2)), ' k') as Total_Sales_in_Thousands,
cast(avg(Total_Sales) as decimal(10,2)) as Average_sales,
cast(AVG(rating) as decimal (10,2)) as Avg_customer_rating 
from blinkit_data
group by Item_Type 
order by Total_Sales_in_Thousands DESC

-- 7.Fat Content by Outlet for Total Sales:
select Item_Fat_Content, Outlet_Identifier,Outlet_Location_Type, 
	concat(cast(sum(Total_Sales)/1000 as decimal(10,2)), ' k') as Total_Sales
from blinkit_data
group by Outlet_Identifier,Item_Fat_Content,Outlet_Location_Type
order by Total_Sales DESC

select * from blinkit_data


-- 7.Fat Content by Outlet for Total Sales also Diffrent Fat content as column.

select Outlet_Location_Type,
	ISNULL([Low Fat],0) as Low_Fat,
	ISNULL([Regular],0) as Regular     -- Creating_Columns
from
(select Item_Fat_Content,Outlet_Location_Type, 
	cast(sum(Total_Sales) as decimal(10,2)) as Total_Sales
from blinkit_data
group by Item_Fat_Content,Outlet_Location_Type) as SourceTable
Pivot                  -- pivot are transforming whatever is there in rows into columns
(
Sum(Total_Sales)
for Item_Fat_Content in ([Low Fat], [Regular])
)as PivotTable

order by Outlet_Location_Type;

-- 8.Total Sales by Outlet Establishment
select Outlet_Establishment_Year, 
	concat(cast(sum(Total_Sales)/1000 as decimal(10,2)), ' k') as Total_Sales
from blinkit_data
group by Outlet_Establishment_Year
order by Outlet_Establishment_Year ASC


-- 9.Percentage of Sales by Outlet Size

select 
	Outlet_Size,
	cast(sum(Total_Sales) as decimal(10,2)) as Total_Sales,
	cast((sum(Total_Sales) *100 / sum(sum(Total_Sales)) over()) as decimal (10,2)) as Sales_Percentage
from blinkit_data
group by Outlet_Size
order by Total_Sales DESC

select * from blinkit_data


-- 10.All Metrics by Outlet Type- 
-- (Total Sales, Average Sales, Number of Items, Average Rating)
select Outlet_Type, 
	concat(cast(sum(Total_Sales)/1000 as decimal(10,2)), 'k') as Total_Sales_in_thousands,
	cast(avg(Total_Sales) as decimal(10,2)) as Average_sales,
	cast((sum(Total_Sales) *100 / sum(sum(Total_Sales)) over()) as decimal (10,2)) as Sales_Percentage,
	cast(AVG(rating) as decimal (10,2)) as Avg_customer_rating,
	count(*) as Number_of_Items
from blinkit_data
group by Outlet_Type 
order by Total_Sales_in_thousands DESC