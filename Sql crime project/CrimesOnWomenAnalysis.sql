-- create database Crime;
-- use crime;

-- alter table crimesonwomendata
-- rename   crime

-- alter table crime
-- modify column Year_ int ;

-- update crime
-- set year_=year(Year);

-- alter table crime
-- drop column year;

-- alter table crime
-- rename column year_ to year;

-- alter table crime
-- drop column myunknowncolumn

-- update  crime
-- set state=proper(state)




-- Total Crimes Over Time: What is the total number of crimes against women in each state per year?
SELECT 
    state, 
    year, 
    Rape + `K&A` + dd + aow + aom + dv + wt AS total_crimes
FROM
    crime
ORDER BY 
    state, 
    year;

-- Crime Trend Analysis: Which state had the highest increase in crimes over the years?
SELECT 
    state,
    "2001 to 2021" AS year,
    ROUND((this_year - last_year) * 100 / last_year, 2) AS percent_increase 
FROM (
    SELECT 
        state,
        year,
        Rape + `K&A` + dd + aow + aom + dv + wt AS this_year,
        COALESCE(LAG(Rape + `K&A` + dd + aow + aom + dv + wt) OVER (PARTITION BY state ORDER BY year), 0) AS last_year 
    FROM 
        crime
    WHERE 
        year IN (2001, 2021)
) AS x
WHERE 
    year = 2021
ORDER BY 
    percent_increase DESC;

-- Highest Crime Categories: Which crime type is the most frequent for each state across all years?
WITH cte AS (
    SELECT 
        state, 
        SUM(Rape) AS total_rapes,
        SUM(`K&A`) AS total_ka,
        SUM(dd) AS total_dd,
        SUM(aow) AS total_aow,
        SUM(aom) AS total_aom,
        SUM(dv) AS total_dv,
        SUM(wt) AS total_wt
    FROM 
        crime
    GROUP BY 
        state
)
SELECT 
    state, 
    category, 
    value AS victims 
FROM (
    SELECT 
        state,
        category,
        value,
        DENSE_RANK() OVER (PARTITION BY state ORDER BY value DESC) AS ranking 
    FROM (
        SELECT 
            state, 
            'total_rapes' AS category, 
            total_rapes AS value 
        FROM 
            cte 
        UNION ALL
        SELECT 
            state, 
            'total_ka' AS category, 
            total_ka AS value 
        FROM 
            cte 
        UNION ALL
        SELECT 
            state, 
            'total_dd' AS category, 
            total_dd AS value 
        FROM 
            cte 
        UNION ALL
        SELECT 
            state, 
            'total_aow' AS category, 
            total_aow AS value 
        FROM 
            cte 
        UNION ALL
        SELECT 
            state, 
            'total_aom' AS category, 
            total_aom AS value 
        FROM 
            cte 
        UNION ALL
        SELECT 
            state, 
            'total_dv' AS category, 
            total_dv AS value 
        FROM 
            cte 
        UNION ALL
        SELECT 
            state, 
            'total_wt' AS category, 
            total_wt AS value 
        FROM 
            cte
    ) AS y
) AS z
WHERE 
    ranking = 1;

-- States with Declining Crime Rates: Which states have shown a consistent decrease in crime rates over a few years?
SELECT 
    state 
FROM (
    SELECT 
        state, 
        year, 
        this_year, 
        last_year 
    FROM (
        SELECT 
            state, 
            year, 
            Rape + `K&A` + dd + aow + aom + dv + wt AS this_year,
            COALESCE(LAG(Rape + `K&A` + dd + aow + aom + dv + wt) OVER (PARTITION BY state ORDER BY year), 0) AS last_year 
        FROM 
            crime
        WHERE 
            year BETWEEN 2015 AND 2021
    ) AS x
    WHERE 
        this_year < last_year
    ORDER BY 
        state, 
        year
) AS y
GROUP BY 
    state
HAVING 
    COUNT(*) >= 4
ORDER BY 
    state;

-- Crime Percentage by Category: What percentage does each crime type contribute to the total crimes for each state and year?
WITH state_data AS (
    SELECT 
        state, 
        year, 
        Rape, 
        `K&A`, 
        dd, 
        aow, 
        aom, 
        dv, 
        wt, 
        Rape + `K&A` + dd + aow + aom + dv + wt AS total_crimes 
    FROM 
        crime
)
SELECT 
    state, 
    year,
    CONCAT(ROUND(Rape / total_crimes, 2) * 100, ' %') AS total_rapes,
    CONCAT(ROUND(`K&A` / total_crimes, 2) * 100, ' %') AS total_ka,
    CONCAT(ROUND(dd / total_crimes, 2) * 100, ' %') AS total_dd,
    CONCAT(ROUND(aow / total_crimes, 2) * 100, ' %') AS total_aow,
    CONCAT(ROUND(aom / total_crimes, 2) * 100, ' %') AS total_aom,
    CONCAT(ROUND(dv / total_crimes, 2) * 100, ' %') AS total_dv,
    CONCAT(ROUND(wt / total_crimes, 2) * 100, ' %') AS total_wt
