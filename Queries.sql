-- get everything from table
SELECT * FROM "public"."cvbankas";
-- 1016 records.


-- get unique job listings
SELECT DISTINCT link FROM "public"."cvbankas";
--145 records.


-- get unique job titles and order them
SELECT DISTINCT title FROM "public"."cvbankas"
ORDER BY title;
--133 records, many titles for same position, but with a bit different wording.


/*I wanted to get all unique words with their counts from titles to get a better idea on how to group titles. Using google search “sql get unique words” I found a suitable solution, but once I started to implement it, it turned out that MySQL uses SUBSTRING_INDEX function, while I use PostgreSQL which uses SPLIT_PART. Then using google search “postgresql get unique words” I find a simple solution with REGEXP_SPLIT_TO_TABLE. Lesson learned – always be specific for which exact tool solution is needed 😊  */


-- get all words from titles
SELECT link, title, regexp_split_to_table(title, '\s') AS word FROM "public"."cvbankas"
GROUP BY link, title
-- 585 records


-- count unique words and filter some generic words
SELECT DISTINCT word, count(*) FROM
(SELECT link, title, regexp_split_to_table(title, '\s') AS word FROM "public"."cvbankas" GROUP BY link, title) t
WHERE word NOT IN ('it', 'in', '(-ė)', 'at', 'SEB', 'Vilnius', '-', '(-a)')
GROUP BY word
ORDER BY count DESC


-- since lower and upper case words are counted separately, convert all words to lower case using LOWER function
SELECT DISTINCT word, count(*) FROM
(SELECT link, title, LOWER(regexp_split_to_table(title, '\s')) AS word FROM "public"."cvbankas" GROUP BY link, title) t
WHERE word NOT IN ('it', 'in', '(-ė)', 'at', 'SEB', 'Vilnius', '-', '(-a)' )
GROUP BY word
ORDER BY count DESC


-- add new column for cleaned titles
ALTER TABLE "public"."cvbankas"
ADD new_title VARCHAR(255);


-- list all unique listings with title, new_title, sort by title
SELECT link, title, new_title 
FROM "public"."cvbankas"
GROUP BY link, title, new_title
ORDER BY title


--Based on most common words in tittles and last table I can start filing new_title column with updated titles.


-- update new_titles column with 'Analyst' titles
UPDATE "public"."cvbankas"
SET new_title = 'Analyst'
WHERE title ILIKE '%anal%'
-- make similar updates with Developer, other, Java developer, Engineer, Administrator, Other, Manager, .NET developer, Data specialist, PHP Developer.


-- grouped titles in 10 main categories
SELECT DISTINCT new_title, count(*), 
-- calculate percent
CAST
(
CAST(count(*) AS DECIMAL)
/
CAST(145 AS DECIMAL) 
*
CAST(100 AS DECIMAL)
AS DECIMAL(4, 0)
) AS percent
FROM -- to filter distinct links need another select
(
SELECT link, title, new_title 
FROM "public"."cvbankas"
GROUP BY link, title, new_title
ORDER BY title
) t
GROUP BY new_title
ORDER BY count DESC
 
 
-- get unique words and their counts from job requirements description
SELECT DISTINCT word, count(*) FROM
(
SELECT link, block_text, LOWER(regexp_split_to_table(block_text, '\s')) AS word 
FROM "public"."cvbankas" 
WHERE block_text ILIKE '%sql%'
GROUP BY link, block_text
) t
GROUP BY word
ORDER BY count DESC
-- 9566 words total, 3069 unique words
-- results placed in new table using: CREATE TABLE <table name> AS (SELECT STATEMENT)


-- add new column for updated words
ALTER TABLE words_from_description
ADD words_updated VARCHAR(255);


-- update words_updated column with 'English language'
UPDATE words_from_description
SET words_updated = 'English language'
WHERE words_updated IS NULL AND (word ILIKE '%engl%' OR word ILIKE '%angl%') 

 
-- made similar updates to other popular keywords and summarized them
SELECT words_updated AS "Words", sum(count) AS "Mentioned times"
FROM "public"."words_from_description"
WHERE words_updated IS NOT NULL
GROUP BY words_updated
ORDER BY "Mentioned times" DESC
 

-- extract and sort numbers from viewed column
SELECT title,
--convert to number
CAST(
--extract numbers from viewed column
SUBSTRING(viewed FROM 1 FOR
--find where number ends
(SELECT POSITION('
' IN viewed)-1
))
AS INT
) AS "Views count",
link, viewed
FROM "public"."cvbankas"
GROUP BY link, viewed, title
ORDER BY "Views count" DESC