-- I. Basic Data Exploration & Overview

-- 1. Total Number of Games:

SELECT
    COUNT(sr_no) AS total_games
FROM steam_games;

-- 2. Number of Unique Publishers and Developers:

SELECT
    COUNT(DISTINCT publisher) AS unique_publishers,
    COUNT(DISTINCT developer) AS unique_developers
FROM steam_games;

--3. Games Released by Year:

SELECT
    EXTRACT(YEAR FROM release) AS release_year,
    COUNT(sr_no) AS games_released_count
FROM steam_games
GROUP BY release_year
ORDER BY release_year;

-- 4. Average Game Rating:

SELECT
    AVG(rating) AS average_game_rating
FROM steam_games;

--5. First and Last Game Release Date:

SELECT
    MIN(release) AS first_release_date,
    MAX(release) AS latest_release_date
FROM steam_games;

-- II. Game Popularity & Performance Analysis

--6. Top 10 Games by All-Time Peak Players:

SELECT
    game,
    all_time_peak
FROM steam_games
ORDER BY all_time_peak DESC
LIMIT 10;

--7. Top 10 Games by Average Rating:

SELECT
    game,
    rating
FROM steam_games
ORDER BY rating DESC
LIMIT 10;

--8. Games with High Peak Players and High Rating (Popular & Well-Received):

SELECT
    game,
    all_time_peak,
    rating
FROM steam_games
WHERE all_time_peak > 100000
  AND rating >= 90
ORDER BY all_time_peak DESC;

--9. Games with Low Peak Players but High Rating (Potential Hidden Gems):

SELECT
    game,
    all_time_peak,
    rating
FROM steam_games
WHERE all_time_peak < 10000
  AND rating >= 85
ORDER BY rating DESC;

--III. Genre Analysis

--10. Number of Games by Primary Genre:

SELECT
    primary_genre_clean,
    COUNT(sr_no) AS game_count
FROM steam_games
GROUP BY primary_genre_clean
ORDER BY game_count DESC;

--11. Average Rating by Primary Genre:

SELECT
    primary_genre,
    ROUND (AVG(rating),2) AS average_rating
FROM steam_games
GROUP BY primary_genre
ORDER BY average_rating DESC;

--12. Top 5 Primary Genres by All-Time Peak Players:

SELECT
    primary_genre,
    SUM(all_time_peak) AS total_all_time_peak
FROM steam_games
GROUP BY primary_genre
ORDER BY total_all_time_peak DESC
LIMIT 5;

--13. Breakdown of Games by All Store Genres (Advanced - Requires UNNEST/STRING_TO_ARRAY):

SELECT
    TRIM(SPLIT_PART(UNNEST(STRING_TO_ARRAY(REPLACE(REPLACE(store_genres, ' (', '('), ')', ''), ',')), '(', 1)) AS genre_name,
    COUNT(sg.sr_no) AS game_count
FROM steam_games sg
CROSS JOIN LATERAL UNNEST(STRING_TO_ARRAY(REPLACE(REPLACE(sg.store_genres, ' (', '('), ')', ''), ',')) AS genre_with_id
GROUP BY genre_name
ORDER BY game_count DESC;

--IV. Review & Sentiment Analysis

--14. Games with Most Positive Reviews:

SELECT
    game,
    positive_reviews
FROM steam_games
ORDER BY positive_reviews DESC
LIMIT 10;

--15. Games with Most Negative Reviews:

SELECT
    game,
    negative_reviews
FROM steam_games
ORDER BY negative_reviews DESC
LIMIT 10;

--16. Average Review Percentage by Primary Genre:

SELECT
    primary_genre,
    AVG(review_percentage) AS avg_review_percentage
FROM steam_games
GROUP BY primary_genre
ORDER BY avg_review_percentage DESC;

--17. Games with High Total Reviews but Low Review Percentage (Controversial/Mixed Reception):

SELECT
    game,
    total_reviews,
    review_percentage
FROM steam_games
WHERE total_reviews > 10000
  AND review_percentage < 70
ORDER BY total_reviews DESC;

--V. Publisher & Developer Analysis

--18. Top 10 Publishers by Total Games Released:

SELECT
    publisher,
    COUNT(sr_no) AS games_released_count
FROM steam_games
GROUP BY publisher
ORDER BY games_released_count DESC
LIMIT 10;

--19. Top 10 Developers by Average Game Rating:

SELECT
    developer,
    AVG(rating) AS average_rating
FROM steam_games
GROUP BY developer
ORDER BY average_rating DESC
LIMIT 10;

--20. Publishers with Highest Total All-Time Peak Players:

SELECT
    publisher,
    SUM(all_time_peak) AS total_all_time_peak
FROM steam_games
GROUP BY publisher
ORDER BY total_all_time_peak DESC
LIMIT 10;

--VI. Game Longevity & Engagement Analysis (Replacing Pricing Analysis)

--21. Games with Sustained Popularity (Older Games with High Current Players):

SELECT
    game,
    release,
    players_right_now,
    all_time_peak
FROM steam_games
WHERE EXTRACT(YEAR FROM release) < 2020 -- Released before 2020
  AND players_right_now > 1000          -- Still has significant concurrent players
ORDER BY players_right_now DESC
LIMIT 10;

--NOTE :- ADDITIONAL QUERY FOR PROFILE ANALYSIS

--22. Developer/Publisher Average Peak Performance (for prolific creators ):

SELECT
    developer,
    COUNT(sr_no) AS total_games_developed,
    AVG(all_time_peak) AS avg_peak_players_per_game
FROM steam_games
GROUP BY developer
HAVING COUNT(sr_no) > 5 -- Only consider developers with more than 5 games
ORDER BY avg_peak_players_per_game DESC
LIMIT 10;

--23. Games with High Review Volume and High Rating (Critically Acclaimed & Popular):

SELECT
    game,
    total_reviews,
    rating,
    review_percentage
FROM steam_games
WHERE total_reviews > 50000 -- Example threshold for high review volume
  AND rating >= 90          -- Example threshold for high rating
ORDER BY total_reviews DESC
LIMIT 10;

--VII. Lifecycle & Technology Analysis

--24. Average Time to All-Time Peak (Days) by Primary Genre:

SELECT
    primary_genre,
    AVG(EXTRACT(EPOCH FROM (all_time_peak_date - release)) / (60*60*24)) AS avg_days_to_peak
FROM steam_games
WHERE all_time_peak_date IS NOT NULL AND release IS NOT NULL
GROUP BY primary_genre_clean
ORDER BY avg_days_to_peak;

--25. Games by Detected Technologies (Advanced - Requires UNNEST/STRING_TO_ARRAY):

SELECT
    TRIM(UNNEST(STRING_TO_ARRAY(sg.detected_technologies, ';'))) AS technology_name,
    COUNT(sg.sr_no) AS game_count
FROM steam_games sg
CROSS JOIN LATERAL UNNEST(STRING_TO_ARRAY(sg.detected_technologies, ';')) AS tech_name
WHERE sg.detected_technologies IS NOT NULL AND sg.detected_technologies != ''
GROUP BY technology_name
ORDER BY game_count DESC;
