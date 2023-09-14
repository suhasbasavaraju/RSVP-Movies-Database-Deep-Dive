USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:


-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

-- rows in director_mapping table

SELECT 
    COUNT(*) AS rows_director_mapping
FROM
    director_mapping; -- 3867 rows 

-- rows in genre table 

SELECT 
    COUNT(*) AS rows_genre
FROM
    genre; -- 14662 rows

-- rows in movie table 

SELECT 
    COUNT(*) AS rows_movie
FROM
    movie; -- 7997 rows

-- rows in names table 

SELECT 
    COUNT(*) AS rows_names
FROM
    `names`; -- 25735 rows 

-- rows in ratings table 

SELECT 
    COUNT(*) AS rows_ratings
FROM
    ratings; -- 7997 rows

-- rows in role_mapping table 

SELECT 
    COUNT(*) AS rows_role_mapping
FROM
    role_mapping; -- 15615 rows




-- Q2. Which columns in the movie table have null values?
-- Type your code below:



SELECT 
    SUM(CASE
        WHEN id IS NULL THEN 1
        ELSE 0
    END) AS id_nulls,
    SUM(CASE
        WHEN title IS NULL THEN 1
        ELSE 0
    END) AS title_nulls,
    SUM(CASE
        WHEN year IS NULL THEN 1
        ELSE 0
    END) AS year_nulls,
    SUM(CASE
        WHEN date_published IS NULL THEN 1
        ELSE 0
    END) AS date_published_nulls,
    SUM(CASE
        WHEN duration IS NULL THEN 1
        ELSE 0
    END) AS duration_nulls,
    SUM(CASE
        WHEN country IS NULL THEN 1
        ELSE 0
    END) AS country_nulls,
    SUM(CASE
        WHEN worlwide_gross_income IS NULL THEN 1
        ELSE 0
    END) AS worlwide_gross_income_nulls,
    SUM(CASE
        WHEN languages IS NULL THEN 1
        ELSE 0
    END) AS languages_nulls,
    SUM(CASE
        WHEN production_company IS NULL THEN 1
        ELSE 0
    END) AS production_company_nulls
FROM
    movie; 



-- Therefore, country, worlwide_gross_income, languages and production_company have null values 



-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


-- total number of movies released each year

SELECT 
    `year`, COUNT(id) AS number_of_movies
FROM
    movie
GROUP BY `year`
ORDER BY `year`;

-- total number of movies released each month 

SELECT 
    MONTH(date_published) AS month_num,
    COUNT(id) AS number_of_movies
FROM
    movie
GROUP BY month_num
ORDER BY number_of_movies desc; 



/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:




SELECT 
    `year`, 
    COUNT(id) AS total_movies
FROM
    movie
WHERE
    year = 2019 AND country IN ('USA', 'India') ; 
    

        

-- Therefore, 887 movies were produced in the USA or India in the year 2019


/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT DISTINCT
    genre
FROM
    genre; 



/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT genre,
       Count(movie_id) AS Total_Movies
FROM   genre g
       INNER JOIN movie m
               ON m.id = g.movie_id
WHERE  `year` = 2019
GROUP  BY genre
ORDER  BY total_movies DESC
LIMIT  1; 

-- Therefore, Highest number of movies were released in Drama genre (1078)



/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:


SELECT 
    COUNT(*) AS total_movies
FROM
    (SELECT 
        COUNT(*) AS movie_cnt
    FROM
        genre
    GROUP BY movie_id) AS t
WHERE
    movie_cnt = 1;  


-- Therefore, 3289 movies belongs to only one genre



/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


SELECT 
    g.genre, ROUND(AVG(duration), 2) AS avg_duration
FROM
    movie m
        INNER JOIN
    genre g ON m.id = g.movie_id
GROUP BY genre
ORDER BY avg_duration DESC ; 



/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT genre,
       Count(movie_id) AS movie_count,
       Rank() OVER ( ORDER BY Count(movie_id) DESC ) AS genre_rank
FROM   genre
GROUP  BY genre; 

-- Therefore, Thriller genre has 1484 movie counts and stand in 3rd position in rank wise. 


/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT 
    MIN(avg_rating) AS min_avg_rating,
    MAX(avg_rating) AS max_avg_rating,
    MIN(total_votes) AS min_total_votes,
    MAX(total_votes) AS max_total_votes,
    MIN(median_rating) AS min_median_rating,
    MAX(median_rating) AS max_median_rating
