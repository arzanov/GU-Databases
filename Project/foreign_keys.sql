USE print_service;

-- Устанавливаем внешние ключи на таблицу devices

DESC devices;

ALTER TABLE devices 
  ADD CONSTRAINT device_type_id_fk
  FOREIGN KEY (type_id) REFERENCES device_types(id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  ADD CONSTRAINT device_vendor_id_fk
  FOREIGN KEY (vendor_id) REFERENCES vendors(id)
  	ON DELETE RESTRICT ON UPDATE CASCADE,
  ADD CONSTRAINT device_client_id_fk
  FOREIGN KEY (client_id) REFERENCES clients(id)
  	ON DELETE RESTRICT ON UPDATE CASCADE,
  ADD CONSTRAINT device_location_id_fk
  FOREIGN KEY (location_id) REFERENCES locations(id)
  	ON DELETE RESTRICT ON UPDATE CASCADE,
  ADD CONSTRAINT device_status_id_fk
  FOREIGN KEY (status_id) REFERENCES device_statuses(id)
  	ON DELETE RESTRICT ON UPDATE CASCADE,
  ADD CONSTRAINT device_user_id_fk
  FOREIGN KEY (user_id) REFERENCES users(id)
  	ON DELETE SET NULL;

-- Устанавливаем внешние ключи на таблицу components

DESC components;

ALTER TABLE components
	ADD CONSTRAINT component_directory_id_fk
	FOREIGN KEY (directory_id) REFERENCES components_directory(id)
	  ON DELETE RESTRICT ON UPDATE CASCADE,
	ADD CONSTRAINT component_work_id_fk
	FOREIGN KEY (work_id) REFERENCES works(id)
	  ON DELETE CASCADE,
	ADD CONSTRAINT component_user_id_fk
    FOREIGN KEY (user_id) REFERENCES users(id)
  	ON DELETE SET NULL;
	  
-- Устанавливаем внешние ключи на таблицу counters

DESC counters;

ALTER TABLE counters
	ADD CONSTRAINT counter_device_id_fk
	FOREIGN KEY (device_id) REFERENCES devices(id)
	  ON DELETE CASCADE,
	ADD CONSTRAINT counter_user_id_fk
    FOREIGN KEY (user_id) REFERENCES users(id)
  	  ON DELETE SET NULL;
	  
-- Устанавливаем внешние ключи на таблицу documents

DESC documents;

ALTER TABLE documents 
	ADD CONSTRAINT document_work_id_fk
	FOREIGN KEY (work_id) REFERENCES works(id)
	  ON DELETE CASCADE,
	ADD CONSTRAINT document_user_id_fk
    FOREIGN KEY (user_id) REFERENCES users(id)
  	  ON DELETE SET NULL;

-- Устанавливаем внешние ключи на таблицу locations

DESC locations;

ALTER TABLE locations 
	ADD CONSTRAINT location_client_id_fk
	FOREIGN KEY (client_id) REFERENCES clients(id)
	  ON DELETE RESTRICT ON UPDATE CASCADE,
	ADD CONSTRAINT location_city_id_fk
	FOREIGN KEY (city_id) REFERENCES cities(id)
	  ON DELETE RESTRICT ON UPDATE CASCADE;

-- Устанавливаем внешние ключи на таблицу users

DESC users;
	
ALTER TABLE users 
	ADD CONSTRAINT user_role_id_fk
	FOREIGN KEY (role_id) REFERENCES user_roles(id)
	  ON DELETE SET NULL;
	  
-- Устанавливаем внешние ключи на таблицу warranties

DESC warranties;
ALTER TABLE warranties
	ADD CONSTRAINT warranty_device_id_fk
	FOREIGN KEY (device_id) REFERENCES devices(id)
	  ON DELETE CASCADE;
	 
-- Устанавливаем внешние ключи на таблицу works

DESC works;

ALTER TABLE works
	ADD CONSTRAINT work_directory_id_fk
	FOREIGN KEY (directory_id) REFERENCES works_directory(id)
	  ON DELETE RESTRICT ON UPDATE CASCADE,
	ADD CONSTRAINT work_device_id_fk
	FOREIGN KEY (device_id) REFERENCES devices(id)
	  ON DELETE CASCADE,
	ADD CONSTRAINT work_user_id_fk
    FOREIGN KEY (user_id) REFERENCES users(id)
  	ON DELETE SET NULL;
