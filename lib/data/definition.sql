-- #################### --
-- ## tesArte DATABASE ## --
-- #################### --


-- ############ --
-- ## TABLES ## --
-- ############ --

CREATE TABLE T_USER(
    a_user_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    a_username TEXT CHECK (LENGTH(a_username) <= 50) UNIQUE NOT NULL,
    a_first_name TEXT CHECK (LENGTH(a_first_name) <= 100),
    a_last_name TEXT CHECK (LENGTH(a_last_name) <= 150),
    a_register_date DATE NOT NULL DEFAULT CURRENT_DATE,
    a_last_login_date DATE NOT NULL DEFAULT CURRENT_DATE,
    a_dark_mode BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE TABLE T_BOOK(
    a_book_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    a_title TEXT CHECK (LENGTH(a_title) <= 200) NOT NULL,
    a_subtitle TEXT CHECK (LENGTH(a_subtitle) <= 200),
    a_published_year INT,
    a_user_id INTEGER,
    a_google_book_id TEXT, -- to check if its created from Google Books API
    a_description TEXT CHECK (LENGTH(a_description) <= 1000),
    a_cover_image_path TEXT CHECK (LENGTH(a_cover_image_path) <= 500),
    a_rating INT CHECK (a_rating >= 0 AND a_rating <= 5),
    a_status INT CHECK (a_status >= 0 AND a_status <= 2), -- 0 → TO BE READ, 1 → READING, 2 = READ
    FOREIGN KEY (a_user_id) REFERENCES T_USER(a_user_id)
);

CREATE TABLE T_GENRE(
    a_genre_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    a_name TEXT CHECK (LENGTH(a_name) <= 50) UNIQUE NOT NULL
);

-- RELATIONAL TABLE --
CREATE TABLE T_BOOK_GENRE(
    a_book_genre_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    a_book_id INTEGER,
    a_genre_id INTEGER,
    FOREIGN KEY (a_book_id) REFERENCES T_BOOK(a_book_id),
    FOREIGN KEY (a_genre_id) REFERENCES T_GENRE(a_genre_id)
);

CREATE TABLE T_QUOTE(

);

CREATE TABLE T_TAG(

);

CREATE TABLE T_AUTHOR(
    a_author_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    a_first_name TEXT CHECK (LENGTH(a_first_name) <= 100) NOT NULL,
    a_last_name TEXT CHECK (LENGTH(a_last_name) <= 150),
    a_birth_date DATE
);

-- RELATIONAL TABLE --
CREATE TABLE T_BOOK_AUTHOR(
    a_book_author_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    a_book_id INTEGER,
    a_author_id INTEGER,
    FOREIGN KEY (a_book_id) REFERENCES T_BOOK(a_book_id),
    FOREIGN KEY (a_author_id) REFERENCES T_AUTHOR(a_author_id)
);