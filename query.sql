/*
 SELECT
 */
select * -- 局部注释
from Customers;

select prod_id, prod_name
from Products;

# distinct 作用于其后的所有列
select distinct vend_id
from Products;

select prod_name
from Products
limit 5;

select prod_name
from Products
limit 5
    offset 3;
# limit 3, 5;

/*
 排序 ORDER BY
 必须作为最后一个子句
 */
select prod_name
from Products
order by prod_name;

select prod_id, prod_price, prod_name
from Products
order by prod_price, prod_name;
# order by 2, 3;

# desc 仅应用到直接位于其前面的列名
select prod_id, prod_price, prod_name
from Products
order by prod_price desc, prod_name;

/*
 Where
 ! = < > BETWEEN, IS NULL,
 */
select prod_name, prod_price
from Products
where prod_price = 3.49;
# where prod_price < 10;
# where prod_price between 5 and 10;
# where vend_id != 'DLL01'; -- 等价于<>

select cust_name, cust_address
from Customers
where cust_email is null;

/*
 组合查询
 AND OR IN NOT
 */
select prod_id, prod_name, prod_price
from Products
where vend_id = 'DLL01'
  and prod_price < 4;

select prod_id, prod_name, prod_price
from Products
# where vend_id = 'DLL01' or vend_id = 'BRS01';
where vend_id in ('DLL01', 'BRS01');

# and 计算优先级高于 or
select prod_id, prod_name, prod_price
from Products
where (vend_id = 'DLL01' or vend_id = 'BRS01')
  and prod_price >= 10;

select prod_name, prod_price
from Products
where not vend_id = 'DLL01';

/*
 通配符
 LIKE, 尽量放到搜索语句比较靠后的位置
 */

# % 除空格、null外的任意次(0)、任意字符
select prod_name, prod_price
from Products
# where prod_name like 'Fish%';
# where prod_name like '%bean bag%';
where prod_name like 'F%y';

# _ 单个字符
select prod_name, prod_price
from Products
# where prod_name like '_ inch teddy bear';
where prod_name like '__ inch teddy bear';

/*
  [] 单个、集合 mysql 不支持
  select cust_name, cust_contact
  from Customers
  where cust_contact like '[JM]%';
 */

/*
 计算字段
 concat, trim, as
 */
select concat(vend_name, '(', vend_country, ')')
           as vend_title
from Vendors;

select prod_id, quantity, item_price, item_price * quantity as expended_price
from OrderItems
where order_num = 20008;

/*
 函数
 */
select vend_name, upper(vend_name) as vend_name_upcase
from Vendors;

select cust_name, cust_contact
from Customers
where soundex(cust_contact) = soundex('Micheal Green');

select order_num
from Orders
where YEAR(order_date) = 2012;

/*
 汇总数据
 */
# avg 忽略null值
select avg(prod_price) as avg_price
from Products;

# count，指定列时，忽略null；使用 * 时，统计全部
# select count(*) as num_cust
select count(cust_email) as num_cust
from Customers;

# select max(prod_price) as max_price
select min(prod_price) as min_price
from Products;

select sum(item_price * quantity) as total_price
from OrderItems
where order_num = 20005;

select avg(distinct prod_price) as avg_price
from Products
where vend_id = 'DLL01';

select count(*)        as num_items,
       min(prod_price) as min_price,
       max(prod_price) as max_price,
       avg(prod_price) as avg_price
from Products;

/*
 分组数据
 select子句顺序：
 select, from, where, group by, having, order by
 */
select vend_id, count(*) as num_prods
from Products
group by vend_id;

select cust_id, count(*) as orders
from Orders
group by cust_id
having orders >= 2;

select vend_id, count(*) as num_prods
from Products
where prod_price >= 4
group by vend_id
having num_prods >= 2;

select order_num, count(*) as items
from OrderItems
group by order_num
having items >= 3
order by items, order_num;

/*
 子查询
 */
select cust_name, cust_contact
from Customers
where cust_id in (
    select cust_id
    from Orders
    where order_num in (
        select order_num
        from OrderItems
        where prod_id = 'RGAN01'));

select cust_name, cust_contact
from Customers,
     Orders,
     OrderItems
where Customers.cust_id = Orders.cust_id
  and Orders.order_num = OrderItems.order_num
  and OrderItems.prod_id = 'RGAN01';

# 子查询，where 中需要使用 表名 + 列名
select cust_name,
       cust_state,
       (select count(*)
        from Orders
        where Orders.cust_id = Customers.cust_id) as orders
from Customers
order by cust_name;

/*
 Join
 */
# 无联结条件，返回笛卡尔积，无意义
select vend_name, prod_name, prod_price
from Vendors,
     Products;

select vend_name, prod_name, prod_price
from Vendors,
     Products
where Vendors.vend_id = Products.vend_id;

select vend_name, prod_name, prod_price
from Vendors
         inner join Products
                    on Vendors.vend_id = Products.vend_id

select cust_name, order_num
from Customers
         left outer join Orders
# from Customers right outer join Orders
                         on Customers.cust_id = Orders.cust_id;

select Customers.cust_id, count(order_num) as orders
from Customers
         inner join Orders
#          left join Orders
                    on Customers.cust_id = Orders.cust_id
group by Customers.cust_id;

/*
 UNION
 union all 不去除重复行
 */
select cust_name, cust_state, cust_contact, cust_email
from Customers
where cust_state IN ('IL', 'IN', 'MI')
union
# union all
select cust_name, cust_state, cust_contact, cust_email
from Customers
where cust_name = 'Fun4All'
order by cust_name, cust_contact;

select cust_name, cust_state, cust_contact, cust_email
from Customers
where cust_state IN ('IL', 'IN', 'MI') or cust_name = 'Fun4All';
