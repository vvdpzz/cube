/*Usage: 
1 create this stored procedure in your database
2 Usage in MySQL: mysql> call sp_deduct_credit_and_money ('test','test',1,0,10.00)
3 Usage in Rails: ActiveRecord::Base.connection.execute("call sp_deduct_credit_and_money('#{title}','#{content}',#{id},#{credit},#{money})") @question_controller.rb
*/
/* Drop if Exists */
DROP PROCEDURE IF EXISTS strong_mail_insert

/* Crete Stored Procedure*/
# 1 Answer: add an answer
# 2 User: deduct 5 credits
# 3 CreditTransaction

DELIMITER //
CREATE PROCEDURE sp_strong_mail_insert (
	  in batch_id         int
	, in sender_id        int
	, in sender_name      varchar(255)
	, in receiver_id      int
	, in receiver_name    varchar(255)
	, in title            varchar(255)
	, in content          text
	, in redis_mail       varchar(30)
	)
BEGIN
declare mail_id int;
START TRANSACTION;
INSERT INTO mails (batch_id, sender_id, sender_name, receiver_id, receiver_name, title, content, redis_mail) 
     VALUES (batch_id, sender_id, sender_name, receiver_id, receiver_name, title, content, redis_mail);
select id into mail_id from mails order by id desc limit 1;
INSERT INTO mail_inboxes (user_id, batch_id, mail_id, redis_mail) VALUES (  sender_id, batch_id, mail_id, redis_mail);
INSERT INTO mail_inboxes (user_id, batch_id, mail_id, redis_mail) VALUES (receiver_id, batch_id, mail_id, redis_mail);
COMMIT;
END
