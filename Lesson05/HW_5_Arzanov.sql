-- Практическое задание по теме “Операторы, фильтрация, сортировка и ограничение”

CREATE DATABASE hw05;
USE hw05;

-- Задание 1. Пусть в таблице users поля created_at и updated_at оказались незаполненными.
-- Заполните их текущими датой и временем.

DROP TABLE IF EXISTS users;
CREATE TABLE users(
	id INT UNSIGNED UNIQUE AUTO_INCREMENT NOT NULL PRIMARY KEY,
	name VARCHAR(50),
	created_at DATETIME,
	updated_at DATETIME
);

INSERT INTO users (name, created_at, updated_at)
VALUES
	('Artur', NULL, NULL),
	('Andrey', NULL, NULL),
	('Timofey', NULL, NULL),
	('Olga', NULL, NULL),
	('Svetlana', NULL, NULL)
;
	
SELECT * FROM users;

UPDATE users
SET
	created_at = NOW(),
	updated_at = NOW();
	
-- Задание 2. Таблица users была неудачно спроектирована. Записи created_at и updated_at были заданы типом VARCHAR 
-- и в них долгое время помещались значения в формате "20.10.2017 8:10".
-- Необходимо преобразовать поля к типу DATETIME, сохранив введеные ранее значения.

DROP TABLE IF EXISTS users;
CREATE TABLE users(
	id INT UNSIGNED UNIQUE AUTO_INCREMENT NOT NULL PRIMARY KEY,
	name VARCHAR(50),
	created_at VARCHAR(50),
	updated_at VARCHAR(50)
);

INSERT INTO users (name, created_at, updated_at)
VALUES
	('Artur', '20.10.2017 8:10', '20.10.2017 8:10'),
	('Andrey', '20.10.2017 8:10', '20.10.2017 8:10'),
	('Timofey', '20.10.2017 8:10', '20.10.2017 8:10'),
	('Olga', '20.10.2017 8:10', '20.10.2017 8:10'),
	('Svetlana', '20.10.2017 8:10', '20.10.2017 8:10')
;
	
SELECT * FROM users;

UPDATE
	users
SET
	created_at = STR_TO_DATE(created_at, '%d.%m.%Y %k:%i'),
	updated_at = STR_TO_DATE(updated_at, '%d.%m.%Y %k:%i');

ALTER TABLE users
CHANGE
	created_at created_at DATETIME DEFAULT CURRENT_TIMESTAMP;

ALTER TABLE users
CHANGE
	updated_at updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;


-- Задание 3. В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры:
-- 0, если товар закончился и выше нуля, если на складе имеются запасы. 
-- Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения значения value.
-- Однако, нулевые запасы должны выводиться в конце, после всех записей.

DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products (
  id SERIAL PRIMARY KEY,
  storehouse_id INT UNSIGNED,
  product_id INT UNSIGNED,
  value INT UNSIGNED COMMENT 'Запас товарной позиции на складе',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Запасы на складе';

INSERT INTO
  storehouses_products (storehouse_id, product_id, value)
VALUES
  (1, 543, 0),
  (1, 789, 2500),
  (1, 3432, 0),
  (1, 826, 30),
  (1, 719, 500),
  (1, 638, 1);
 
SELECT * FROM storehouses_products
ORDER BY IF(value > 0, 0, 1), value;

-- Задание 4. (по желанию) Из таблицы users необходимо извлечь пользователей, родившихся в августе и мае. 
-- Месяцы заданы в виде списка английских названий ('may', 'august')

SELECT name  
  FROM users
  WHERE DATE_FORMAT(birthday_at, '%M') IN ('may', 'august');
 
-- Задание 5. (по желанию) Из таблицы catalogs извлекаются записи при помощи запроса. 
-- SELECT * FROM catalogs WHERE id IN (5, 1, 2);
-- Отсортируйте записи в порядке, заданном в списке IN.

DROP TABLE IF EXISTS catalogs;
CREATE TABLE catalogs (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название раздела',
  UNIQUE unique_name(name(10))
) COMMENT = 'Разделы интернет-магазина';

INSERT INTO catalogs VALUES
  (NULL, 'Процессоры'),
  (NULL, 'Материнские платы'),
  (NULL, 'Видеокарты'),
  (NULL, 'Жесткие диски'),
  (NULL, 'Оперативная память');

SELECT * FROM catalogs WHERE id IN (5, 1, 2) ORDER BY IF(id > 2, 0, 1), id; -- вариант 1
SELECT * FROM catalogs WHERE id IN (5, 1, 2) ORDER BY FIELD(id, 5, 1, 2); -- вариант 2



-- Практическое задание теме “Агрегация данных”
-- Задание 1. Подсчитайте средний возраст пользователей в таблице users

 DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Покупатели';

INSERT INTO users (name, birthday_at) VALUES
  ('Геннадий', '1990-10-05'),
  ('Наталья', '1984-11-12'),
  ('Александр', '1985-05-20'),
  ('Сергей', '1988-02-14'),
  ('Иван', '1998-01-12'),
  ('Мария', '1992-08-29');
 
 SELECT AVG(DATE_FORMAT(NOW(), '%Y') - DATE_FORMAT(birthday_at, '%Y')) AS age FROM users; -- вариант 1
 SELECT AVG(TIMESTAMPDIFF(YEAR, birthday_at, NOW())) AS age FROM users;  -- вариант 2
 
 -- Задание 2. Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели. 
 -- Следует учесть, что необходимы дни недели текущего года, а не года рождения.
 

SELECT
  DATE_FORMAT(DATE(CONCAT_WS('-', YEAR(NOW()), MONTH(birthday_at), DAY(birthday_at))), '%W') AS day,
  COUNT(*) AS total
FROM
  users
GROUP BY
  day
ORDER BY
  total DESC;

-- Задание 3. (по желанию) Подсчитайте произведение чисел в столбце таблицы

INSERT INTO catalogs VALUES
  (NULL, 'Процессоры'),
  (NULL, 'Материнские платы'),
  (NULL, 'Видеокарты'),
  (NULL, 'Жесткие диски'),
  (NULL, 'Оперативная память');

SELECT ROUND(EXP(SUM(LN(id)))) FROM catalogs;
