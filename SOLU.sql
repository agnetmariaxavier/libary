select * from books;
select * from branch;
select * from employees;
select * from issued_status;
select * from members;
select * from return_status;

-- Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.'


INSERT INTO books
VALUES('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
SELECT * FROM books;


-- Update an Existing Member's Address

update members
SET member_address = '124main'
WHERE member_id = 'C101';

--  Delete a Record from the Issued Status Table -- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

delete from issued_status WHERE issued_id= 'IS121';

 -- Retrieve All Books Issued by a Specific Employee -- Objective: Select all books issued by the employee with emp_id = 'E101'
 
 select * FROM issued_status
 where issued_emp_id ='E101';
 
-- Task 5: List Members Who Have Issued More Than One Book -- Objective: Use GROUP BY to find members who have issued more than one book.

SELECT issued_emp_id,
COUNT(*) from issued_status
group by 1
having count(*) >1 ;


CREATE TABLE book_issued_cnt AS
SELECT b.isbn, b.book_title, COUNT(ist.issued_id) AS issue_count
FROM issued_status as ist
JOIN books as b
ON ist.issued_book_isbn = b.isbn
GROUP BY b.isbn, b.book_title;
select * from book_issued_cnt;
drop table book_issued_cnt;

UPDATE members
SET member_address =' 124 Main'
WHERE member_id ='C101';

update members 
set member_address = '123polliyo'
WHERE member_id ='C102';

SELECT * FROM MEMBERS;

-- Task 5: List Members Who Have Issued More Than One Book -- Objective: Use GROUP BY to find members who have issued more than one book.

select issued_emp_id,
count(*) FROM issued_status
group by 1
Having count(*)>1;


-- Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**

CREATE TABLE summary AS 
SELECT b.book_title, b.isbn, count(ist.issued_emp_id) as issued_count 
FROM issued_status as ist
JOIN books as b
ON b.isbn = ist.issued_book_isbn
group by 1, 2;


SELECT b.contact_no, boo.isbn, m.member_name
FROM branch as b
JOIN members as m
JOIN books as boo
JOIN employees as emp
JOIN issued_status as iss
ON b.branch_id = emp.branch_id
AND emp.emp_id = iss.issued_emp_id
AND iss.issued_book_isbn = boo.isbn
AND iss.issued_member_id = m.member_id ;


-- Task 7. Retrieve All Books in a Specific Category:

select *
from books
where category = 'children';

select * from books
where category ='classic';

-- Task 8: Find Total Rental Income by Category:

select b.category,
sum(b.rental_price ),
count(*) as count  from issued_status as ist
 Join books as b
 on b.isbn = ist.issued_book_isbn
 group by 1
;

-- List Employees with Their Branch Manager's Name and their branch details:

select e.emp_id, e.emp_name, b.manager_id, b.branch_address
from employees as e
Join branch as b
ON b.branch_id = e.branch_id;

--  Retrieve the List of Books Not Yet Returned

select * from issued_status as ist
LEFT JOIN return_status  as r
ON r.issued_id =ist.issued_id 
WHERE r.return_id IS NULL;


-- Task 13: Identify Members with Overdue Books
-- Write a query to identify members who have overdue books (assume a 30-day return period). Display the member's_id, member's name, book title, issue date, and days overdue.


select i.issued_member_id, m.member_name, b.book_title, i.issued_date,
CURRENT_DATE,
DATEDIFF(CURRENT_DATE, i.issued_date) AS over_due_days
FROM 
issued_status as i 
JOIN books as b
ON b.isbn = i.issued_book_isbn
JOIN members as m
ON m.member_id =i.issued_member_id
LEFT JOIN return_status as r
ON r.issued_id = i.issued_id

WHERE 
    r.return_date IS NULL
    AND DATEDIFF(CURRENT_DATE, i.issued_date) > 30
ORDER BY 
    i.issued_member_id;
    
    
    -- List Members Who Registered in the Last 180 Days:
    SELECT * FROM members
WHERE reg_date <= CURRENT_DATE - INTERVAL 180 DAY;

-- Task 14: Update Book Status on Return
-- Write a query to update the status of books in the books table to "Yes" when they are returned (based on entries in the return_status table).


    









