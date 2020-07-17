DELIMITER //

-- При создании записи о гарантийных сроках в таблице warranties,
-- в таблице devices устанавливаем устанавливаем флаг on_warranty,
-- если текущая дата попадает в гарантийный диапазон

DROP TRIGGER IF EXISTS warranty_record_update_devices_flag//
CREATE TRIGGER warranty_record_update_devices_flag AFTER INSERT ON warranties
FOR EACH ROW BEGIN
  IF NOW() BETWEEN NEW.start_date AND NEW.end_date THEN
    UPDATE devices SET on_warranty = 1 WHERE id = NEW.device_id;
  END IF;
END//

-- Когда в таблицу devices добавляется устройство,
-- в таблицу counters добавить запись с показаниями счётчика

DROP TRIGGER IF EXISTS add_device_insert_counter_record//
CREATE TRIGGER add_device_insert_counter_record AFTER INSERT ON devices
FOR EACH ROW BEGIN
  INSERT INTO counters(device_id, counter, user_id) 
    VALUES (NEW.id, NEW.counter, NEW.user_id);
END//

-- Когда в таблицу counters добавляются показания счётчика,
-- обновить значение counter в таблице devices

DROP TRIGGER IF EXISTS add_counter_update_devices//
CREATE TRIGGER add_counter_update_devices AFTER INSERT ON counters
FOR EACH ROW BEGIN
  UPDATE devices SET counter = NEW.counter WHERE id = NEW.device_id;
END//

DELIMITER ; 