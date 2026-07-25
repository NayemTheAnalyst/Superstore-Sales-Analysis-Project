/*1. Quantity per sub-category
	Binders and Paper are the top sellers, over 5,000 units each. 
	Makes sense — these are cheap things people buy again and again.*/

SELECT 
	Sub_Category,
	SUM(Quantity) as total_unit_sold
FROM potfolio_project3.superstore
group by sub_category
order by total_unit_sold desc;

/*2. Loss-making sub-categories
	Tables is the biggest loss — around $17.7K down even with $206K in sales.
	Bookcases and Supplies are losing money too, probably because of high discounts.*/
    
SELECT 
Sub_Category,
round(SUM(sales),2) as total_sales,
round(SUM(profit),2)as total_profit
FROM potfolio_project3.superstore
group by Sub_Category
having SUM(profit)<0
order by total_profit;

/*3. Region + Category
	East region's Technology sales bring the most profit, close to $47K.
	Central region's Furniture is the only one actually losing money.*/
    
SELECT 
region,
Category,
ROUND(SUM(sales),2) as total_sales,
ROUND(SUM(profit),2) as total_profit
FROM potfolio_project3.superstore
group by Region,Category
order by Region,total_sales desc;

/*4. Top 10 customers
	Sean Miller has the highest spending but actually causes a loss for the company. 
	Tamara Chand spends less but gives more profit, so she's a better customer.*/

SELECT
Customer_name
customer_id,
ROUND(SUM(sales),2) as total_sales,
ROUND(SUM(profit),2) as total_profit
FROM potfolio_project3.superstore
group by Customer_id, Segment, customer_name
order by total_sales desc
limit 10;

/*5. Loss-making combos
	Over 1,600 customer-product-state combinations are losing money. Machines and 
	Binders keep showing up as the main problem items.*/

SELECT
Customer_name,
sub_category,
state,
ROUND(SUM(profit),2) as total_profit
FROM potfolio_project3.superstore
group by Customer_name, Sub_Category,state
Having total_profit<0
order by total_profit asc;

/*6. Discount vs profit
	When there's no discount, average profit is around $67. But once discount goes above 40%, 
	profit turns negative. So high discounts are hurting profit a lot.*/

SELECT 
  CASE 
    WHEN Discount = 0 THEN '0%'
    WHEN Discount <= 0.2 THEN '1-20%'
    WHEN Discount <= 0.4 THEN '21-40%'
    ELSE '40%+'
  END as discount_band,
  ROUND(AVG(Profit),3) as avg_profit,
  COUNT(*) as num_orders
FROM superstore
GROUP BY discount_band;
SELECT *
FROM superstore;

/*7.  Monthly sales trend
	November has the highest sales, probably due to holiday shopping.
	Sales are usually lower in the early months like February.*/

SELECT DATE_FORMAT(order_date, '%Y-%m') as month, 
ROUND(SUM(sales),2) as total_sales
FROM superstore
GROUP BY month
ORDER BY month;

/*8.Ship mode
	Standard Class brings the most total profit since most people use it. 
	Same Day is fastest but earns less overall because fewer people choose it.
*/
SELECT ship_mode, 
AVG(DATEDIFF(ship_date, order_date)) as avg_ship_days, 
ROUND(SUM(profit),2) as total_profit
FROM superstore
GROUP BY ship_mode;

/*9. Sub-category rank within category
	Chairs is the top performer in Furniture, Paper in Office Supplies, and Copiers in Technology. 
	Tables and Supplies are at the bottom again.
*/
SELECT Category, Sub_Category, 
	ROUND(SUM(Profit),2) as total_profit,
	RANK() OVER (PARTITION BY Category ORDER BY SUM(Profit) DESC) as profit_rank
FROM superstore
	GROUP BY Category, Sub_Category;
  
/*10. Running total of sales
	Sales go up and down a bit month to month, but the overall total keeps growing over time, which is a good sign.
*/
SELECT month, total_sales,
  SUM(total_sales) OVER (ORDER BY month) as running_total
FROM (
  SELECT DATE_FORMAT(order_date,'%Y-%m') as month, 
	ROUND(SUM(sales),2) as total_sales
  FROM superstore GROUP BY month
) t;

/*11. Worst products
One single product from Machines lost almost $8.9K alone, the biggest loss
in the whole dataset. Most of the worst products come from Machines and Tables.
*/
SELECT product_id, Sub_Category, 
ROUND(SUM(Profit),2) as total_profit
FROM superstore
GROUP BY product_id, Sub_Category
ORDER BY total_profit ASC
LIMIT 10;








