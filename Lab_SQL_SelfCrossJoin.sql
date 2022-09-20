use sakila;

-- 1. Get all pairs of actors that worked together.

select * from actor;
select * from film_actor;
  
select f2.film_id, f1.actor_id, f2.actor_id from film_actor f1
join film_actor f2
on f1.film_id = f2.film_id
group by f1.actor_id
having f1.actor_id != f2.actor_id
order by f2.film_id;


-- 2. Get all pairs of customers that have rented the same film more than 3 times.

select * from customer;

select c1.customer_id cus1, c2.customer_id cus2 , count(c1.film_id) repeated_films from
	(
		(
		select c.customer_id, f.film_id from customer c
		join rental r on c.customer_id = r.customer_id
		join inventory i on r.inventory_id = i.inventory_id
		join film f on i.film_id = f.film_id
		) c1 -- identifying the films rented by first column of customers
		join (
			select c.customer_id, f.film_id from customer c
			join rental r on c.customer_id = r.customer_id
			join inventory i on r.inventory_id = i.inventory_id
			join film f on i.film_id = f.film_id -- -- identifying the films rented by second column of customers
			) c2 on c2.film_id = c1.film_id -- joining both c1 and c2 on the same film_ids  
            and c2.customer_id < c1.customer_id --  condition to avoid the entry of the same pairs twice and the repetition of the same customer_id in the two columns 
	)
group by c1.customer_id, c2.customer_id -- group the repeated films by both customer columns
having count(c1.film_id) > 3 -- condition to display number of repeated movies bigger than 3, as required in the question
order by count(c1.film_id);

-- 3. Get all possible pairs of actors and films.

select * from actor;
select * from film_actor;

select * from (select distinct actor_id, concat(first_name, " ", last_name) as "Actors" from actor
) sub1 
cross join (select distinct film_id from film_actor
) sub2;