-- #################### --
-- ## tesArte DATABASE ## --
-- #################### --


-- ############ --
-- ## TABLES ## --
-- ############ --

CREATE TABLE T_USER(
    a_user_id INTEGER PRIMARY KEY NOT NULL,
    a_username TEXT CHECK (LENGTH(a_username) <= 50) UNIQUE NOT NULL,
    a_first_name TEXT CHECK (LENGTH(a_first_name) <= 100),
    a_last_name TEXT CHECK (LENGTH(a_last_name) <= 150),
    a_register_date DATE NOT NULL DEFAULT CURRENT_DATE,
    a_last_login_date DATE NOT NULL DEFAULT CURRENT_DATE,
    a_dark_mode BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE TABLE T_BOOK(
    a_book_id INTEGER PRIMARY KEY NOT NULL,
    a_title TEXT CHECK (LENGTH(a_title) <= 200) NOT NULL,
    a_subtitle TEXT CHECK (LENGTH(a_subtitle) <= 200),
    a_published_year INT,
    a_user_id INTEGER,
    a_google_book_id TEXT UNIQUE, -- if not empty, book was created from Google Books API
    a_description TEXT CHECK (LENGTH(a_description) <= 2000),
    a_cover_image_path TEXT CHECK (LENGTH(a_cover_image_path) <= 500),
    a_rating REAL CHECK (a_rating >= 0 AND a_rating <= 5),
    a_status INT CHECK (a_status >= 0 AND a_status <= 2), -- 0 → TO BE READ, 1 → READING, 2 -> READ
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

-- TODO: T_TAG

CREATE TABLE T_AUTHOR(
    a_author_id INTEGER PRIMARY KEY NOT NULL,
    a_name TEXT CHECK (LENGTH(a_name) <= 250) UNIQUE NOT NULL,
    a_birth_date DATE
    -- -1 -> GENERIC | 0 → BOOK AUTHOR, 1 → FILM AUTHOR, 2 → SERIES AUTHOR ... ⬇️
    a_author_type INTEGER CHECK(a_author_type IN (-1, 0, 1, 2))
    -- TODO: a_author_image_path (CHECK( LENGTH(a_author_image_path) <= 500 ))
);

-- RELATIONAL TABLES --
CREATE TABLE T_USER_AUTHOR(
    a_user_author_id INTEGER PRIMARY KEY NOT NULL,
    a_user_id INTEGER NOT NULL,
    a_author_id INTEGER NOT NULL,
    FOREIGN KEY (a_user_id) REFERENCES T_USER(a_user_id) ON DELETE CASCADE,
    FOREIGN KEY (a_author_id) REFERENCES T_AUTHOR(a_author_id) ON DELETE CASCADE
);

CREATE TABLE T_BOOK_AUTHOR(
    a_book_author_id INTEGER PRIMARY KEY NOT NULL,
    a_book_id INTEGER NOT NULL,
    a_author_id INTEGER,
    FOREIGN KEY (a_book_id) REFERENCES T_BOOK(a_book_id) ON DELETE CASCADE,
    FOREIGN KEY (a_author_id) REFERENCES T_AUTHOR(a_author_id) ON DELETE SET NULL
);