FROM
    ratings; 
    






    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

WITH movie_info
     AS (SELECT m.title,
                r.avg_rating,
                Dense_rank() OVER ( ORDER BY r.avg_rating DESC ) AS movie_rank
         FROM   movie m
                INNER JOIN ratings r
                        ON m.id = r.movie_id)
SELECT *
FROM   movie_info
WHERE  movie_rank <= 10; 



/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have


SELECT 
    median_rating, COUNT(movie_id) AS movie_count
FROM
    ratings
GROUP BY median_rating
ORDER BY movie_count DESC; 




/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:


SELECT m.production_company,
       Count(m.id) AS movie_count,
       Rank() OVER ( ORDER BY Count(m.id) DESC ) AS prod_company_rank
FROM   movie m
       INNER JOIN ratings r
               ON m.id = r.movie_id
WHERE  r.avg_rating > 8 AND m.production_company IS NOT NULL
GROUP  BY m.production_company; 



-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
    g.genre, COUNT(m.id) AS movie_count
FROM
    movie m
        INNER JOIN
    genre g ON m.id = g.movie_id
        INNER JOIN
    ratings r USING (movie_id)
WHERE
    MONTH(m.date_published) = 3
        AND m.`year` = 2017
        AND m.country = 'USA'
        AND r.total_votes > 1000
GROUP BY genre
ORDER BY movie_count DESC;  





-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:


SELECT 
    m.title, r.avg_rating, 
    group_concat(g.genre) as genre 
FROM
    movie m
        INNER JOIN
    genre g ON m.id = g.movie_id
        INNER JOIN
    ratings r USING (movie_id)
WHERE
    m.title REGEXP '^The'
        AND r.avg_rating > 8
GROUP BY title
ORDER BY r.avg_rating DESC; 



-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:


SELECT 
    COUNT(m.id) AS movie_count
FROM
    movie m
        INNER JOIN
    ratings r ON m.id = r.movie_id
WHERE
    r.median_rating = 8
        AND m.date_published BETWEEN '2018-04-01' AND '2019-04-01'; 




-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:


SELECT 
    m.languages, 
	r.total_votes
FROM
    movie m
        INNER JOIN
    ratings r ON m.id = r.movie_id
WHERE
    m.languages IN ('German' , 'Italian')
GROUP BY m.languages; 






-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT 
    SUM(CASE
        WHEN `name` IS NULL THEN 1
        ELSE 0
    END) AS name_nulls,
    SUM(CASE
        WHEN height IS NULL THEN 1
        ELSE 0
    END) AS height_nulls,
    SUM(CASE
        WHEN date_of_birth IS NULL THEN 1
        ELSE 0
    END) AS date_of_birth_nulls,
    SUM(CASE
        WHEN known_for_movies IS NULL THEN 1
        ELSE 0
    END) AS known_for_movies_nulls
FROM
    `names`; 
    
-- null values :   name - 0,  height - 17335, date_of_birth - 13431, known_for_movies - 15226




/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


WITH ranked_genre
     AS (WITH top3_genre
              AS (SELECT genre,
                         Count(title)                    AS movie_count,
                         Rank()
                           OVER(
                             ORDER BY Count(title) DESC) AS genre_rank
                  FROM   movie m
                         INNER JOIN ratings r
                                 ON r.movie_id = m.id
                         INNER JOIN genre g
                                 ON g.movie_id = m.id
                  WHERE  avg_rating > 8
                  GROUP  BY genre)
         SELECT genre
          FROM   top3_genre
          WHERE  genre_rank < 4),
     top_directors
     AS (SELECT `name`                                 AS director_name,
                Count(g.movie_id)                    AS movie_count,
                Rank()
                  OVER(
                    ORDER BY Count(g.movie_id) DESC) AS director_rank
         FROM   names n
                INNER JOIN director_mapping dm
                        ON n.id = dm.name_id
                INNER JOIN genre g
                        ON dm.movie_id = g.movie_id
                INNER JOIN ratings r
                        ON r.movie_id = g.movie_id,
                ranked_genre
         WHERE  g.genre IN ( ranked_genre.genre )
                AND avg_rating > 8
         GROUP  BY director_name
         ORDER  BY movie_count DESC)
SELECT director_name,
       movie_count
