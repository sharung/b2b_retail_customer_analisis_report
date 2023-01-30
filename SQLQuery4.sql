-- menampilkan 5 data teratas dari 3 table 
Mengecek tabel orders_1 :SELECT * FROM orders_1 limit 5;
Mengecek tabel orders_2 :SELECT * FROM orders_2 limit 5;
Mengecek tabel customer :SELECT * FROM customer limit 5;

-- mencari total penjualan dan revenue pada Q-1 dan Q-2
select sum(quantity) total_penjualan, sum(quantity*priceEach) revenue from orders_1;
select sum(quantity) total_penjualan, sum(quantity*priceeach) revenue from orders_2 where status = 'shipped';

-- menghitung dari 2 table yang digabungkan menjadi 1
select quarter, sum(quantity) total_penjualan, sum(quantity*priceeach) revenue from 
( 
	select orderNumber,status,quantity,priceeach, '1' quarter
	from orders_1
	union
	select orderNumber,status,quantity,priceeach, '2' quarter 
	from orders_2
)as a
where status='shipped'
group by quarter;


-- melihat pertumbuhan customer xyz
select quarter, count(distinct customerid) total_customers from 
(
	select customerID, createDate, QUARTER(createDate) quarter 
	from customer
	where createDate between '2004-01-01' and '2004-06-30'
	order by createDate
) as b
group by 1


select quarter, count(distinct customerid) total_customers from
(
	select customerID,createdate, quarter(createdate) quarter from customer
	where createdate between '2004-01-01' and '2004-06-30'
) table_b
where customerID IN ( 
	select distinct customerID from orders_1
	union
	select distinct customerid from orders_2
	)
group by 1


select * from (
	select categoryID, count( distinct orderNumber) total_order, sum(quantity) total_penjualan 
		from  (
			select productCode, orderNumber, quantity, status, Left(productCode, 3
			) categoryID from orders_2
	where status = 'shipped'
	) table_c
group by categoryID) a
order by total_order desc;


#Menghitung total unik customers yang transaksi di quarter_1
SELECT COUNT(DISTINCT customerID) as total_customers FROM orders_1;
#output = 25
select 1 quarter, (count(distinct customerid)*100)/25 as q2 
from orders_1 
where customerid in ( 
	select distinct customerid
	from orders_2 );
