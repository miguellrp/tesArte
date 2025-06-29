-- #################### --
-- ## tesArte DATABASE ## --
-- #################### --


-- ############ --
-- ## TABLES ## --
-- ############ --

CREATE TABLE T_USER(
    a_user_id INTEGER PRIMARY KEY NOT NULL,
    a_username VARCHAR CHECK (LENGTH(a_username) <= 50) UNIQUE NOT NULL,
    a_first_name VARCHAR CHECK (LENGTH(a_first_name) <= 100),
    a_last_name VARCHAR CHECK (LENGTH(a_last_name) <= 150),
    a_register_date DATE NOT NULL DEFAULT CURRENT_DATE,
    a_last_login_date DATE NOT NULL DEFAULT CURRENT_DATE,
    a_dark_mode BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE TABLE T_BOOK(
    a_book_id INTEGER PRIMARY KEY NOT NULL,
    a_title TEXT CHECK (LENGTH(a_title) <= 200) NOT NULL,
    a_subtitle VARCHAR CHECK (LENGTH(a_subtitle) <= 200),
    a_published_year INT,
    a_user_id INTEGER,
    a_google_book_id TEXT UNIQUE, -- if not empty, book was created from Google Books API
    a_description VARCHAR CHECK (LENGTH(a_description) <= 2000),
    a_cover_image_path VARCHAR CHECK (LENGTH(a_cover_image_path) <= 500),
    a_rating REAL CHECK (a_rating >= 0 AND a_rating <= 5),
    a_status INT CHECK (a_status >= 0 AND a_status <= 2), -- 0 → TO BE READ, 1 → READING, 2 -> READ
    a_addition_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (a_user_id) REFERENCES T_USER(a_user_id)
);

CREATE TABLE T_GENRE(
    a_genre_id INTEGER PRIMARY KEY NOT NULL,
    a_name TEXT CHECK (LENGTH(a_name) <= 50) UNIQUE NOT NULL
);

-- RELATIONAL TABLE --
CREATE TABLE T_BOOK_GENRE(
    a_book_genre_id INTEGER PRIMARY KEY NOT NULL,
    a_book_id INTEGER,
    a_genre_id INTEGER,
    FOREIGN KEY (a_book_id) REFERENCES T_BOOK(a_book_id) ON DELETE CASCADE,
    FOREIGN KEY (a_genre_id) REFERENCES T_GENRE(a_genre_id) ON DELETE SET NULL
);

CREATE TABLE T_QUOTE(
    a_quote_id INTEGER PRIMARY KEY NOT NULL,
    a_book_id INTEGER,
    a_quote TEXT CHECK (LENGTH(a_quote) <= 200) NOT NULL,
    a_chapter TEXT CHECK (LENGTH(a_chapter) <= 150),
    FOREIGN KEY (a_book_id) REFERENCES T_BOOK(a_book_id) ON DELETE CASCADE
);

CREATE TABLE T_NOTE(
    a_note_id INTEGER PRIMARY KEY NOT NULL,
    a_book_id INTEGER,
    a_note TEXT CHECK (LENGTH(a_note) <= 5000) NOT NULL ,
    a_creation_date DATE NOT NULL DEFAULT CURRENT_DATE,
    a_last_update_date DATE NOT NULL DEFAULT CURRENT_DATE,
    FOREIGN KEY (a_book_id) REFERENCES T_BOOK(a_book_id) ON DELETE CASCADE
);

CREATE TABLE T_BOOK_AUTHOR(
    a_book_author_id INTEGER PRIMARY KEY NOT NULL,
    a_first_name VARCHAR CHECK (LENGTH(a_first_name) <= 100),
    a_last_name VARCHAR CHECK (LENGTH(a_first_name) <= 150),
    a_birth_date DATE,
    a_death_date DATE,
    a_picture_path VARCHAR CHECK (LENGTH(a_picture_path) <= 500)
);

CREATE TABLE T_BOOK_AUTHOR_REL_BOOK( -- RELATIONAL
    a_book_author_rel_book_id INTEGER PRIMARY KEY NOT NULL,
    a_book_author_id INTEGER NOT NULL,
    a_book_id INTEGER NOT NULL,
    FOREIGN KEY (a_book_author_id) REFERENCES T_BOOK_AUTHOR(a_book_author_id) ON DELETE CASCADE,
    FOREIGN KEY (a_book_id) REFERENCES T_BOOK(a_book_id) ON DELETE CASCADE
);

-- TODO: T_BOOK_TAG