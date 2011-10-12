#Usage
mysql> select hot(10,1,now());
    -> |
+-----------------+
| hot(10,1,now()) |
+-----------------+
|            4100 |
+-----------------+
1 row in set (0.01 sec)

#Run below in MySQL to create the FUNCTION
DELIMITER |
CREATE FUNCTION hot (ups INT, downs INT, time datetime)
  RETURNS INT
   DETERMINISTIC
    BEGIN
     DECLARE avg INT;
     set avg = round((log(greatest(abs(ups - downs), 1)) + sign(ups - downs) *(unix_timestamp(time) - 1134028003) / 45000),7);
     RETURN avg;
    END|