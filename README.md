# Steam Gaming Platform: Game Performance & User Engagement Analysis

## Project Overview

This project focuses on analyzing data from the Steam digital game distribution platform to understand game performance, identify factors driving popularity and sales, and gain insights into player engagement. This solution aims to provide valuable data-driven insights for game developers, publishers, and the platform itself to optimize strategies and enhance growth.

**Key Technologies Used:** PostgreSQL, pgAdmin, Power BI, Power Query, DAX, SQL.

## Business Problem & Goal

In the highly competitive gaming industry, understanding what makes a game successful and how users engage with content is paramount. Game developers and platform owners need to move beyond simple sales figures to deeper insights into player behavior, content reception, and market trends.

**The primary goal of this project is to:**
* Transform raw, complex Steam game data into clear, actionable intelligence.
* Enable proactive identification of popular trends, market opportunities, and areas for improvement.
* Provide a centralized, interactive platform for stakeholders to monitor game performance and inform strategic decisions.

## Dataset

The analysis utilizes a comprehensive **Steam Games Dataset** acquired from Kaggle. This dataset contains detailed information about games available on the Steam platform.
* **Source:** [Link to Kaggle dataset, e.g., `https://www.kaggle.com/datasets/whigmalwhim/steam-releases/data?select=game_data_all.csv`]
* **Key Columns:** `game`, `release`, `peak_players`, `positive_reviews`, `negative_reviews`, `total_reviews`, `rating`, `primary_genre`, `store_genres`, `publisher`, `developer`, `review_percentage`, `all_time_peak`, `all_time_peak_date`, and others.

## Analytical Process & Methodology

1.  **Data Acquisition & Database Setup:**
    * Acquired the raw Steam games data in CSV format.
    * Set up a dedicated **PostgreSQL database (`steam_analytics_db`)** to store and manage the data.
    * Defined a robust table schema (`steam_games`) with appropriate data types (e.g., `DATE`, `BIGINT`, `NUMERIC(5,2)`).

2.  **Data Cleaning & Transformation (PostgreSQL & Power Query):**
    * Performed initial data profiling to identify inconsistencies and missing values.
    * Utilized **Power Query (within Power BI)** for meticulous data cleaning and transformation:
        * **Handled blank/null values:** Replaced `NULL` in numerical columns (e.g., `peak_players`, `review_percentage`) with `0` or `0.0` where appropriate. `rating` blanks were kept as `NULL` for accurate average calculations. `all_time_peak_date` blanks were kept as `NULL`.
        * **Standardized Text:** Cleaned `primary_genre` by extracting the genre name (e.g., "Action" from "Action (1)").
        * **Parsed Multi-Value Columns:** Transformed `store_genres` and `detected_technologies` (if analyzed) from delimited strings into separate rows for granular analysis, enabling proper categorization and counting.
        * Ensured correct data types for all columns post-transformation.

