-- #################### --
-- ## tesArte DATABASE ## --
-- #################### --

-- ## TABLES ## --
CREATE TABLE T_USER(
    a_user_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    a_username TEXT CHECK (LENGTH(a_username) <= 50) UNIQUE NOT NULL,
    a_first_name TEXT CHECK (LENGTH(a_first_name) <= 100),
    a_last_name TEXT CHECK (LENGTH(a_last_name) <= 150),
    a_register_date DATE NOT NULL DEFAULT CURRENT_DATE,
    a_last_login_date DATE NOT NULL DEFAULT CURRENT_DATE,
    a_dark_mode BOOLEAN NOT NULL DEFAULT FALSE
);

