 

DROP TABLE IF EXISTS borrows;
DROP TABLE IF EXISTS books;
DROP TABLE IF EXISTS members;
DROP TABLE IF EXISTS fines;

-- 1. Members Table
CREATE TABLE members (
    id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    membership_date DATE DEFAULT CURRENT_DATE
);

-- 2. Books Table
CREATE TABLE books (
    id SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    author VARCHAR(100) NOT NULL,
    isbn VARCHAR(20) UNIQUE,
    genre VARCHAR(50)
);

-- 3. Borrows Table (Main transaction table)
CREATE TABLE borrows (
    id SERIAL PRIMARY KEY,
    member_id INTEGER REFERENCES members(id) ON DELETE CASCADE,
    book_id INTEGER REFERENCES books(id) ON DELETE CASCADE,
    borrow_date DATE DEFAULT CURRENT_DATE,
    due_date DATE DEFAULT (CURRENT_DATE + INTERVAL '14 days'),
    return_date DATE NULL, -- NULL means it is STILL borrowed
    status VARCHAR(20) DEFAULT 'ACTIVE'
);

-- 4. Fines Table
CREATE TABLE fines (
    id SERIAL PRIMARY KEY,
    borrow_id INTEGER REFERENCES borrows(id) ON DELETE CASCADE,
    member_id INTEGER REFERENCES members(id),
    fine_amount DECIMAL(5,2) NOT NULL,
    paid_status BOOLEAN DEFAULT FALSE,
    issued_date DATE DEFAULT CURRENT_DATE
);