CREATE TABLE dim_property (
    property_id SERIAL PRIMARY KEY,
    property_title VARCHAR(255),
    city VARCHAR(100),
    property_type VARCHAR(50),
    bedrooms VARCHAR(50),
    bathrooms INT,
    rating VARCHAR(50),
    furnish_type VARCHAR(50),
    apart_size VARCHAR(50),
    promotion_label VARCHAR(255)
);

CREATE TABLE dim_time (
    date_id SERIAL PRIMARY KEY,
    date DATE,
    year INT,
    month INT,
    day INT,
    quarter INT
);

CREATE TABLE dim_capacity (
    capacity_id SERIAL PRIMARY KEY,
    capacity INT,
    rental_period VARCHAR(50)
);



CREATE TABLE fact_property_rentals (
    property_id INT,
    date_id INT,
    capacity_id INT,
    price FLOAT,
    availability_number INT,
    FOREIGN KEY (property_id) REFERENCES dim_property(property_id),
    FOREIGN KEY (date_id) REFERENCES dim_time(date_id),
    FOREIGN KEY (capacity_id) REFERENCES dim_capacity(capacity_id)
);



-- INSERT DATA

-- dim_property
INSERT INTO dim_property (property_title, city, property_type, bedrooms, bathrooms, rating, furnish_type, apart_size, promotion_label)
SELECT DISTINCT
    property_title,
    city,
    property_type,
    bedrooms,
    bathrooms,
    rating,
    furnish_type,
    apart_size,
    promotion_label
FROM all_data;


-- dim time
INSERT INTO dim_time (date, year, month, day, quarter)
SELECT DISTINCT
    date AS date,
    year,
    month,
    day,
    quarter
FROM all_data;


-- dim_capacity
INSERT INTO dim_capacity (capacity, rental_period)
SELECT DISTINCT
    capacity,
    rental_period
FROM all_data;


-- fact_rentals
INSERT INTO fact_property_rentals (property_id, date_id, capacity_id, price, availability_number)
SELECT 
    dp.property_id,
    dt.date_id,
    dc.capacity_id,
    ad.price,
    ad.availability_number
FROM all_data ad
JOIN dim_property dp ON ad.property_title = dp.property_title AND ad.city = dp.city
JOIN dim_time dt ON ad.date = dt.date
JOIN dim_capacity dc ON ad.capacity = dc.capacity AND ad.rental_period = dc.rental_period;






select count(*) from fact_property_rentals2;

select sum(availability_number) from fact_property_rentals;
select count(property_id), city from dim_property group by city order by count(property_id) DESC;
select furnish_type, count(furnish_type) from dim_property group by furnish_type order by count(furnish_type) DESC;
select rating, avg(price) from fact_property_rentals group by rating order by count(furnish_type) DESC;

select count(*) from fact_property_rentals fpr ;



