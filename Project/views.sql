-- Представление, которое выводит информацию по устройству в удобочитаемом виде

CREATE OR REPLACE VIEW device_info AS
  SELECT id,
         s_n,
         vendor.name AS vendor,
         name,
         counter,
         clients.name AS client,
         locations.name AS location,
         locations.address AS address 
  FROM devices
  JOIN vendors ON devices.vendor_id = vendors.id
  JOIN clients ON devices.client_id = clients.id
  JOIN locations ON devices.location_id = locations.id;

-- Представление, которое понадобится для построения аналилики печати по клиентам

CREATE OR REPLACE VIEW print_volumes AS 
  SELECT devices.id AS dev_id, 
	     devices.counter - (SELECT counter FROM counters WHERE device_id = devices.id ORDER BY id DESC LIMIT 1 OFFSET 1)  AS volume, 
	     clients.id AS cl_id, 
	     clients.name AS cl_name, 
	     locations.id AS loc_id, 
	     locations.name AS loc_name  
  FROM devices
  JOIN clients ON clients.id = devices.client_id 
  JOIN locations ON locations.id = devices.location_id;
