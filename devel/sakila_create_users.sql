CREATE USER 'bruce.wayne'@'localhost' IDENTIFIED BY '45ff25ee4282c1a4affdafd4fb625260';
CREATE USER 'natasha.romanov'@'localhost' IDENTIFIED BY '64d3cc168dcf15b5785e4ede568e3890';
CREATE USER 'walter.kovacs'@'localhost' IDENTIFIED BY '01970c3568e781e765a181de2106036c';
CREATE USER 'abraham.sapien'@'localhost' IDENTIFIED BY 'bdf6984169fb67d7a2faacf1955f7c79';
CREATE USER 'selina.kyle'@'localhost' IDENTIFIED BY 'ff5e6da42a34361d0bda27e32105fee2';
CREATE USER 'atticus.finch'@'localhost' IDENTIFIED BY 'd6aa764fb0dbfff0a3cf3c78ba024c03';
CREATE USER 'ignatius.reilly'@'localhost' IDENTIFIED BY 'd89354252e642b61588e7d7a1e160c75';
CREATE USER 'patrick.bateman'@'localhost' IDENTIFIED BY 'ce7a5513cec3e9ee326f8e43f522d653';
CREATE USER 'jane.eyre'@'localhost' IDENTIFIED BY '7223546439e73ef996be6269c6797494';
CREATE USER 'hester.prynne'@'localhost' IDENTIFIED BY '014ccd4378d0838dd78bccd4ac80732d';
CREATE USER 'tom.ripley'@'localhost' IDENTIFIED BY '1eb628083fe59097a5e9be5cdc7e87d5';
CREATE USER 'joe.kavalier'@'localhost' IDENTIFIED BY 'c40fdc7e758716438d116d16ce83efec';
CREATE USER 'dean.moriarty'@'localhost' IDENTIFIED BY '11d6e3262c3920bd69cda9bf9a5bb8fd';
CREATE USER 'daisy.buchanan'@'localhost' IDENTIFIED BY 'd518265cd6ccdb8e3330efd5f9f224da';
CREATE USER 'meg.murry'@'localhost' IDENTIFIED BY '33dbc0be0ed1bef7934cf265a20de706';
CREATE USER 'roland.deschain'@'localhost' IDENTIFIED BY '1a10f3efdd259b93e98eea67cf2d11a1';
CREATE USER 'jo.march'@'localhost' IDENTIFIED BY 'fbd8af1c41e25e7a55ed199cee0d032e';

GRANT ALTER, CREATE, CREATE ROUTINE, CREATE TEMPORARY TABLES, DELETE, DROP, EXECUTE, FILE, INDEX, INSERT, LOCK TABLES, REFERENCES, RELOAD, SELECT, SHOW DATABASES, SHOW VIEW, SHUTDOWN, SUPER, TRIGGER, UPDATE ON *.* TO 'bruce.wayne'@'localhost';
GRANT ALTER, CREATE, CREATE ROUTINE, CREATE TEMPORARY TABLES, DELETE, DROP, EXECUTE, FILE, INDEX, INSERT, LOCK TABLES, REFERENCES, RELOAD, SELECT, SHOW DATABASES, SHOW VIEW, SHUTDOWN, SUPER, TRIGGER, UPDATE ON *.* TO 'natasha.romanov'@'localhost';
GRANT ALTER, CREATE, CREATE ROUTINE, CREATE TEMPORARY TABLES, DELETE, DROP, EXECUTE, FILE, INDEX, INSERT, LOCK TABLES, REFERENCES, RELOAD, SELECT, SHOW DATABASES, SHOW VIEW, SHUTDOWN, SUPER, TRIGGER, UPDATE ON *.* TO 'walter.kovacs'@'localhost';
GRANT ALTER, CREATE, CREATE ROUTINE, CREATE TEMPORARY TABLES, DELETE, DROP, EXECUTE, FILE, INDEX, INSERT, LOCK TABLES, REFERENCES, RELOAD, SELECT, SHOW DATABASES, SHOW VIEW, SHUTDOWN, SUPER, TRIGGER, UPDATE ON *.* TO 'abraham.sapien'@'localhost';
GRANT ALTER, CREATE, CREATE ROUTINE, CREATE TEMPORARY TABLES, DELETE, DROP, EXECUTE, FILE, INDEX, INSERT, LOCK TABLES, REFERENCES, RELOAD, SELECT, SHOW DATABASES, SHOW VIEW, SHUTDOWN, SUPER, TRIGGER, UPDATE ON *.* TO 'selina.kyle'@'localhost';
GRANT DELETE, INSERT, SELECT, UPDATE ON sakila.* TO 'ignatius.reilly'@'localhost';
GRANT DELETE, INSERT, SELECT, UPDATE ON sakila.* TO 'patrick.bateman'@'localhost';
GRANT DELETE, INSERT, SELECT, UPDATE ON sakila.* TO 'tom.ripley'@'localhost';
GRANT DELETE, INSERT, SELECT, UPDATE ON sakila.* TO 'joe.kavalier'@'localhost';
GRANT DELETE, INSERT, SELECT, UPDATE ON sakila.* TO 'dean.moriarty'@'localhost';
GRANT DELETE, INSERT, SELECT, UPDATE ON sakila.* TO 'daisy.buchanan'@'localhost';
GRANT DELETE, INSERT, SELECT, UPDATE ON sakila.* TO 'meg.murry'@'localhost';
GRANT DELETE, INSERT, SELECT, UPDATE ON sakila.* TO 'jo.march'@'localhost';
GRANT SELECT ON sakila.* TO 'atticus.finch'@'localhost';
GRANT SELECT ON sakila.* TO 'jane.eyre'@'localhost';
GRANT SELECT ON sakila.* TO 'hester.prynne'@'localhost';
GRANT SELECT ON sakila.* TO 'roland.deschain'@'localhost';

