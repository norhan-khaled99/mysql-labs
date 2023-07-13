num1:
begin;
insert into Student(S_ID,geneder,birhtDate,Contact_Info,F_Name,L_Name)
values(5,"male",'2000-12-24',"Ibrahim@mail.com","Ibrahim","Mohammed");
insert into Study(Stud_ID,Sub_ID,ExamDate,Grade)
values (5,1,'2023-5-11',80);
commit;

--num2:
select DATE_FORMAT(ExamDate,'%D-%M-%Y') from Study;

--num3:
select F_Name , L_Name , YEAR(now()) - YEAR(birhtDate) from Student;

--num4:
select F_Name , L_Name ,round(Grade,2) from Student , Study 
where S_ID=Stud_ID;

--num5:
select F_Name , L_Name , YEAR(birhtDate) from Student;

--num6:
insert into Study(Stud_ID,Sub_ID,ExamDate,Grade)
values (5,3,now(),90);

--num7:
DELIMITER //
create function HelloWorld(name char(50))
returns char(50)
DETERMINISTIC
BEGIN
return concat('Hello  ',name);
END //
DELIMITER ;
select HelloWorld('nor');

--num8:
DELIMITER //
create function Multiply(num1 int,num2 int)
returns int
DETERMINISTIC
BEGIN
return num1*num2;
END //
DELIMITER ;
select Multiply(10,2);

--num9:
DELIMITER //
create function GetScore(s_id int , edate Date)
returns int
DETERMINISTIC
BEGIN
declare score int;
select Grade into score from Study where Stud_ID=s_id and ExamDate=edate;
return score;
END //
DELIMITER ;
select GetScore(1,'2022-12-25');

--num10:
DELIMITER //
create function fail(examID int)
returns int
DETERMINISTIC
BEGIN
declare countre int;
select count(Stud_ID) into countre from Study where Sub_ID=examID and Grade<50;
return countre;
END //
DELIMITER ;
select fail(1);

--num11:
DELIMITER //
create function AvrgSubScore(SubName char(50))
returns int
DETERMINISTIC
BEGIN
declare avgr int;
select avg(Grade) into avgr from Study , Subject where Subject.Sub_ID=Study.Sub_ID and SubName=Subject.Sub_Name;
return avgr;
END //
DELIMITER ;
select AvrgSubScore('HTML');

--num12:
create table DeletedStudent like Student;

--num13:
DELIMITER //
create trigger DeleteStud before delete on Student
for each row
insert into DeletedStudent (S_ID,geneder,birhtDate,Contact_Info,F_Name,L_Name) values (old.S_ID,old.geneder,old.birhtDate,old.Contact_Info,old.F_Name,old.L_Name);
//
DELIMITER ;

--num14:
create table AddedStudent like Student;
DELIMITER //
create trigger BackupStudent after insert on Student
for each row
insert into AddedStudent (S_ID,geneder,birhtDate,Contact_Info,F_Name,L_Name) values (new.S_ID,new.geneder,new.birhtDate,new.Contact_Info,new.F_Name,new.L_Name);
//
DELIMITER ;

--num15:
create table Student_log(id int  auto_increment primary key ,operation varchar(40), att  datetime);
DELIMITER //
create trigger logs after insert on Student
for each row
insert into Student_log (operation,att) values ('insert',now());
//
DELIMITER ;

DELIMITER //
create trigger logs after update on Student
for each row
insert into Student_log (operation,att) values ('update',now());
//
DELIMITER ;

--num16:
sudo mysqldump --databases lab1Mysql > lab3dump.sql

--num17:
sudo mysqldump lab1Mysql Student > StudentData.sql 

--num18:
sudo mysqlimport lab3dump.sql