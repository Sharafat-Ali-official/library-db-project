# 📚 Library Management System - Database Project

This is a complete PostgreSQL database designed for a library. It handles book borrowing, overdue fines, member tracking, and provides analytical dashboards for management. 

**Role:** Junior Database Developer (Portfolio Project)

---

## 🛠️ Tech Stack
- **Database:** PostgreSQL 16
- **Tools:** DBeaver / Neon.tech (Cloud)
- **Version Control:** Git & GitHub

---

## 🗂️ Database Schema (ERD Summary)

- **`members`** – Stores library members (name, email, membership date).
- **`books`** – Stores book inventory (title, author, ISBN, genre).
- **`borrows`** – Transaction table linking members and books. Tracks borrow date, due date, return date, and status.
- **`fines`** – Stores overdue fines linked to specific borrows.

---

## ⚙️ Core Business Logic (Functions)

### 1. `borrow_book(p_member_id, p_book_id)`
- Checks if the member has borrowed less than 5 books.
- Checks if the book is currently available (not borrowed by someone else).
- If both pass, inserts a new borrow record with a 14-day due date.
- **Usage:** `SELECT borrow_book(1, 7);`

### 2. `process_overdue_fines()`
- Scans all active borrows that are past their due date.
- Calculates a fine of **$0.50 per day** overdue.
- Inserts the fine into the `fines` table (prevents duplicate fines).
- Updates the borrow status to `OVERDUE`.
- **Usage:** `CALL process_overdue_fines();`

---

## 📊 Analytics Views (Reports)

### `v_top_books`
Shows the top 3 most borrowed books using a CTE and `RANK()` window function.

### `v_member_activity`
Shows member borrowing habits:
- Total books borrowed.
- Currently active borrows.
- Average return days (for returned books).
- Total unpaid fines.

---

## 🚀 How to Run This Project

1. **Clone the repository:**
   ```bash
   git clone https://github.com/Sharafat_Ali_official/library-db-project.git