FROM   top_directors
WHERE  director_rank <= 3; 





/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


SELECT 
    n.`name` AS actor_name, COUNT(m.id) AS movie_count
FROM
    movie m
        INNER JOIN
    ratings r ON m.id = r.movie_id
        INNER JOIN
    role_mapping ro USING (movie_id)
        INNER JOIN
    `names` n ON ro.name_id = n.id
WHERE
    median_rating >= 8 and 
    ro.category = 'actor' 
GROUP BY actor_name
ORDER BY movie_count DESC
LIMIT 2; 

-- Therefore, Mammooty and Mohanlal are top 2 actors with 8 and 5 movie respectively
    




/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:


SELECT     m.production_company,
           Sum(r.total_votes)                               AS vote_count,
           Rank() OVER ( ORDER BY Sum(r.total_votes) DESC ) AS prod_comp_rank
FROM       movie m
INNER JOIN ratings r
ON         m.id = r.movie_id
GROUP BY   production_company limit 3 ;


-- Thereby, Marvel Studios, Syncopy, New Line Cinema are the top 3 production companies



/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. 
-- If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:



SELECT NAME                                                            AS
       actor_name,
       Sum(total_votes)                                                AS
       total_votes,
       Count(r.movie_id)                                               AS
       movie_count,
       Round(Sum(avg_rating * total_votes) / Sum(total_votes), 2)      AS
       actor_avg_rating,
       Rank()
         OVER(
           ORDER BY Sum(avg_rating*total_votes)/Sum(total_votes) DESC) AS
       actor_rank
FROM   names n
       INNER JOIN role_mapping rm
               ON n.id = rm.name_id
       INNER JOIN movie m
               ON rm.movie_id = m.id
       INNER JOIN ratings r
               ON m.id = r.movie_id
WHERE  country = 'India' AND category = 'actor' 
GROUP  BY actor_name
HAVING Count(r.movie_id) >= 5;     





-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:


SELECT     NAME                                                                    AS actress_name,
           Sum(total_votes)                                                        AS total_votes,
           Count(m.id)                                                             AS movie_count,
           Round(Sum(avg_rating               *total_votes)/Sum(total_votes),2)    AS actress_avg_rating,
           Rank() OVER(ORDER BY Sum(avg_rating*total_votes)/Sum(total_votes) DESC) AS actress_rank
FROM       names n
INNER JOIN role_mapping rm
ON         n.id = rm.name_id
INNER JOIN movie m
ON         rm.movie_id = m.id
INNER JOIN ratings r
ON         m.id = r.movie_id
WHERE      category='actress'
AND        country= 'India'
AND        languages= 'Hindi'
GROUP BY   actress_name
HAVING     Count(m.id)>=3 limit 5;






/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:


SELECT m.title,
       r.avg_rating,
       CASE
         WHEN r.avg_rating > 8 THEN 'Superhit movies'
         WHEN r.avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
         WHEN r.avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
         ELSE 'Flop movies'
       END AS Rating_Category
FROM   movie m
       INNER JOIN genre g
               ON m.id = g.movie_id
       INNER JOIN ratings r using (movie_id)
WHERE  genre = 'Thriller'
GROUP  BY m.title
ORDER BY avg_rating DESC ; 











/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT     genre,
           Round(Avg(duration), 2)              AS avg_duration,
           sum(Round(Avg(duration), 2)) OVER w1 AS running_total_duration,
           avg(round(avg(duration), 2)) OVER w2  AS moving_avg_duration
FROM       movie m
INNER JOIN genre g
ON         m.id = g.movie_id
GROUP BY   genre window w1 AS ( ORDER BY genre rows UNBOUNDED PRECEDING ),
           w2              AS ( ORDER BY genre rows 6 PRECEDING ) ;

/* 
genre  avg_duration   running_total     moving_avg
Action		112.88		112.88			112.880000
Adventure	101.87		214.75			107.375000
Comedy		102.62		317.37			105.790000
Crime		107.05		424.42			106.105000
Drama		106.77		531.19			106.238000
Family		100.97		632.16			105.360000
Fantasy		105.14		737.30			105.328571
Horror		92.72		830.02			102.448571
Mystery		101.80		931.82			102.438571
Others		100.16		1031.98			102.087143
Romance		109.53		1141.51			102.441429
Sci-Fi		97.94		1239.45			101.180000
Thriller	101.58		1341.03			101.267143
*/





