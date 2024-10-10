#Crimes Against Women in India (2001 - 2021) | SQL Data Analysis
Overview
This project provides an in-depth analysis of crimes against women in India from 2001 to 2021. The data was analyzed using SQL to extract insights into crime trends, crime categories, and state-wise statistics. This repository includes SQL queries that explore various aspects of the dataset, aiming to uncover meaningful patterns and trends in crime data.

Objectives
The main objectives of this analysis were:

To understand the overall trends of crimes against women in India.
To identify which states had the highest and lowest crime rates over the years.
To analyze crime categories (e.g., rape, domestic violence) and determine the most frequent types of crimes in each state.
To identify states with consistent declines or increases in crime rates.
To compare crimes by category and understand the contribution of each to the total crime rate.
Dataset
The dataset includes various categories of crimes against women in India, such as:

Rape
Kidnapping & Abduction (K&A)
Dowry Deaths (dd)
Assault on Women (aow)
Abetment to Suicide (aom)
Domestic Violence (dv)
Trafficking & Human Trafficking (wt)
Key Insights from the Analysis
Total Crimes Over Time: The total number of crimes per year and state was calculated to identify trends over time. This helped to determine how crime rates have fluctuated from 2001 to 2021.

Crime Trend Analysis: States with the highest and lowest increases in crimes were identified, revealing which regions experienced significant changes in crime rates.

Most Common Crime Categories: By evaluating the frequency of different crime types across states, the most common types of crimes were determined for each state.

Crime Percentage by Category: The percentage contribution of each crime type to the total number of crimes was calculated for each state, providing insights into which types of crimes are more prevalent.

State-wise Crime Severity: States were ranked based on their crime growth rate, allowing us to identify states where crime is increasing or decreasing.

Top 5 States for Domestic Violence: The states with the highest number of domestic violence cases were highlighted.

SQL Queries
The repository includes a variety of SQL queries covering:

Crime Trends: Identifying increases and decreases in crime rates.
Category-wise Analysis: Determining which crime types are the most frequent in each state.
Growth Rate Calculation: Measuring the year-over-year growth in crime numbers.
State Rankings: Ranking states by the total number of crimes and by specific crime categories like domestic violence and rape.
Crime Comparisons: Comparing the proportion of different crime types and analyzing the change over time.
Tools Used
SQL: The primary tool used for querying and analyzing the dataset. Advanced SQL techniques like window functions, WITH clauses, and aggregate functions were used to extract meaningful insights.
Dataset: The crime dataset was pre-processed and stored in a relational database for querying.
Future Work
This analysis can be further enhanced by:

Visualizations: Importing the SQL output into a visualization tool like Power BI or Tableau to create interactive dashboards.
Predictive Analysis: Building a predictive model using Python to forecast future crime trends based on historical data.
Regional Analysis: Conducting a more granular regional analysis by drilling down into city-level data, if available.
Conclusion
This project demonstrates the power of SQL in uncovering critical insights from raw data. Through various queries, we can better understand the state of crimes against women in India, how they have evolved over time, and which areas need the most attention.

How to Use This Repository
Clone the repository:

bash
Copy code
git clone https://github.com/yourusername/crime-analysis-india.git
Open your SQL workbench and connect to your database.

Run the SQL queries provided in the queries.sql file.

Analyze the output and feel free to modify the queries based on your specific needs or insights you wish to explore further.

