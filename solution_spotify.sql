-- EDA
	SELECT count(*) from spotify;
	
	select count(distinct artist) from spotify;
	
	select distinct album_type from spotify;
	
	select MAX(duration_min) from spotify;
	
	select MIN(duration_min) from spotify;

	SELECT DISTINCT licensed FROM spotify;
	
	DELETE FROM spotify
	where duration_min = 0;

	SELECT DISTINCT channel from spotify;

	SELECT DISTINCT most_played_on from spotify;

-- ------------------------------------------------------------------------------
-- DATA ANALYSIS 

-- Easy Level
	select * from spotify;
-- Retrieve the names of all tracks that have more than 1 billion streams.

	select track from spotify where stream > 1000000000;

--List all albums along with their respective artists.
	
	SELECT DISTINCT album , artist FROM SPOTIFY ORDER BY 1;

--Get the total number of comments for tracks where licensed = TRUE.

	SELECT SUM(comments) FROM spotify 
	WHERE licensed = TRUE;
	
-- Find all tracks that belong to the album type single.

	SELECT * FROM spotify
	WHERE album_type ='single';

--Count the total number of tracks by each artist.

	SELECT artist , COUNT(track) FROM spotify
	GROUP BY 1
	ORDER BY 2 DESC;

-- ----------------------------------------------------------------------------------------------------
-- Calculate the average danceability of tracks in each album.

	SELECT album , AVG(danceability) AS avg_danceability FROM spotify
	GROUP BY 1 
	ORDER BY 2 DESC;

-- Find the top 5 tracks with the highest energy values.

	SELECT track , MAX(energy) 
	FROM spotify
	GROUP BY 1
	ORDER BY 2 DESC
	LIMIT 5;

--List all tracks along with their views and likes where official_video = TRUE.

	SELECT DISTINCT track , SUM(views) AS total_views , SUM(likes ) AS total_likes
	FROM spotify
	WHERE official_video = 'true'
	GROUP BY 1
	ORDER BY 2 DESC;
	
-- For each album, calculate the total views of all associated tracks.

	SELECT album , track , SUM (views ) AS total_views
	FROM spotify 
	group by 1,2 
	ORDER BY 1 ;

--Retrieve the track names that have been streamed on Spotify more than YouTube.

SELECT * 
FROM
(select track ,
	       --most_played_on
		   coalesce(SUM(CASE WHEN most_played_on = 'Youtube' THEN stream END),0) AS streamed_on_youtube,
	       coalesce(SUM(CASE WHEN most_played_on = 'Spotify' THEN stream END),0) AS streamed_on_spotify
	
	from spotify
	group by 1
) AS T
WHERE streamed_on_spotify > streamed_on_youtube
AND  streamed_on_youtube <>0

-- ------------------------------------------------------------------------------------------------------------
-- hARD LEVEL

--Find the top 3 most-viewed tracks for each artist using window functions.

SELECT artist , track 
FROM
(SELECT artist , track , 
	SUM (views) AS total_views,
	DENSE_RANK() OVER (PARTITION BY artist ORDER BY SUM(views) DESC) as rank
	FROM spotify 
	group by 1,2 
) AS T
WHERE rank IN (1,2,3)

--Write a query to find tracks where the liveness score is above the average.

	SELECT track,artist,liveness
	from spotify
	where liveness > (select avg(liveness) from spotify)

--Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.
 
	WITH CTE AS
	(
		SELECT album ,
		MAX(energy) as high,
		MIN(energy) as low
		FROM SPOTIFY
		GROUP BY 1
	)
	select album , high-low as enrgy_diff
	from CTE
	ORDER BY enrgy_diff DESC;

--Find tracks where the energy-to-liveness ratio is greater than 1.2.

	SELECT track , floor(energy/liveness) as energylin_ration
	from spotify where energy/liveness >1.2;

--Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.

	select track,
	       SUM(likes) OVER (ORDER BY views desc) AS cumulative_sum
	from spotify
	order by 2;














































