select * from books;
select * from branch;
select * from employees;
select * from issued_status;
select * from members;
select * from return_status;

-- Write a query to update the status of books in the books table to "Yes" when they are returned (based on entries in the return_status table)

select*  FROM books
where isbn = '978-0-451-52994-2';

UPDATE books
SET status ='no'
WHERE isbn = '978-0-451-52994-2';

select * from issued_status
where issued_book_isbn = '978-0-451-52994-2';
select * from return_status
where issued_id ='IS130';

--
insert into return_status(return_id, issued_id, return_date)
VALUES ('RS532', 'IS130', CURRENT_DATE);

select * from return_status
where issued_id ='IS130';


DELIMITER $$

CREATE PROCEDURE add_return_records(
    IN p_return_id VARCHAR(10), 
    IN p_issued_id VARCHAR(10), 
    IN p_book_quality VARCHAR(10)
)
BEGIN
    DECLARE v_isbn VARCHAR(50);
    DECLARE v_book_name VARCHAR(80);

    -- Insert return record
    INSERT INTO return_status(return_id, issued_id, return_date, book_quality)
    VALUES (p_return_id, p_issued_id, CURRENT_DATE, p_book_quality);

    -- Get book details
    SELECT issued_book_isbn, issued_book_name
    INTO v_isbn, v_book_name
    FROM issued_status
    WHERE issued_id = p_issued_id;

    -- Update book status
    UPDATE books
    SET status = 'yes'
    WHERE isbn = v_isbn;

    -- Optional: simulate a message (MySQL doesn't support RAISE NOTICE)
    SELECT CONCAT('Thank you for returning the book: ', v_book_name) AS message;
END$$

DELIMITER ;

DROP PROCEDURE IF EXISTS add_return;

DELIMITER $$
CREATE PROCEDURE add_return
(IN p_return_id VARCHAR(10), 
IN p_issued_id VARCHAR(10))

BEGIN
DECLARE v_isbn VARCHAR(50);
DECLARE v_book_name VARCHAR(80);

INSERT INTO return_status (return_id, issued_id,return_date)
VALUES (p_return_id, p_issued_id, CURRENT_DATE);

SELECT issued_book_isbn, issued_book_name
INTO v_isbn, v_book_name
FROM issued_status
WHERE issued_id = p_issued_id;

UPDATE books
SET status = 'yes'
WHERE isbn = v_isbn;

SELECT CONCAT('thank you for returing the book: ', v_book_name) as message;
END $$

DELIMITER ;



SHOW PROCEDURE STATUS LIKE 'add_return';
CALL add_return('RS101', 'IS101');


DELETE FROM return_status
WHERE return_id = 'RS101'
LIMIT 1;

CALL add_return('RS101', 'IS101');
SELECT * FROM return_status WHERE return_id = 'RS101';

SELECT * FROM books
WHERE isbn = '978-0-307-58837-1';

CALL add_return('RS138', 'IS135');
CALL add_return('RS148', 'IS140');



DELIMITER $$

CREATE PROCEDURE issue_book (
    IN p_issued_id VARCHAR(10), 
    IN p_issued_member_id VARCHAR(30), 
    IN p_issued_book_isbn VARCHAR(30), 
    IN p_issued_emp_id VARCHAR(10)
)
BEGIN
    DECLARE v_status VARCHAR(10);

    -- Check if the book is available
    SELECT status INTO v_status
    FROM books
    WHERE isbn = p_issued_book_isbn;

    IF v_status = 'yes' THEN
        -- Insert issue record
        INSERT INTO issued_status (issued_id, issued_member_id, issued_date, issued_book_isbn, issued_emp_id)
        VALUES (p_issued_id, p_issued_member_id, CURRENT_DATE, p_issued_book_isbn, p_issued_emp_id);

        -- Update book status to 'no'
        UPDATE books
        SET status = 'no'
        WHERE isbn = p_issued_book_isbn;

        -- Show success message
        SELECT CONCAT('Book records added successfully for book ISBN: ', p_issued_book_isbn) AS message;
    ELSE
        -- Show unavailable message
        SELECT CONCAT('Sorry, the book is unavailable. ISBN: ', p_issued_book_isbn) AS message;
    END IF;
END$$

DELIMITER ;


CALL issue_book('IS155', 'C108', '978-0-553-29698-2', 'E104');
CALL issue_book('IS156', 'C108', '978-0-375-41398-8', 'E104');