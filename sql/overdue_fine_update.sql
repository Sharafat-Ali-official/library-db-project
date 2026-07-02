-- =============================================
-- PHASE 4: BUSINESS LOGIC (Overdue Fines)
-- =============================================

CREATE OR REPLACE PROCEDURE process_overdue_fines()
LANGUAGE plpgsql
AS $$
DECLARE
    v_borrow_record RECORD;
    v_days_overdue INTEGER;
    v_fine_amount DECIMAL(5,2);
BEGIN
    -- Loop through all active/overdue borrows where the due_date is in the past
    FOR v_borrow_record IN
        SELECT 
            id AS borrow_id,
            member_id,
            due_date,
            CURRENT_DATE - due_date AS days_overdue
        FROM borrows
        WHERE return_date IS NULL 
          AND due_date < CURRENT_DATE
    LOOP
  
        
        v_days_overdue := EXTRACT(DAY FROM v_borrow_record.days_overdue);
        v_fine_amount := v_days_overdue * 0.50;

       
        IF NOT EXISTS (
            SELECT 1 FROM fines WHERE borrow_id = v_borrow_record.borrow_id
        ) THEN
            -- new fine up[dated]
            INSERT INTO fines (borrow_id, member_id, fine_amount, paid_status, issued_date)
            VALUES (
                v_borrow_record.borrow_id,
                v_borrow_record.member_id,
                v_fine_amount,
                FALSE,  -- Unpaid
                CURRENT_DATE
            );
        END IF;
    END LOOP;

    -- Update the status of overdue borrows in the borrows table
    UPDATE borrows
    SET status = 'OVERDUE'
    WHERE return_date IS NULL AND due_date < CURRENT_DATE;
END;
$$;

--testing 
CALL process_overdue_fines();