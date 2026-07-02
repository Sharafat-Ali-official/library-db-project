-- =============================================
-- PHASE 6: PERFORMANCE TUNING (Indexing)
-- =============================================

-- 1. BEFORE INDEX: See how PostgreSQL executes a query
-- This query finds all active borrows for a specific member (David, ID = 4)
EXPLAIN ANALYZE
SELECT 
    m.full_name,
    b.title,
    br.borrow_date,
    br.due_date,
    br.status
FROM borrows br
JOIN members m ON m.id = br.member_id
JOIN books b ON b.id = br.book_id
WHERE br.member_id = 4 AND br.return_date IS NULL;

-- Notice: It probably says "Seq Scan" (sequential scan) — it reads the ENTIRE table row by row.
-- That's slow for large tables!

-- 2. CREATE INDEXES (The magic speed-up!)
-- Foreign Key Index: Speeds up JOINs between borrows and members/books
CREATE INDEX IF NOT EXISTS idx_borrows_member_id ON borrows(member_id);
CREATE INDEX IF NOT EXISTS idx_borrows_book_id ON borrows(book_id);

-- Date Index: Speeds up searches by dates (overdue reports, due dates, etc.)
CREATE INDEX IF NOT EXISTS idx_borrows_due_date ON borrows(due_date);
CREATE INDEX IF NOT EXISTS idx_borrows_return_date ON borrows(return_date);

-- Composite Index: Speeds up common filtering (member_id + return_date)
CREATE INDEX IF NOT EXISTS idx_borrows_member_return ON borrows(member_id, return_date);

-- Email Index: Speeds up member lookups by email
CREATE INDEX IF NOT EXISTS idx_members_email ON members(email);

-- Book Title Index: Speeds up book searches by title
CREATE INDEX IF NOT EXISTS idx_books_title ON books(title);

-- 3. AFTER INDEX: Re-run the exact same query to see the improvement!
EXPLAIN ANALYZE
SELECT 
    m.full_name,
    b.title,
    br.borrow_date,
    br.due_date,
    br.status
FROM borrows br
JOIN members m ON m.id = br.member_id
JOIN books b ON b.id = br.book_id
WHERE br.member_id = 4 AND br.return_date IS NULL;

-- You should now see "Index Scan" instead of "Seq Scan" — much faster!