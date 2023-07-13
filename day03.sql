--- views


create view employees_info as (

    select id , name , gender from employees
);


--- to select data from view 

select * from employees_info; 

select id , name from employees_info;

---------

-- make sure that the result of the query doesn't have duplication 
-- in the columns 

-- select * from employees,  departments 
-- where employees.dept_id = departments.id;


-- create view employees_full_info as (
-- select employees.id , employees.name, employees.gender, employees.address, 
-- employees.salary, employees.dept_id, 
-- departments.id as my_dept_id , departments.dept_name
-- from employees,  departments 
-- where employees.dept_id = departments.id);

create or replace view employees_full_info as (
select employees.id , employees.name, employees.gender, employees.address, 
employees.salary, 
departments.id as my_dept_id , departments.dept_name
from employees,  departments 
where employees.dept_id = departments.id);

-----------------  views like a table (but not a table)
---- updatable views ------- (insert , update, delete ,truncate )


create or replace view employees_subset_info as (
    select id ,name , dept_name from employees_full_info
); 


---------- 
-- employees_info is an updatable view.
insert into employees_info(id, name) values (21, 'added_via_view2');


------------------------------------- alter view ? ----------------------------------



alter view employees_info as (

    select id , name , gender , salary from employees
);



--- drop view 
drop view if exists employees_info;

-- show how the view created

show create view view_name;

