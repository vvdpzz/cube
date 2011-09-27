/*Usage: 
1 create this stored procedure in your database
2 Usage in MySQL: mysql> call sp_deduct_credit_and_money ('test','test',1,0,10.00)
3 Usage in Rails: ActiveRecord::Base.connection.execute("call sp_deduct_credit_and_money('#{title}','#{content}',#{id},#{credit},#{money})") @question_controller.rb
*/
/* Drop if Exists */
DROP PROCEDURE IF EXISTS sp_strong_create_pay_answer

/* Crete Stored Procedure*/
# 1 Answer: add an answer
# 2 User: deduct 5 credits
# 3 CreditTransaction

DELIMITER //
CREATE PROCEDURE sp_strong_create_pay_answer (
	in answer_id bigint,
	in question_id bigint,
	in user_id int,
	in content text,
	in answer_price int)
BEGIN
START TRANSACTION;
INSERT INTO answers (id, user_id, question_id, content) VALUES (answer_id, user_id, question_id, content, answer_price);
UPDATE users SET updated_at = NOW(), credit = credit - answer_price WHERE id = user_id;
INSERT INTO credit_transactions (answer_id, created_at, payment, question_id, trade_status, trade_type, updated_at, user_id, value, winner_id) 
VALUES (answer_id, NOW(), 1, question_id, 0, 0, NOW(), user_id, answer_price, NULL);
COMMIT;
END