3.  **Data Modeling & DAX Measures (Power BI):**
    * Loaded the cleaned data into Power BI Desktop, ensuring a robust data model.
    * Created key **DAX measures** for advanced calculations and KPIs, including:
        * `Total Games`, `Average Game Rating`, `Average Review Percentage`, `Average All-Time Peak Players`, `Estimated Total Revenue`. *(Note: Estimated Total Revenue might be less relevant if 'Price' column isn't used for analysis.)*
        * `Time to All-Time Peak (Days)`: Calculated days from release to peak popularity.

4.  **Interactive Dashboard Development (Power BI):**
    * Designed and built a multi-faceted interactive dashboard in Power BI, incorporating various visual types to present insights effectively.
    * **[https://vitacin-my.sharepoint.com/:u:/g/personal/prabhat_dutta2021_vitstudent_ac_in/EXM_RXfr8-lDpBor5psIgRoBCSCDPTe1HlizEou2S8f0dw?e=vWnWw9]**
    * 
      <img width="1387" height="781" alt="Report" src="https://github.com/user-attachments/assets/1133ab52-8928-4c30-920e-e90c61976f89" />


## Key Dashboard Highlights & Analytical Insights

The dashboard provides a dynamic view of game performance and market trends on Steam, enabling data-driven decision-making for developers and publishers:

* **Platform Overview:** High-level KPIs showcase total games, estimated revenue, average ratings, and overall player engagement.
* **Top Performers:** Bar charts highlight the top games and genres by `all_time_peak` players, identifying leading titles and popular categories.
* **Genre Landscape:** Visuals break down the distribution of games by `primary_genre` and `store_genres`, revealing market saturation and niche opportunities.
* **Review Sentiment:** Charts analyze `review_percentage` and `rating` distribution by genre, identifying well-received categories and potential areas for game improvement.
* **Release Trends:** A line chart illustrates the number of games released over time, showing growth or shifts in publishing frequency.
* **Game Lifecycle:** Scatter plots explore the relationship between `all_time_peak` players and `Time to All-Time Peak (Days)`, offering insights into how quickly games achieve popularity.
* **Publisher/Developer Performance:** Visuals can highlight top creators based on game count, average rating, or total player peaks.
* **Interactive Exploration:** Slicers for `Primary_Genre`, `Release Year`, `Rating Range`, `Publisher`, and `Developer` enable users to filter and drill down into specific segments of the data.

## SQL Analysis

The following SQL queries were instrumental in exploring, transforming, and extracting key insights from the `steam_games` dataset in PostgreSQL. These queries underpin the data presented in the Power BI dashboard and demonstrate a strong command of SQL for analytical purposes.

## SQL Analysis

The following SQL queries were instrumental in exploring, transforming, and extracting key insights from the `steam_games` dataset in PostgreSQL. These queries underpin the data presented in the Power BI dashboard and demonstrate a strong command of SQL for analytical purposes.

# Steam Games Data Analysis (SQL)

### I. Basic Data Exploration & Overview

## 1. Total Number of Games:
```sql
SELECT
    COUNT(sr_no) AS total_games
FROM steam_games;
```
### 2. Number of Unique Publishers and Developers:
```sql
SELECT
    COUNT(DISTINCT publisher) AS unique_publishers,
    COUNT(DISTINCT developer) AS unique_developers
FROM steam_games;
```
### 3. Games Released by Year:
```sql
SELECT
    EXTRACT(YEAR FROM release) AS release_year,
    COUNT(sr_no) AS games_released_count
FROM steam_games
GROUP BY release_year
ORDER BY release_year;
```
### 4. Average Game Rating:
```sql
SELECT
    AVG(rating) AS average_game_rating
FROM steam_games;
```
### 5. First and Last Game Release Date:
```sql
SELECT
    MIN(release) AS first_release_date,
    MAX(release) AS latest_release_date
FROM steam_games;
```
## II. Game Popularity & Performance Analysis

### 6. Top 10 Games by All-Time Peak Players:
```sql
SELECT
    game,
    all_time_peak
FROM steam_games
ORDER BY all_time_peak DESC
LIMIT 10;
```
### 7. Top 10 Games by Average Rating:
```sql
SELECT
    game,
    rating
FROM steam_games
ORDER BY rating DESC
LIMIT 10;
```
### 8. Games with High Peak Players and High Rating (Popular & Well-Received):
```sql
SELECT
    game,
    all_time_peak,
    rating
FROM steam_games
WHERE all_time_peak > 100000
  AND rating >= 90
ORDER BY all_time_peak DESC;
```
### 9. Games with Low Peak Players but High Rating (Potential Hidden Gems):
```sql
SELECT
    game,
    all_time_peak,
    rating
FROM steam_games
WHERE all_time_peak < 10000
  AND rating >= 85
ORDER BY rating DESC;
```
## III. Genre Analysis

### 10. Number of Games by Primary Genre:
```sql
SELECT
    primary_genre,
    COUNT(sr_no) AS game_count
FROM steam_games
GROUP BY primary_genre
ORDER BY game_count DESC;
```
### 11. Average Rating by Primary Genre:
```sql
SELECT
    primary_genre,
    ROUND(AVG(rating),2) AS average_rating
FROM steam_games
GROUP BY primary_genre
ORDER BY average_rating DESC;
```
### 12. Top 5 Primary Genres by All-Time Peak Players:
```sql
SELECT
    primary_genre,
    SUM(all_time_peak) AS total_all_time_peak
FROM steam_games
GROUP BY primary_genre
ORDER BY total_all_time_peak DESC
LIMIT 5;
```
### 13. Breakdown of Games by All Store Genres (Advanced - Requires UNNEST/STRING_TO_ARRAY):
```sql
SELECT
    TRIM(SPLIT_PART(UNNEST(STRING_TO_ARRAY(REPLACE(REPLACE(store_genres, ' (', '('), ')', ''), ',')), '(', 1)) AS genre_name,
    COUNT(sg.sr_no) AS game_count
FROM steam_games sg
CROSS JOIN LATERAL UNNEST(STRING_TO_ARRAY(REPLACE(REPLACE(sg.store_genres, ' (', '('), ')', ''), ',')) AS genre_with_id
GROUP BY genre_name
ORDER BY game_count DESC;
```
## IV. Review & Sentiment Analysis

### 14. Games with Most Positive Reviews:
```sql
SELECT
    game,
    positive_reviews
FROM steam_games
ORDER BY positive_reviews DESC
LIMIT 10;
```
### 15. Games with Most Negative Reviews:
```sql
SELECT
    game,
    negative_reviews
FROM steam_games
ORDER BY negative_reviews DESC
LIMIT 10;
```
### 16. Average Review Percentage by Primary Genre:
```sql
SELECT
    primary_genre,
    AVG(review_percentage) AS avg_review_percentage
FROM steam_games
GROUP BY primary_genre
ORDER BY avg_review_percentage DESC;
```
### 17. Games with High Total Reviews but Low Review Percentage (Controversial/Mixed Reception):
```sql
SELECT
    game,
    total_reviews,
    review_percentage
FROM steam_games
WHERE total_reviews > 10000
  AND review_percentage < 70
ORDER BY total_reviews DESC;
```

## V. Publisher & Developer Analysis

### 18. Top 10 Publishers by Total Games Released:
```sql
SELECT
    publisher,
    COUNT(sr_no) AS games_released_count
FROM steam_games
GROUP BY publisher
ORDER BY games_released_count DESC
LIMIT 10;
```
### 19. Top 10 Developers by Average Game Rating:
```sql
SELECT
    developer,
    AVG(rating) AS average_rating
FROM steam_games
GROUP BY developer
ORDER BY average_rating DESC
LIMIT 10;
```
### 20. Publishers with Highest Total All-Time Peak Players:
```sql
SELECT
    publisher,
    SUM(all_time_peak) AS total_all_time_peak
FROM steam_games
GROUP BY publisher
ORDER BY total_all_time_peak DESC
LIMIT 10;
```

### VI. Game Longevity & Engagement Analysis (Replacing Pricing Analysis)

###21. Games with Sustained Popularity (Older Games with High Current Players):
```sql
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
```
### NOTE :- ADDITIONAL QUERY FOR PROFILE ANALYSIS 
### 22. Developer/Publisher Average Peak Performance (for prolific creators ): 
```sql
SELECT
    developer,
    COUNT(sr_no) AS total_games_developed,
    AVG(all_time_peak) AS avg_peak_players_per_game
FROM steam_games
GROUP BY developer
HAVING COUNT(sr_no) > 5 -- Only consider developers with more than 5 games
ORDER BY avg_peak_players_per_game DESC
LIMIT 10;
```
### 23. Games with High Review Volume and High Rating (Critically Acclaimed & Popular):
```sql
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
```

## VII. Lifecycle & Technology Analysis

### 24. Average Time to All-Time Peak (Days) by Primary Genre:
```sql
SELECT
    primary_genre,
    AVG(EXTRACT(EPOCH FROM (all_time_peak_date - release)) / (60*60*24)) AS avg_days_to_peak
FROM steam_games
WHERE all_time_peak_date IS NOT NULL AND release IS NOT NULL
GROUP BY primary_genre
ORDER BY avg_days_to_peak;
```
### 25. Games by Detected Technologies (Advanced - Requires UNNEST/STRING_TO_ARRAY):
```sql
SELECT
    TRIM(UNNEST(STRING_TO_ARRAY(sg.detected_technologies, ';'))) AS technology_name,
    COUNT(sg.sr_no) AS game_count
FROM steam_games sg
CROSS JOIN LATERAL UNNEST(STRING_TO_ARRAY(sg.detected_technologies, ';')) AS tech_name
WHERE sg.detected_technologies IS NOT NULL AND sg.detected_technologies != ''
GROUP BY technology_name
ORDER BY game_count DESC;
```
