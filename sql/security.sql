-- =============================================
-- PHASE 7: SECURITY (Neon-Compatible Passwords)
-- =============================================

-- 1. Analyst Role (Read-Only)
-- Password: Contains uppercase, lowercase, number, special char
CREATE ROLE analyst WITH LOGIN PASSWORD 'Analyst@2026#Secure';
GRANT CONNECT ON DATABASE postgres TO analyst;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO analyst;
GRANT SELECT ON ALL SEQUENCES IN SCHEMA public TO analyst;
GRANT SELECT ON v_top_books TO analyst;
GRANT SELECT ON v_member_activity TO analyst;

-- 2. App User Role (Read/Write Data)
CREATE ROLE app_user WITH LOGIN PASSWORD 'AppUser@2026#Pass';
GRANT CONNECT ON DATABASE postgres TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO app_user;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO app_user;
GRANT EXECUTE ON FUNCTION borrow_book(integer, integer) TO app_user;
GRANT EXECUTE ON PROCEDURE process_overdue_fines() TO app_user;

-- 3. Admin Role (Full Control)
CREATE ROLE admin WITH LOGIN PASSWORD 'Admin@2026#Root';
GRANT CONNECT ON DATABASE postgres TO admin;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO admin;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO admin;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public TO admin;

-- 4. Set Default Privileges (Future-proofing)
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO analyst;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO app_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL PRIVILEGES ON TABLES TO admin;

-- 5. Verify the roles were created successfully
SELECT usename FROM pg_user ORDER BY usename;