| employees_info | CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` 
SQL SECURITY DEFINER VIEW `employees_info` 
AS select `employees`.`id` AS `id`,`employees`.`name` 
AS `name`,`employees`.`gender` AS `gender` from `employees` | utf8mb4              
| utf8mb4_0900_ai_ci   | 


----  views benifits 


create view employees_salaries as
(
    select id , name, salary*.8 from employees
);

--------------------------------- Transaction----------------------------

--- 
begin;

start Transaction ; 


update employees set salary = salary - 2000 where id = 10;

update employees set salary = salary + 2000 where id = 11;

commit;  -- if you  need to apply the changes to the database 

rollback ; --- > if you need to cancel the changes 



------------------------------------------ auto commit 
set autocommit = 1;    --- by default in your mysql client autocommit=1;

-- if I need to make a transaction
set autocommit=0;
update employees set salary = salary - 2000 where id = 10;

update employees set salary = salary + 2000 where id = 11;


--- you have the option to commit or rollback. 

--------------- Database engines 

--- > Innodb ---> ensure refrential integrity ---> support fk checks, transaction
---> MyISAM ---> doesn't support referential integrity , transaction

----------------- transaction savepoints 


begin ; 
update employees set salary = salary - 2000 where id = 10;
savepoint savepoint1; 
update employees set salary = salary + 2000 where id = 11;
savepoint savepoint2; 
update employees set salary = salary + 2000 where id = 11;
savepoint savepoint3; 

rollback to savepoint2;
commit; 


------------------------------------- built-in functions 


SELECT GREATEST(4, 83, 0, 9, -3);



SELECT GREATEST(Null , null);



select if (expr1, expr2 , expr3 ); 

-- if expr1 == True ----> return expr2 
-- else: ----> return expr3


--------------------------------------------------

select ifnull(expr1 , expr2);




if expr1==null -------> returns with expr2 



-------------------
select nullif('iti', 'noha');


-------------------- Cases
select * , 
case 
when gender = 'male' then 'M'
when gender = 'female' then 'F'
else 'None'
end 
from employees; 




SELECT SUBSTRING('cats and dogs', 10);
------------------------------------------------------------------

---- functions----------------------------------------


-- create function employees_count ()
-- returns int 

-- return  select count(*) from employees; 




-- create function ---> hello name 




-----------------
-- CREATE FUNCTION hello (s CHAR(20))
-- RETURNS CHAR(50) DETERMINISTIC
--        RETURN CONCAT('Hello, ',s,'!');
-------------------------------------------------------
dELIMiTER //
create function function_name(paramters  datatype)

return datatype 

begin
    -- define set of variables 
    ---> declare vARANME DATATYPE   ;
    ---> SELECT COUNT(*) into count FROM EMPLOYEES  ;
    RETURN COUNT;

END;
 // dELIMiTER;





DELIMITER //
CREATE FUNCTION get_count()
   RETURNS int
   DETERMINISTIC
   BEGIN
      declare counn int;
      select count(*) into counn from employees;
      return counn;
   END // DELIMITER ;



DELIMITER //
CREATE FUNCTION get_emp_count()
   RETURNS int
   DETERMINISTIC
   BEGIN
      declare counn int;
      select count(*) into counn from employees;
      return counn;
   END // DELIMITER ;



--- name employee
DELIMITER //
CREATE FUNCTION get_emp_name()
   RETURNS varchar(100)
   DETERMINISTIC
   BEGIN
      declare emp_name varchar(100);
      select name into emp_name from employees where id =10;
      return emp_name;
   END // DELIMITER ;



-----------------------
-- DELIMITER //
-- CREATE FUNCTION sum_nums(num1 int , num2 int)
--    RETURNS int
--    DETERMINISTIC
--    BEGIN
--       return num1 + num2;
--    END // DELIMITER ;


------------
DELIMITER //
CREATE FUNCTION sum_nums2(num1 int , num2 int)
   RETURNS int
   DETERMINISTIC
   BEGIN
        declare res int; 
        select num1 + num2 into res;
      return res;
   END // DELIMITER ;

   -----

    --- function retrun no_of employees , no_of departments 

DELIMITER //
CREATE or replace FUNCTION emp_dept()
RETURNS int
DETERMINISTIC
BEGIN
    declare emp_count int;
    declare dept_count int; 
    select count(*) into emp_count from employees;        
    select count(*) into dept_count from departments;
    return emp_count + dept_count;
END // DELIMITER ;


---- drop function 
drop function emp_dept; 

-----to call the function

select emp_dept();

---------------------------------------- create function accept name 


DELIMITER //
CREATE FUNCTION sayhello(name char(40))
   RETURNS char(100)
   DETERMINISTIC
   BEGIN
        
      return CONCAT('hello', ' ',name );
   END // DELIMITER ;

---------------------

--- functions doesn't allow creating transaction inside it 
---> procedure do ----> 



----------------- get count of employees in employees 

-- procudure ---> In--->  , out ---> 

DELIMITER // 
create procedure empcount(IN d_id int , OUT countt int)
Begin 

    select count(*) into countt from employees where dept_id = d_id; 
End // 
DELIMITER;



-- @var_name ---> define variable in your mysql shell 
--> to access the variable 
select @var_name; 

--------------- procedure accept name then insert into table 
DELIMITER // 
CREATE  PROCEDURE insert_emp (IN emp_name varchar(100), IN emp_id int)
Begin
    insert into employees (id , name) values (emp_id, emp_name); 
end // 
DELIMITER ; 

------------------
CREATE PROCEDURE world_record_count ()
SELECT  COUNT(*) FROM  employees;

------------------------------------------------------------------







-- select *, 


--  from employees

DELIMITER //
CREATE FUNCTION check_greate_male_female()
   RETURNS int
   DETERMINISTIC
   BEGIN
      declare male_count int;
      declare female_count int;
      select count(gender) into male_count from employees where gender = 'male';
      select count(gender) into female_count from employees where gender = 'female';

      if (male_count > female_count)
        then  return 1;
        else return 0;
        end if; 
   END // DELIMITER ;

--------------------- Repeat function 

select repeat('Mysql', 3) as repated_string; 


select id , repeat(name, 2) from employees;



------------ Repeat with procedures 

-- 0 , 1, 2,3 
DELIMITER // 
create procedure repeatloop()
Begin 
    declare num  int;
    declare mystr varchar(100);
    -- define default values for variables 
    set num = 0;
    set mystr = '';
    repeat 
        set mystr =  CONCAT(mystr, num, ',');
        set num = num +1;
        UNTIL num > 5
    end repeat;

    select  mystr;

End // 
DELIMITER;
---------------------


DELIMITER // 
create procedure whileloop()
Begin 
    declare num  int;
    declare mystr varchar(100);
    -- define default values for variables 
    set num = 0;
    set mystr = '';
    while num <=5 do
        set mystr =  CONCAT(mystr, num, ',');
        set num = num +1;
    end while;

    select  mystr;

End // 
DELIMITER;



--- Salama's question 

select repeat(sayhello('Ahmed'),4) as iti_repeat;

----------------------------------

--------------------------------- Triggers --------------------
--- > fire action when something happened ?

--- triggers 
    ---> insert , update, delete ---> 

    ---> insert data in the database  ---> name ---> duplicate 



    --------------------

    create table person
    (id int auto_increment primary key , name varchar(100), age int );


    insert into person(name) values ('ahmed');



    ----> check old data ?
    --->   
   ---> Trigger ---> Old , new 

   --->  insert ? 
DELIMITER // 
    create trigger insert_person before insert 
    on person 
     for each row
        if new.age < 20 then 
        signal sqlstate '50001' set message_text ='person must be older than 20'; 
        end if; //
    DELIMITER ;




insert into person(name, age) values ('test', 15);


   --->  insert ? 
DELIMITER // 
    create trigger insert_person_duplicate_name before insert 
    on person 
     for each row
        if new.name in (select name from person) then 
        signal sqlstate '50001' set message_text ='person name cannot be duplicated'; 
        end if; //
    DELIMITER ;



------

create table person_log(id int  auto_increment primary key ,
 operation varchar(40), att  datetime);


DELIMITER // 
    create trigger person_log_insert after insert 
    on person 
     for each row
        insert into person_log (operation, att) values ('insert', now())
    //
DELIMITER ;


-------------- Trigger 
---- OLD 

----> NEW ---> in
SELECT TIMESTAMPDIFF(YEAR, '1970-02-01', CURDATE()) AS age;




---
-- create table xyz as select * from oldtable;  -- not empty
-- > create table mm like oldtable ;




