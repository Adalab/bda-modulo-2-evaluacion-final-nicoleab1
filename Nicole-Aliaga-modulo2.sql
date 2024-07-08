-- Evaluación final Módulo 2

USE Sakila;


-- Ejercicio 1: Selecciona todos los nombres de las películas sin que aparezcan duplicados.
SELECT DISTINCT (title) 
FROM film 
ORDER BY (title) asc;

-- Ejercicio 2: Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".
SELECT title, rating 
FROM film
WHERE rating = "PG-13";

-- Ejercicio 3: Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción.
SELECT 	title, description
FROM film 
WHERE description LIKE "%amazing%";

-- Ejercicio 4: Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.
SELECT title, length
FROM film
WHERE length > 120;

-- Ejercicio 5: Recupera los nombres de todos los actores.
SELECT CONCAT(first_name, " ", last_name) AS actor_name
FROM actor;

-- Ejercicio 6: Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.
SELECT CONCAT(first_name, " ", last_name) AS actor_name_with_gibson
FROM actor
WHERE last_name LIKE "Gibson";

-- Ejercicio 7: Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.
SELECT actor_id, CONCAT(first_name, " ", last_name) AS actor_name
FROM actor
WHERE actor_id BETWEEN 10 AND 20;

-- Ejercicio 8: Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en cuanto a su clasificación.
SELECT title, rating 
FROM film
WHERE rating NOT IN ("R", "PG-13");

-- Ejercicio 9: Encuentra la cantidad total de películas en cada clasificación de la tabla film y 
-- muestra la clasificación junto con el recuento.
SELECT rating, COUNT(rating) AS number_of_movies 
FROM film
GROUP BY rating;

-- Ejercicio 10: Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y
-- apellido junto con la cantidad de películas alquiladas

SELECT cu.customer_id, CONCAT(cu.first_name, " ", cu.last_name) AS customer_name, COUNT(re.rental_id) AS rented_films
FROM rental AS re
INNER JOIN customer AS cu
ON cu.customer_id = re.customer_id
GROUP BY customer_id;

-- Ejercicio 11: Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el
-- recuento de alquileres.
SELECT COUNT(rental_id) AS rented_films, cat.name AS category_name 
FROM category AS cat
INNER JOIN film_category AS fcat
ON cat.category_id = fcat.category_id
INNER JOIN inventory AS inv
ON inv.film_id = fcat.film_id
INNER JOIN rental AS re
ON re.inventory_id = inv.inventory_id
GROUP BY cat.name;

-- Ejercicio 12: Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la
-- clasificación junto con el promedio de duración
SELECT rating, AVG(length) AS average_length
FROM film
GROUP BY rating;

-- Ejercicio 13: Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".
SELECT first_name AS actor_first_name, last_name AS actor_last_name, title AS movie_title
FROM actor AS ac
INNER JOIN film_actor AS fac
ON ac.actor_id = fac.actor_id
INNER JOIN film AS f
ON fac.film_id = f.film_id
WHERE title = "Indian Love";

-- Ejercicio 14: Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.
SELECT title, description AS description_w_dog_cat
FROM film
WHERE description LIKE "%_dog_%" OR "%_cat_%";

-- Ejercicio 15: Hay algún actor o actriz que no aparezca en ninguna película en la tabla film_actor.

SELECT CONCAT (ac.first_name, " ", ac.last_name) AS actors_in_no_movie, film_id
FROM actor AS ac
LEFT JOIN film_actor AS fac
ON ac.actor_id = fac.actor_id
WHERE fac.film_id IS NULL;

-- No aparece ningún actor, por si acaso me fijo en esto: 

 SELECT COUNT(DISTINCT actor_id)
 FROM actor;
 
 SELECT COUNT(DISTINCT actor_id)
 FROM film_actor;
 
 
 -- Ejercicio 16: Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.
 
SELECT f.title 
FROM film AS f
WHERE release_date BETWEEN "2005" AND "2010";

-- Ejercicio 17: Encuentra el título de todas las películas que son de la misma categoría que "Family".
SELECT f.title AS titles_in_cat_Family
FROM film AS f
INNER JOIN film_category AS fac
ON f.film_id = fac.film_id
INNER JOIN category AS cat
ON cat.category_id = fac.category_id
WHERE cat.name = "Family";

-- Ejercicio 18: Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.
SELECT ac.first_name, ac.last_name, COUNT(fac.film_id) AS films
FROM actor AS ac
INNER JOIN film_actor AS fac
ON ac.actor_id = fac.actor_id
GROUP BY fac.actor_id
HAVING COUNT(fac.film_id) > 10;

