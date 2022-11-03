## SQL job listings

I was interested how popular SQL is in job listings:

1.	Searched for SQL keyword in CVbankas.lt page, got 145 listings.
2.	Scraped results.
3.	Cleaned and analysed data with SQL.
4.	Used Power BI to visualize results.

To scrape search results used Web Scraper - Free Web Scraping Chrome extension. Exported results as CSV. Created PostgresSQL data base using Valentina Studio and imported CSV. Backed up database with Create dump.

For next project it would be interesting to create own Python script to perform customized scraping and get a cleaner data, automate load to SQL database.

[I analysed data with SQL.] Only 4 job titles contained SQL, so I arranged job titles in to 10 categories:

[I analysed data with SQL.]: <https://github.com/Geduifx/My-first-SQL-project/blob/main/Queries.sql>

<img src="Images/10titles.png" width="">

Then imported query results to Power BI and visualized them. 

For next project it would be interesting to setup server level connection between SQL database and Power BI.

![](Images/10chart.png)

Main issues faced: mix of upper- and lower-case  case letters, different wording for same job positions, two languages (EN, LT), different punctuations.

Looks like there are only few positions where main requirement is SQL expertise, but good news is that SQL is a necessary and important supplementary tool in many broad fields.

I was interested what other tools and skills are used together with SQL, so looked at scraped job requirements. It was difficult to find out what are common requirements when many job listing have huge requirements lists. So extracted all words (9566 total, 3069 unique) from requirements lists and summarized most common ones:

![](Images/skills_table.png)

![](Images/skills_chart.png)

Also checked which job listings where most popular.

![](Images/popular.png)

Could scrape additional data that includes information on how long the listing was available. Then it would be possible to present relative and more accurate data in last table.
