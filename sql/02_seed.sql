-- seed data set

-- 1. Insert Members
INSERT INTO members (full_name, email, membership_date) VALUES
('Alice Johnson', 'alice.j@email.com', '2025-01-15'),
('Bob Smith', 'bob.s@email.com', '2025-02-20'),
('Carol White', 'carol.w@email.com', '2025-03-10'),
('David Brown', 'david.b@email.com', '2025-04-05'),
('Eve Davis', 'eve.d@email.com', '2025-05-12');

-- 2. Insert Books
INSERT INTO books (title, author, isbn, genre) VALUES
('The Great Gatsby', 'F. Scott Fitzgerald', '978-0-7432-7356-5', 'Classic'),
('To Kill a Mockingbird', 'Harper Lee', '978-0-06-112008-4', 'Fiction'),
('1984', 'George Orwell', '978-0-452-28423-4', 'Dystopian'),
('Pride and Prejudice', 'Jane Austen', '978-0-14-143951-8', 'Romance'),
('The Catcher in the Rye', 'J.D. Salinger', '978-0-316-76948-0', 'Fiction'),
('Dune', 'Frank Herbert', '978-0-441-17271-9', 'Sci-Fi'),
('The Hobbit', 'J.R.R. Tolkien', '978-0-547-92822-7', 'Fantasy'),
('Fahrenheit 451', 'Ray Bradbury', '978-1-4516-7331-9', 'Dystopian'),
('Jane Eyre', 'Charlotte Brontë', '978-0-14-144114-6', 'Classic'),
('The Alchemist', 'Paulo Coelho', '978-0-06-250217-4', 'Inspirational');

-- 3. Insert Borrows (Transactions)
-- Note: return_date = NULL means the book is currently ACTIVE.
-- We manually set some borrow_date/due_date to simulate history.
INSERT INTO borrows (member_id, book_id, borrow_date, due_date, return_date, status) VALUES
-- Alice (member 1) borrowed The Great Gatsby (book 1) and returned it
(1, 1, '2026-06-01', '2026-06-15', '2026-06-14', 'RETURNED'),

-- Bob (member 2) borrowed 1984 (book 3) and returned it late
(2, 3, '2026-06-05', '2026-06-19', '2026-06-22', 'RETURNED'),

-- Carol (member 3) currently has Dune (book 6) - still active
(3, 6, '2026-06-20', '2026-07-04', NULL, 'ACTIVE'),

-- David (member 4) currently has The Hobbit (book 7) - still active
(4, 7, '2026-06-25', '2026-07-09', NULL, 'ACTIVE'),

-- Eve (member 5) borrowed Pride and Prejudice (book 4) and returned it
(5, 4, '2026-06-10', '2026-06-24', '2026-06-23', 'RETURNED'),

-- Alice (member 1) borrowed The Catcher in the Rye (book 5) - currently active
(1, 5, '2026-06-28', '2026-07-12', NULL, 'ACTIVE'),

-- Bob (member 2) borrowed Fahrenheit 451 (book 8) and returned it on time
(2, 8, '2026-06-15', '2026-06-29', '2026-06-28', 'RETURNED'),

-- Carol (member 3) borrowed Jane Eyre (book 9) - currently active
(3, 9, '2026-07-01', '2026-07-15', NULL, 'ACTIVE'),

-- David (member 4) borrowed The Alchemist (book 10) - OVERDUE! (due date was June 20)
(4, 10, '2026-06-06', '2026-06-20', NULL, 'OVERDUE'),

-- Eve (member 5) borrowed To Kill a Mockingbird (book 2) and returned it
(5, 2, '2026-05-20', '2026-06-03', '2026-06-02', 'RETURNED'),

-- Alice (member 1) borrowed Dune (book 6) - returned
(1, 6, '2026-06-12', '2026-06-26', '2026-06-25', 'RETURNED'),

-- Bob (member 2) borrowed The Hobbit (book 7) - OVERDUE! (due date was June 25)
(2, 7, '2026-06-11', '2026-06-25', NULL, 'OVERDUE');