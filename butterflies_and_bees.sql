SELECT * FROM bee_presence_and_traits;

SELECT * FROM bug_range_change;

SELECT * FROM butterfly_species_presence;

SELECT * FROM butterfly_traits;

-- do something with range change
CREATE OR REPLACE TEMP TABLE families_n_ecoregions AS
    SELECT 
        CASE 
            WHEN GroupInData IN ('butterflies', 'moths', 'geometridae', 'caterpillars', 'moths (selected species)', 'lepidoptera') THEN 'lepidoptera'
            WHEN GroupInData IN ('euglossine bees', 'bumblebees', 'ichneumonidae','aculeata') THEN 'hymenoptera'
            ELSE 'Other'
        END AS Order, 
        
        MODE(WWFEcoRegion) AS majority_ecoregion,
        MEAN(amt_cropland) AS amt_cropland, 
        MEAN(amt_urban) AS amt_urban, 
        MEAN(amt_forest) AS amt_forest,
        MEAN(mean_temp_c) AS mean_temp_c, 
        MEAN(temp_change_c) AS temp_change_c, 
        MEAN(mean_monthly_precip_mm) AS mean_monthly_precip_mm, 
        MEAN(precip_change_mm) AS precip_change_mm
        
    FROM bug_range_change WHERE GroupInData IN (
        'butterflies', 
        'moths', 
        'lepidoptera', 
        'geometridae', 
        'euglossine bees', 
        'ichneumonidae', 
        -- 'moths and beetles', 
        'bumblebees', 
        'aculeata',
        'caterpillars', 
        'moths (selected species)',
        -- 'hoverflies, bees'

    )
    GROUP BY GroupInData;




ALTER TABLE butterfly_species_presence RENAME COLUMN "year" TO obs_year;


SELECT DISTINCT WWFEcoRegion, year FROM bug_range_change;

-- butterfly species richness
SELECT SUM(count)/SUM(count) AS species_richness, "Reported species name", CAST(obs_year AS INTEGER) AS obs_year FROM butterfly_species_presence WHERE "Reported species name" NOT LIKE '%sp.' GROUP BY obs_year, "Reported species name";

-- bee species richness
SELECT COUNT(DISTINCT scientificName)/COUNT(*) AS species_richness, LEFT(eventDate, 4) AS obs_year FROM bee_presence_and_traits GROUP BY obs_year;

SELECT COUNT(*) FROM butterfly_species_presence;


CREATE OR REPLACE TABLE yearly_butterfly_species_params AS
    SELECT 
        "Reported species name", 
        MODE(obs_year) AS obs_year, 
        SUM(count) AS count,
        MEAN(lat) AS lat, 
        MEAN(lon) AS lon,
        MODE(Oviposition) AS Oviposition, 
        MODE(Voltinism) AS Voltinism, 
        MODE(Canopy) AS Canopy, 
        MODE(Edge) AS Edge,
        MODE(Moisture) AS Moisture,
        MODE(Disturbance) AS Disturbance,
        ROUND(MEAN(earliest_month)) AS earliest_month,
        ROUND(MEAN(latest_month)) AS latest_month, 
        MODE(bimodality) AS bimodality


    FROM butterfly_species_presence AS but_pre
    INNER JOIN butterfly_traits AS but_tr 
    ON but_pre."Reported species name" = CONCAT(but_tr.Genus, ' ', but_tr.Species)

    WHERE 
        Canopy != 'U' AND
        Edge != 'U' AND
        Moisture != 'U' AND
        Disturbance != 'U' AND

        obs_year >= 2015 AND
        obs_year <= 2020

    GROUP BY "Reported species name", obs_year
    ORDER BY "Reported species name", obs_year;


SELECT CONCAT(Genus, ' ', Species), * FROM butterfly_traits;

SELECT * FROM butterfly_species_presence;
