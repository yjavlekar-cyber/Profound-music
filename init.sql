CREATE TABLE IF NOT EXISTS artist_info (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    genre VARCHAR(50),
    bio TEXT
);

CREATE TABLE IF NOT EXISTS subscribers (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    signup_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELETE FROM artist_info;

INSERT INTO artist_info (name, genre, bio) 
VALUES ('Profound', 'Hip-Hop / Lyrical', 'Hailing from Mumbai, Profound is part of a new wave of independent hip-hop artists shaping the city’s evolving underground sound. His music reflects a raw, unfiltered perspective blending introspection and street narratives. Rather than chasing trends, his approach is grounded in authenticity—where storytelling meets mood-driven production. Each release adds another layer to an identity built on growth, struggle, and relentless self-expression.')
ON CONFLICT DO NOTHING;
