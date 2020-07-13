# Домашнее задание к уроку 11
## Практическое задание по теме “Оптимизация запросов”
**Задание 1 -** Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users, catalogs и products в таблицу logs помещается время и дата создания записи, название таблицы, идентификатор первичного ключа и содержимое поля name.
```sql
-- Создаём  таблицу логов
DROP TABLE IF EXISTS logs;
CREATE TABLE logs (
	id INT UNSIGNED UNIQUE AUTO_INCREMENT PRIMARY KEY,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP, 
	table_name VARCHAR(30),
	pk_id INT UNSIGNED NOT NULL, 
	name VARCHAR(100)
  ) ENGINE = Archive;

-- Создаём триггеры

DELIMITER //

CREATE TRIGGER users_insert AFTER INSERT ON users
FOR EACH ROW BEGIN
	INSERT INTO logs(table_name, pk_id, name) VALUES ('users', NEW.id, NEW.name);
END//

CREATE TRIGGER catalogs_insert AFTER INSERT ON catalogs
FOR EACH ROW BEGIN
	INSERT INTO logs(table_name, pk_id, name) VALUES ('catalogs', NEW.id, NEW.name);
END//

CREATE TRIGGER products_insert AFTER INSERT ON products
FOR EACH ROW BEGIN
	INSERT INTO logs(table_name, pk_id, name) VALUES ('products', NEW.id, NEW.name);
END//

DELIMITER ;
```
