-- borrow function automation

CREATE OR REPLACE FUNCTION borrow_book(
    p_member_id INTEGER,
    p_book_id INTEGER
)
RETURNS TEXT
LANGUAGE plpgsql
AS $$
DECLARE
    v_active_borrows INTEGER;
    v_book_available BOOLEAN;
    v_new_borrow_id INTEGER;
BEGIN
    -- 1. Check if member has 5 or more active borrows
    SELECT COUNT(*) INTO v_active_borrows
    FROM borrows
    WHERE member_id = p_member_id AND return_date IS NULL;

    IF v_active_borrows >= 5 THEN
        RETURN 'ERROR: Member has already borrowed 5 books. Return one first.';
    END IF;

    -- 2. Check if the book is currently borrowed by someone else
    SELECT EXISTS (
        SELECT 1 FROM borrows
        WHERE book_id = p_book_id AND return_date IS NULL
    ) INTO v_book_available;

    IF v_book_available = TRUE THEN
        RETURN 'ERROR: This book is currently borrowed by someone else.';
    END IF;

    -- 3. If all checks pass, insert the new borrow record
    INSERT INTO borrows (member_id, book_id, borrow_date, due_date, status)
    VALUES (
        p_member_id,
        p_book_id,
        CURRENT_DATE,
        CURRENT_DATE + INTERVAL '14 days',
        'ACTIVE'
    )
    RETURNING id INTO v_new_borrow_id;

    -- 4. Return success message with the borrow ID
    RETURN 'SUCCESS: Book borrowed! Borrow ID #' || v_new_borrow_id;
END;
$$;


SELECT borrow_book(1, 7);
SELECT borrow_book(1, 2);
