# Домашнее задание к уроку 10
## Индексы
**Задание 1.** - Проанализировать какие запросы могут выполняться наиболее часто в процессе работы приложения и добавить необходимые индексы.  
```sql
-- Таблица users

-- Уникальный индекс по email. Для снижения нагрузки на базу при логине:
CREATE UNIQUE INDEX users_email_uq ON users (email);

-- Составной индекс на имя и фамилию. Ускорит выдачу при поисковых запросах:
CREATE INDEX users_first_name_last_name_idx ON users (first_name, last_name);

-- Таблица profiles

-- Обычные  индексы по полям gender, city, country, birthday. Ускорит работу фильтров при поиске по полу, локации и по возрастному интервалу:
CREATE INDEX profiles_gender_idx ON profiles (gender);
CREATE INDEX profiles_country_idx ON profiles (country);
CREATE INDEX profiles_city_idx ON profiles (city);
CREATE INDEX profiles_birthday_idx ON profiles (birthday);

-- Таблица messages

-- Составной индекс по полям from_user_id и to_user_id. Ускорит вывод переписки пользователя:
CREATE INDEX messages_from_user_id_to_user_id_idx ON messages (from_user_id, to_user_id);

-- Таблица posts

-- Составные индексы на user_id, media_id, community_id и id. 
-- Позволит снизить нагрузку на базу и ускорить вывод (посты пользователя, медиафайлы к посту, посты группы):
CREATE INDEX posts_user_id_id_idx ON posts (user_id, id);
CREATE INDEX posts_media_id_id_idx ON posts (media_id, id);
CREATE INDEX posts_community_id_id_idx ON posts (community_id, id);
```
## Оконные функции
**Задание 2.** - Построить запрос, который будет выводить следующие столбцы:
* имя группы
* среднее количество пользователей в группах
* самый молодой пользователь в группе
* самый старший пользователь в группе
* общее количество пользователей в группе
* всего пользователей в системе
* отношение в процентах (общее количество пользователей в группе / всего пользователей в системе) * 100
```sql
SELECT DISTINCT communities.name,
  ROUND(COUNT(communities_users.user_id) OVER () / (SELECT COUNT(1) FROM communities)) AS average,
  CONCAT(FIRST_VALUE(users.first_name) OVER (PARTITION BY communities_users.community_id ORDER BY profiles.birthday DESC), ' ',
  		 FIRST_VALUE(users.last_name) OVER (PARTITION BY communities_users.community_id ORDER BY profiles.birthday DESC)) AS youngest,
  CONCAT(FIRST_VALUE(users.first_name) OVER (PARTITION BY communities_users.community_id ORDER BY profiles.birthday), ' ',
  		 FIRST_VALUE(users.last_name) OVER (PARTITION BY communities_users.community_id ORDER BY profiles.birthday)) AS oldest,
  COUNT(communities_users.user_id) OVER (PARTITION BY communities_users.community_id) AS user_in_groups,
  (SELECT COUNT(1) FROM users) AS total_users,
  ROUND(COUNT(communities_users.user_id) OVER (PARTITION BY communities_users.community_id) / (SELECT COUNT(1) FROM users) * 100, 2) AS '%%'
	FROM communities
	LEFT JOIN communities_users
		ON communities.id = communities_users.community_id
	LEFT JOIN users
		ON communities_users.user_id = users.id
	LEFT JOIN profiles
		ON users.id = profiles.user_id;
```
