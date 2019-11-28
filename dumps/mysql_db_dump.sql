SET GLOBAL log_bin_trust_function_creators = 1;

-- MySQL dump 10.13  Distrib 8.0.18, for Linux (x86_64)
--
-- Host: localhost    Database: mysql
-- ------------------------------------------------------
-- Server version	8.0.18

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `first_name` varchar(255) NOT NULL,
  `last_name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `hash_pass` varchar(64) NOT NULL,
  `birth_date` date NOT NULL,
  `is_dead` tinyint(1) DEFAULT '0',
  `insurance_company` varchar(255) DEFAULT NULL,
  `insurance_number` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `unique_insurance` (`insurance_company`,`insurance_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `staff`
--

DROP TABLE IF EXISTS `staff`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `staff` (
  `id` int(11) NOT NULL,
  `hired_by` int(11) DEFAULT NULL,
  `employment_start` date NOT NULL,
  `employment_end` date DEFAULT NULL,
  `salary` decimal(15,2) NOT NULL,
  `schedule_type` enum('2/3','0','1') NOT NULL,
  PRIMARY KEY (`id`),
  KEY `staff_hired_by_hr` (`hired_by`),
  CONSTRAINT `staff_hired_by_hr` FOREIGN KEY (`hired_by`) REFERENCES `hrs` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff`
--

LOCK TABLES `staff` WRITE;
/*!40000 ALTER TABLE `staff` DISABLE KEYS */;
/*!40000 ALTER TABLE `staff` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hrs`
--

DROP TABLE IF EXISTS `hrs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hrs` (
  `id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hrs`
--

LOCK TABLES `hrs` WRITE;
/*!40000 ALTER TABLE `hrs` DISABLE KEYS */;
/*!40000 ALTER TABLE `hrs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `doctors`
--

DROP TABLE IF EXISTS `doctors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `doctors` (
  `id` int(11) NOT NULL,
  `specialization` enum('Traumatologist','Surgeon','Oculist','Therapist') NOT NULL,
  `clinic_number` varchar(32) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `doctors`
--

LOCK TABLES `doctors` WRITE;
/*!40000 ALTER TABLE `doctors` DISABLE KEYS */;
/*!40000 ALTER TABLE `doctors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nurses`
--

DROP TABLE IF EXISTS `nurses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `nurses` (
  `id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nurses`
--

LOCK TABLES `nurses` WRITE;
/*!40000 ALTER TABLE `nurses` DISABLE KEYS */;
/*!40000 ALTER TABLE `nurses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `doctors_nurses`
--

DROP TABLE IF EXISTS `doctors_nurses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `doctors_nurses` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `doctor_id` int(11) NOT NULL,
  `nurse_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `doctors_nurses`
--

LOCK TABLES `doctors_nurses` WRITE;
/*!40000 ALTER TABLE `doctors_nurses` DISABLE KEYS */;
/*!40000 ALTER TABLE `doctors_nurses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventory_managers`
--

DROP TABLE IF EXISTS `inventory_managers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventory_managers` (
  `id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory_managers`
--

LOCK TABLES `inventory_managers` WRITE;
/*!40000 ALTER TABLE `inventory_managers` DISABLE KEYS */;
/*!40000 ALTER TABLE `inventory_managers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pharmacists`
--

DROP TABLE IF EXISTS `pharmacists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pharmacists` (
  `id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pharmacists`
--

LOCK TABLES `pharmacists` WRITE;
/*!40000 ALTER TABLE `pharmacists` DISABLE KEYS */;
/*!40000 ALTER TABLE `pharmacists` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lab_technicians`
--

DROP TABLE IF EXISTS `lab_technicians`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lab_technicians` (
  `id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lab_technicians`
--

LOCK TABLES `lab_technicians` WRITE;
/*!40000 ALTER TABLE `lab_technicians` DISABLE KEYS */;
/*!40000 ALTER TABLE `lab_technicians` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `receptionists`
--

DROP TABLE IF EXISTS `receptionists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `receptionists` (
  `id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `receptionists`
--

LOCK TABLES `receptionists` WRITE;
/*!40000 ALTER TABLE `receptionists` DISABLE KEYS */;
/*!40000 ALTER TABLE `receptionists` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `paramedics`
--

DROP TABLE IF EXISTS `paramedics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `paramedics` (
  `id` int(11) NOT NULL,
  `position` enum('Primary','Secondary') NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `paramedics`
--

LOCK TABLES `paramedics` WRITE;
/*!40000 ALTER TABLE `paramedics` DISABLE KEYS */;
/*!40000 ALTER TABLE `paramedics` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `paramedic_groups`
--

DROP TABLE IF EXISTS `paramedic_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `paramedic_groups` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `is_active` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `paramedic_groups`
--

LOCK TABLES `paramedic_groups` WRITE;
/*!40000 ALTER TABLE `paramedic_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `paramedic_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `paramedic_group_divisions`
--

DROP TABLE IF EXISTS `paramedic_group_divisions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `paramedic_group_divisions` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `paramedic_id` int(11) DEFAULT NULL,
  `group_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `paramedic_group_divisions`
--

LOCK TABLES `paramedic_group_divisions` WRITE;
/*!40000 ALTER TABLE `paramedic_group_divisions` DISABLE KEYS */;
/*!40000 ALTER TABLE `paramedic_group_divisions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `patients`
--

DROP TABLE IF EXISTS `patients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `patients` (
  `id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `patients`
--

LOCK TABLES `patients` WRITE;
/*!40000 ALTER TABLE `patients` DISABLE KEYS */;
/*!40000 ALTER TABLE `patients` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `admins`
--

DROP TABLE IF EXISTS `admins`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admins` (
  `id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admins`
--

LOCK TABLES `admins` WRITE;
/*!40000 ALTER TABLE `admins` DISABLE KEYS */;
/*!40000 ALTER TABLE `admins` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `users_roles`
--

DROP TABLE IF EXISTS `users_roles`;
/*!50001 DROP VIEW IF EXISTS `users_roles`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `users_roles` AS SELECT 
 1 AS `user_id`,
 1 AS `is_patient`,
 1 AS `is_hr`,
 1 AS `is_doctor`,
 1 AS `is_nurse`,
 1 AS `is_inventory_manager`,
 1 AS `is_pharmacist`,
 1 AS `is_lab_technician`,
 1 AS `is_receptionist`,
 1 AS `is_paramedic`,
 1 AS `is_admin`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `chats`
--

DROP TABLE IF EXISTS `chats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chats` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `chat_type` enum('private','channel','group') NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chats`
--

LOCK TABLES `chats` WRITE;
/*!40000 ALTER TABLE `chats` DISABLE KEYS */;
/*!40000 ALTER TABLE `chats` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `chats_messages`
--

DROP TABLE IF EXISTS `chats_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chats_messages` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `content_type` enum('text') NOT NULL,
  `content` text NOT NULL,
  `datetime` timestamp NOT NULL,
  `sent_by` int(11) NOT NULL,
  `sent_to` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chats_messages`
--

LOCK TABLES `chats_messages` WRITE;
/*!40000 ALTER TABLE `chats_messages` DISABLE KEYS */;
/*!40000 ALTER TABLE `chats_messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `chats_participants`
--

DROP TABLE IF EXISTS `chats_participants`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chats_participants` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `chat_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `private_chat_participant_number` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chats_participants`
--

LOCK TABLES `chats_participants` WRITE;
/*!40000 ALTER TABLE `chats_participants` DISABLE KEYS */;
/*!40000 ALTER TABLE `chats_participants` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `logs`
--

DROP TABLE IF EXISTS `logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `logs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `date` timestamp NOT NULL,
  `text` text NOT NULL,
  `performed_by` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `logs`
--

LOCK TABLES `logs` WRITE;
/*!40000 ALTER TABLE `logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `board_messages`
--

DROP TABLE IF EXISTS `board_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `board_messages` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `text` text NOT NULL,
  `expiry` date NOT NULL DEFAULT ((curdate() + interval 10 day)),
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `board_messages`
--

LOCK TABLES `board_messages` WRITE;
/*!40000 ALTER TABLE `board_messages` DISABLE KEYS */;
/*!40000 ALTER TABLE `board_messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `board_modifications`
--

DROP TABLE IF EXISTS `board_modifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `board_modifications` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `datetime` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `change` text NOT NULL,
  `change_type` enum('Addition','Removal','Modification','Creation') NOT NULL,
  `modifies` int(11) NOT NULL,
  `made_by` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `board_modifications`
--

LOCK TABLES `board_modifications` WRITE;
/*!40000 ALTER TABLE `board_modifications` DISABLE KEYS */;
/*!40000 ALTER TABLE `board_modifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `invoices`
--

DROP TABLE IF EXISTS `invoices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `invoices` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `datetime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `amount` decimal(15,2) NOT NULL,
  `text` text,
  `paid_by` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  CONSTRAINT `invoices_chk_1` CHECK ((`amount` > 0.0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `invoices`
--

LOCK TABLES `invoices` WRITE;
/*!40000 ALTER TABLE `invoices` DISABLE KEYS */;
/*!40000 ALTER TABLE `invoices` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payments`
--

DROP TABLE IF EXISTS `payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payments` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `datetime` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `type` enum('Cash','Card','Insurance') NOT NULL,
  `insurance_company` varchar(255) DEFAULT NULL,
  `insurance_number` varchar(255) DEFAULT NULL,
  `accepted_by` int(11) DEFAULT NULL,
  `pays_for` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  UNIQUE KEY `pays_for` (`pays_for`),
  CONSTRAINT `payments_chk_1` CHECK (((`type` <> _utf8mb4'Insurance') or (`insurance_company` is not null))),
  CONSTRAINT `payments_chk_2` CHECK (((`type` <> _utf8mb4'Insurance') or (`insurance_number` is not null)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payments`
--

LOCK TABLES `payments` WRITE;
/*!40000 ALTER TABLE `payments` DISABLE KEYS */;
/*!40000 ALTER TABLE `payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `appointments`
--

DROP TABLE IF EXISTS `appointments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `appointments` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `doctor_id` int(11) NOT NULL,
  `patient_id` int(11) NOT NULL,
  `datetime` timestamp NOT NULL,
  `location` varchar(255) NOT NULL,
  `invoice_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  UNIQUE KEY `invoice_id` (`invoice_id`),
  UNIQUE KEY `doctor_id` (`doctor_id`,`datetime`),
  UNIQUE KEY `patient_id` (`patient_id`,`datetime`),
  UNIQUE KEY `datetime` (`datetime`,`location`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `appointments`
--

LOCK TABLES `appointments` WRITE;
/*!40000 ALTER TABLE `appointments` DISABLE KEYS */;
/*!40000 ALTER TABLE `appointments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `redirections`
--

DROP TABLE IF EXISTS `redirections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `redirections` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `issue_date` date NOT NULL DEFAULT (curdate()),
  `directs_to` int(11) NOT NULL,
  `is_made_by` int(11) NOT NULL,
  `directs` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `redirections`
--

LOCK TABLES `redirections` WRITE;
/*!40000 ALTER TABLE `redirections` DISABLE KEYS */;
/*!40000 ALTER TABLE `redirections` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `in_patient_directions`
--

DROP TABLE IF EXISTS `in_patient_directions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `in_patient_directions` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `issue_date` date NOT NULL DEFAULT (curdate()),
  `is_made_by` int(11) NOT NULL,
  `directs` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `in_patient_directions`
--

LOCK TABLES `in_patient_directions` WRITE;
/*!40000 ALTER TABLE `in_patient_directions` DISABLE KEYS */;
/*!40000 ALTER TABLE `in_patient_directions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `in_patient_clinic_places`
--

DROP TABLE IF EXISTS `in_patient_clinic_places`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `in_patient_clinic_places` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `room` varchar(32) NOT NULL,
  `amount_per_day` decimal(15,2) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `in_patient_clinic_places`
--

LOCK TABLES `in_patient_clinic_places` WRITE;
/*!40000 ALTER TABLE `in_patient_clinic_places` DISABLE KEYS */;
/*!40000 ALTER TABLE `in_patient_clinic_places` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `in_patient_clinic_stay`
--

DROP TABLE IF EXISTS `in_patient_clinic_stay`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `in_patient_clinic_stay` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `place_id` int(11) NOT NULL,
  `occupied_by` int(11) NOT NULL,
  `invoice_id` int(11) NOT NULL,
  `check_in_datetime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `check_out_datetime` timestamp NULL DEFAULT NULL,
  `amount_per_day` decimal(15,2) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  UNIQUE KEY `invoice_id` (`invoice_id`),
  CONSTRAINT `in_patient_clinic_stay_chk_1` CHECK (((`check_out_datetime` is null) or (`check_in_datetime` < `check_out_datetime`)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `in_patient_clinic_stay`
--

LOCK TABLES `in_patient_clinic_stay` WRITE;
/*!40000 ALTER TABLE `in_patient_clinic_stay` DISABLE KEYS */;
/*!40000 ALTER TABLE `in_patient_clinic_stay` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `in_patient_clinic_services`
--

DROP TABLE IF EXISTS `in_patient_clinic_services`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `in_patient_clinic_services` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `service_name` varchar(255) NOT NULL,
  `amount` decimal(15,2) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `in_patient_clinic_services`
--

LOCK TABLES `in_patient_clinic_services` WRITE;
/*!40000 ALTER TABLE `in_patient_clinic_services` DISABLE KEYS */;
/*!40000 ALTER TABLE `in_patient_clinic_services` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `in_patient_clinic_provided_services`
--

DROP TABLE IF EXISTS `in_patient_clinic_provided_services`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `in_patient_clinic_provided_services` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `stay_id` int(11) NOT NULL,
  `service` int(11) NOT NULL,
  `datetime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `amount` decimal(15,2) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `in_patient_clinic_provided_services`
--

LOCK TABLES `in_patient_clinic_provided_services` WRITE;
/*!40000 ALTER TABLE `in_patient_clinic_provided_services` DISABLE KEYS */;
/*!40000 ALTER TABLE `in_patient_clinic_provided_services` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventory_items`
--

DROP TABLE IF EXISTS `inventory_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventory_items` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `cost_per_unit` decimal(15,2) NOT NULL,
  `quantity` decimal(32,6) NOT NULL,
  `units` enum('Items','Litres','Grams') NOT NULL,
  `is_consumable` tinyint(1) NOT NULL,
  `category` enum('Medicine','Hospital stationary item','Electronic device','Pharmacy item','In-patient clinic inventory') NOT NULL,
  `need_prescription` tinyint(1) NOT NULL,
  `belongs_to_place` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  UNIQUE KEY `category` (`category`,`name`),
  CONSTRAINT `inventory_items_chk_1` CHECK (((`category` = _utf8mb4'In-patient clinic inventory') = (`belongs_to_place` is not null)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory_items`
--

LOCK TABLES `inventory_items` WRITE;
/*!40000 ALTER TABLE `inventory_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `inventory_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventory_items_requests`
--

DROP TABLE IF EXISTS `inventory_items_requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventory_items_requests` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `item_id` int(11) NOT NULL,
  `requested_by` int(11) NOT NULL,
  `status` enum('Approved','Rejected','Pending') NOT NULL DEFAULT 'Pending',
  `approved_by` int(11) DEFAULT NULL,
  `datetime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `quantity` decimal(32,6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  CONSTRAINT `inventory_items_requests_chk_1` CHECK ((((`status` = _utf8mb4'Pending') and (`approved_by` is null)) or ((`status` <> _utf8mb4'Pending') and (`approved_by` is not null))))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory_items_requests`
--

LOCK TABLES `inventory_items_requests` WRITE;
/*!40000 ALTER TABLE `inventory_items_requests` DISABLE KEYS */;
/*!40000 ALTER TABLE `inventory_items_requests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `item_sales`
--

DROP TABLE IF EXISTS `item_sales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `item_sales` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `item_id` int(11) NOT NULL,
  `quantity` decimal(32,6) NOT NULL,
  `cost_per_unit` decimal(15,2) NOT NULL,
  `datetime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `sold_by` int(11) NOT NULL,
  `invoice_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `item_sales`
--

LOCK TABLES `item_sales` WRITE;
/*!40000 ALTER TABLE `item_sales` DISABLE KEYS */;
/*!40000 ALTER TABLE `item_sales` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `medical_records`
--

DROP TABLE IF EXISTS `medical_records`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `medical_records` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `content` text NOT NULL,
  `belongs_to` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `medical_records`
--

LOCK TABLES `medical_records` WRITE;
/*!40000 ALTER TABLE `medical_records` DISABLE KEYS */;
/*!40000 ALTER TABLE `medical_records` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `medical_record_modifications`
--

DROP TABLE IF EXISTS `medical_record_modifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `medical_record_modifications` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `change` text NOT NULL,
  `change_type` enum('Addition','Removal','Modification','Creation') NOT NULL,
  `date` date NOT NULL DEFAULT (curdate()),
  `is_made_by` int(11) NOT NULL,
  `modifies` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `medical_record_modifications`
--

LOCK TABLES `medical_record_modifications` WRITE;
/*!40000 ALTER TABLE `medical_record_modifications` DISABLE KEYS */;
/*!40000 ALTER TABLE `medical_record_modifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `prescriptions`
--

DROP TABLE IF EXISTS `prescriptions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prescriptions` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `issue_date` date NOT NULL DEFAULT (curdate()),
  `belongs_to` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prescriptions`
--

LOCK TABLES `prescriptions` WRITE;
/*!40000 ALTER TABLE `prescriptions` DISABLE KEYS */;
/*!40000 ALTER TABLE `prescriptions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `prescription_allowances`
--

DROP TABLE IF EXISTS `prescription_allowances`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prescription_allowances` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `prescription_id` int(11) NOT NULL,
  `inventory_item_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prescription_allowances`
--

LOCK TABLES `prescription_allowances` WRITE;
/*!40000 ALTER TABLE `prescription_allowances` DISABLE KEYS */;
/*!40000 ALTER TABLE `prescription_allowances` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ambulance_calls`
--

DROP TABLE IF EXISTS `ambulance_calls`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ambulance_calls` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `location` point NOT NULL,
  `datetime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `assigned_group` int(11) NOT NULL,
  `assigned_invoice` int(11) NOT NULL,
  `is_made_by` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  UNIQUE KEY `assigned_invoice` (`assigned_invoice`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ambulance_calls`
--

LOCK TABLES `ambulance_calls` WRITE;
/*!40000 ALTER TABLE `ambulance_calls` DISABLE KEYS */;
/*!40000 ALTER TABLE `ambulance_calls` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `analyses`
--

DROP TABLE IF EXISTS `analyses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `analyses` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `type` enum('Blood','Urine','Fecal') NOT NULL,
  `status` enum('Collected','Proceeded') NOT NULL DEFAULT 'Collected',
  `result` text,
  `assigned_invoice` int(11) NOT NULL,
  `proceeded_by` int(11) DEFAULT NULL,
  `requested_by` int(11) NOT NULL,
  `datetime_collected` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `datetime_proceeded` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  CONSTRAINT `analyses_chk_1` CHECK ((((`status` = _utf8mb4'Proceeded') and (`datetime_proceeded` is not null)) or ((`status` = _utf8mb4'Collected') and (`datetime_proceeded` is null)))),
  CONSTRAINT `analyses_chk_2` CHECK ((((`status` = _utf8mb4'Collected') and (`result` is null)) or ((`status` = _utf8mb4'Proceeded') and (`result` is not null))))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `analyses`
--

LOCK TABLES `analyses` WRITE;
/*!40000 ALTER TABLE `analyses` DISABLE KEYS */;
/*!40000 ALTER TABLE `analyses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Final view structure for view `users_roles`
--

/*!50001 DROP VIEW IF EXISTS `users_roles`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `users_roles` AS select `u`.`id` AS `user_id`,(`p`.`id` is not null) AS `is_patient`,(`h`.`id` is not null) AS `is_hr`,(`d`.`id` is not null) AS `is_doctor`,(`n`.`id` is not null) AS `is_nurse`,(`im`.`id` is not null) AS `is_inventory_manager`,(`ph`.`id` is not null) AS `is_pharmacist`,(`lt`.`id` is not null) AS `is_lab_technician`,(`r`.`id` is not null) AS `is_receptionist`,(`pm`.`id` is not null) AS `is_paramedic`,(`a`.`id` is not null) AS `is_admin` from ((((((((((`users` `u` left join `patients` `p` on((`p`.`id` = `u`.`id`))) left join `hrs` `h` on((`h`.`id` = `u`.`id`))) left join `doctors` `d` on((`d`.`id` = `u`.`id`))) left join `nurses` `n` on((`n`.`id` = `u`.`id`))) left join `inventory_managers` `im` on((`im`.`id` = `u`.`id`))) left join `pharmacists` `ph` on((`ph`.`id` = `u`.`id`))) left join `lab_technicians` `lt` on((`lt`.`id` = `u`.`id`))) left join `receptionists` `r` on((`r`.`id` = `u`.`id`))) left join `paramedics` `pm` on((`pm`.`id` = `u`.`id`))) left join `admins` `a` on((`a`.`id` = `u`.`id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Dumping routines for database 'mysql'
--
/*!50003 DROP FUNCTION IF EXISTS `absolute_number_of_weeks` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` FUNCTION `absolute_number_of_weeks`(end_date date) RETURNS int(11)
begin
    return number_of_weeks_between(FROM_UNIXTIME(UNIX_TIMESTAMP(0)), end_date);
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `can_item_be_taken` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` FUNCTION `can_item_be_taken`(requested_amount numeric, item_id int) RETURNS tinyint(1)
begin
    declare
        available_amount numeric;
    select quantity
    into available_amount
    from inventory.inventory_items
    where id = item_id;

    return available_amount <= requested_amount;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `can_staff_make_item_request` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` FUNCTION `can_staff_make_item_request`(staff_id int) RETURNS tinyint(1)
begin
    return exists(
            select *
            from users_roles as ur
            where ur.user_id = staff_id
              and (ur.is_doctor or ur.is_nurse or ur.is_lab_technician or ur.is_admin)
        );
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `charge` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` FUNCTION `charge`(age int, appointment_count int) RETURNS decimal(15,2)
begin
    return
        case
            when age < 50 and appointment_count < 3 then cast(200 as decimal(15, 2))
            when age < 50 and appointment_count >= 3 then cast(250 as decimal(15, 2))
            when age >= 50 and appointment_count < 3 then cast(450 as decimal(15, 2))
            when age >= 50 and appointment_count >= 3 then cast(500 as decimal(15, 2))
            end;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `cpsaips` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` FUNCTION `cpsaips`(new_patient_id int,
                        new_place_id int,
                        new_check_in_datetime timestamp,
                        new_check_out_datetime timestamp) RETURNS tinyint(1)
begin
    return not exists(
        -- the given place is not occupied at the given time
        -- or
        -- the given person does not occupy some place at the given time
            select *
            from in_patient_clinic_stay as s
            where (s.place_id = new_place_id or s.occupied_by = new_patient_id)
              and not
                ((s.check_in_datetime <= coalesce(new_check_out_datetime, timestamp('9999-12-31 23:59:59')) AND
                  s.check_out_datetime >= new_check_in_datetime)
                    OR (s.check_in_datetime >= coalesce(new_check_out_datetime, timestamp('9999-12-31 23:59:59')) AND
                        s.check_in_datetime <= new_check_in_datetime AND s.check_out_datetime <= new_check_in_datetime)
                    OR (s.check_out_datetime <= new_check_in_datetime AND
                        s.check_out_datetime >= coalesce(new_check_out_datetime, timestamp('9999-12-31 23:59:59')) AND
                        s.check_in_datetime <= coalesce(new_check_out_datetime, timestamp('9999-12-31 23:59:59')))
                    OR (start_date >= coalesce(new_check_out_datetime, timestamp('9999-12-31 23:59:59')) AND
                        start_date <= new_check_in_datetime))
        );
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `exists_reference` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` FUNCTION `exists_reference`(
    reference_name varchar(64)
) RETURNS tinyint(1)
begin
    return exists(
            select *
            from information_schema.referential_constraints as r
            where r.constraint_name = reference_name
        );
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `get_age` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` FUNCTION `get_age`(birth_date date) RETURNS int(11)
begin
    return timestampdiff(year, birth_date, now());
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `implication` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` FUNCTION `implication`(x bool, y bool) RETURNS tinyint(1)
    DETERMINISTIC
return (not x) or y ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `is_chat_private` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` FUNCTION `is_chat_private`(chat_id integer) RETURNS tinyint(1)
begin
    return exists(
            select 1 as res
            from chats
            where id = chat_id
              and chat_type = 'private'
        );
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `is_employment_end_valid` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` FUNCTION `is_employment_end_valid`(user_id int, employment_start date, employment_end date) RETURNS tinyint(1)
begin
    declare is_user_dead bool;
    select is_dead into is_user_dead from users where id = user_id;
    return ((employment_start < employment_end) AND (implication(is_user_dead, employment_end <= now())));
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `is_int` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` FUNCTION `is_int`(number numeric) RETURNS tinyint(1)
begin
    return number = floor(number);
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `is_inventory_item_valid_for_sale` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` FUNCTION `is_inventory_item_valid_for_sale`(
    item_id int
) RETURNS tinyint(1)
begin
    return exists(
            select *
            from inventory_items as ii
            where ii.id = item_id
              and ii.is_consumable = true
              and ii.category = 'Pharmacy item'
        );
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `is_in_patient_service_valid` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` FUNCTION `is_in_patient_service_valid`(stay_id int,
                                            datetime timestamp) RETURNS tinyint(1)
begin
    return exists(
            select *
            from in_patient_clinic_stay as s
            where s.id = stay_id
              and datetime between s.check_in_datetime and coalesce(s.check_out_datetime, timestamp('9999-12-31 23:59:59'))
        );
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `is_item_quantity_valid` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` FUNCTION `is_item_quantity_valid`(number numeric, item_id int) RETURNS tinyint(1)
begin
    declare
        unit_type text;
    select units
    into unit_type
    from inventory.inventory_items
    where id = item_id;

    return is_item_quantity_valid_for_unit(number, unit_type);
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `is_item_quantity_valid_for_unit` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` FUNCTION `is_item_quantity_valid_for_unit`(number numeric, unit text) RETURNS tinyint(1)
begin
    return
        case
            when number is null then False
            when unit is null then False
            when unit = 'Items' then is_int(number)
            else True
            end;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `number_of_weeks_between` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` FUNCTION `number_of_weeks_between`(begin_date date, end_date date) RETURNS int(11)
begin
    return (end_date - begin_date) / 7;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `init_db` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `init_db`()
begin
-- -----------------------------------------------------------------------------
-- users
-- -----------------------------------------------------------------------------
create table if not exists users
(
  id                serial primary key
, first_name        varchar(255) not null
, last_name         varchar(255) not null
, email             varchar(255) not null unique
, hash_pass         varchar(64)  not null
, birth_date        date         not null
, is_dead           bool default false
, insurance_company varchar(255)
, insurance_number  varchar(255),

  constraint unique_insurance unique (insurance_company, insurance_number)
);

-- -----------------------------------------------------------------------------
-- staff
-- -----------------------------------------------------------------------------
create table if not exists staff
(
  id               int primary key references users
, hired_by         int            null
, employment_start date           not null
, employment_end   date           null
, salary           decimal(15, 2) not null
, schedule_type    enum('2/3'
                      , '0'
                      , '1')      not null
);

-- -----------------------------------------------------------------------------
-- hrs
-- -----------------------------------------------------------------------------
create table if not exists hrs
(
  id int primary key references staff
);
if not exists_reference('staff_hired_by_hr') then
  alter table staff
  add constraint staff_hired_by_hr
  foreign key (hired_by)
  references hrs (id);
end if;

-- -----------------------------------------------------------------------------
-- doctors
-- -----------------------------------------------------------------------------
create table if not exists doctors
(
  id             int primary key references staff
, specialization enum('Traumatologist'
                    , 'Surgeon'
                    , 'Oculist'
                    , 'Therapist') not null
, clinic_number  varchar(32) not null
);

-- -----------------------------------------------------------------------------
-- nurses
-- -----------------------------------------------------------------------------
create table if not exists nurses
(
  id int primary key references staff
);

-- -----------------------------------------------------------------------------
-- doctors_nurses
-- -----------------------------------------------------------------------------
create table if not exists doctors_nurses
(
  id        serial primary key
, doctor_id int not null references doctors
, nurse_id  int not null references nurses
);
-- -----------------------------------------------------------------------------
-- inventory_managers
-- -----------------------------------------------------------------------------
create table if not exists inventory_managers
(
  id int primary key references staff
);

-- -----------------------------------------------------------------------------
-- pharmacists
-- -----------------------------------------------------------------------------
create table if not exists pharmacists
(
  id int primary key references staff
);

-- -----------------------------------------------------------------------------
-- lab_technicians
-- -----------------------------------------------------------------------------
create table if not exists lab_technicians
(
  id int primary key references staff
);

-- -----------------------------------------------------------------------------
-- receptionists
-- -----------------------------------------------------------------------------
create table if not exists receptionists
(
  id int primary key references staff
);

-- -----------------------------------------------------------------------------
-- paramedics
-- -----------------------------------------------------------------------------
create table if not exists paramedics
(
  id       int primary key references staff
, position enum('Primary'
              , 'Secondary') not null
);

-- -----------------------------------------------------------------------------
-- paramedic_groups
-- -----------------------------------------------------------------------------
create table if not exists paramedic_groups
(
  id serial primary key
, is_active boolean default true
);

-- -----------------------------------------------------------------------------
-- paramedic_group_divisions
-- -----------------------------------------------------------------------------
create table if not exists paramedic_group_divisions
(
  id           serial primary key
, paramedic_id int references paramedics (id)
, group_id     int references paramedic_groups (id)
);

-- -----------------------------------------------------------------------------
-- patients
-- -----------------------------------------------------------------------------
create table if not exists patients
(
  id int primary key references users
);

-- -----------------------------------------------------------------------------
-- admins
-- -----------------------------------------------------------------------------
create table if not exists admins
(
  id int primary key references staff
);

-- -----------------------------------------------------------------------------
-- users_roles
-- -----------------------------------------------------------------------------
create or replace view users_roles as
  select u.id              as user_id
       , p.id  is not null as is_patient
       , h.id  is not null as is_hr
       , d.id  is not null as is_doctor
       , n.id  is not null as is_nurse
       , im.id is not null as is_inventory_manager
       , ph.id is not null as is_pharmacist
       , lt.id is not null as is_lab_technician
       , r.id  is not null as is_receptionist
       , pm.id is not null as is_paramedic
       , a.id  is not null as is_admin
  from users as u
  left join patients as p
    on p.id = u.id
  left join hrs as h
    on h.id = u.id
  left join doctors as d
    on d.id = u.id
  left join nurses as n
    on n.id = u.id
  left join inventory_managers as im
    on im.id = u.id
  left join pharmacists as ph
    on ph.id = u.id
  left join lab_technicians as lt
    on lt.id = u.id
  left join receptionists as r
    on r.id = u.id
  left join paramedics as pm
    on pm.id = u.id
  left join admins as a
    on a.id = u.id
;

-- -----------------------------------------------------------------------------
-- chats
-- -----------------------------------------------------------------------------
create table if not exists chats
(
  id        serial primary key
, name      varchar(255)   not null unique
, chat_type enum('private'
               , 'channel'
               , 'group') not null
);

-- -----------------------------------------------------------------------------
-- chats_messages
-- -----------------------------------------------------------------------------
create table if not exists chats_messages
(
  id           serial primary key
, content_type enum('text') not null
, content      text              not null
, datetime     timestamp         not null
, sent_by      int               not null
    references users (id)
, sent_to      int               not null
    references chats (id)
);

-- -----------------------------------------------------------------------------
-- chats_participants
-- -----------------------------------------------------------------------------
create table if not exists chats_participants
(
  id                              serial primary key
, chat_id                         int not null
    references chats(id)
, user_id                         int not null
    references users(id)
, private_chat_participant_number bool
);

-- -----------------------------------------------------------------------------
-- logs
-- -----------------------------------------------------------------------------
create table if not exists logs
(
  id           serial primary key
, date         timestamp not null
, text         text      not null
, performed_by int       not null
    references users (id)
);

-- -----------------------------------------------------------------------------
-- board_messages
-- -----------------------------------------------------------------------------
create table if not exists board_messages
(
  id     serial primary key
, text   text not null
, expiry date not null
    default (date_add(current_date(), interval 10 day))
);

-- -----------------------------------------------------------------------------
-- modifications
-- -----------------------------------------------------------------------------
create table if not exists board_modifications
(
  id          serial primary key
, datetime    timestamp default current_timestamp()
, `change`    text not null
, change_type enum('Addition'
                 , 'Removal'
                 , 'Modification'
                 , 'Creation') not null
, `modifies` int not null references board_messages (id)
, made_by    int not null references staff (id)
);

-- -----------------------------------------------------------------------------
-- invoices
-- -----------------------------------------------------------------------------
create table if not exists invoices
(
  id       serial primary key
, datetime timestamp not null
    default current_timestamp()
, amount   decimal(15, 2) not null
    check (amount > 0.0)
, text     text null
, paid_by  int  not null
    references patients (id)
);

-- -----------------------------------------------------------------------------
-- payments
-- -----------------------------------------------------------------------------
create table if not exists payments
(
  id                serial primary key
, datetime          timestamp default current_timestamp()
, type              enum('Cash'
                       , 'Card'
                       , 'Insurance') not null
, insurance_company varchar(255) null
, insurance_number  varchar(255) null
, accepted_by       int null references receptionists
, pays_for          int unique not null references invoices

, check ( (not (type = 'Insurance')) or (insurance_company is not null) )
, check ( (not (type = 'Insurance')) or (insurance_number is not null) )
);

-- -----------------------------------------------------------------------------
-- appointments
-- -----------------------------------------------------------------------------
create table if not exists appointments
(
  id         serial primary key
, doctor_id  int not null references doctors
, patient_id int not null references patients
, datetime   timestamp               not null
, location   varchar(255)            not null
, invoice_id int unique              not null
    references invoices

, unique (doctor_id, datetime)
, unique (patient_id, datetime)
, unique (datetime, location)
);

-- -----------------------------------------------------------------------------
-- meeting.redirection
-- -----------------------------------------------------------------------------
create table if not exists redirections
(
  id         serial primary key
, issue_date date not null
    default (curdate())
, directs_to int not null
    references doctors (id)
, is_made_by int not null
    references doctors (id)
, directs    int not null
    references patients (id)
);

-- -----------------------------------------------------------------------------
-- in_patient_direction
-- -----------------------------------------------------------------------------
create table if not exists in_patient_directions
(
  id         serial primary key
, issue_date date                             not null
    default (curdate())
, is_made_by int                              not null
    references doctors (id)
, directs    int                              not null
    references patients (id)
);

-- -----------------------------------------------------------------------------
-- in_patient_clinic_places
-- -----------------------------------------------------------------------------
create table if not exists in_patient_clinic_places
(
  id             serial primary key
, room           varchar(32)    not null
, amount_per_day decimal(15, 2) not null
);

-- -----------------------------------------------------------------------------
-- in_patient_clinic_stay
-- -----------------------------------------------------------------------------
create table if not exists in_patient_clinic_stay
(
  id                 serial primary key
, place_id           int            not null references in_patient_clinic_places
, occupied_by        int            not null references patients
, invoice_id         int unique     not null references invoices
, check_in_datetime  timestamp      not null default now()
, check_out_datetime timestamp      null
, amount_per_day     decimal(15, 2) not null

, check((check_out_datetime is null) or (check_in_datetime < check_out_datetime))
);

-- -----------------------------------------------------------------------------
-- in_patient_clinic_services
-- -----------------------------------------------------------------------------
create table if not exists in_patient_clinic_services
(
  id           serial primary key
, service_name varchar(255) not null
, amount       decimal(15, 2)        not null
);

-- -----------------------------------------------------------------------------
-- in_patient_clinic_provided_services
-- -----------------------------------------------------------------------------
create table if not exists in_patient_clinic_provided_services
(
  id       serial primary key
, stay_id  int            not null references in_patient_clinic_stay
, service  int            not null references in_patient_clinic_services
, datetime timestamp      not null default current_timestamp()
, amount   decimal(15, 2) not null
);

-- -----------------------------------------------------------------------------
-- inventory_items
-- -----------------------------------------------------------------------------
create table if not exists inventory_items
(
  id                serial primary key
, name              varchar(255)                not null
, cost_per_unit     decimal(15, 2)              not null
, quantity          numeric(32, 6)              not null
, units             enum('Items'
                       , 'Litres'
                       , 'Grams')              not null
, is_consumable     bool                        not null
, category          enum('Medicine'
                       , 'Hospital stationary item'
                       , 'Electronic device'
                       , 'Pharmacy item'
                       , 'In-patient clinic inventory') not null
, need_prescription bool                        not null
, belongs_to_place  int                         null references in_patient_clinic_places
, unique (category, name)
, check ((category = 'In-patient clinic inventory') = (belongs_to_place is not null))
);

-- -----------------------------------------------------------------------------
-- inventory_items_requests
-- -----------------------------------------------------------------------------
create table if not exists inventory_items_requests
(
  id           serial primary key
, item_id      int not null
    references inventory_items
, requested_by int not null
    references staff
, status enum('Approved'
            , 'Rejected'
            , 'Pending') not null
    default 'Pending'
, approved_by  int null references inventory_managers
, datetime     timestamp                             not null
    default current_timestamp()
, quantity     numeric(32, 6)                        not null
, check ((status='Pending' and approved_by is null) or (status != 'Pending' and approved_by is not null))
);

-- -----------------------------------------------------------------------------
-- item_sales
-- -----------------------------------------------------------------------------
create table if not exists item_sales
(
  id            serial primary key
, item_id       int            not null
    references inventory_items
, quantity      numeric(32, 6) not null
, cost_per_unit decimal(15, 2) not null
, datetime      timestamp      not null
    default current_timestamp()
, sold_by       int            not null
    references pharmacists
, invoice_id    int            not null
    references invoices
);

-- -----------------------------------------------------------------------------
-- medical_records
-- -----------------------------------------------------------------------------
create table if not exists medical_records
(
  id         serial primary key
, content    text not null
, belongs_to int  not null references patients (id)
);

-- -----------------------------------------------------------------------------
-- medical_record_modifications
-- -----------------------------------------------------------------------------
create table if not exists medical_record_modifications
(
  id          serial primary key
, `change`      text not null
, change_type enum('Addition'
                 , 'Removal'
                 , 'Modification'
                 , 'Creation') not null
, date date not null
    default (current_date())
, is_made_by  int not null references staff (id)
, `modifies`    int not null references medical_records
);

-- -----------------------------------------------------------------------------
-- prescriptions
-- -----------------------------------------------------------------------------
create table if not exists prescriptions
(
  id         serial primary key
, issue_date date not null
    default (curdate())
, belongs_to int references medical_records (id)
);

-- -----------------------------------------------------------------------------
-- prescription_allowances
-- -----------------------------------------------------------------------------
create table if not exists prescription_allowances
(
  id                serial primary key
, prescription_id   int not null
    references prescriptions(id)
, inventory_item_id int not null
    references inventory_items (id)
);

-- -----------------------------------------------------------------------------
-- ambulance_calls
-- -----------------------------------------------------------------------------
create table if not exists ambulance_calls
(
  id               serial primary key
, location         point      not null
, datetime         timestamp  not null default current_timestamp()
, assigned_group   int        not null references paramedic_groups (id)
, assigned_invoice int unique not null references invoices (id)
, is_made_by       int        not null references patients (id)
);

-- -----------------------------------------------------------------------------
-- analyses
-- -----------------------------------------------------------------------------
create table if not exists analyses
(
  id serial primary key
, type enum('Blood'
          , 'Urine'
          , 'Fecal') not null
, status enum('Collected'
            , 'Proceeded') not null default 'Collected'
, result text null
, assigned_invoice   int       not null references invoices(id)
, proceeded_by       int       null references lab_technicians (id)
, requested_by       int       not null references patients (id)
, datetime_collected timestamp not null default current_timestamp()
, datetime_proceeded timestamp null

, check ((status = 'Proceeded') and (datetime_proceeded is not null)
      or (status = 'Collected') and datetime_proceeded is null)
, check ((status = 'Collected' and result is null ) or (status = 'Proceeded' and result is not null))
);
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-11-28 14:53:03
