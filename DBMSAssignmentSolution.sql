create database if not exists TravelOnTheGo;
use TravelOnTheGo;

/*
I have divided the data into three tables 'passenger', 'route' and 'price'
First I added auto incrementing primary key to 'passenger' table
Since it is observed that in 'passenger' table there is a transitive dependency
between passenger_id -> boarding and destination city -> distance
I have created new table 'route' with auto incrementing primary key 'route_id'
Now I have assumed that there will be one bus operator running on a specific route
So I have created table 'price' with auto incrementing primary key 'bus_operator_id'
and according to a combination of distance and bus_type per passenger,
in 'route' table assigned foreign key 'bus_operator_id' per 'route_id' 
*/

create table if not exists price(
bus_operator_id int auto_increment primary key,
bus_type  varchar(20),
price int
);

create table if not exists route(
route_id int auto_increment primary key,
boarding_city varchar(20),
destination_city varchar(20),
distance int,
bus_operator_id int,
foreign key (bus_operator_id) references price (bus_operator_id)
);

create table if not exists passenger(
passenger_id int auto_increment primary key,
passenger_name varchar(20),
category varchar(20),
gender char,
route_id int,
foreign key (route_id) references route (route_id)
);

insert into price (bus_type,price) values ("Sleeper",770);
insert into price (bus_type,price) values ("Sleeper", 1100);
insert into price (bus_type,price) values ("Sleeper", 1320);
insert into price (bus_type,price) values ("Sleeper", 1540);
insert into price (bus_type,price) values ("Sleeper", 2200);
insert into price (bus_type,price) values ("Sleeper", 2640);
insert into price (bus_type,price) values ("Sleeper", 434);
insert into price (bus_type,price) values ("Sitting", 620);
insert into price (bus_type,price) values ("Sitting", 620);
insert into price (bus_type,price) values ("Sitting", 744);
insert into price (bus_type,price) values ("Sitting", 868);
insert into price (bus_type,price) values ("Sitting", 1240);
insert into price (bus_type,price) values ("Sitting", 1488);
insert into price (bus_type,price) values ("Sitting", 1860);

insert into route (boarding_city,destination_city,distance,bus_operator_id) values ("Bengaluru","Chennai",350,1);
insert into route (boarding_city,destination_city,distance,bus_operator_id) values ("Mumbai","Hyderabad",1100,11);
insert into route (boarding_city,destination_city,distance,bus_operator_id) values ("Panaji","Bengaluru",600,3);
insert into route (boarding_city,destination_city,distance,bus_operator_id) values ("Chennai","Mumbai",1500,null);
insert into route (boarding_city,destination_city,distance,bus_operator_id) values ("Trivandrum","Panaji",1000,5);
insert into route (boarding_city,destination_city,distance,bus_operator_id) values ("Nagpur","Hyderabad",500,8);
insert into route (boarding_city,destination_city,distance,bus_operator_id) values ("Panaji","Mumbai",700,4);
insert into route (boarding_city,destination_city,distance,bus_operator_id) values ("Hyderabad","Bengaluru",500,9);
insert into route (boarding_city,destination_city,distance,bus_operator_id) values ("Pune","Nagpur",700,null);

update route set distance=700 where route_id=2;

insert into passenger (passenger_name,category,gender,route_id) values ("Sejal", "AC" ,"F",1);
insert into passenger (passenger_name,category,gender,route_id) values ("Anmol", "Non-AC", "M",2);
insert into passenger (passenger_name,category,gender,route_id) values ("Pallavi" ,"AC" ,"F" ,3);
insert into passenger (passenger_name,category,gender,route_id) values ("Khusboo" ,"AC" ,"F" ,4);
insert into passenger (passenger_name,category,gender,route_id) values ("Udit" ,"Non-AC" ,"M" ,5);
insert into passenger (passenger_name,category,gender,route_id) values ("Ankur" ,"AC" ,"M" ,6);
insert into passenger (passenger_name,category,gender,route_id) values ("Hemant" ,"Non-AC" ,"M" ,7);
insert into passenger (passenger_name,category,gender,route_id) values ("Manish" ,"Non-AC", "M",8);
insert into passenger (passenger_name,category,gender,route_id) values ("Piyush", "AC", "M",9);

-- Answer to question 3
select p.gender,count(p.gender) as count from price k inner join route r on k.bus_operator_id=r.bus_operator_id inner join passenger p on r.route_id=p.route_id where r.distance >= 600 group by p.gender;

-- Answer to question 4
select min(p.price) as min_price from price p where p.bus_type='sleeper';

-- Answer to question 5
select p.passenger_name from passenger p where p.passenger_name like 'S%';

-- Answer to question 6
select p.passenger_name,r.boarding_city,r.destination_city,k.bus_type,k.price from price k inner join route r on k.bus_operator_id=r.bus_operator_id inner join passenger p on r.route_id=p.route_id;

-- Answer to question 7
select p.passenger_name,k.price from price k inner join route r on k.bus_operator_id=r.bus_operator_id inner join passenger p on r.route_id=p.route_id where r.distance=1000 and k.bus_type='sitting';

-- Answer to question 8
select p.passenger_name,k.bus_type,k.price from price k inner join route r on k.bus_operator_id=r.bus_operator_id inner join passenger p on r.route_id=p.route_id where p.passenger_name='Pallavi' and (k.bus_type='sitting' or k.bus_type='sleeper');

-- Answer to question 9
select j.distance from (select distance,count(distance) as count from route group by distance) as j where j.count=1 order by j.distance desc;

-- Answer to question 10
select p.passenger_name,(r.distance/(select sum(r.distance) from route r inner join price p on r.bus_operator_id=p.bus_operator_id))*100 as percentage from price k inner join route r on k.bus_operator_id=r.bus_operator_id inner join passenger p on r.route_id=p.route_id;

-- Answer to question 11
select r.distance,p.price,
case
when p.price > 1000 then 'Expensive'
when p.price > 500 then 'Average cost'
else 'Cheap'
end
as price_value from route r inner join price p on r.bus_operator_id=p.bus_operator_id;