FROM 
    state_data
ORDER BY 
    state, 
    year;

-- Year with Highest Crimes per State: Which year saw the highest crime rate for each state?
SELECT 
    state, 
    year, 
    crimes 
FROM (
    SELECT 
        state, 
        year,
        Rape + `K&A` + dd + aow + aom + dv + wt AS crimes,
        DENSE_RANK() OVER (PARTITION BY state ORDER BY Rape + `K&A` + dd + aow + aom + dv + wt DESC) AS ranking 
    FROM 
        crime
    ORDER BY 
        state, 
        year
) AS x
WHERE 
    ranking = 1;

-- Crime Ratio of Major Categories: What is the ratio of Rape to Domestic Violence crimes across all states?
SELECT 
    state,
    CONCAT(ROUND(total_rape / total, 2) * 100, "  :  ", ROUND(total_dv / total, 2) * 100) AS "rape : dv" 
FROM (
    SELECT 
        state,
        SUM(rape) AS total_rape,
        SUM(dv) AS total_dv,
        SUM(rape + dv) AS total
    FROM 
        crime
    GROUP BY 
        state
) AS x;

-- Most Dangerous States by Year: Which states ranked highest in total crimes for each year?
SELECT 
    year, 
    state 
FROM (
    SELECT 
        year, 
        state, 
        Rape + `K&A` + dd + aow + aom + dv + wt,
        DENSE_RANK() OVER (PARTITION BY year ORDER BY Rape + `K&A` + dd + aow + aom + dv + wt DESC) AS ranking 
    FROM 
        crime
) AS x
WHERE 
    ranking = 1;

-- Crimes Growth Rate: What is the growth rate of crimes across the years for each state?
SELECT 
    state, 
    year, 
    coalesce(round((present_year - previous_year) / previous_year,2)*100,0) AS growth_rate
FROM (
    SELECT 
        state, 
        year,
        Rape + `K&A` + dd + aow + aom + dv + wt AS present_year,
        COALESCE(LAG(Rape + `K&A` + dd + aow + aom + dv + wt) OVER (PARTITION BY state ORDER BY year), 0) AS previous_year 
    FROM 
        crime
) AS x;

-- Top 5 States with Highest Domestic Violence: Which states have the highest domestic violence cases over the years?
SELECT 
    state, 
    dv_cases 
FROM (
    SELECT 
        state, 
        SUM(dv) AS dv_cases,
        DENSE_RANK() OVER (ORDER BY SUM(dv) DESC) AS ranking 
    FROM 
        crime
    GROUP BY 
        state
) AS x
WHERE 
    ranking <= 5;

-- Year with Lowest Crimes Overall: Which year had the lowest total number of crimes across India?
SELECT 
    year, 
    SUM(Rape + `K&A` + dd + aow + aom + dv + wt) AS total_cases 
FROM 
    crime
GROUP BY 
    year
ORDER BY 
    total_cases ASC
LIMIT 1;

-- Comparison of Rape and Domestic Violence Across Years: How has the proportion of rape to domestic violence changed over the years?
SELECT 
    year,
    coalesce(round((rape - rape_previous) / rape_previous*100,2),0) AS rape_growth,
    coalesce(round((dv - dv_previous)/ dv_previous,2)*100,0) AS dv_growth 
FROM (
    SELECT 
        year,
        SUM(rape) AS rape,
        COALESCE(LAG(SUM(rape)) OVER (), 0) AS rape_previous,
        SUM(dv) AS dv,
        COALESCE(LAG(SUM(dv)) OVER (), 0) AS dv_previous 
    FROM 
        crime
    GROUP BY 
        year
) AS x;

-- State-wise Crime Severity Analysis: How severe are the crimes in terms of their growth rate over the years in each state?
SELECT 
    state,
    ROUND(AVG((current - previous) / previous * 100), 2) AS growth_rate 
FROM (
    SELECT 
        state, 
        year,
        Rape + `K&A` + dd + aow + aom + dv + wt AS current,
        COALESCE(LAG(Rape + `K&A` + dd + aow + aom + dv + wt) OVER (PARTITION BY state ORDER BY year), 0) AS previous 
    FROM 
        crime
) AS y
GROUP BY 
    state;


















