
-- make tables
---- countries

CREATE OR REPLACE TABLE countries AS
    SELECT * FROM read_csv('spider_ver_tables/countries.csv', 
        nullstr = 'NA', -- convert all NA chars to NULL
        types = {
            'country': 'TEXT', 
            'most_dominant_biome': 'INT', 
            'most_dominant_biome_area': 'DOUBLE', 
            'second_dominant_biome': 'INT', 
            'second_dominant_biome_area': 'DOUBLE', 
            'third_dominant_biome': 'INT', 
            'third_dominant_biome_area': 'DOUBLE'
        }
); 

---- biomes
CREATE OR REPLACE TABLE biomes AS
    SELECT * FROM read_csv('spider_ver_tables/ecoregions.csv');

---- spider traits
CREATE OR REPLACE TABLE spider_traits AS
    SELECT * FROM read_csv('spider_ver_tables/full_spider_traits.csv', 
        nullstr = 'NA', 
        types = {
            'id': 'INT',
            'latin_name': 'TEXT', 
            'value': 'TEXT',
            'sample_size': 'INT',
            'note': 'TEXT', 
            'row_code': 'INT', 
            'family': 'TEXT',
            'trait': 'TEXT', 
            'measure_type': 'TEXT', 
            'sex': 'TEXT', 
            'country': 'TEXT', 
            'lat': 'FLOAT', 
            'lon': 'FLOAT'
        }
);

