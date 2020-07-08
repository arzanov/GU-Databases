# Домашнее задание к уроку 9
## Практическое задание по теме “Транзакции, переменные, представления”
**Задание 1.** В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных.
Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте транзакции.

```sql
START TRANSACTION;
INSERT INTO sample.users (name, birthday_at, created_at, updated_at) 
	SELECT name, birthday_at, created_at, updated_at 
		FROM shop.users WHERE id = 1;
DELETE FROM shop.users WHERE id = 1;
COMMIT;
```
**Задание 2.** Создайте представление, которое выводит название name товарной позиции из таблицы products и соответствующее название каталога name из таблицы catalogs.
```sql
USE shop;
CREATE VIEW prod_cat AS 
	SELECT p.name AS product, c.name AS catalog 
		FROM products p
		LEFT JOIN catalogs c
		ON p.catalog_id = c.id;
SELECT * FROM prod_cat;
```

**Задание 3.** (по желанию) Пусть имеется таблица с календарным полем created_at. В ней размещены разряженые календарные записи за август 2018 года '2018-08-01', '2018-08-04', '2018-08-16' и 2018-08-17. Составьте запрос, который выводит полный список дат за август, выставляя в соседнем поле значение 1, если дата присутствует в исходном таблице и 0, если она отсутствует.
```sql
-- Создаём и заполняем таблицу с датами из задания

DROP TABLE IF EXISTS my_dates;
CREATE TABLE my_dates(
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    created_at DATE);

INSERT INTO my_dates(created_at) VALUES
	('2018-08-01'),
	('2018-08-04'),
	('2018-08-16'),
	('2018-08-17');

-- Таблицу с полным перечнем дат за август 2018 создаём с помощью процедуры

DROP TABLE IF EXISTS dates_interval;
DROP PROCEDURE IF EXISTS get_dates_interval;
CREATE TABLE dates_interval (id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY, dates DATE);
DELIMITER //
CREATE   PROCEDURE  get_dates_interval (IN from_date DATE, IN to_date DATE) 
BEGIN
  DECLARE i DATE DEFAULT from_date;
  WHILE i <= to_date DO
    INSERT INTO dates_interval (dates) VALUES (i);
    SET i = i + INTERVAL 1 DAY;
  END WHILE;
END//
DELIMITER ;

CALL get_dates_interval('2018-08-01', '2018-08-31');

-- Соединяем обе таблицы через левый JOIN и вставляем 0 и 1 по условию равенства значений

SELECT di.id, di.dates, IF (di.dates = md.created_at, 1, 0) AS is_in_my_dates FROM dates_interval di
	LEFT JOIN my_dates md
	ON di.dates = md.created_at
	ORDER BY di.dates;
```

**Задание 4.** (по желанию) Пусть имеется любая таблица с календарным полем created_at. Создайте запрос, который удаляет устаревшие записи из таблицы, оставляя только 5 самых свежих записей.
```sql
START TRANSACTION;
	SELECT @oldest := created_at FROM dates_interval ORDER BY dates DESC LIMIT 5;
	DELETE FROM dates_interval WHERE created_at > @oldest;
COMMIT;
```

## Практическое задание по теме “Хранимые процедуры и функции, триггеры"
**Задание 1.** Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток. С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".

```sql
DROP FUNCTION IF EXISTS hello ();

DELIMITER //

CREATE FUNCTION hello()
RETURNS TEXT NO SQL
BEGIN
	DECLARE hour INT;
	SET hour = HOUR(NOW());
	IF (hour BETWEEN 6 AND 11) THEN RETURN 'Доброе утро';
	ELSEIF (hour BETWEEN 12 AND 18) THEN RETURN 'Добрый день';
	ELSEIF (hour BETWEEN 0 AND 5) THEN RETURN 'Доброй ночи';
	ELSE RETURN 'Добрый вечер';
	END IF;
END//


DELIMITER ;

SELECT NOW(), hello();
```
**Задание 2.** В таблице products есть два текстовых поля: name с названием товара и description с его описанием. Допустимо присутствие обоих полей или одно из них. Ситуация, когда оба поля принимают неопределенное значение NULL неприемлема. Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены. При попытке присвоить полям NULL-значение необходимо отменить операцию.
```sql
DELIMITER //

CREATE TRIGGER validate_name_description_insert BEFORE INSERT ON products
FOR EACH ROW BEGIN
  IF NEW.name IS NULL AND NEW.description IS NULL THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Both name and description are NULL';
  END IF;
END//

INSERT INTO products
  (name, description, price, catalog_id)
VALUES
  (NULL, NULL, 9360.00, 2)//

INSERT INTO products
  (name, description, price, catalog_id)
VALUES
  ('ASUS PRIME Z370-P', 'HDMI, SATA3, PCI Express 3.0,, USB 3.1', 9360.00, 2)//

INSERT INTO products
  (name, description, price, catalog_id)
VALUES
  (NULL, 'HDMI, SATA3, PCI Express 3.0,, USB 3.1', 9360.00, 2)//

CREATE TRIGGER validate_name_description_update BEFORE UPDATE ON products
FOR EACH ROW BEGIN
  IF NEW.name IS NULL AND NEW.description IS NULL THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Both name and description are NULL';
  END IF;
END//
```

**Задание 3.** (по желанию) Напишите хранимую функцию для вычисления произвольного числа Фибоначчи. Числами Фибоначчи называется последовательность в которой число равно сумме двух предыдущих чисел. Вызов функции FIBONACCI(10) должен возвращать число 55.
```sql
DELIMITER //

CREATE FUNCTION FIBONACCI(num INT)
RETURNS INT DETERMINISTIC
BEGIN
  DECLARE fs DOUBLE;
  SET fs = SQRT(5);

  RETURN (POW((1 + fs) / 2.0, num) + POW((1 - fs) / 2.0, num)) / fs;
END//

SELECT FIBONACCI(10)//
```
