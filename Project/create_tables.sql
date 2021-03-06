CREATE DATABASE print_service;
USE print_service;

-- Создаем таблицу устройств
DROP TABLE IF EXISTS devices;
CREATE TABLE devices(
  id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
  s_n VARCHAR(30) NOT NULL UNIQUE COMMENT 'Серийный номер',
  name VARCHAR(100) NOT NULL COMMENT 'Название устройства',
  type_id INT UNSIGNED COMMENT 'Тип устройства',
  vendor_id INT UNSIGNED COMMENT 'Производитель',
  client_id INT UNSIGNED COMMENT 'Клиент, у которого находится устройство',
  location_id INT UNSIGNED COMMENT 'Локация (где находится устройство)',
  status_id INT UNSIGNED COMMENT 'Статус устройства',
  user_id INT UNSIGNED COMMENT 'Пользователь, добавивший устройство',
  on_warranty BOOL DEFAULT FALSE COMMENT 'Находится ли устройство на гарантии.',
  counter INT UNSIGNED DEFAULT 0 COMMENT 'Текущее значение счетчика',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
  );
 
-- Создаем таблицу типов устройств
DROP TABLE IF EXISTS device_types;
CREATE TABLE device_types(
  id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
  name VARCHAR(30) NOT NULL
  );

 -- Создаем таблицу статусов устройств
DROP TABLE IF EXISTS device_statuses;
CREATE TABLE device_statuses(
  id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
  name VARCHAR(100) NOT NULL
  );
 
-- Создаем таблицу производителей
DROP TABLE IF EXISTS vendors;
CREATE TABLE vendors(
  id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
  name VARCHAR(50) NOT NULL
  );

 -- Создаем таблицу компонентов
DROP TABLE IF EXISTS components;
CREATE TABLE components(
  id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
  s_n VARCHAR(30) NOT NULL DEFAULT 'None' COMMENT 'Серийный номер компонента',
  directory_id INT UNSIGNED COMMENT 'id компонента в справочнике',
  work_id INT UNSIGNED COMMENT 'id работы, в которой был использован компонент',
  user_id INT UNSIGNED COMMENT 'id пользователя, добавившего компонент',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
  );
  
 -- Создаем справочник компонентов
DROP TABLE IF EXISTS components_directory;
CREATE TABLE components_directory(
  id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
  name VARCHAR(100) NOT NULL
  );

-- Создаем таблицу работ
DROP TABLE IF EXISTS works;
CREATE TABLE works(
  id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
  directory_id INT UNSIGNED COMMENT 'id работы в справочнике',
  device_id INT UNSIGNED COMMENT 'id устройства по которому производились работы',
  user_id INT UNSIGNED COMMENT 'id пользователя, добавившего работу',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
  );
  
 -- Создаем справочник работ
DROP TABLE IF EXISTS works_directory;
CREATE TABLE works_directory(
  id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
  name VARCHAR(100) NOT NULL
  );

-- Создаем талицу клиентов
DROP TABLE IF EXISTS clients;
CREATE TABLE clients(
  id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
  name VARCHAR(50) NOT NULL
  );

-- Создаем таблицу локаций
DROP TABLE IF EXISTS locations;
CREATE TABLE locations(
  id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  city_id INT UNSIGNED NOT NULL,
  address VARCHAR(100) NOT NULL,
  phone VARCHAR(100) NOT NULL,
  client_id INT UNSIGNED NOT NULL
  );

-- Создаем таблицу городов
DROP TABLE IF EXISTS cities;
CREATE TABLE cities(
  id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
  name VARCHAR(50) NOT NULL
  ); 
 
 
-- Создаем таблицу документов
DROP TABLE IF EXISTS documents;
CREATE TABLE documents(
  id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
  name VARCHAR(100) NOT NULL COMMENT 'название документа',
  work_id INT UNSIGNED COMMENT 'id работы, к которой относится документ',
  url VARCHAR(255) NOT NULL COMMENT 'URL по которому находится файл документа',
  user_id INT UNSIGNED COMMENT 'id пользователя, добавившего документ',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
  );

-- Создаем таблицу показаний счетчиков. Показания счётчиков не подлежат обновлению, поэтому поля updated_at нет. 
-- Каждое показание - отдельная запись, чтобы можно было видеть всю историю.
DROP TABLE IF EXISTS counters;
CREATE TABLE counters(
  id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
  device_id INT UNSIGNED NOT NULL COMMENT 'id устройства к которому относится счётчик',
  counter INT UNSIGNED DEFAULT 0 COMMENT 'показания счётчика',
  user_id INT UNSIGNED COMMENT 'id пользователя, добавившего показание счетчика',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP 
  );
  
-- Создаем таблицу гарантийных сроков
DROP TABLE IF EXISTS warranties;
CREATE TABLE warranties(
  id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
  device_id INT UNSIGNED NOT NULL COMMENT 'id устройства',
  start_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'дата начала гарантийного срока',
  end_date DATE NOT NULL COMMENT 'дата окончания гарантийного срока',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
  );

-- Создаем таблицу пользователей
DROP TABLE IF EXISTS users;
CREATE TABLE users(
  id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
  name VARCHAR(50) NOT NULL COMMENT 'имя пользователя',
  role_id INT UNSIGNED COMMENT 'роль пользователя',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
  );
  
-- Создаем таблицу ролей пользователей (для ограничений прав доступа)
DROP TABLE IF EXISTS user_roles;
CREATE TABLE user_roles(
  id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
  name VARCHAR(30) NOT NULL
  );
  
 -- Создаем внешние ключи