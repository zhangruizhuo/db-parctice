insert into Customers(cust_id, cust_name, cust_address, cust_city, cust_state, cust_zip, cust_country, cust_contact,
                      cust_email)
    value ('1000000006', 'Toy Land', '123 Any Street', 'New York', 'NY', '11111', 'USA', NULL, NULL);

# 允许空值 or 有默认值时，可以省略列
insert into Customers(cust_id, cust_name, cust_address, cust_city, cust_state, cust_zip, cust_country)
    value ('1000000006', 'Toy Land', '123 Any Street', 'New York', 'NY', '11111', 'USA');

# 复制表
INSERT INTO Customers(cust_id, cust_contact, cust_email, cust_name, cust_address, cust_city, cust_state, cust_zip,
                      cust_country)
SELECT cust_id,
       cust_contact,
       cust_email,
       cust_name,
       cust_address,
       cust_city,
       cust_state,
       cust_zip,
       cust_country
FROM New_Customer;
# where cust_id='1000000006';

# 复制内容到新创建的表
create table New_Customer
as
select *
from Customers;

/*
 Update, Delete
 使用前，先用select进行测试，保证过滤的是正确记录。
 */
update Customers
set cust_email='xxx@gmail.com'
where cust_id = '1000000005';

update Customers
set cust_contact='Steve Rogers',
    cust_email='cap@ameraca.com'
where cust_id = '1000000006';

delete
from Customers
where cust_id = '1000000006';

alter table Vendors
    add vend_phone char(20);
# drop column vend_phone;

drop table New_Customer;

/*
 view，视图，不包含任何列或数据，包含的是一个查询
 */
create view ProductCustomers as
select cust_name, cust_contact, prod_id
from Customers,
     Orders,
     OrderItems
where Customers.cust_id = Orders.cust_id
  and Orders.order_num = OrderItems.order_num;

select *
from ProductCustomers;

/*
 约束，ALTER TABLE 中，使用 add constraint 来完成
 PRIMARY KEY，REFERENCES，UNIQUE，CHECK
 */

# 外键
create table Ox
(
    ox_id     integer not null primary key,
    order_num int references Orders (order_num)
);

# 索引，可以对多列建立
create index prod_name_idx
on Products(prod_name);

# Trigger
