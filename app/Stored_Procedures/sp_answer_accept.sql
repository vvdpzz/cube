/*Usage: 
1 create this stored procedure in your database
2 Usage in MySQL: mysql> call sp_deduct_credit_and_money ('test','test',1,0,10.00)
3 Usage in Rails: ActiveRecord::Base.connection.execute("call sp_deduct_credit_and_money('#{title}','#{content}',#{id},#{credit},#{money})") @question_controller.rb
*/
/* Drop if Exists */
DROP PROCEDURE IF EXISTS sp_answer_accept

/* Crete Stored Procedure*/
# 1 User: add credit and/or money to user table
# 2 CreditTransaction and/or MoneyTransaction
# 3 Question: mark correct answer
# 4 Answer: mark is correct answer

DELIMITER //
CREATE PROCEDURE sp_answer_accept (
	in question_id bigint,
	in answer_id bigint,
	in user_id int,
	in deduct_credit int,
	in deduct_money DECIMAL(8,2))
BEGIN
IF deduct_credit = 0 AND deduct_money =0.00 THEN
    START TRANSACTION;
    UPDATE questions SET correct_answer_id = answer_id WHERE id = question_id;
    UPDATE answers SET is_correct = true WHERE id = answer_id;
    COMMIT;
ELSE IF deduct_credit > 0 AND deduct_money =0.00 THEN
	START TRANSACTION;
	UPDATE users SET credit = credit + deduct_credit WHERE id = user_id;
	INSERT INTO credit_transactions (answer_id, user_id, value)	VALUES (answer_id, user_id, deduct_credit);
	UPDATE questions SET correct_answer_id = answer_id WHERE id = question_id;
	UPDATE answers SET is_correct = true WHERE id = answer_id;
	COMMIT;
ELSE IF deduct_credit = 0 AND deduct_money > 0.00 THEN
    START TRANSACTION;
    UPDATE users SET money = money + deduct_money WHERE id = user_id;
    INSERT INTO money_transactions (answer_id, user_id, value) VALUES (answer_id, user_id, deduct_money);
    UPDATE questions SET correct_answer_id = answer_id WHERE id = question_id;
    UPDATE answers SET is_correct = true WHERE id = answer_id;
    COMMIT;
ELSE IF deduct_credit > 0 AND deduct_money > 0.00 THEN
    START TRANSACTION;
    UPDATE users SET credit = credit + deduct_credit, money = money + deduct_money WHERE id = user_id;
    INSERT INTO credit_transactions (answer_id, user_id, value) VALUES (answer_id, user_id, deduct_credit);
	INSERT INTO money_transactions (answer_id, user_id, value) VALUES (answer_id, user_id, deduct_money);
    UPDATE questions SET correct_answer_id = answer_id WHERE id = question_id;
    UPDATE answers SET is_correct = true WHERE id = answer_id;
    COMMIT;
end if;
end if;
end if;
end if;
END