-- Ejercicio 19: Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film.
SELECT f.title
FROM film AS f
WHERE f.rating = "R" AND length > 120;

-- Ejercicio 20: Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y muestra el
-- nombre de la categoría junto con el promedio de duración
SELECT cat.name AS category, ROUND(AVG(length),0) AS average_length
FROM category AS cat
INNER JOIN film_category AS fac
ON cat.category_id = fac.category_id
INNER JOIN film AS f
ON f.film_id = fac.film_id
GROUP BY cat.name
HAVING average_length > 120;

-- Ejercicio 21: Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la
-- cantidad de películas en las que han actuado.
SELECT CONCAT(ac.first_name, " ", ac.last_name) AS actor_name, COUNT(fac.film_id) AS films
FROM actor AS ac
INNER JOIN film_actor AS fac
ON ac.actor_id = fac.actor_id
GROUP BY fac.actor_id
HAVING COUNT(fac.film_id) > 5;

-- Ejercicio 22: Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. Utiliza una subconsulta para
-- encontrar los rental_ids con una duración superior a 5 días y luego selecciona las películas correspondientes

-- primero encontramos los rental_ids con una duración superior a 5 días:

SELECT r.rental_id, DATEDIFF(r.return_date, r.rental_date) AS days
FROM rental AS r
WHERE DATEDIFF(r.return_date, r.rental_date) > 5;

-- Ahora mostramos adicionalmente el título de las películas

SELECT DISTINCT(f.title)
FROM rental AS r
INNER JOIN inventory AS inv
ON inv.inventory_id = r.inventory_id 
INNER JOIN film AS f
ON f.film_id = inv.film_id
WHERE DATEDIFF(r.return_date, r.rental_date) > 5;

-- Ejercicio 23: Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "Horror".
-- Utiliza una subconsulta para encontrar los actores que han actuado en películas de la categoría "Horror" y luego
-- exclúyelos de la lista de actores.

-- primero encontramos a los actores que han actuado en películas de la categoría "Horror"
SELECT a.first_name, a.last_name, cat.name
FROM actor AS a
INNER JOIN film_actor AS fac
ON a.actor_id = fac.actor_id
INNER JOIN film_category AS fc
ON fac.film_id = fc.film_id
INNER JOIN category AS cat
ON fc.category_id = cat.category_id
WHERE cat.name = "Horror";

-- Ahora excluimos lo encontrado para ver los actores que no han actuado en Horror movies

SELECT a.first_name, a.last_name
FROM actor AS a
WHERE a.actor_id NOT IN( 
SELECT a.actor_id
FROM actor AS a
INNER JOIN film_actor AS fac
ON a.actor_id = fac.actor_id
INNER JOIN film_category AS fc
ON fac.film_id = fc.film_id
INNER JOIN category AS cat
ON fc.category_id = cat.category_id
WHERE cat.name = "Horror");

-- Ejercicio 24 BONUS: Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la
-- tabla film.
SELECT f.title, cat.name, f.length
FROM film AS f
INNER JOIN film_category AS fc
ON f.film_id = fc.film_id
INNER JOIN category AS cat
ON cat.category_id = fc.category_id
WHERE name = "Comedy" AND length > 180;

-- Ejercicio 25 BONUS: Encuentra todos los actores que han actuado juntos en al menos una película. La consulta debe
-- mostrar el nombre y apellido de los actores y el número de películas en las que han actuado juntos.

SELECT *
FROM 
    film_actor fa1
    JOIN 
    film_actor fa2 ON fa1.film_id = fa2.film_id AND fa1.actor_id < fa2.actor_id;

SELECT 
    a1.first_name AS actor1_first_name,
    a1.last_name AS actor1_last_name,
    a2.first_name AS actor2_first_name,
    a2.last_name AS actor2_last_name,
    COUNT(fa1.film_id) AS num_peliculas_juntos
FROM 
    film_actor fa1
JOIN 
    film_actor fa2 ON fa1.film_id = fa2.film_id AND fa1.actor_id < fa2.actor_id
JOIN 
    actor a1 ON fa1.actor_id = a1.actor_id
JOIN 
    actor a2 ON fa2.actor_id = a2.actor_id
GROUP BY 
    a1.actor_id, a2.actor_id
HAVING 
    COUNT(fa1.film_id) > 0
ORDER BY 
    num_peliculas_juntos DESC;
