

CREATE OR REPLACE TABLE spiders_query AS 
    -- Full Query
    --- displays average traits by country, and by proximity, biome
    SELECT 
        -- select columns
        ---- select our group cols
        trait, country, 

        ---- grab our biome params for each country
        FIRST(countries.most_dominant_biome) AS biome,
        FIRST(biomes.biome_nm) AS biome_name, 

        --- advanced calculations
        ---- create new fload col that takes in all values that are numerical for the continuous traits
        ---- use regex to select for only numerical chars, then convert those values to type int
        AVG(CASE WHEN value ~ '^[0-9]+(\.[0-9]+)?$' THEN CAST(value AS FLOAT) END) AS avg_numeric_value, 

        ---- another column that does the opposite for the categorical data as text 
        (SELECT value 
        FROM spider_traits AS st2 
        WHERE st2.trait = st1.trait AND NOT value ~ '^[0-9]+(\.[0-9]+)?$' ---- deselect all numerical chars

        ---- mediate the duplicate issue
        GROUP BY value ------ collapse all common values together
        ORDER BY COUNT(*) DESC ------ sort by commonality
        LIMIT 1) AS most_common_categorical_value ------ then select the most common one at the top of the list

    FROM spider_traits AS st1

    -- our joins and groupby
    JOIN countries 
        USING(country)
    JOIN biomes
        ON biomes.BIOME = countries.most_dominant_biome
    GROUP BY trait, country
    ORDER BY trait;