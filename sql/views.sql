
-- PHASE 5: ANALYTICS & REPORTS (Views & CTEs)


-- 1. DROP VIEWS IF THEY ALREADY EXIST (clean slate)

DROP VIEW IF EXISTS v_top_books;
DROP VIEW IF EXISTS v_member_activity;


-- VIEW 1: Top 3 Most Borrowed Books

CREATE VIEW v_top_books AS
WITH book_borrow_counts AS (
    SELECT 
        b.id AS book_id,
        b.title,
        b.author,
        COUNT(br.id) AS borrow_count
    FROM books b
    LEFT JOIN borrows br ON br.book_id = b.id
    GROUP BY b.id, b.title, b.author
),
ranked_books AS (
    SELECT 
        *,
        RANK() OVER (ORDER BY borrow_count DESC) AS rank_position
    FROM book_borrow_counts
)
SELECT 
    rank_position,
    title,
    author,
    borrow_count
FROM ranked_books
WHERE rank_position <= 3
ORDER BY rank_position;


-- VIEW 2: Member Activity Summary
-- Shows how many books each member has borrowed,
-- average days taken to return them, and current active borrows

CREATE VIEW v_member_activity AS
SELECT 
    m.id AS member_id,
    m.full_name,
    m.email,
    COUNT(br.id) AS total_books_borrowed,
    COUNT(CASE WHEN br.return_date IS NULL THEN 1 END) AS currently_borrowed,
    ROUND(AVG(CASE 
        WHEN br.return_date IS NOT NULL 
        THEN (br.return_date - br.borrow_date) 
        ELSE NULL 
    END), 2) AS avg_return_days,
    SUM(f.fine_amount) AS total_fines_owed
FROM members m
LEFT JOIN borrows br ON br.member_id = m.id
LEFT JOIN fines f ON f.member_id = m.id AND f.paid_status = FALSE
GROUP BY m.id, m.full_name, m.email;


SELECT * FROM v_top_books;

SELECT * FROM v_member_activity;