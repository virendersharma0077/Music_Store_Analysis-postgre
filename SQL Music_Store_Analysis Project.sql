1.	Who is the senior most employee in the job title?

SELECT * FROM employee
order by levels DESC
limit 1

2.	Which countries have the most invoices?

SELECT COUNT (*) AS C,BILLING_COUNTRY
FROM INVOICE
GROUP BY billing_country
ORDER BY C DESC

3.	What are the top 3 values of total invoices?

SELECT * FROM invoice
ORDER BY total DESC
LIMIT 3

4.	Which city has the best customers? We would like to throw 
promotional music festival in the city we made the most money.
Write a query that return one city that has the highest sum of 
invoice total. Return both of city name and sum of all invoices.

SELECT SUM(total) AS invoice_total, billing_city
FROM invoice
GROUP BY billing_city
ORDER BY invoice_total DESC
LIMIT 1

5.	Who is the best customer? The customer who spent the most
money will be declared the best customer. Write a query that
return the person who spent the most money.

SELECT customer.customer_id,customer.first_name,customer.last_name,
SUM(invoice.total) AS total
FROM customer
JOIN invoice ON CUSTOMER.CUSTOMER_ID = INVOICE.CUSTOMER_ID
GROUP BY customer.customer_id
ORDER BY total DESC
LIMIT 1

6.write query to return the email,first name,last name & Genre of 
all rock music listener.return your list order alphabeticially 
by email starting A.

SELECT DISTINCT email, first_name, last_name
FROM customer
JOIN invoice ON customer.customer_id= invoice.customer_id
JOIN invoice_line ON invoice.invoice_id= invoice_line.invoice_id
WHERE track_id IN (
    SELECT track_id FROM track
JOIN genre ON track.genre_id= genre.genre_id
where genre.name LIKE 'ROCK'
)
ORDER BY email;

7.Let’s invite the artists who have written the most rock music in our dataset.
Write a query that returns the Artist name and total track count of the top 10 rock bands.

SELECT artist.artist_id, artist.name,COUNT(artist.artist_id) AS number_of_songs
FROM track
JOIN album ON album.album_id = track.album_id
JOIN artist ON artist.artist_id = album.artist_id
JOIN genre ON genre.genre_id = track.genre_id
WHERE genre.name LIKE 'Rock'
GROUP BY artist.artist_id
ORDER BY number_of_songs DESC
LIMIT 10;

8.Return all the track names that have a song length longer than the average song
length.Return the Name and Milliseconds for each track. Order by the song length 
with the longestsongs listed first.
 
SELECT name, milliseconds 
FROM track	
WHERE milliseconds >
(SELECT AVG(milliseconds) AS average_song_lenght from track)
ORDER BY milliseconds DESC;

9.Find how much amount spent by each customer on artists? Write a query to return 
customer name, artist name and total spent.

WITH best_selling_artist AS (
SELECT artist.artist_id AS artist_id, artist.name AS artist_name, 
SUM(invoice_line.unit_price*invoice_line.quantity) AS total_sales
FROM invoice_line
JOIN track ON track.track_id = invoice_line.track_id
JOIN album ON album.album_id = track.album_id
JOIN artist ON artist.artist_id = album.artist_id
GROUP BY 1
ORDER BY 3 DESC
LIMIT 1
)
SELECT c.customer_id, c.first_name, c.last_name, bsa.artist_name,
SUM(il.unit_price*il.quantity) AS amount_spent
FROM invoice i
JOIN customer c ON c.customer_id = i.customer_id
JOIN invoice_line il ON il.invoice_id = i.invoice_id
JOIN track t ON t.track_id = il.track_id
JOIN album alb ON alb.album_id = t.album_id
JOIN best_selling_artist bsa ON bsa.artist_id = alb.artist_id
GROUP BY 1,2,3,4
ORDER BY 5 DESC;


10.Write a query that determines the customer that has spent the most on music for each country.
Write a query that returns the country along with the top customer and how much they spent.
For countries where the top amount spent is shared, provide all customers who spent this amount.

WITH Customter_with_country AS (
SELECT customer.customer_id,first_name,last_name,billing_country,SUM(total) AS total_spending,
ROW_NUMBER() OVER(PARTITION BY billing_country ORDER BY SUM(total) DESC) AS RowNo
FROM invoice
JOIN customer ON customer.customer_id = invoice.customer_id
GROUP BY 1,2,3,4
ORDER BY 4 ASC,5 DESC)
SELECT * FROM Customter_with_country WHERE RowNo <= 1