-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:


WITH top_3_genre AS
(
         SELECT   genre
         FROM     genre
         GROUP BY genre
         ORDER BY Count(movie_id) DESC limit 3 ), movie_info AS
(
           SELECT     genre,
                      `year`,
                      title AS movie_name,
                      CASE
                                 WHEN worlwide_gross_income LIKE '$%' THEN CONVERT(substring(worlwide_gross_income, 3), signed   int)
                                 WHEN worlwide_gross_income LIKE 'INR%' THEN CONVERT(substring(worlwide_gross_income, 5), signed int)
                      END AS worlwide_gross_income
           FROM       movie m
           INNER JOIN genre g
           ON         m.id = g.movie_id
           WHERE      genre IN
                      (
                             SELECT genre
                             FROM   top_3_genre) ), movie_rank_info AS
(
         SELECT   *,
                  group_concat(genre)                                                           AS grouped_genre,
                  dense_rank() OVER ( partition BY `year` ORDER BY worlwide_gross_income DESC ) AS movie_rank
         FROM     movie_info
         GROUP BY movie_name )
SELECT grouped_genre AS genre,
       `year`,
       movie_name,
       worlwide_gross_income,
       movie_rank
FROM   movie_rank_info
WHERE  movie_rank <= 5 ;
	


-- Finally, let’s find out the names of the top two production houses that have produced 
-- the highest number of hits among multilingual movies.

-- Q27.  Which are the top two production houses that have produced the highest number of hits
--  (median rating >= 8) among multilingual movies?

/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:


-- with multi_lingual_movies as 

SELECT     production_company,
           Count(id)                               AS movie_count,
           Rank() OVER ( ORDER BY Count(id) DESC ) AS prod_company_rank
FROM       movie m
INNER JOIN ratings r
ON         m.id = r.movie_id
WHERE      POSITION(',' IN languages) > 0 
AND        median_rating >= 8
AND        production_company IS NOT NULL
GROUP BY   production_company limit 2 ; 


-- Star Cinema, Twentieth Century Fox are the top 2 production companies
 


-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:


SELECT     `NAME`                                    as actress_name,
           Sum(total_votes)                          AS total_votes,
           Count(m.id)                               AS movie_count,
           Round(avg(avg_rating), 2)                      AS actress_avg_rating,
           Row_Number() OVER ( ORDER BY count(m.id) DESC ) AS actress_rank
FROM       movie m
INNER JOIN genre g
ON         m.id = g.movie_id
INNER JOIN ratings r
using      (movie_id)
INNER JOIN role_mapping rm
using      (movie_id)
INNER JOIN `names` n
ON         rm.name_id = n.id
WHERE      genre = 'Drama'
AND        category = 'actress'
AND        avg_rating > 8
GROUP BY   actress_name limit 3 ;



-- thereby, top 3 actress are Parvathy Thiruvothu, Susan Brown and Amanda Lawrence




/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:



WITH director_info AS
(
           SELECT     n.id   AS director_id,
                      `NAME` as director_name,
                      m.id,
                      avg_rating,
                      total_votes,
                      duration,
                      date_published,
                      Lead(date_published, 1) OVER ( partition BY `NAME` ORDER BY date_published, `NAME` ) AS next_date
           FROM       movie m
           INNER JOIN ratings r
           ON         m.id = r.movie_id
           INNER JOIN director_mapping dm
           using      (movie_id)
           INNER JOIN `names` n
           ON         dm.name_id = n.id )
SELECT   director_id,
         director_name,
         count(id)                                                         AS number_of_movies,
         round(sum(datediff(next_date, date_published)) / (count(id) - 1)) AS avg_inter_movie_days,
         round(sum(avg_rating * total_votes) / sum(total_votes), 2)        AS avg_rating,
         sum(total_votes)                                                  AS total_votes,
         min(avg_rating)                                                   AS min_rating,
         max(avg_rating)                                                   AS max_rating,
         sum(duration)                                                     AS total_duration
FROM     director_info
GROUP BY director_name
ORDER BY number_of_movies DESC limit 9 ;

/*
Therefore, top 9 directors are 

A.L. Vijay
Andrew Jones
Jesse V. Johnson
Justin Price
Steven Soderbergh
Özgür Bakar
Sam Liu
Sion Sono
Chris Stokes

*/ 