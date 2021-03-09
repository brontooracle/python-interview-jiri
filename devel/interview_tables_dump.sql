-- MySQL dump 10.13  Distrib 5.7.33, for Linux (x86_64)
--
-- Host: localhost    Database: bronto
-- ------------------------------------------------------
-- Server version	5.7.33-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `bronto`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `bronto` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `bronto`;

--
-- Table structure for table `instance`
--

DROP TABLE IF EXISTS `instance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `instance` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `service_id` int(10) unsigned NOT NULL,
  `host` varchar(128) COLLATE utf8_bin NOT NULL,
  `port` smallint(5) unsigned NOT NULL,
  `role` enum('master','slave','other') COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `host` (`host`,`port`),
  KEY `service_id` (`service_id`),
  CONSTRAINT `instance_ibfk_1` FOREIGN KEY (`service_id`) REFERENCES `service` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=99 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `instance`
--

LOCK TABLES `instance` WRITE;
/*!40000 ALTER TABLE `instance` DISABLE KEYS */;
INSERT INTO `instance` VALUES (1,1,'mysql-01-prod',3306,'master'),(2,1,'mysql-02-prod',3306,'slave'),(3,2,'mysql-03-prod',3306,'master'),(4,2,'mysql-04-prod',3306,'slave');
/*!40000 ALTER TABLE `instance` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permission`
--

DROP TABLE IF EXISTS `permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `permission` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned DEFAULT NULL,
  `service_id` int(10) unsigned DEFAULT NULL,
  `role_id` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_role_perm_id` (`user_id`,`service_id`,`role_id`),
  KEY `role_db_ibfk_2` (`service_id`),
  KEY `role_db_ibfk_3` (`role_id`),
  CONSTRAINT `role_db_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  CONSTRAINT `role_db_ibfk_2` FOREIGN KEY (`service_id`) REFERENCES `service` (`id`),
  CONSTRAINT `role_db_ibfk_3` FOREIGN KEY (`role_id`) REFERENCES `role` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1024 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permission`
--

LOCK TABLES `permission` WRITE;
/*!40000 ALTER TABLE `permission` DISABLE KEYS */;
INSERT INTO `permission` VALUES (1,1,1,1),(29,1,2,1),(2,2,1,1),(30,2,2,1),(3,3,1,1),(31,3,2,1),(4,4,1,1),(32,4,2,1),(5,5,1,1),(33,5,2,1),(6,6,1,1),(34,6,2,1),(7,7,1,2),(35,7,2,3),(8,8,1,3),(9,9,1,3),(36,9,2,2),(10,10,1,3),(11,11,1,3),(12,12,1,3),(37,12,2,2),(13,13,1,2),(38,13,2,2),(14,14,1,3),(39,14,2,3),(15,15,1,2),(40,15,2,3),(16,16,1,2),(41,16,2,3),(17,17,1,3),(42,17,2,2),(18,18,1,2),(19,19,1,2),(43,19,2,2),(20,20,1,3),(21,21,1,3),(44,21,2,2),(22,22,1,3),(23,23,1,2),(24,24,1,3),(45,24,2,2),(25,25,1,2),(26,26,1,2),(46,26,2,2),(27,27,1,3),(47,27,2,3),(28,28,1,3),(48,28,2,2);
/*!40000 ALTER TABLE `permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role`
--

DROP TABLE IF EXISTS `role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `role` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_bin NOT NULL,
  `permissions` varchar(255) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role`
--

LOCK TABLES `role` WRITE;
/*!40000 ALTER TABLE `role` DISABLE KEYS */;
INSERT INTO `role` VALUES (1,'ADMIN','ALTER, CREATE, CREATE ROUTINE, CREATE TEMPORARY TABLES, DELETE, DROP, EXECUTE, FILE, INDEX, INSERT, LOCK TABLES, REFERENCES, RELOAD, SELECT, SHOW DATABASES, SHOW VIEW, SHUTDOWN, SUPER, TRIGGER, UPDATE'),(2,'CRUD','DELETE, INSERT, SELECT, UPDATE'),(3,'READONLY','SELECT');
/*!40000 ALTER TABLE `role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `service`
--

DROP TABLE IF EXISTS `service`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `service` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_bin NOT NULL,
  `dbname` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `service`
--

LOCK TABLES `service` WRITE;
/*!40000 ALTER TABLE `service` DISABLE KEYS */;
INSERT INTO `service` VALUES (1,'HR Timesheets','employees'),(2,'Movie Rentals','sakila');
/*!40000 ALTER TABLE `service` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(30) COLLATE utf8_bin NOT NULL,
  `create_date` datetime DEFAULT NULL,
  `status` enum('active','inactive','terminated') COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'bruce.wayne','2018-06-30 11:01:10','active'),(2,'natasha.romanov','2018-11-22 16:09:15','active'),(3,'walter.kovacs','2017-07-20 13:30:43','active'),(4,'raven.darkholme','2017-08-23 00:53:43','inactive'),(5,'abraham.sapien','2018-02-16 19:44:24','active'),(6,'selina.kyle','2018-04-16 13:48:49','active'),(7,'atticus.finch','2017-08-19 15:38:50','active'),(8,'holden.caulfield','2017-11-11 20:35:38','active'),(9,'holly.golightly','2018-12-27 20:49:38','terminated'),(10,'harry.angstrom','2017-12-05 04:09:12','active'),(11,'lisbeth.salander','2019-03-28 17:05:00','active'),(12,'ignatius.reilly','2018-12-24 05:45:22','active'),(13,'patrick.bateman','2017-10-02 15:19:46','active'),(14,'jane.eyre','2018-05-25 17:10:41','active'),(15,'philip.marlowe','2019-04-19 00:42:02','terminated'),(16,'hester.prynne','2017-11-11 07:46:02','active'),(17,'tom.ripley','2017-12-28 01:32:03','active'),(18,'elinor.dashwood','2018-12-07 18:10:05','active'),(19,'joe.kavalier','2019-04-10 01:02:11','active'),(20,'clarice.starling','2018-02-16 03:28:38','active'),(21,'dean.moriarty','2019-05-23 04:04:34','active'),(22,'annie.wilkes','2019-02-20 14:44:52','active'),(23,'tristram.shandy','2018-02-05 02:18:33','terminated'),(24,'daisy.buchanan','2017-08-21 02:06:08','active'),(25,'randle.mcmurphy','2018-06-18 09:22:55','active'),(26,'meg.murry','2017-12-21 00:24:09','active'),(27,'roland.deschain','2019-01-14 10:39:55','active'),(28,'jo.march','2017-11-05 13:55:04','active');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-03-02 16:06:12
