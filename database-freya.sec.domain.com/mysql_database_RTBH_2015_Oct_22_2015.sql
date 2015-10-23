-- MySQL dump 10.13  Distrib 5.5.43, for Linux (x86_64)
--
-- Host: localhost    Database: RTBH
-- ------------------------------------------------------
-- Server version	5.5.43-cll-lve

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
-- Table structure for table `blacklist`
--

DROP TABLE IF EXISTS `blacklist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `blacklist` (
  `id` mediumint(10) unsigned NOT NULL AUTO_INCREMENT,
  `sourceip` varbinary(16) NOT NULL,
  `cidr` smallint(3) NOT NULL DEFAULT '32',
  `type` enum('ipv4','ipv6') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'ipv4',
  `inserttime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `expiretime` datetime NOT NULL DEFAULT '9999-12-31 23:59:59',
  `hits` int(8) unsigned NOT NULL DEFAULT '0',
  `country` varchar(3) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'UNK',
  `comment` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `insertby` varchar(80) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `allow_edit` enum('Y','N') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Y',
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_sourceip` (`sourceip`),
  KEY `timestamps` (`inserttime`,`expiretime`),
  KEY `sourceip` (`sourceip`)
) ENGINE=InnoDB AUTO_INCREMENT=7008 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `blacklist`
--

/*!40000 ALTER TABLE `blacklist` DISABLE KEYS */;
INSERT INTO `blacklist` VALUES (1,'+ÚÚv',32,'ipv4','2015-10-22 10:33:16','2015-12-07 23:04:25',1310,'UNK','graylog-ftp','graylog-ftp-web0c30','Y');
INSERT INTO `blacklist` VALUES (2,'√Œ˝í',32,'ipv4','2015-10-22 10:33:16','2016-01-18 14:58:13',5282,'UNK','graylog-web-wp-login','graylog-web-wp-login-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `blacklist` VALUES (3,'áîâ',32,'ipv4','2015-10-22 10:33:16','2016-01-11 14:58:17',5083,'UNK','graylog-web-wp-login','graylog-web-wp-login-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `blacklist` VALUES (4,'z†§T',32,'ipv4','2015-10-22 10:33:16','2015-12-08 15:58:17',506,'UNK','graylog-ftp','graylog-ftp-web0c30','Y');
INSERT INTO `blacklist` VALUES (5,'æÏˆX',32,'ipv4','2015-10-22 10:33:16','2015-12-08 23:04:26',542,'UNK','graylog-ftp','graylog-ftp-web0c30','Y');
INSERT INTO `blacklist` VALUES (6,'ﬁ|\n6',32,'ipv4','2015-10-22 10:33:16','2015-12-08 23:04:27',872,'UNK','graylog-ftp','graylog-ftp-web0c30','Y');
INSERT INTO `blacklist` VALUES (7,'sJ,>',32,'ipv4','2015-10-22 10:33:16','2015-12-08 23:04:26',599,'UNK','graylog-ftp','graylog-ftp-web0c30','Y');
INSERT INTO `blacklist` VALUES (8,'À¬v',32,'ipv4','2015-10-22 10:33:16','2015-12-10 09:58:21',563,'UNK','graylog-ftp','graylog-ftp-web0c30','Y');
INSERT INTO `blacklist` VALUES (9,'q°∆{',32,'ipv4','2015-10-22 10:33:16','2015-12-10 13:58:19',691,'UNK','graylog-ftp','graylog-ftp-web0c30','Y');
INSERT INTO `blacklist` VALUES (10,'tdbæ',32,'ipv4','2015-10-22 10:33:16','2015-12-11 07:58:11',609,'UNK','graylog-ftp','graylog-ftp-web0c30','Y');
INSERT INTO `blacklist` VALUES (11,'.ÏΩc',32,'ipv4','2015-10-22 10:33:16','2015-12-11 08:58:28',1135,'UNK','graylog-ftp','graylog-ftp-web0c30','Y');
INSERT INTO `blacklist` VALUES (12,'qÆê®',32,'ipv4','2015-10-22 10:33:16','2015-12-11 11:58:11',570,'UNK','graylog-ftp','graylog-ftp-web0c30','Y');
INSERT INTO `blacklist` VALUES (13,'ßÁ2',32,'ipv4','2015-10-22 10:33:16','2015-12-11 14:58:27',1184,'UNK','graylog-ftp','graylog-ftp-web0c30','Y');
INSERT INTO `blacklist` VALUES (14,'[Âÿ\r',32,'ipv4','2015-10-22 10:33:16','2015-12-11 15:58:23',943,'UNK','graylog-ftp','graylog-ftp-web0c30','Y');
INSERT INTO `blacklist` VALUES (15,'’¨M',32,'ipv4','2015-10-22 10:33:16','2015-12-11 18:58:27',501,'UNK','graylog-ftp','graylog-ftp-web0c30','Y');
INSERT INTO `blacklist` VALUES (16,'*s%ﬂ',32,'ipv4','2015-10-22 10:33:16','2015-12-11 23:04:23',502,'UNK','graylog-ftp','graylog-ftp-web0c30','Y');
INSERT INTO `blacklist` VALUES (17,'≈“›*',32,'ipv4','2015-10-22 10:33:16','2015-12-13 12:58:21',625,'UNK','graylog-ftp','graylog-ftp-web0c30','Y');
INSERT INTO `blacklist` VALUES (18,'ø∞',32,'ipv4','2015-10-22 10:33:16','2015-12-14 23:04:14',534,'UNK','graylog-ftp','graylog-ftp-web0c30','Y');
INSERT INTO `blacklist` VALUES (19,'q¨ûó',32,'ipv4','2015-10-22 10:33:16','2015-12-15 11:58:11',642,'UNK','graylog-ftp','graylog-ftp-web0c30','Y');
INSERT INTO `blacklist` VALUES (20,'w]KH',32,'ipv4','2015-10-22 10:33:16','2015-12-15 23:04:23',1387,'UNK','graylog-ftp','graylog-ftp-web0c30','Y');
INSERT INTO `blacklist` VALUES (21,'∂t‚3',32,'ipv4','2015-10-22 10:33:16','2015-12-16 07:58:17',700,'UNK','graylog-ftp','graylog-ftp-web0c30','Y');
INSERT INTO `blacklist` VALUES (22,'∫M-',32,'ipv4','2015-10-22 10:33:16','2015-12-18 10:58:15',568,'UNK','graylog-ftp','graylog-ftp-web0c30','Y');
INSERT INTO `blacklist` VALUES (23,'∂0ƒ',32,'ipv4','2015-10-22 10:33:16','2015-12-19 11:58:21',577,'UNK','graylog-ftp','graylog-ftp-web0c30','Y');
INSERT INTO `blacklist` VALUES (24,'®v',32,'ipv4','2015-10-22 10:33:16','2015-12-20 08:58:29',507,'UNK','graylog-ftp','graylog-ftp-web0c30','Y');
INSERT INTO `blacklist` VALUES (25,'—p&‚',32,'ipv4','2015-10-22 10:33:16','2015-12-23 11:58:19',896,'UNK','graylog-ftp','graylog-ftp-web0c2','Y');
INSERT INTO `blacklist` VALUES (26,'Œ›ª',32,'ipv4','2015-10-22 10:33:16','2015-12-28 17:58:10',688,'UNK','graylog-ftp','graylog-ftp-web0c30','Y');
INSERT INTO `blacklist` VALUES (27,' ≥ΩÇ',32,'ipv4','2015-10-22 10:33:16','2015-12-28 21:58:26',184,'UNK','graylog-ftp','graylog-ftp-web0c2','Y');
INSERT INTO `blacklist` VALUES (28,'y\Z¬Ó',32,'ipv4','2015-10-22 10:33:16','2015-12-28 22:58:09',221,'UNK','graylog-ftp','graylog-ftp-web0c38','Y');
INSERT INTO `blacklist` VALUES (29,'tÿ',32,'ipv4','2015-10-22 10:33:16','2015-12-28 21:58:23',267,'UNK','graylog-ftp','graylog-ftp-web0c38','Y');
INSERT INTO `blacklist` VALUES (30,'j!i',32,'ipv4','2015-10-22 10:33:16','2015-12-28 21:58:23',193,'UNK','graylog-ftp','graylog-ftp-web0c38','Y');
INSERT INTO `blacklist` VALUES (31,':>D',32,'ipv4','2015-10-22 10:33:16','2015-12-28 21:58:29',151,'UNK','graylog-ftp','graylog-ftp-web0c75','Y');
INSERT INTO `blacklist` VALUES (32,'∫Ù i',32,'ipv4','2015-10-22 10:33:16','2015-12-28 21:58:18',180,'UNK','graylog-ftp','graylog-ftp-web0c45','Y');
INSERT INTO `blacklist` VALUES (33,'{≥Û',32,'ipv4','2015-10-22 10:33:16','2015-12-28 21:58:18',181,'UNK','graylog-ftp','graylog-ftp-web0c45','Y');
INSERT INTO `blacklist` VALUES (34,'mÑlÂ',32,'ipv4','2015-10-22 10:33:16','2015-12-30 10:58:23',99,'UNK','graylog-ftpchk3','ftpchk3-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `blacklist` VALUES (35,'óP Ü',32,'ipv4','2015-10-22 10:33:16','2015-12-30 10:58:23',137,'UNK','graylog-ftpchk3','ftpchk3-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `blacklist` VALUES (36,'oê‘',32,'ipv4','2015-10-22 10:33:16','2015-12-28 22:58:12',159,'UNK','graylog-ftp','graylog-ftp-web0c40','Y');
INSERT INTO `blacklist` VALUES (37,'=†◊H',32,'ipv4','2015-10-22 10:33:16','2016-01-19 14:58:18',199,'UNK','graylog-ftp','graylog-ftp-web0c0','Y');
INSERT INTO `blacklist` VALUES (38,'FßAº',32,'ipv4','2015-10-22 10:33:16','2016-01-19 14:58:08',181,'UNK','graylog-ftp','graylog-ftp-web0c25','Y');
INSERT INTO `blacklist` VALUES (39,'ª∑ñ',32,'ipv4','2015-10-22 10:33:16','2016-01-12 14:58:20',200,'UNK','graylog-ftp','graylog-ftp-web0c75','Y');
INSERT INTO `blacklist` VALUES (40,'{á“',32,'ipv4','2015-10-22 10:33:16','2016-01-16 19:58:11',224,'UNK','graylog-ftp','graylog-ftp-web0c30','Y');
INSERT INTO `blacklist` VALUES (41,'¶’~?',32,'ipv4','2015-10-22 10:33:16','2016-01-19 14:58:18',172,'UNK','graylog-ftp','graylog-ftp-web0c0','Y');
INSERT INTO `blacklist` VALUES (42,'P≤˙=',32,'ipv4','2015-10-22 10:33:16','2016-01-18 15:58:19',206,'UNK','graylog-ftp','graylog-ftp-web0c38','Y');
INSERT INTO `blacklist` VALUES (43,'Ø,b',32,'ipv4','2015-10-22 10:33:16','2016-01-18 14:58:18',154,'UNK','graylog-ftp','graylog-ftp-web0c2','Y');
INSERT INTO `blacklist` VALUES (44,'=¨s√',32,'ipv4','2015-10-22 10:33:16','2015-12-29 00:58:17',180,'UNK','graylog-ftp','graylog-ftp-web0c38','Y');
INSERT INTO `blacklist` VALUES (45,'ﬁ*í·',32,'ipv4','2015-10-22 10:33:16','2015-12-29 00:58:27',187,'UNK','graylog-ftp','graylog-ftp-web0c75','Y');
INSERT INTO `blacklist` VALUES (46,'Q!˚',32,'ipv4','2015-10-22 10:33:16','2015-12-29 00:58:26',152,'UNK','graylog-ftp','graylog-ftp-web0c75','Y');
INSERT INTO `blacklist` VALUES (47,'y+¡Q',32,'ipv4','2015-10-22 10:33:16','2015-12-29 00:58:19',174,'UNK','graylog-ftp','graylog-ftp-web0c38','Y');
INSERT INTO `blacklist` VALUES (48,'‹®}ˇ',32,'ipv4','2015-10-22 10:33:16','2015-12-29 00:58:27',155,'UNK','graylog-ftp','graylog-ftp-web0c75','Y');
INSERT INTO `blacklist` VALUES (49,'hÓì/',32,'ipv4','2015-10-22 10:33:16','2015-12-29 14:58:29',180,'UNK','graylog-ftp','graylog-ftp-web0c75','Y');
INSERT INTO `blacklist` VALUES (50,'y)',32,'ipv4','2015-10-22 10:33:16','2015-12-29 00:58:22',154,'UNK','graylog-ftp','graylog-ftp-web0c0','Y');
INSERT INTO `blacklist` VALUES (51,'ﬁ|®í',32,'ipv4','2015-10-22 10:33:16','2015-12-29 00:58:17',154,'UNK','graylog-ftp','graylog-ftp-web0c38','Y');
INSERT INTO `blacklist` VALUES (52,'&kG',32,'ipv4','2015-10-22 10:33:16','2016-01-19 14:58:15',161,'UNK','graylog-ftp','graylog-ftp-web0c45','Y');
INSERT INTO `blacklist` VALUES (6678,'{9ïq',32,'ipv4','2015-10-22 10:33:16','2016-01-17 09:58:10',154,'UNK','graylog-ftp','graylog-ftp-web0c38','Y');
INSERT INTO `blacklist` VALUES (6679,'{8ÅJ',32,'ipv4','2015-10-22 10:33:16','2016-01-17 14:58:11',213,'UNK','graylog-ftp','graylog-ftp-web0c38','Y');
INSERT INTO `blacklist` VALUES (6680,'≥¸t',32,'ipv4','2015-10-22 10:33:16','2016-01-17 11:58:22',174,'UNK','graylog-ftp','graylog-ftp-web0c45','Y');
INSERT INTO `blacklist` VALUES (6681,'j%ÏÁ',32,'ipv4','2015-10-22 10:33:16','2016-01-17 10:58:13',154,'UNK','graylog-ftp','graylog-ftp-web0c0','Y');
INSERT INTO `blacklist` VALUES (6682,'ro¶˜',32,'ipv4','2015-10-22 10:33:16','2016-01-17 10:58:19',163,'UNK','graylog-ftp','graylog-ftp-web0c38','Y');
INSERT INTO `blacklist` VALUES (6683,'v{c',32,'ipv4','2015-10-22 10:33:16','2016-01-17 11:58:22',179,'UNK','graylog-ftp','graylog-ftp-web0c45','Y');
INSERT INTO `blacklist` VALUES (6684,'ªfå',32,'ipv4','2015-10-22 10:33:16','2016-01-17 12:58:19',163,'UNK','graylog-ftp','graylog-ftp-web0c2','Y');
INSERT INTO `blacklist` VALUES (6685,'v˙-À',32,'ipv4','2015-10-22 10:33:16','2016-01-19 14:58:17',170,'UNK','graylog-ftp','graylog-ftp-web0c0','Y');
INSERT INTO `blacklist` VALUES (6686,'}v√û',32,'ipv4','2015-10-22 10:33:16','2016-01-18 14:58:15',158,'UNK','graylog-ftp','graylog-ftp-web0c38','Y');
INSERT INTO `blacklist` VALUES (6687,'*Q.ã',32,'ipv4','2015-10-22 10:33:16','2016-01-17 13:58:17',174,'UNK','graylog-ftp','graylog-ftp-web0c38','Y');
INSERT INTO `blacklist` VALUES (6688,'PVT∑',32,'ipv4','2015-10-22 10:33:16','2016-01-17 13:58:17',167,'UNK','graylog-ftp','graylog-ftp-web0c38','Y');
INSERT INTO `blacklist` VALUES (6691,'poøΩ',32,'ipv4','2015-10-22 10:33:16','2016-01-17 14:58:25',195,'UNK','graylog-ftp','graylog-ftp-web0c25','Y');
INSERT INTO `blacklist` VALUES (6694,'xj',32,'ipv4','2015-10-22 10:33:16','2016-01-17 14:58:12',158,'UNK','graylog-ftp','graylog-ftp-web0c0','Y');
INSERT INTO `blacklist` VALUES (6695,'x£~',32,'ipv4','2015-10-22 10:33:16','2016-01-17 16:58:10',187,'UNK','graylog-ftp','graylog-ftp-web0c38','Y');
INSERT INTO `blacklist` VALUES (6696,'poºÌ',32,'ipv4','2015-10-22 10:33:16','2016-01-17 16:58:13',214,'UNK','graylog-ftp','graylog-ftp-web0c25','Y');
INSERT INTO `blacklist` VALUES (6697,'ùïø',32,'ipv4','2015-10-22 10:33:16','2016-01-17 16:58:10',172,'UNK','graylog-ftp','graylog-ftp-web0c38','Y');
INSERT INTO `blacklist` VALUES (6698,'x%˙j',32,'ipv4','2015-10-22 10:33:16','2016-01-17 17:58:21',285,'UNK','graylog-ftp','graylog-ftp-web0c2','Y');
INSERT INTO `blacklist` VALUES (6699,'tÿ',32,'ipv4','2015-10-22 10:33:16','2016-01-17 19:58:11',170,'UNK','graylog-ftp','graylog-ftp-web0c38','Y');
INSERT INTO `blacklist` VALUES (6700,'g+ì',32,'ipv4','2015-10-22 10:33:16','2016-01-17 19:58:11',195,'UNK','graylog-ftp','graylog-ftp-web0c38','Y');
INSERT INTO `blacklist` VALUES (6701,'j%Ï”',32,'ipv4','2015-10-22 10:33:16','2016-01-17 20:58:17',169,'UNK','graylog-ftp','graylog-ftp-web0c38','Y');
INSERT INTO `blacklist` VALUES (6702,'yŒú=',32,'ipv4','2015-10-22 10:33:16','2016-01-17 19:58:08',157,'UNK','graylog-ftp','graylog-ftp-web0c25','Y');
INSERT INTO `blacklist` VALUES (6703,'ò^',32,'ipv4','2015-10-22 10:33:16','2016-01-17 20:58:17',191,'UNK','graylog-ftp','graylog-ftp-web0c2','Y');
INSERT INTO `blacklist` VALUES (6704,'z\rÑ7',32,'ipv4','2015-10-22 10:33:16','2016-01-17 20:58:28',179,'UNK','graylog-ftp','graylog-ftp-web0c30','Y');
INSERT INTO `blacklist` VALUES (6705,'}X(',32,'ipv4','2015-10-22 10:33:16','2016-01-17 20:58:12',168,'UNK','graylog-ftp','graylog-ftp-web0c45','Y');
INSERT INTO `blacklist` VALUES (6706,'z†>',32,'ipv4','2015-10-22 10:33:16','2016-01-17 20:58:25',152,'UNK','graylog-ftp','graylog-ftp-web0c25','Y');
INSERT INTO `blacklist` VALUES (6707,'åŒvÑ',32,'ipv4','2015-10-22 10:33:16','2016-01-17 21:58:14',193,'UNK','graylog-ftp','graylog-ftp-web0c25','Y');
INSERT INTO `blacklist` VALUES (6708,';&aà',32,'ipv4','2015-10-22 10:33:16','2016-01-17 21:58:13',179,'UNK','graylog-ftp','graylog-ftp-web0c38','Y');
INSERT INTO `blacklist` VALUES (6709,'ò^#',32,'ipv4','2015-10-22 10:33:16','2016-01-17 22:58:12',163,'UNK','graylog-ftp','graylog-ftp-web0c10','Y');
INSERT INTO `blacklist` VALUES (6710,'y9,',32,'ipv4','2015-10-22 10:33:16','2016-01-17 22:58:24',176,'UNK','graylog-ftp','graylog-ftp-web0c25','Y');
INSERT INTO `blacklist` VALUES (6711,'‹ÇõÁ',32,'ipv4','2015-10-22 10:33:16','2016-01-17 22:58:15',188,'UNK','graylog-ftp','graylog-ftp-web0c2','Y');
INSERT INTO `blacklist` VALUES (6712,'j%Ï÷',32,'ipv4','2015-10-22 10:33:16','2016-01-17 22:58:27',187,'UNK','graylog-ftp','graylog-ftp-web0c38','Y');
INSERT INTO `blacklist` VALUES (6713,'\n',32,'ipv4','2015-10-22 10:33:16','2016-01-18 00:58:07',187,'UNK','graylog-ftp','graylog-ftp-web0c10','Y');
INSERT INTO `blacklist` VALUES (6714,';&am',32,'ipv4','2015-10-22 10:33:16','2016-01-18 05:58:26',162,'UNK','graylog-ftp','graylog-ftp-web0c30','Y');
INSERT INTO `blacklist` VALUES (6715,'x%˚å',32,'ipv4','2015-10-22 10:33:16','2016-01-18 01:58:21',157,'UNK','graylog-ftp','graylog-ftp-web0c25','Y');
INSERT INTO `blacklist` VALUES (6716,'z‰Â€',32,'ipv4','2015-10-22 10:33:16','2016-01-18 01:58:21',179,'UNK','graylog-ftp','graylog-ftp-web0c38','Y');
INSERT INTO `blacklist` VALUES (6717,'|»˙',32,'ipv4','2015-10-22 10:33:16','2016-01-18 03:58:08',174,'UNK','graylog-ftp','graylog-ftp-web0c2','Y');
INSERT INTO `blacklist` VALUES (6718,'ò^	',32,'ipv4','2015-10-22 10:33:16','2016-01-18 04:58:16',177,'UNK','graylog-ftp','graylog-ftp-web0c38','Y');
INSERT INTO `blacklist` VALUES (6719,'}X\"',32,'ipv4','2015-10-22 10:33:16','2016-01-18 04:58:17',172,'UNK','graylog-ftp','graylog-ftp-web0c38','Y');
INSERT INTO `blacklist` VALUES (6720,';&aD',32,'ipv4','2015-10-22 10:33:16','2016-01-18 04:58:16',157,'UNK','graylog-ftp','graylog-ftp-web0c38','Y');
INSERT INTO `blacklist` VALUES (6721,'rÛÄ:',32,'ipv4','2015-10-22 10:33:16','2016-01-18 03:58:15',176,'UNK','graylog-ftp','graylog-ftp-web0c38','Y');
INSERT INTO `blacklist` VALUES (6722,'qjet',32,'ipv4','2015-10-22 10:33:16','2016-01-18 04:58:18',169,'UNK','graylog-ftp','graylog-ftp-web0c45','Y');
INSERT INTO `blacklist` VALUES (6723,'ò^A',32,'ipv4','2015-10-22 10:33:16','2016-01-18 07:58:09',168,'UNK','graylog-ftp','graylog-ftp-web0c38','Y');
INSERT INTO `blacklist` VALUES (6724,';&a',32,'ipv4','2015-10-22 10:33:16','2016-01-18 08:58:10',189,'UNK','graylog-ftp','graylog-ftp-web0c38','Y');
INSERT INTO `blacklist` VALUES (6725,'xd©',32,'ipv4','2015-10-22 10:33:16','2016-01-18 14:58:17',164,'UNK','graylog-ftp','graylog-ftp-web0c45','Y');
INSERT INTO `blacklist` VALUES (6726,'$k‘Ç',32,'ipv4','2015-10-22 10:33:16','2016-01-18 08:58:10',208,'UNK','graylog-ftp','graylog-ftp-web0c38','Y');
INSERT INTO `blacklist` VALUES (6727,'tÿ',32,'ipv4','2015-10-22 10:33:16','2016-01-18 08:58:10',186,'UNK','graylog-ftp','graylog-ftp-web0c38','Y');
INSERT INTO `blacklist` VALUES (6728,'©5ÖÜ',32,'ipv4','2015-10-22 10:33:16','2016-01-18 09:38:09',758,'UNK','graylog-shell','graylog-shell-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `blacklist` VALUES (6729,'RMç',32,'ipv4','2015-10-22 10:33:16','2016-01-18 08:58:17',159,'UNK','graylog-ftp','graylog-ftp-web0c0','Y');
INSERT INTO `blacklist` VALUES (6730,';&aé',32,'ipv4','2015-10-22 10:33:16','2016-01-18 10:58:16',159,'UNK','graylog-ftp','graylog-ftp-web0c38','Y');
INSERT INTO `blacklist` VALUES (6731,'j%Ï·',32,'ipv4','2015-10-22 10:33:16','2016-01-18 10:58:26',198,'UNK','graylog-ftp','graylog-ftp-web0c0','Y');
INSERT INTO `blacklist` VALUES (6732,'q9Ω7',32,'ipv4','2015-10-22 10:33:16','2016-01-18 13:58:12',186,'UNK','graylog-ftp','graylog-ftp-web0c38','Y');
INSERT INTO `blacklist` VALUES (6733,'ç¬',32,'ipv4','2015-10-22 10:33:16','2016-01-18 12:40:16',5265,'UNK','graylog-web-wp-login','graylog-web-wp-login-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `blacklist` VALUES (6734,'ªW0\"',32,'ipv4','2015-10-22 10:33:16','2016-01-18 13:58:11',157,'UNK','graylog-ftp','graylog-ftp-web0c45','Y');
INSERT INTO `blacklist` VALUES (6735,'ò^J',32,'ipv4','2015-10-22 10:33:16','2016-01-18 13:58:15',198,'UNK','graylog-ftp','graylog-ftp-web0c25','Y');
INSERT INTO `blacklist` VALUES (6789,'±WÛJ',32,'ipv4','2015-10-22 10:33:16','2016-01-19 11:58:21',195,'UNK','graylog-ftp','graylog-ftp-web0c2','Y');
INSERT INTO `blacklist` VALUES (6790,';&av',32,'ipv4','2015-10-22 10:33:16','2016-01-19 12:58:22',157,'UNK','graylog-ftp','graylog-ftp-web0c2','Y');
INSERT INTO `blacklist` VALUES (6791,';&aù',32,'ipv4','2015-10-22 10:33:16','2016-01-19 12:58:23',155,'UNK','graylog-ftp','graylog-ftp-web0c0','Y');
INSERT INTO `blacklist` VALUES (6806,'%ÔèÈ',32,'ipv4','2015-10-22 10:33:16','2015-10-22 07:58:09',161,'UNK','graylog-ftp','graylog-ftp-web0c28','Y');
INSERT INTO `blacklist` VALUES (6807,'“”~⁄',32,'ipv4','2015-10-22 10:33:16','2016-01-19 22:58:21',170,'UNK','graylog-ftp','graylog-ftp-web0c30','Y');
INSERT INTO `blacklist` VALUES (6808,']ûﬂ ',32,'ipv4','2015-10-22 10:33:16','2015-10-22 06:58:21',184,'UNK','graylog-ftp','graylog-ftp-web0c40','Y');
INSERT INTO `blacklist` VALUES (6809,'r◊Rÿ',32,'ipv4','2015-10-22 10:33:16','2016-01-19 18:58:13',180,'UNK','graylog-ftp','graylog-ftp-web0c38','Y');
INSERT INTO `blacklist` VALUES (6810,'qjeF',32,'ipv4','2015-10-22 10:33:16','2015-10-22 08:58:26',162,'UNK','graylog-ftp','graylog-ftp-web0c38','Y');
INSERT INTO `blacklist` VALUES (6812,'yÍ«I',32,'ipv4','2015-10-22 10:33:16','2015-10-22 08:58:17',180,'UNK','graylog-ftp','graylog-ftp-web0c0','Y');
INSERT INTO `blacklist` VALUES (6813,'{äΩ¥',32,'ipv4','2015-10-22 10:33:16','2015-10-22 07:58:09',165,'UNK','graylog-ftp','graylog-ftp-web0c28','Y');
INSERT INTO `blacklist` VALUES (6814,'wµH',32,'ipv4','2015-10-22 10:33:16','2016-01-19 18:58:13',204,'UNK','graylog-ftp','graylog-ftp-web0c38','Y');
INSERT INTO `blacklist` VALUES (6815,'ª^dÙ',32,'ipv4','2015-10-22 10:33:16','2015-10-22 08:58:13',168,'UNK','graylog-ftp','graylog-ftp-web0c28','Y');
INSERT INTO `blacklist` VALUES (6816,'åŒc.',32,'ipv4','2015-10-22 10:33:16','2015-10-22 07:58:20',183,'UNK','graylog-ftp','graylog-ftp-web0c0','Y');
INSERT INTO `blacklist` VALUES (6817,'∑•Ú”',32,'ipv4','2015-10-22 10:33:16','2015-10-22 08:58:26',151,'UNK','graylog-ftp','graylog-ftp-web0c38','Y');
INSERT INTO `blacklist` VALUES (6818,'Ø\0K',32,'ipv4','2015-10-22 10:33:16','2015-10-22 08:58:26',212,'UNK','graylog-ftp','graylog-ftp-web0c38','Y');
INSERT INTO `blacklist` VALUES (6819,'qjej',32,'ipv4','2015-10-22 10:33:16','2015-10-22 08:58:26',180,'UNK','graylog-ftp','graylog-ftp-web0c38','Y');
INSERT INTO `blacklist` VALUES (6820,';&a!',32,'ipv4','2015-10-22 10:33:16','2016-01-19 19:58:27',170,'UNK','graylog-ftp','graylog-ftp-web0c38','Y');
INSERT INTO `blacklist` VALUES (6821,'R∏O',32,'ipv4','2015-10-22 10:33:16','2015-10-22 08:58:18',171,'UNK','graylog-ftp','graylog-ftp-web0c75','Y');
INSERT INTO `blacklist` VALUES (6822,'¥aQ',32,'ipv4','2015-10-22 10:33:16','2015-10-22 08:58:10',161,'UNK','graylog-ftp','graylog-ftp-web0c45','Y');
INSERT INTO `blacklist` VALUES (6823,'◊ß±',32,'ipv4','2015-10-22 10:33:16','2015-10-22 09:58:23',163,'UNK','graylog-ftp','graylog-ftp-web0c75','Y');
INSERT INTO `blacklist` VALUES (6824,'≠Ê¸:',32,'ipv4','2015-10-22 10:33:16','2016-01-19 19:58:16',165,'UNK','graylog-ftp','graylog-ftp-web0c40','Y');
INSERT INTO `blacklist` VALUES (6825,';&ak',32,'ipv4','2015-10-22 10:33:16','2016-01-19 20:58:21',167,'UNK','graylog-ftp','graylog-ftp-web0c38','Y');
INSERT INTO `blacklist` VALUES (6826,'ò^\"',32,'ipv4','2015-10-22 10:33:16','2015-10-22 08:58:26',179,'UNK','graylog-ftp','graylog-ftp-web0c38','Y');
INSERT INTO `blacklist` VALUES (6827,';-J ',32,'ipv4','2015-10-22 10:33:16','2016-01-19 19:58:17',181,'UNK','graylog-ftp','graylog-ftp-web0c0','Y');
INSERT INTO `blacklist` VALUES (6828,'xf',32,'ipv4','2015-10-22 10:33:16','2016-01-19 20:58:21',225,'UNK','graylog-ftp','graylog-ftp-web0c38','Y');
INSERT INTO `blacklist` VALUES (6829,'ﬂQ¿œ',32,'ipv4','2015-10-22 10:33:16','2015-10-22 08:58:26',163,'UNK','graylog-ftp','graylog-ftp-web0c38','Y');
INSERT INTO `blacklist` VALUES (6830,';\':p',32,'ipv4','2015-10-22 10:33:16','2015-10-22 09:58:23',160,'UNK','graylog-ftp','graylog-ftp-web0c75','Y');
INSERT INTO `blacklist` VALUES (6831,':<rò',32,'ipv4','2015-10-22 10:33:16','2015-10-22 09:58:21',172,'UNK','graylog-ftp','graylog-ftp-web0c38','Y');
INSERT INTO `blacklist` VALUES (6832,'sÊO',32,'ipv4','2015-10-22 10:33:16','2016-01-19 20:58:21',172,'UNK','graylog-ftp','graylog-ftp-web0c38','Y');
INSERT INTO `blacklist` VALUES (6833,';\':',32,'ipv4','2015-10-22 10:33:16','2015-10-22 09:58:21',205,'UNK','graylog-ftp','graylog-ftp-web0c38','Y');
INSERT INTO `blacklist` VALUES (6834,'{9Ó◊',32,'ipv4','2015-10-22 10:33:16','2016-01-19 20:58:21',192,'UNK','graylog-ftp','graylog-ftp-web0c38','Y');
INSERT INTO `blacklist` VALUES (6835,'}(ÿ˝',32,'ipv4','2015-10-22 10:33:16','2015-10-22 09:58:11',197,'UNK','graylog-ftp','graylog-ftp-web0c25','Y');
INSERT INTO `blacklist` VALUES (6836,'x:…',32,'ipv4','2015-10-22 10:33:16','2016-01-19 20:58:09',168,'UNK','graylog-ftp','graylog-ftp-web0c45','Y');
INSERT INTO `blacklist` VALUES (6837,'Ø¿Uv',32,'ipv4','2015-10-22 10:33:16','2015-10-22 09:58:09',155,'UNK','graylog-ftp','graylog-ftp-web0c45','Y');
INSERT INTO `blacklist` VALUES (6838,';&b',32,'ipv4','2015-10-22 10:33:16','2016-01-19 21:58:12',164,'UNK','graylog-ftp','graylog-ftp-web0c38','Y');
INSERT INTO `blacklist` VALUES (6839,'p^ô˝',32,'ipv4','2015-10-22 10:33:16','2016-01-19 20:58:28',170,'UNK','graylog-ftp','graylog-ftp-web0c0','Y');
INSERT INTO `blacklist` VALUES (6840,'î‰®',32,'ipv4','2015-10-22 10:33:16','2016-01-19 20:58:21',164,'UNK','graylog-ftp','graylog-ftp-web0c38','Y');
INSERT INTO `blacklist` VALUES (6841,';&a',32,'ipv4','2015-10-22 10:33:16','2016-01-19 21:58:09',151,'UNK','graylog-ftp','graylog-ftp-web0c2','Y');
INSERT INTO `blacklist` VALUES (6842,'zã',32,'ipv4','2015-10-22 10:33:16','2016-01-19 21:58:12',224,'UNK','graylog-ftp','graylog-ftp-web0c38','Y');
INSERT INTO `blacklist` VALUES (6843,'o°a˜',32,'ipv4','2015-10-22 10:33:16','2016-01-19 21:58:10',162,'UNK','graylog-ftp','graylog-ftp-web0c25','Y');
INSERT INTO `blacklist` VALUES (6844,'qjek',32,'ipv4','2015-10-22 10:33:16','2016-01-19 22:58:12',170,'UNK','graylog-ftp','graylog-ftp-web0c38','Y');
INSERT INTO `blacklist` VALUES (6845,'z‰‰l',32,'ipv4','2015-10-22 10:33:16','2015-10-22 11:58:24',160,'UNK','graylog-ftp','graylog-ftp-web0c25','Y');
INSERT INTO `blacklist` VALUES (6846,'t‚(',32,'ipv4','2015-10-22 10:33:16','2015-10-22 10:58:12',169,'UNK','graylog-ftp','graylog-ftp-web0c38','Y');
INSERT INTO `blacklist` VALUES (6847,'t·í',32,'ipv4','2015-10-22 10:33:16','2015-10-22 10:58:13',158,'UNK','graylog-ftp','graylog-ftp-web0c38','Y');
INSERT INTO `blacklist` VALUES (6848,';&aú',32,'ipv4','2015-10-22 10:33:16','2015-10-22 11:58:12',169,'UNK','graylog-ftp','graylog-ftp-web0c38','Y');
INSERT INTO `blacklist` VALUES (6849,'“%',32,'ipv4','2015-10-22 10:33:16','2016-01-19 22:58:12',171,'UNK','graylog-ftp','graylog-ftp-web0c38','Y');
INSERT INTO `blacklist` VALUES (6850,')¯{¥',32,'ipv4','2015-10-22 10:33:16','2015-10-22 10:58:12',154,'UNK','graylog-ftp','graylog-ftp-web0c38','Y');
INSERT INTO `blacklist` VALUES (6851,';&a',32,'ipv4','2015-10-22 10:33:16','2015-10-22 11:58:12',184,'UNK','graylog-ftp','graylog-ftp-web0c38','Y');
INSERT INTO `blacklist` VALUES (6852,'|rF',32,'ipv4','2015-10-22 10:33:16','2015-10-22 10:58:13',159,'UNK','graylog-ftp','graylog-ftp-web0c38','Y');
INSERT INTO `blacklist` VALUES (6853,'q9Ω)',32,'ipv4','2015-10-22 10:33:16','2015-10-22 11:58:12',157,'UNK','graylog-ftp','graylog-ftp-web0c38','Y');
INSERT INTO `blacklist` VALUES (6854,';-J',32,'ipv4','2015-10-22 10:33:16','2015-10-22 11:58:15',159,'UNK','graylog-ftp','graylog-ftp-web0c75','Y');
INSERT INTO `blacklist` VALUES (6855,'P2',32,'ipv4','2015-10-22 10:33:16','2015-10-22 11:58:12',205,'UNK','graylog-ftp','graylog-ftp-web0c38','Y');
INSERT INTO `blacklist` VALUES (6856,'}]Sf',32,'ipv4','2015-10-22 10:33:16','2016-01-19 22:58:11',196,'UNK','graylog-ftp','graylog-ftp-web0c38','Y');
INSERT INTO `blacklist` VALUES (6857,'wÑNŸ',32,'ipv4','2015-10-22 10:33:16','2015-10-22 11:58:11',161,'UNK','graylog-ftp','graylog-ftp-web0c38','Y');
INSERT INTO `blacklist` VALUES (6858,'=¨ø/',32,'ipv4','2015-10-22 10:33:16','2015-10-22 11:58:24',182,'UNK','graylog-ftp','graylog-ftp-web0c25','Y');
INSERT INTO `blacklist` VALUES (6859,'+;Î',32,'ipv4','2015-10-22 10:33:16','2015-10-22 11:58:12',178,'UNK','graylog-ftp','graylog-ftp-web0c38','Y');
INSERT INTO `blacklist` VALUES (6860,'y*ë)',32,'ipv4','2015-10-22 10:33:16','2015-10-22 11:58:12',188,'UNK','graylog-ftp','graylog-ftp-web0c38','Y');
INSERT INTO `blacklist` VALUES (6862,';&a¬',32,'ipv4','2015-10-22 10:33:16','2016-01-19 23:04:21',182,'UNK','graylog-ftp','graylog-ftp-web0c38','Y');
INSERT INTO `blacklist` VALUES (6863,'oå',32,'ipv4','2015-10-22 10:33:16','2015-10-22 11:58:12',154,'UNK','graylog-ftp','graylog-ftp-web0c0','Y');
INSERT INTO `blacklist` VALUES (6864,'y(µ|',32,'ipv4','2015-10-22 10:33:16','2016-01-19 22:58:12',155,'UNK','graylog-ftp','graylog-ftp-web0c0','Y');
INSERT INTO `blacklist` VALUES (6865,'pZÁ',32,'ipv4','2015-10-22 10:33:16','2015-10-22 12:04:28',173,'UNK','graylog-ftp','graylog-ftp-web0c75','Y');
INSERT INTO `blacklist` VALUES (6866,'p^ö¶',32,'ipv4','2015-10-22 10:33:16','2015-10-22 12:04:21',175,'UNK','graylog-ftp','graylog-ftp-web0c38','Y');
INSERT INTO `blacklist` VALUES (6867,'o¬iÈ',32,'ipv4','2015-10-22 10:33:16','2016-01-19 22:58:11',163,'UNK','graylog-ftp','graylog-ftp-web0c38','Y');
INSERT INTO `blacklist` VALUES (6868,';&b',32,'ipv4','2015-10-22 10:33:16','2016-01-19 23:04:09',155,'UNK','graylog-ftp','graylog-ftp-web0c45','Y');
INSERT INTO `blacklist` VALUES (6869,';&b',32,'ipv4','2015-10-22 10:33:16','2015-10-22 13:58:08',223,'UNK','graylog-ftp','graylog-ftp-web0c45','Y');
INSERT INTO `blacklist` VALUES (6870,';&ar',32,'ipv4','2015-10-22 10:33:16','2016-01-20 00:58:26',158,'UNK','graylog-ftp','graylog-ftp-web0c38','Y');
INSERT INTO `blacklist` VALUES (6871,'r◊X',32,'ipv4','2015-10-22 10:33:16','2016-01-20 00:58:26',153,'UNK','graylog-ftp','graylog-ftp-web0c38','Y');
INSERT INTO `blacklist` VALUES (6872,'s∫P',32,'ipv4','2015-10-22 10:33:16','2016-01-20 00:58:27',192,'UNK','graylog-ftp','graylog-ftp-web0c75','Y');
INSERT INTO `blacklist` VALUES (6873,'P9',32,'ipv4','2015-10-22 10:33:16','2016-01-20 00:58:26',189,'UNK','graylog-ftp','graylog-ftp-web0c38','Y');
INSERT INTO `blacklist` VALUES (6874,'tÿ\n',32,'ipv4','2015-10-22 10:33:16','2015-10-22 13:58:26',166,'UNK','graylog-ftp','graylog-ftp-web0c38','Y');
/*!40000 ALTER TABLE `blacklist` ENABLE KEYS */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER tr_blacklist_insert BEFORE INSERT ON blacklist FOR EACH ROW
BEGIN

   SET NEW.inserttime = NOW();

   IF (NEW.expiretime < NOW() ) THEN
       SET NEW.expiretime = NOW() + INTERVAL 60 MINUTE;
   END IF;

   IF (NEW.type = 'ipv4')  THEN

       IF NOT (NEW.cidr REGEXP '^[0-9]+$') THEN
           SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = 'ipv4 cidr must be int';
       END IF;

       IF NEW.cidr < 12 or NEW.cidr > 32 THEN
           SIGNAL SQLSTATE '45002' SET MESSAGE_TEXT = 'ipv4 cidr must be between 12 and 32';
       END IF;

       IF (NEW.sourceip REGEXP '^([0-1]?[0-9]{1,2}|2[0-4][0-9]|25[0-5])\\.([0-1]?[0-9]{1,2}|2[0-4][0-9]|25[0-5])\\.([0-1]?[0-9]{1,2}|2[0-4][0-9]|25[0-5])\\.([0-1]?[0-9]{1,2}|2[0-4][0-9]|25[0-5])$' ) THEN
           SIGNAL SQLSTATE '45003' SET MESSAGE_TEXT = 'sourceip not in inet6_pton format';
       END IF;

   ELSEIF (NEW.type = 'ipv6')  THEN
       IF NOT (NEW.cidr REGEXP '^[0-9]+$') THEN
           SIGNAL SQLSTATE '45004' SET MESSAGE_TEXT = 'ipv6 cidr must be int';
       END IF;

       IF NEW.cidr < 32 or NEW.cidr > 128 THEN
           SIGNAL SQLSTATE '45005' SET MESSAGE_TEXT = 'ipv6 cidr must be between 32 and 128';
       END IF;   
     
   ELSE
    SIGNAL SQLSTATE '45005' SET MESSAGE_TEXT = 'Invalid col type: must be ipv4 or ipv6';
  END IF;

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER tr_blacklist_update BEFORE UPDATE ON blacklist FOR EACH ROW
BEGIN

   SET NEW.inserttime = NOW();

   IF (NEW.expiretime < NOW() ) THEN
       SET NEW.expiretime = NOW() + INTERVAL 60 MINUTE;
   END IF;

   IF (NEW.type = 'ipv4')  THEN

       IF NOT (NEW.cidr REGEXP '^[0-9]+$') THEN
           SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = 'ipv4 cidr must be int';
       END IF;

       IF NEW.cidr < 12 or NEW.cidr > 32 THEN
           SIGNAL SQLSTATE '45002' SET MESSAGE_TEXT = 'ipv4 cidr must be between 12 and 32';
       END IF;

       IF (NEW.sourceip REGEXP '^([0-1]?[0-9]{1,2}|2[0-4][0-9]|25[0-5])\\.([0-1]?[0-9]{1,2}|2[0-4][0-9]|25[0-5])\\.([0-1]?[0-9]{1,2}|2[0-4][0-9]|25[0-5])\\.([0-1]?[0-9]{1,2}|2[0-4][0-9]|25[0-5])$' ) THEN
           SIGNAL SQLSTATE '45003' SET MESSAGE_TEXT = 'sourceip not in inet6_pton format';
       END IF;

   ELSEIF (NEW.type = 'ipv6')  THEN
       IF NOT (NEW.cidr REGEXP '^[0-9]+$') THEN
           SIGNAL SQLSTATE '45004' SET MESSAGE_TEXT = 'ipv6 cidr must be int';
       END IF;

       IF NEW.cidr < 32 or NEW.cidr > 128 THEN
           SIGNAL SQLSTATE '45005' SET MESSAGE_TEXT = 'ipv6 cidr must be between 32 and 128';
       END IF;   
     
   ELSE
    SIGNAL SQLSTATE '45005' SET MESSAGE_TEXT = 'Invalid col type: must be ipv4 or ipv6';
  END IF;

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER blacklist_history BEFORE DELETE ON `blacklist`
    FOR EACH ROW BEGIN
        INSERT INTO history (sourceip,cidr,type,inserttime,expiretime,hits,country,comment,insertby,allow_edit) VALUES (
        OLD.sourceip,OLD.cidr,OLD.type,OLD.inserttime,OLD.expiretime,OLD.hits,OLD.country,OLD.comment,OLD.insertby,OLD.allow_edit );
    END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `graylog_settings_connections`
--

DROP TABLE IF EXISTS `graylog_settings_connections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `graylog_settings_connections` (
  `id` mediumint(10) unsigned NOT NULL AUTO_INCREMENT,
  `connections` smallint(6) unsigned NOT NULL DEFAULT '200',
  `block_for` int(10) unsigned NOT NULL DEFAULT '200',
  `inserttime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `comment` varchar(250) NOT NULL DEFAULT '-',
  `insertby` varchar(250) NOT NULL DEFAULT '-',
  PRIMARY KEY (`id`),
  UNIQUE KEY `myindex` (`connections`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `graylog_settings_connections`
--

/*!40000 ALTER TABLE `graylog_settings_connections` DISABLE KEYS */;
INSERT INTO `graylog_settings_connections` VALUES (1,100,43200,'2015-09-17 17:45:52','12h block','SecGuy');
INSERT INTO `graylog_settings_connections` VALUES (2,500,86400,'2015-09-30 16:27:23','24h block','SecGuy');
INSERT INTO `graylog_settings_connections` VALUES (3,599,86400,'2015-09-30 16:27:31','24h block','SecGuy');
INSERT INTO `graylog_settings_connections` VALUES (4,600,86400,'2015-09-30 16:27:34','24h block','SecGuy');
INSERT INTO `graylog_settings_connections` VALUES (5,700,86400,'2015-09-30 16:27:36','24h block','SecGuy');
INSERT INTO `graylog_settings_connections` VALUES (6,799,86400,'2015-09-30 16:27:40','24h block','SecGuy');
INSERT INTO `graylog_settings_connections` VALUES (7,800,86400,'2015-09-17 17:46:37','24h block','SecGuy');
INSERT INTO `graylog_settings_connections` VALUES (8,900,86400,'2015-09-17 17:46:37','24h block','SecGuy');
INSERT INTO `graylog_settings_connections` VALUES (9,999,86400,'2015-09-17 17:46:37','24h block','SecGuy');
INSERT INTO `graylog_settings_connections` VALUES (10,1000,64800,'2015-06-19 18:51:00','18h block','SecGuy');
INSERT INTO `graylog_settings_connections` VALUES (11,1500,86400,'2015-06-19 18:51:00','18h block','SecGuy');
INSERT INTO `graylog_settings_connections` VALUES (12,1600,86400,'2015-06-19 18:51:00','24h block','SecGuy');
INSERT INTO `graylog_settings_connections` VALUES (13,1999,86400,'2015-06-19 18:51:00','24h block','SecGuy');
INSERT INTO `graylog_settings_connections` VALUES (14,4000,86400,'2015-06-19 18:51:00','24h block','SecGuy');
INSERT INTO `graylog_settings_connections` VALUES (15,8000,604800,'2015-06-19 18:51:00','7d block','SecGuy');
INSERT INTO `graylog_settings_connections` VALUES (16,9000,604800,'2015-06-19 18:51:00','7d block','SecGuy');
INSERT INTO `graylog_settings_connections` VALUES (17,10000,31557600,'2015-06-19 18:51:00','1y block','SecGuy');
INSERT INTO `graylog_settings_connections` VALUES (18,200,43200,'2015-09-17 17:45:52','12h block','SecGuy');
INSERT INTO `graylog_settings_connections` VALUES (19,299,86400,'2015-09-30 16:28:00','24h block','SecGuy');
INSERT INTO `graylog_settings_connections` VALUES (20,399,86400,'2015-09-30 16:28:04','24h block','SecGuy');
/*!40000 ALTER TABLE `graylog_settings_connections` ENABLE KEYS */;

--
-- Table structure for table `graylog_strings`
--

DROP TABLE IF EXISTS `graylog_strings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `graylog_strings` (
  `id` mediumint(10) unsigned NOT NULL AUTO_INCREMENT,
  `string` varchar(250) NOT NULL DEFAULT 'wpad.dat',
  `type` enum('GET','POST','HEAD') DEFAULT NULL,
  `hits` smallint(5) unsigned NOT NULL DEFAULT '200',
  `inserttime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `expiretime` datetime NOT NULL DEFAULT '9999-12-31 23:59:59',
  `comment` varchar(250) NOT NULL DEFAULT '-',
  `insertby` varchar(250) NOT NULL DEFAULT '-',
  PRIMARY KEY (`id`),
  UNIQUE KEY `myindex` (`string`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `graylog_strings`
--

/*!40000 ALTER TABLE `graylog_strings` DISABLE KEYS */;
INSERT INTO `graylog_strings` VALUES (1,'wp-login.php','POST',200,'2015-06-19 18:50:46','9999-12-31 23:59:59','WP Administrator Login','SecGuy');
INSERT INTO `graylog_strings` VALUES (2,'wpad.dat','GET',200,'2015-08-17 02:12:32','9999-12-31 23:59:59','admin page','SecGuy');
INSERT INTO `graylog_strings` VALUES (3,'ftpchk3.php','GET',50,'2015-08-17 02:12:32','9999-12-31 23:59:59','FTP CMS detector','SecGuy');
/*!40000 ALTER TABLE `graylog_strings` ENABLE KEYS */;

--
-- Table structure for table `history`
--

DROP TABLE IF EXISTS `history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `history` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `sourceip` varbinary(16) NOT NULL,
  `cidr` smallint(3) NOT NULL DEFAULT '32',
  `type` enum('ipv4','ipv6') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'ipv4',
  `inserttime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `expiretime` datetime NOT NULL DEFAULT '9999-12-31 23:59:59',
  `hits` int(8) unsigned NOT NULL DEFAULT '0',
  `country` varchar(3) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'UNK',
  `comment` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `insertby` varchar(80) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `allow_edit` enum('Y','N') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Y',
  PRIMARY KEY (`id`),
  KEY `sourceip` (`sourceip`),
  KEY `timestamps` (`inserttime`,`expiretime`)
) ENGINE=InnoDB AUTO_INCREMENT=130610 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `history`
--

/*!40000 ALTER TABLE `history` DISABLE KEYS */;
INSERT INTO `history` VALUES (2847,'ﬁ?¢',32,'ipv4','2015-10-21 18:42:06','2015-09-07 06:56:16',630,'UNK','graylog-mail','mail-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `history` VALUES (2848,'⁄õä',32,'ipv4','2015-10-21 18:42:06','2015-09-07 06:52:11',633,'UNK','graylog-mail','mail-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `history` VALUES (2849,' 8•',32,'ipv4','2015-10-21 18:42:06','2015-09-07 06:54:26',611,'UNK','graylog-mail','mail-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `history` VALUES (2850,'r`O>',32,'ipv4','2015-10-21 18:42:06','2015-09-07 06:52:11',612,'UNK','graylog-mail','mail-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `history` VALUES (2851,' h∑k',32,'ipv4','2015-10-21 18:42:06','2015-09-07 06:52:11',620,'UNK','graylog-mail','mail-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `history` VALUES (2852,'IÅ≈∆',32,'ipv4','2015-10-21 18:42:06','2015-09-07 06:52:11',604,'UNK','graylog-mail','mail-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `history` VALUES (2853,'∏^\Z√',32,'ipv4','2015-10-21 18:42:06','2015-09-07 06:56:16',601,'UNK','graylog-mail','mail-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `history` VALUES (2854,'Rqjâ',32,'ipv4','2015-10-21 18:42:06','2015-09-07 06:56:16',608,'UNK','graylog-mail','mail-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `history` VALUES (2855,'∂w:Ä',32,'ipv4','2015-10-21 18:42:06','2015-09-07 06:55:10',164,'UNK','graylog-ftp','graylog-ftp-web0c0','Y');
INSERT INTO `history` VALUES (2856,'x<√',32,'ipv4','2015-10-21 18:42:06','2015-09-07 06:55:29',187,'UNK','graylog-ftp','graylog-ftp-web0c38','Y');
INSERT INTO `history` VALUES (2857,'™_É',32,'ipv4','2015-10-21 18:42:06','2015-09-07 06:55:15',167,'UNK','graylog-ftp','graylog-ftp-web0c45','Y');
INSERT INTO `history` VALUES (2858,'{\ZâM',32,'ipv4','2015-10-21 18:42:06','2015-09-07 06:55:29',173,'UNK','graylog-ftp','graylog-ftp-web0c38','Y');
INSERT INTO `history` VALUES (2860,'zËc',32,'ipv4','2015-10-21 18:42:06','2015-09-07 06:55:11',152,'UNK','graylog-ftp','graylog-ftp-web0c28','Y');
INSERT INTO `history` VALUES (2861,'poºO',32,'ipv4','2015-10-21 18:42:06','2015-09-07 06:55:25',182,'UNK','graylog-ftp','graylog-ftp-web0c10','Y');
INSERT INTO `history` VALUES (2862,'´ÈE8',32,'ipv4','2015-10-21 18:42:06','2015-09-07 06:55:15',165,'UNK','graylog-ftp','graylog-ftp-web0c75','Y');
INSERT INTO `history` VALUES (2863,'ﬁ—˘À',32,'ipv4','2015-10-21 18:42:06','2015-09-07 06:55:29',252,'UNK','graylog-ftp','graylog-ftp-web0c38','Y');
INSERT INTO `history` VALUES (2864,'qv',32,'ipv4','2015-10-21 18:42:06','2015-09-07 06:55:10',181,'UNK','graylog-ftp','graylog-ftp-web0c25','Y');
INSERT INTO `history` VALUES (2865,'q•{',32,'ipv4','2015-10-21 18:42:06','2015-09-07 06:55:29',156,'UNK','graylog-ftp','graylog-ftp-web0c38','Y');
INSERT INTO `history` VALUES (2866,'ﬁHÖ∂',32,'ipv4','2015-10-21 18:42:06','2015-09-07 06:55:10',175,'UNK','graylog-ftp','graylog-ftp-web0c25','Y');
INSERT INTO `history` VALUES (2867,'M9',32,'ipv4','2015-10-21 18:42:06','2015-09-07 06:55:15',160,'UNK','graylog-ftp','graylog-ftp-web0c45','Y');
INSERT INTO `history` VALUES (2868,'LiÆ',32,'ipv4','2015-10-21 18:42:06','2015-09-07 06:55:10',163,'UNK','graylog-ftp','graylog-ftp-web0c25','Y');
INSERT INTO `history` VALUES (2869,'x\Zå„',32,'ipv4','2015-10-21 18:42:06','2015-09-07 06:55:25',156,'UNK','graylog-ftp','graylog-ftp-web0c10','Y');
INSERT INTO `history` VALUES (2870,'H@G',32,'ipv4','2015-10-21 18:42:06','2015-09-07 06:55:29',161,'UNK','graylog-ftp','graylog-ftp-web0c38','Y');
INSERT INTO `history` VALUES (2871,'ºBÈ',32,'ipv4','2015-10-21 18:42:06','2015-09-07 07:00:16',942,'UNK','graylog-asm-violations','asm-violations-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `history` VALUES (2872,'ÃtxÇ',32,'ipv4','2015-10-21 18:42:06','2015-09-07 06:58:14',637,'UNK','graylog-mail','mail-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `history` VALUES (2873,'y„&V',32,'ipv4','2015-10-21 18:42:06','2015-09-07 06:58:14',617,'UNK','graylog-mail','mail-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `history` VALUES (2874,'$!P›',32,'ipv4','2015-10-21 18:42:06','2015-09-07 07:00:17',601,'UNK','graylog-mail','mail-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `history` VALUES (2875,'∑£I',32,'ipv4','2015-10-21 18:42:06','2015-09-07 07:00:17',661,'UNK','graylog-mail','mail-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `history` VALUES (2876,']OK}',32,'ipv4','2015-10-21 18:42:06','2015-09-07 06:58:14',609,'UNK','graylog-mail','mail-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `history` VALUES (2877,'∆ÃÔz',32,'ipv4','2015-10-21 18:42:06','2015-09-07 07:02:28',2126,'UNK','graylog-asm-violations','asm-violations-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `history` VALUES (2878,'∆ÃÊÇ',32,'ipv4','2015-10-21 18:42:06','2015-09-07 07:02:28',1351,'UNK','graylog-asm-violations','asm-violations-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `history` VALUES (2879,'f≥œ',32,'ipv4','2015-10-21 18:42:06','2015-09-07 07:02:22',1036,'UNK','graylog-mail','mail-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `history` VALUES (2880,'ºx˘„',32,'ipv4','2015-10-21 18:42:06','2015-09-07 07:04:13',1085,'UNK','graylog-asm-violations','asm-violations-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `history` VALUES (2881,'»s£≠',32,'ipv4','2015-10-21 18:42:06','2015-09-07 07:02:22',1028,'UNK','graylog-mail','mail-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `history` VALUES (2882,'vxò',32,'ipv4','2015-10-21 18:42:06','2015-09-07 07:02:20',794,'UNK','graylog-mail','mail-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `history` VALUES (2883,'ﬁˆ÷∆',32,'ipv4','2015-10-21 18:42:06','2015-09-07 07:02:20',634,'UNK','graylog-mail','mail-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `history` VALUES (2884,'πp¯>',32,'ipv4','2015-10-21 18:42:06','2015-09-07 07:04:26',631,'UNK','graylog-mail','mail-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `history` VALUES (2885,'ÃºÒ®',32,'ipv4','2015-10-21 18:42:06','2015-09-07 07:06:26',603,'UNK','graylog-mail','mail-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `history` VALUES (2886,'xçyY',32,'ipv4','2015-10-21 18:42:06','2015-09-07 07:02:20',618,'UNK','graylog-mail','mail-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `history` VALUES (2887,'ÿ/-',32,'ipv4','2015-10-21 18:42:06','2015-09-07 07:04:26',643,'UNK','graylog-mail','mail-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `history` VALUES (2888,'¨bƒk',32,'ipv4','2015-10-21 18:42:06','2015-09-07 07:10:17',1134,'UNK','graylog-mail','mail-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `history` VALUES (2889,'*(Ä\0˙Œ∞\0\0\0',128,'ipv6','2015-10-21 18:42:06','2015-09-07 07:10:03',106,'UNK','graylog-afm-drop','afm-drop-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `history` VALUES (2890,'√ö∞',32,'ipv4','2015-10-21 18:42:06','2015-09-07 07:10:21',663,'UNK','graylog-web','web-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `history` VALUES (2891,'J–≠è',32,'ipv4','2015-10-21 18:42:06','2015-09-07 07:08:17',677,'UNK','graylog-mail','mail-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `history` VALUES (2892,'O©Ÿ∑',32,'ipv4','2015-10-21 18:42:06','2015-09-07 07:12:09',625,'UNK','graylog-mail','mail-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `history` VALUES (2893,'Y#≤;',32,'ipv4','2015-10-21 18:42:06','2015-09-07 07:12:09',611,'UNK','graylog-mail','mail-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `history` VALUES (2894,'å˘?ó',32,'ipv4','2015-10-21 18:42:06','2015-09-07 07:12:09',657,'UNK','graylog-mail','mail-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `history` VALUES (2895,'}ÏÍå',32,'ipv4','2015-10-21 18:42:06','2015-09-07 07:10:12',631,'UNK','graylog-mail','mail-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `history` VALUES (2896,'_ç',32,'ipv4','2015-10-21 18:42:06','2015-09-07 07:12:23',923,'UNK','graylog-asm-violations','asm-violations-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `history` VALUES (2897,'∆@\n',32,'ipv4','2015-10-21 18:42:06','2015-09-07 07:16:29',852,'UNK','graylog-asm-violations','asm-violations-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `history` VALUES (2898,'z„‡2',32,'ipv4','2015-10-21 18:42:06','2015-09-07 07:12:23',814,'UNK','graylog-asm-violations','asm-violations-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `history` VALUES (2899,'π?ˇr',32,'ipv4','2015-10-21 18:42:06','2015-09-07 07:16:20',616,'UNK','graylog-mail','mail-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `history` VALUES (2900,'QÜ®',32,'ipv4','2015-10-21 18:42:06','2015-09-07 07:14:27',654,'UNK','graylog-mail','mail-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `history` VALUES (2901,'¢ˇV',32,'ipv4','2015-10-21 18:42:06','2015-09-07 07:18:11',1185,'UNK','graylog-mail','mail-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `history` VALUES (2902,'¿c$',32,'ipv4','2015-10-21 18:42:06','2015-09-07 07:22:09',914,'UNK','graylog-asm-violations','asm-violations-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `history` VALUES (2903,'z«&',32,'ipv4','2015-10-21 18:42:06','2015-09-07 07:18:27',867,'UNK','graylog-asm-violations','asm-violations-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `history` VALUES (2904,'qÛ÷Ô',32,'ipv4','2015-10-21 18:42:06','2015-09-07 07:20:10',616,'UNK','graylog-mail','mail-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `history` VALUES (2905,'“\\',32,'ipv4','2015-10-21 18:42:06','2015-09-07 07:18:18',645,'UNK','graylog-web','web-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `history` VALUES (2906,'∆Øí',32,'ipv4','2015-10-21 18:42:06','2015-09-07 07:20:17',676,'UNK','graylog-web','web-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `history` VALUES (2907,'F#ÃΩ',32,'ipv4','2015-10-21 18:42:06','2015-09-07 07:18:19',627,'UNK','graylog-mail','mail-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `history` VALUES (2908,'≠…Œ',32,'ipv4','2015-10-21 18:42:06','2015-09-07 07:20:17',645,'UNK','graylog-web','web-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `history` VALUES (2909,'º≠',32,'ipv4','2015-10-21 18:42:06','2015-09-07 07:20:09',604,'UNK','graylog-mail','mail-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `history` VALUES (2910,'?ç‡j',32,'ipv4','2015-10-21 18:42:06','2015-09-07 07:22:21',1670,'UNK','graylog-asm-violations','asm-violations-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `history` VALUES (2911,'^ÿL',32,'ipv4','2015-10-21 18:42:06','2015-09-07 07:24:11',1166,'UNK','graylog-asm-violations','asm-violations-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `history` VALUES (2912,'∆&]Ÿ',32,'ipv4','2015-10-21 18:42:06','2015-09-07 07:24:08',628,'UNK','graylog-mail','mail-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `history` VALUES (2913,'vx˜|',32,'ipv4','2015-10-21 18:42:06','2015-09-07 07:26:15',609,'UNK','graylog-mail','mail-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `history` VALUES (2914,'ﬁˆÛ¬',32,'ipv4','2015-10-21 18:42:06','2015-09-07 07:26:15',686,'UNK','graylog-mail','mail-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `history` VALUES (2915,'ﬁ•.',32,'ipv4','2015-10-21 18:42:06','2015-09-07 07:24:07',607,'UNK','graylog-mail','mail-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `history` VALUES (2916,'Wb„ﬁ',32,'ipv4','2015-10-21 18:42:06','2015-09-07 07:33:16',966,'UNK','graylog-asm-violations','asm-violations-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `history` VALUES (2917,'±iBK',32,'ipv4','2015-10-21 18:42:06','2015-09-07 07:33:16',708,'UNK','graylog-mail','mail-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `history` VALUES (2918,'æ«O	',32,'ipv4','2015-10-21 18:42:06','2015-09-07 07:33:16',745,'UNK','graylog-web','web-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `history` VALUES (2919,'„ÓÍ',32,'ipv4','2015-10-21 18:42:06','2015-09-07 07:33:16',685,'UNK','graylog-mail','mail-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `history` VALUES (2920,'|Á\'ı',32,'ipv4','2015-10-21 18:42:06','2015-09-07 07:33:16',662,'UNK','graylog-mail','mail-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `history` VALUES (2921,'UÖæö',32,'ipv4','2015-10-21 18:42:06','2015-09-07 07:33:16',605,'UNK','graylog-mail','mail-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `history` VALUES (2922,'%À÷π',32,'ipv4','2015-10-21 18:42:06','2015-09-07 07:33:16',630,'UNK','graylog-mail','mail-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `history` VALUES (2923,'≠–√ù',32,'ipv4','2015-10-21 18:42:06','2015-09-07 07:34:27',665,'UNK','graylog-mail','mail-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `history` VALUES (2924,'Dî˘',32,'ipv4','2015-10-21 18:42:06','2015-09-07 07:40:18',1143,'UNK','graylog-mail','mail-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `history` VALUES (2925,'±F{g',32,'ipv4','2015-10-21 18:42:06','2015-09-07 07:40:13',674,'UNK','graylog-mail','mail-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `history` VALUES (2926,'vˇ{≥',32,'ipv4','2015-10-21 18:42:06','2015-09-07 07:40:14',624,'UNK','graylog-mail','mail-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `history` VALUES (2927,'´”\Z;',32,'ipv4','2015-10-21 18:42:06','2015-09-07 07:40:14',620,'UNK','graylog-mail','mail-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `history` VALUES (2928,'vxıò',32,'ipv4','2015-10-21 18:42:06','2015-09-07 07:40:14',666,'UNK','graylog-mail','mail-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `history` VALUES (2929,'x?«Å',32,'ipv4','2015-10-21 18:42:06','2015-09-07 07:38:27',694,'UNK','graylog-mail','mail-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `history` VALUES (2930,'pÑ´”',32,'ipv4','2015-10-21 18:42:06','2015-09-07 07:40:14',626,'UNK','graylog-mail','mail-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `history` VALUES (2931,'ßX#H',32,'ipv4','2015-10-21 18:42:06','2015-09-07 07:43:30',4000,'UNK','tornet','tornet-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `history` VALUES (2932,'3˛e',32,'ipv4','2015-10-21 18:42:06','2015-09-07 07:43:32',4000,'UNK','tornet','tornet-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `history` VALUES (2933,'Rx‚L',32,'ipv4','2015-10-21 18:42:06','2015-09-07 07:43:59',4000,'UNK','tornet','tornet-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `history` VALUES (2934,'%ìfÏ',32,'ipv4','2015-10-21 18:42:06','2015-09-07 07:43:47',4000,'UNK','tornet','tornet-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `history` VALUES (2935,'Sÿz',32,'ipv4','2015-10-21 18:42:06','2015-09-07 07:43:51',4000,'UNK','tornet','tornet-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `history` VALUES (2936,'kèê',32,'ipv4','2015-10-21 18:42:06','2015-09-07 07:43:49',4000,'UNK','tornet','tornet-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `history` VALUES (2937,'OÁFñ',32,'ipv4','2015-10-21 18:42:06','2015-09-07 07:43:29',4000,'UNK','tornet','tornet-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `history` VALUES (2938,'^W≠',32,'ipv4','2015-10-21 18:42:06','2015-09-07 07:43:51',4000,'UNK','tornet','tornet-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `history` VALUES (2939,'W¶º',32,'ipv4','2015-10-21 18:42:06','2015-09-07 07:43:57',4000,'UNK','tornet','tornet-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `history` VALUES (2940,'>]e_',32,'ipv4','2015-10-21 18:42:06','2015-09-07 07:43:35',4000,'UNK','tornet','tornet-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `history` VALUES (2941,'N\"ñ',32,'ipv4','2015-10-21 18:42:06','2015-09-07 07:43:49',4000,'UNK','tornet','tornet-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `history` VALUES (2942,'Wdñ>',32,'ipv4','2015-10-21 18:42:06','2015-09-07 07:43:47',4000,'UNK','tornet','tornet-nsyslog-mia1.sec.domain.com','Y');
INSERT INTO `history` VALUES (2943,'W´≈H',32,'ipv4','2015-10-21 18:42:06','2015-09-07 07:43:25',4000,'UNK','tornet','tornet-nsyslog-mia1.sec.domain.com','Y');

/*!40000 ALTER TABLE `history` ENABLE KEYS */;

--
-- Table structure for table `history_thresholdhits`
--

DROP TABLE IF EXISTS `history_thresholdhits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `history_thresholdhits` (
  `id` mediumint(10) unsigned NOT NULL AUTO_INCREMENT,
  `hits` smallint(6) unsigned NOT NULL DEFAULT '200',
  `block_for` int(10) unsigned NOT NULL DEFAULT '200',
  `inserttime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `comment` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `insertby` varchar(80) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `myindex` (`hits`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `history_thresholdhits`
--

/*!40000 ALTER TABLE `history_thresholdhits` DISABLE KEYS */;
INSERT INTO `history_thresholdhits` VALUES (1,3,604800,'2015-06-19 18:51:31','1w block','SecGuy');
INSERT INTO `history_thresholdhits` VALUES (2,6,2419200,'2015-06-19 18:51:31','1m block','SecGuy');
INSERT INTO `history_thresholdhits` VALUES (3,10,7776000,'2015-06-19 18:51:31','3m block','SecGuy');
/*!40000 ALTER TABLE `history_thresholdhits` ENABLE KEYS */;

--
-- Table structure for table `stats`
--

DROP TABLE IF EXISTS `stats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `stats` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `inserttime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `ips_manual` mediumint(10) unsigned NOT NULL DEFAULT '0',
  `hits_manual` int(15) unsigned NOT NULL DEFAULT '0',
  `ips_web` mediumint(10) unsigned NOT NULL DEFAULT '0',
  `hits_web` int(15) unsigned NOT NULL DEFAULT '0',
  `ips_asm` mediumint(10) unsigned NOT NULL DEFAULT '0',
  `hits_asm` int(15) unsigned NOT NULL DEFAULT '0',
  `ips_mail` mediumint(10) unsigned NOT NULL DEFAULT '0',
  `hits_mail` int(15) unsigned NOT NULL DEFAULT '0',
  `ips_ftp` mediumint(10) unsigned NOT NULL DEFAULT '0',
  `hits_ftp` int(15) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stats`
--

/*!40000 ALTER TABLE `stats` DISABLE KEYS */;
/*!40000 ALTER TABLE `stats` ENABLE KEYS */;

--
-- Table structure for table `temp_whitelist`
--

DROP TABLE IF EXISTS `temp_whitelist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `temp_whitelist` (
  `id` mediumint(10) unsigned NOT NULL AUTO_INCREMENT,
  `sourceip` varbinary(16) NOT NULL,
  `cidr` smallint(3) NOT NULL DEFAULT '32',
  `type` enum('ipv4','ipv6') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'ipv4',
  `inserttime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `expiretime` datetime NOT NULL DEFAULT '9999-12-31 23:59:59',
  `hits` int(8) unsigned NOT NULL DEFAULT '0',
  `country` varchar(3) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'UNK',
  `comment` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `insertby` varchar(80) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `allow_edit` enum('Y','N') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Y',
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_whitelist` (`sourceip`),
  KEY `sourceip` (`sourceip`),
  KEY `timestamps` (`inserttime`,`expiretime`)
) ENGINE=InnoDB AUTO_INCREMENT=346 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `temp_whitelist`
--

/*!40000 ALTER TABLE `temp_whitelist` DISABLE KEYS */;
INSERT INTO `temp_whitelist` VALUES (7,'∆)\0',32,'ipv4','2015-08-09 16:28:04','9999-12-31 23:59:59',0,'UNK','DNS root','SecGuy','N');
INSERT INTO `temp_whitelist` VALUES (8,'¿‰O…',32,'ipv4','2015-08-09 16:28:04','9999-12-31 23:59:59',0,'UNK','DNS root','SecGuy','N');
INSERT INTO `temp_whitelist` VALUES (9,'¿!',32,'ipv4','2015-08-09 16:28:04','9999-12-31 23:59:59',0,'UNK','DNS root','SecGuy','N');
INSERT INTO `temp_whitelist` VALUES (10,'«[\r',32,'ipv4','2015-08-09 16:28:04','9999-12-31 23:59:59',0,'UNK','DNS root','SecGuy','N');
INSERT INTO `temp_whitelist` VALUES (11,'¿ÀÊ\n',32,'ipv4','2015-08-09 16:28:04','9999-12-31 23:59:59',0,'UNK','DNS root','SecGuy','N');
INSERT INTO `temp_whitelist` VALUES (12,'¿Ò',32,'ipv4','2015-08-09 16:28:04','9999-12-31 23:59:59',0,'UNK','DNS root','SecGuy','N');
INSERT INTO `temp_whitelist` VALUES (13,'¿p$',32,'ipv4','2015-08-09 16:28:04','9999-12-31 23:59:59',0,'UNK','DNS root','SecGuy','N');
INSERT INTO `temp_whitelist` VALUES (14,'Ä?5',32,'ipv4','2015-08-09 16:28:04','9999-12-31 23:59:59',0,'UNK','DNS root','SecGuy','N');
INSERT INTO `temp_whitelist` VALUES (15,'¿$î',32,'ipv4','2015-08-09 16:28:04','9999-12-31 23:59:59',0,'UNK','DNS root','SecGuy','N');
INSERT INTO `temp_whitelist` VALUES (16,'¿:Ä',32,'ipv4','2015-08-09 16:28:04','9999-12-31 23:59:59',0,'UNK','DNS root','SecGuy','N');
INSERT INTO `temp_whitelist` VALUES (17,'¡\0Å',32,'ipv4','2015-08-09 16:28:04','9999-12-31 23:59:59',0,'UNK','DNS root','SecGuy','N');
INSERT INTO `temp_whitelist` VALUES (18,'«S*',32,'ipv4','2015-08-09 16:28:04','9999-12-31 23:59:59',0,'UNK','DNS root','SecGuy','N');
INSERT INTO `temp_whitelist` VALUES (19,' !',32,'ipv4','2015-08-09 16:28:04','9999-12-31 23:59:59',0,'UNK','DNS root','SecGuy','N');
INSERT INTO `temp_whitelist` VALUES (20,'≠\0Q',32,'ipv4','2015-08-09 16:28:04','9999-12-31 23:59:59',0,'UNK','PayPal-D-3483952','SecGuy','N');
INSERT INTO `temp_whitelist` VALUES (21,'≠\0Q!',32,'ipv4','2015-08-09 16:28:04','9999-12-31 23:59:59',0,'UNK','PayPal-D-3483952','SecGuy','N');
INSERT INTO `temp_whitelist` VALUES (22,'B”™B',32,'ipv4','2015-08-09 16:28:04','9999-12-31 23:59:59',0,'UNK','PayPal-D-3483952','SecGuy','N');
INSERT INTO `temp_whitelist` VALUES (199,'∆2Æ!',32,'ipv4','2015-08-09 16:28:04','9999-12-31 23:59:59',0,'UNK','sucuri.net fw','SecGuy','Y');
INSERT INTO `temp_whitelist` VALUES (200,'éŸª',32,'ipv4','2015-08-09 16:28:04','9999-12-31 23:59:59',0,'UNK','sucuri.net fw','SecGuy','Y');
INSERT INTO `temp_whitelist` VALUES (201,'∆2Æ\"',32,'ipv4','2015-08-09 16:28:04','9999-12-31 23:59:59',0,'UNK','sucuri.net fw','SecGuy','Y');
INSERT INTO `temp_whitelist` VALUES (202,'éŸº',32,'ipv4','2015-08-09 16:28:04','9999-12-31 23:59:59',0,'UNK','sucuri.net fw','SecGuy','Y');
/*!40000 ALTER TABLE `temp_whitelist` ENABLE KEYS */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER tr_temp_whitelist_insert BEFORE INSERT ON temp_whitelist FOR EACH ROW
BEGIN

   SET NEW.inserttime = NOW();

   IF (NEW.expiretime < NOW() ) THEN
       SET NEW.expiretime = NOW() + INTERVAL 2880 MINUTE;
   END IF;


   IF (NEW.type = 'ipv4')  THEN
       SET NEW.cidr = 32;

       IF (NEW.sourceip REGEXP '^([0-1]?[0-9]{1,2}|2[0-4][0-9]|25[0-5])\\.([0-1]?[0-9]{1,2}|2[0-4][0-9]|25[0-5])\\.([0-1]?[0-9]{1,2}|2[0-4][0-9]|25[0-5])\\.([0-1]?[0-9]{1,2}|2[0-4][0-9]|25[0-5])$' ) THEN
           SIGNAL SQLSTATE '45003' SET MESSAGE_TEXT = 'tr_temp_whitelist_insert: sourceip not in inet6_pton format';
       END IF;

   ELSEIF (NEW.type = 'ipv6')  THEN
       SET NEW.cidr = 128;

   ELSE
    SIGNAL SQLSTATE '45005' SET MESSAGE_TEXT = 'tr_temp_whitelist_insert: Invalid col type: must be ipv4 or ipv6';
  END IF;

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER tr_temp_whitelist_update BEFORE UPDATE ON temp_whitelist FOR EACH ROW
BEGIN

   SET NEW.inserttime = NOW();

   IF (NEW.expiretime < NOW() ) THEN
       SET NEW.expiretime = NOW() + INTERVAL 2880 MINUTE;
   END IF;

   IF (NEW.type = 'ipv4')  THEN
       SET NEW.cidr = 32;

       IF (NEW.sourceip REGEXP '^([0-1]?[0-9]{1,2}|2[0-4][0-9]|25[0-5])\\.([0-1]?[0-9]{1,2}|2[0-4][0-9]|25[0-5])\\.([0-1]?[0-9]{1,2}|2[0-4][0-9]|25[0-5])\\.([0-1]?[0-9]{1,2}|2[0-4][0-9]|25[0-5])$' ) THEN
           SIGNAL SQLSTATE '45003' SET MESSAGE_TEXT = 'tr_temp_whitelist_update: sourceip not in inet6_pton format';
       END IF;

   ELSEIF (NEW.type = 'ipv6')  THEN
       SET NEW.cidr = 128;

   ELSE
    SIGNAL SQLSTATE '45005' SET MESSAGE_TEXT = 'tr_temp_whitelist_update: Invalid col type: must be ipv4 or ipv6';
  END IF;

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER temp_whitelist_history BEFORE DELETE ON `temp_whitelist`
    FOR EACH ROW BEGIN
        INSERT INTO temp_whitelist_history (sourceip,cidr,type,inserttime,expiretime,hits,country,comment,insertby,allow_edit) VALUES (
        OLD.sourceip,OLD.cidr,OLD.type,OLD.inserttime,OLD.expiretime,OLD.hits,OLD.country,OLD.comment,OLD.insertby,OLD.allow_edit );
    END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `temp_whitelist_history`
--

DROP TABLE IF EXISTS `temp_whitelist_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `temp_whitelist_history` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `sourceip` varbinary(16) NOT NULL,
  `cidr` smallint(3) NOT NULL DEFAULT '32',
  `type` enum('ipv4','ipv6') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'ipv4',
  `inserttime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `expiretime` datetime NOT NULL DEFAULT '9999-12-31 23:59:59',
  `hits` int(8) unsigned NOT NULL DEFAULT '0',
  `country` varchar(3) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'UNK',
  `comment` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `insertby` varchar(80) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `allow_edit` enum('Y','N') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Y',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=241 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `temp_whitelist_history`
--

/*!40000 ALTER TABLE `temp_whitelist_history` DISABLE KEYS */;
INSERT INTO `temp_whitelist_history` VALUES (2,'&\0<\0\0\0\0<ëˇ˛Æ:Ó',0,'ipv6','2015-08-09 16:32:10','9999-12-31 23:59:59',169,'UNK','graylog-ftp','graylog-ftp-mal0c75.sec.domain.com','Y');
INSERT INTO `temp_whitelist_history` VALUES (57,'»†x',32,'ipv4','2015-08-09 16:28:04','9999-12-31 23:59:59',0,'UNK','ftptemp_whitelist','SecGuy','Y');
INSERT INTO `temp_whitelist_history` VALUES (59,'…8Kå',32,'ipv4','2015-08-09 16:28:04','9999-12-31 23:59:59',0,'UNK','ftptemp_whitelist','SecGuy','Y');
INSERT INTO `temp_whitelist_history` VALUES (60,'…8Kç',32,'ipv4','2015-08-09 16:28:04','9999-12-31 23:59:59',0,'UNK','ftptemp_whitelist','SecGuy','Y');
INSERT INTO `temp_whitelist_history` VALUES (61,'…8Ké',32,'ipv4','2015-08-09 16:28:04','9999-12-31 23:59:59',0,'UNK','ftptemp_whitelist','SecGuy','Y');
INSERT INTO `temp_whitelist_history` VALUES (62,'…8Kè',32,'ipv4','2015-08-09 16:28:04','9999-12-31 23:59:59',0,'UNK','ftptemp_whitelist','SecGuy','Y');
INSERT INTO `temp_whitelist_history` VALUES (63,'…8Kê',32,'ipv4','2015-08-09 16:28:04','9999-12-31 23:59:59',0,'UNK','ftptemp_whitelist','SecGuy','Y');
INSERT INTO `temp_whitelist_history` VALUES (64,'…8Kë',32,'ipv4','2015-08-09 16:28:04','9999-12-31 23:59:59',0,'UNK','ftptemp_whitelist','SecGuy','Y');
INSERT INTO `temp_whitelist_history` VALUES (65,'…8Kí',32,'ipv4','2015-08-09 16:28:04','9999-12-31 23:59:59',0,'UNK','ftptemp_whitelist','SecGuy','Y');
INSERT INTO `temp_whitelist_history` VALUES (66,'…8Kì',32,'ipv4','2015-08-09 16:28:04','9999-12-31 23:59:59',0,'UNK','ftptemp_whitelist','SecGuy','Y');
INSERT INTO `temp_whitelist_history` VALUES (67,'…8Kî',32,'ipv4','2015-08-09 16:28:04','9999-12-31 23:59:59',0,'UNK','ftptemp_whitelist','SecGuy','Y');
INSERT INTO `temp_whitelist_history` VALUES (68,'…8Kï',32,'ipv4','2015-08-09 16:28:04','9999-12-31 23:59:59',0,'UNK','ftptemp_whitelist','SecGuy','Y');
INSERT INTO `temp_whitelist_history` VALUES (69,'Ã——Å',32,'ipv4','2015-08-09 16:28:04','9999-12-31 23:59:59',0,'UNK','ftptemp_whitelist','SecGuy','Y');
/*!40000 ALTER TABLE `temp_whitelist_history` ENABLE KEYS */;

--
-- Table structure for table `whitelist`
--

DROP TABLE IF EXISTS `whitelist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `whitelist` (
  `id` mediumint(10) unsigned NOT NULL AUTO_INCREMENT,
  `sourceip` varbinary(16) NOT NULL,
  `cidr` smallint(3) NOT NULL DEFAULT '32',
  `type` enum('ipv4','ipv6') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'ipv4',
  `inserttime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `expiretime` datetime NOT NULL DEFAULT '9999-12-31 23:59:59',
  `hits` int(8) unsigned NOT NULL DEFAULT '0',
  `country` varchar(3) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'UNK',
  `comment` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `insertby` varchar(80) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `allow_edit` enum('Y','N') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Y',
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_whitelist` (`sourceip`,`cidr`),
  KEY `timestamps` (`inserttime`,`expiretime`),
  KEY `sourceip` (`sourceip`)
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `whitelist`
--

/*!40000 ALTER TABLE `whitelist` DISABLE KEYS */;
INSERT INTO `whitelist` VALUES (2,'\nF\0',20,'ipv4','2015-08-28 15:19:44','9999-12-31 23:59:59',0,'UNK','VPN','SecGuy','N');
INSERT INTO `whitelist` VALUES (3,'\0\0\0',8,'ipv4','2015-08-28 15:22:33','9999-12-31 23:59:59',0,'UNK','self','SecGuy','N');
INSERT INTO `whitelist` VALUES (4,'\n\0\0\0',8,'ipv4','2015-08-28 15:19:44','9999-12-31 23:59:59',0,'UNK','Private','SecGuy','N');
INSERT INTO `whitelist` VALUES (5,'¿®\0\0',16,'ipv4','2015-08-28 15:19:44','9999-12-31 23:59:59',0,'UNK','Private','SecGuy','N');
INSERT INTO `whitelist` VALUES (6,'¨\0\0',12,'ipv4','2015-08-28 15:19:44','9999-12-31 23:59:59',0,'UNK','Private','SecGuy','N');
INSERT INTO `whitelist` VALUES (23,'≠\0T\0',24,'ipv4','2015-08-28 15:19:44','9999-12-31 23:59:59',0,'UNK','PayPal','SecGuy','N');
INSERT INTO `whitelist` VALUES (24,'≠\0X\0',24,'ipv4','2015-08-28 15:19:44','9999-12-31 23:59:59',0,'UNK','PayPal','SecGuy','N');
INSERT INTO `whitelist` VALUES (25,'≠\0\\\0',24,'ipv4','2015-08-28 15:19:44','9999-12-31 23:59:59',0,'UNK','PayPal-D-3483952','SecGuy','N');
INSERT INTO `whitelist` VALUES (26,'≠\0]\0',24,'ipv4','2015-08-28 15:19:44','9999-12-31 23:59:59',0,'UNK','PayPal-D-3483952','SecGuy','N');
INSERT INTO `whitelist` VALUES (27,'@¯\0',24,'ipv4','2015-08-28 15:19:44','9999-12-31 23:59:59',0,'UNK','PayPal-D-3483952','SecGuy','N');
INSERT INTO `whitelist` VALUES (28,'@˘\0',24,'ipv4','2015-08-28 15:19:44','9999-12-31 23:59:59',0,'UNK','PayPal-D-3483952','SecGuy','N');
INSERT INTO `whitelist` VALUES (29,'B”®\0',24,'ipv4','2015-08-28 15:19:44','9999-12-31 23:59:59',0,'UNK','PayPal-D-3483952','SecGuy','N');
INSERT INTO `whitelist` VALUES (30,'∫Á\0\0',24,'ipv4','2015-08-28 15:19:44','9999-12-31 23:59:59',0,'UNK','ftptemp_whitelist','SecGuy','Y');
INSERT INTO `whitelist` VALUES (31,'Àô\0',24,'ipv4','2015-08-28 15:19:44','9999-12-31 23:59:59',0,'UNK','ftpwhitelist','SecGuy','Y');
INSERT INTO `whitelist` VALUES (32,'Àô\r\0',24,'ipv4','2015-08-28 15:19:44','9999-12-31 23:59:59',0,'UNK','ftpwhitelist','SecGuy','Y');
INSERT INTO `whitelist` VALUES (33,'’Vç\0',24,'ipv4','2015-08-28 15:19:44','9999-12-31 23:59:59',0,'UNK','ftpwhitelist','SecGuy','Y');
INSERT INTO `whitelist` VALUES (34,'@⁄©\0',24,'ipv4','2015-08-28 15:19:44','9999-12-31 23:59:59',0,'UNK','ftpwhitelist','SecGuy','Y');
INSERT INTO `whitelist` VALUES (36,'¸\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',7,'ipv6','2015-08-28 15:19:44','9999-12-31 23:59:59',0,'UNK','ipv6 Unique local','SecGuy','Y');
INSERT INTO `whitelist` VALUES (37,'˛Ä\0\0\0\0\0\0\0\0\0\0\0\0\0\0',10,'ipv6','2015-08-28 15:19:44','9999-12-31 23:59:59',0,'UNK','ipv6 Link local','SecGuy','Y');
INSERT INTO `whitelist` VALUES (38,'˛¿\0\0\0\0\0\0\0\0\0\0\0\0\0\0',10,'ipv6','2015-08-28 15:19:44','9999-12-31 23:59:59',0,'UNK','ipv6 link-local absolete','SecGuy','Y');
INSERT INTO `whitelist` VALUES (39,'©˛\0\0',16,'ipv4','2015-08-28 15:19:44','9999-12-31 23:59:59',0,'UNK','ipv4 IANA reserved','SecGuy','Y');
INSERT INTO `whitelist` VALUES (40,'¿\0\0',24,'ipv4','2015-08-28 15:19:44','9999-12-31 23:59:59',0,'UNK','ipv4 IANA reserved','SecGuy','Y');
INSERT INTO `whitelist` VALUES (41,'‡\0\0\0',4,'ipv4','2015-08-28 15:19:44','9999-12-31 23:59:59',0,'UNK','ipv4 IANA reserved','SecGuy','Y');
INSERT INTO `whitelist` VALUES (42,'\0\0\0',5,'ipv4','2015-08-28 15:19:44','9999-12-31 23:59:59',0,'UNK','ipv4 IANA reserved','SecGuy','Y');
INSERT INTO `whitelist` VALUES (43,'¯\0\0\0',5,'ipv4','2015-08-28 15:19:44','9999-12-31 23:59:59',0,'UNK','ipv4 IANA reserved','SecGuy','Y');
INSERT INTO `whitelist` VALUES (44,'\0\0\0\0',8,'ipv4','2015-08-28 15:30:12','9999-12-31 23:59:59',0,'UNK','Private','SecGuy','Y');
INSERT INTO `whitelist` VALUES (45,'Ä\0\0\0',16,'ipv4','2015-08-28 15:30:12','9999-12-31 23:59:59',0,'UNK','Private','SecGuy','Y');
INSERT INTO `whitelist` VALUES (46,'øˇ\0\0',16,'ipv4','2015-08-28 15:30:12','9999-12-31 23:59:59',0,'UNK','Private','SecGuy','Y');
INSERT INTO `whitelist` VALUES (47,'¿\0\0\0',24,'ipv4','2015-08-28 15:30:12','9999-12-31 23:59:59',0,'UNK','Private','SecGuy','Y');
INSERT INTO `whitelist` VALUES (48,'¿Xc\0',24,'ipv4','2015-08-28 15:30:12','9999-12-31 23:59:59',0,'UNK','Private','SecGuy','Y');
INSERT INTO `whitelist` VALUES (49,'∆\0\0',15,'ipv4','2015-08-28 15:30:12','9999-12-31 23:59:59',0,'UNK','Private','SecGuy','Y');
INSERT INTO `whitelist` VALUES (50,'ﬂˇˇ\0',24,'ipv4','2015-08-28 15:31:15','9999-12-31 23:59:59',0,'UNK','Private','SecGuy','Y');
/*!40000 ALTER TABLE `whitelist` ENABLE KEYS */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER tr_whitelist_insert BEFORE INSERT ON whitelist FOR EACH ROW
BEGIN
SET NEW.inserttime = NOW();
   SET NEW.expiretime = '9999-12-31 23:59:59';

   IF (NEW.type = 'ipv4')  THEN

       IF NOT (NEW.cidr REGEXP '^[0-9]+$') THEN
           SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = 'tr_whitelist_insert: ipv4 cidr must be int';
       END IF;

       IF NEW.cidr < 12 or NEW.cidr > 31 THEN
           SIGNAL SQLSTATE '45002' SET MESSAGE_TEXT = 'tr_whitelist_insert: ipv4 cidr must be between 12 and 31';
       END IF;

       IF (NEW.sourceip REGEXP '^([0-1]?[0-9]{1,2}|2[0-4][0-9]|25[0-5])\\.([0-1]?[0-9]{1,2}|2[0-4][0-9]|25[0-5])\\.([0-1]?[0-9]{1,2}|2[0-4][0-9]|25[0-5])\\.([0-1]?[0-9]{1,2}|2[0-4][0-9]|25[0-5])$' ) THEN
           SIGNAL SQLSTATE '45003' SET MESSAGE_TEXT = 'tr_whitelist_insert: sourceip not in inet6_pton format';
       END IF;

   ELSEIF (NEW.type = 'ipv6')  THEN
       IF NOT (NEW.cidr REGEXP '^[0-9]+$') THEN
           SIGNAL SQLSTATE '45004' SET MESSAGE_TEXT = 'tr_whitelist_insert: ipv6 cidr must be int';
       END IF;

       IF NEW.cidr < 32 or NEW.cidr > 127 THEN
           SIGNAL SQLSTATE '45005' SET MESSAGE_TEXT = 'tr_whitelist_insert: ipv6 cidr must be between 32 and 127';
       END IF;
   ELSE
    SIGNAL SQLSTATE '45005' SET MESSAGE_TEXT = 'tr_whitelist_insert: Invalid col type: must be ipv4 or ipv6';
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER tr_whitelist_update BEFORE UPDATE ON whitelist FOR EACH ROW
BEGIN
 SET NEW.inserttime = NOW();
   SET NEW.expiretime = '9999-12-31 23:59:59';

   IF (NEW.type = 'ipv4')  THEN

       IF NOT (NEW.cidr REGEXP '^[0-9]+$') THEN
           SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = 'tr_whitelist_update: ipv4 cidr must be int';
       END IF;

       IF NEW.cidr < 12 or NEW.cidr > 31 THEN
           SIGNAL SQLSTATE '45002' SET MESSAGE_TEXT = 'tr_whitelist_update: ipv4 cidr must be between 12 and 31';
       END IF;

       IF (NEW.sourceip REGEXP '^([0-1]?[0-9]{1,2}|2[0-4][0-9]|25[0-5])\\.([0-1]?[0-9]{1,2}|2[0-4][0-9]|25[0-5])\\.([0-1]?[0-9]{1,2}|2[0-4][0-9]|25[0-5])\\.([0-1]?[0-9]{1,2}|2[0-4][0-9]|25[0-5])$' ) THEN
           SIGNAL SQLSTATE '45003' SET MESSAGE_TEXT = 'tr_whitelist_update: sourceip not in inet6_pton format';
       END IF;

   ELSEIF (NEW.type = 'ipv6')  THEN
       IF NOT (NEW.cidr REGEXP '^[0-9]+$') THEN
           SIGNAL SQLSTATE '45004' SET MESSAGE_TEXT = 'tr_whitelist_update: ipv6 cidr must be int';
       END IF;

       IF NEW.cidr < 32 or NEW.cidr > 127 THEN
           SIGNAL SQLSTATE '45005' SET MESSAGE_TEXT = 'tr_whitelist_update: ipv6 cidr must be between 32 and 127';
       END IF;
   ELSE
    SIGNAL SQLSTATE '45005' SET MESSAGE_TEXT = 'tr_whitelist_update: Invalid col type: must be ipv4 or ipv6';
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Dumping events for database 'RTBH'
--
/*!50106 SET @save_time_zone= @@TIME_ZONE */ ;
/*!50106 DROP EVENT IF EXISTS `clean_blacklist` */;
DELIMITER ;;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;;
/*!50003 SET character_set_client  = utf8 */ ;;
/*!50003 SET character_set_results = utf8 */ ;;
/*!50003 SET collation_connection  = utf8_general_ci */ ;;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;;
/*!50003 SET sql_mode              = '' */ ;;
/*!50003 SET @saved_time_zone      = @@time_zone */ ;;
/*!50003 SET time_zone             = 'SYSTEM' */ ;;
/*!50106 CREATE*/ /*!50117 DEFINER=`root`@`localhost`*/ /*!50106 EVENT `clean_blacklist` ON SCHEDULE EVERY 5 MINUTE STARTS '2015-06-19 22:42:11' ON COMPLETION NOT PRESERVE ENABLE DO BEGIN DELETE FROM `blacklist` WHERE expiretime < DATE_SUB(NOW(), INTERVAL 5 MINUTE );
END */ ;;
/*!50003 SET time_zone             = @saved_time_zone */ ;;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;;
/*!50003 SET character_set_client  = @saved_cs_client */ ;;
/*!50003 SET character_set_results = @saved_cs_results */ ;;
/*!50003 SET collation_connection  = @saved_col_connection */ ;;
/*!50106 DROP EVENT IF EXISTS `clean_history` */;;
DELIMITER ;;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;;
/*!50003 SET character_set_client  = utf8 */ ;;
/*!50003 SET character_set_results = utf8 */ ;;
/*!50003 SET collation_connection  = utf8_general_ci */ ;;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;;
/*!50003 SET sql_mode              = '' */ ;;
/*!50003 SET @saved_time_zone      = @@time_zone */ ;;
/*!50003 SET time_zone             = 'SYSTEM' */ ;;
/*!50106 CREATE*/ /*!50117 DEFINER=`root`@`localhost`*/ /*!50106 EVENT `clean_history` ON SCHEDULE EVERY 5 MINUTE STARTS '2015-06-19 14:43:54' ON COMPLETION NOT PRESERVE ENABLE DO BEGIN DELETE FROM `history` WHERE expiretime < DATE_SUB(NOW(), INTERVAL 45 DAY);
END */ ;;
/*!50003 SET time_zone             = @saved_time_zone */ ;;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;;
/*!50003 SET character_set_client  = @saved_cs_client */ ;;
/*!50003 SET character_set_results = @saved_cs_results */ ;;
/*!50003 SET collation_connection  = @saved_col_connection */ ;;
/*!50106 DROP EVENT IF EXISTS `clean_temp_whitelist` */;;
DELIMITER ;;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;;
/*!50003 SET character_set_client  = utf8 */ ;;
/*!50003 SET character_set_results = utf8 */ ;;
/*!50003 SET collation_connection  = utf8_general_ci */ ;;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;;
/*!50003 SET sql_mode              = '' */ ;;
/*!50003 SET @saved_time_zone      = @@time_zone */ ;;
/*!50003 SET time_zone             = 'SYSTEM' */ ;;
/*!50106 CREATE*/ /*!50117 DEFINER=`root`@`localhost`*/ /*!50106 EVENT `clean_temp_whitelist` ON SCHEDULE EVERY 5 MINUTE STARTS '2015-06-19 14:46:27' ON COMPLETION NOT PRESERVE ENABLE DO BEGIN DELETE FROM `temp_whitelist` WHERE expiretime < DATE_SUB(NOW(), INTERVAL 5 MINUTE);
END */ ;;
/*!50003 SET time_zone             = @saved_time_zone */ ;;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;;
/*!50003 SET character_set_client  = @saved_cs_client */ ;;
/*!50003 SET character_set_results = @saved_cs_results */ ;;
/*!50003 SET collation_connection  = @saved_col_connection */ ;;
/*!50106 DROP EVENT IF EXISTS `renumber_blacklist` */;;
DELIMITER ;;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;;
/*!50003 SET character_set_client  = utf8 */ ;;
/*!50003 SET character_set_results = utf8 */ ;;
/*!50003 SET collation_connection  = utf8_general_ci */ ;;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;;
/*!50003 SET sql_mode              = '' */ ;;
/*!50003 SET @saved_time_zone      = @@time_zone */ ;;
/*!50003 SET time_zone             = 'SYSTEM' */ ;;
/*!50106 CREATE*/ /*!50117 DEFINER=`root`@`localhost`*/ /*!50106 EVENT `renumber_blacklist` ON SCHEDULE EVERY 1 HOUR STARTS '2015-06-19 22:33:16' ON COMPLETION NOT PRESERVE ENABLE COMMENT 'renumbering blacklist table' DO BEGIN set @a=0; update blacklist set id=(@a:=@a+1); ALTER TABLE blacklist auto_increment = 1; END */ ;;
/*!50003 SET time_zone             = @saved_time_zone */ ;;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;;
/*!50003 SET character_set_client  = @saved_cs_client */ ;;
/*!50003 SET character_set_results = @saved_cs_results */ ;;
/*!50003 SET collation_connection  = @saved_col_connection */ ;;
/*!50106 DROP EVENT IF EXISTS `renumber_history` */;;
DELIMITER ;;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;;
/*!50003 SET character_set_client  = utf8 */ ;;
/*!50003 SET character_set_results = utf8 */ ;;
/*!50003 SET collation_connection  = utf8_general_ci */ ;;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;;
/*!50003 SET sql_mode              = '' */ ;;
/*!50003 SET @saved_time_zone      = @@time_zone */ ;;
/*!50003 SET time_zone             = 'SYSTEM' */ ;;
/*!50106 CREATE*/ /*!50117 DEFINER=`root`@`localhost`*/ /*!50106 EVENT `renumber_history` ON SCHEDULE EVERY 1 DAY STARTS '2015-06-19 14:42:06' ON COMPLETION NOT PRESERVE ENABLE COMMENT 'renumbering history table' DO BEGIN set @a=0; update history set id=(@a:=@a+1); ALTER TABLE history auto_increment = 1; END */ ;;
/*!50003 SET time_zone             = @saved_time_zone */ ;;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;;
/*!50003 SET character_set_client  = @saved_cs_client */ ;;
/*!50003 SET character_set_results = @saved_cs_results */ ;;
/*!50003 SET collation_connection  = @saved_col_connection */ ;;
/*!50106 DROP EVENT IF EXISTS `stats` */;;
DELIMITER ;;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;;
/*!50003 SET character_set_client  = utf8 */ ;;
/*!50003 SET character_set_results = utf8 */ ;;
/*!50003 SET collation_connection  = utf8_general_ci */ ;;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;;
/*!50003 SET sql_mode              = '' */ ;;
/*!50003 SET @saved_time_zone      = @@time_zone */ ;;
/*!50003 SET time_zone             = 'SYSTEM' */ ;;
/*!50106 CREATE*/ /*!50117 DEFINER=`root`@`localhost`*/ /*!50106 EVENT `stats` ON SCHEDULE EVERY 1 DAY STARTS '2015-02-25 23:59:30' ON COMPLETION NOT PRESERVE ENABLE DO BEGIN
          INSERT INTO RTBH_stats (`ips_manual`,`hits_manual`, `ips_web`,`hits_web`, `ips_asm`,`hits_asm`, `ips_mail`,`hits_mail`, `ips_ftp`,`hits_ftp`) VALUES (
              (select count(1) from blacklist where insertby NOT LIKE 'graylog%'),
              (select SUM(hits) from blacklist where insertby NOT LIKE 'graylog%'),
              (select count(1) from blacklist where insertby LIKE 'graylog-web%'),
              (select SUM(hits) from blacklist where insertby LIKE 'graylog-web%'),

              (select count(1) from blacklist where insertby LIKE 'graylog-asm%'),
              (select SUM(hits) from blacklist where insertby LIKE 'graylog-asm%'),

              (select count(1) from blacklist where insertby LIKE 'graylog-mail%'),
              (select SUM(hits) from blacklist where insertby LIKE 'graylog-mail%'),

              (select count(1) from blacklist where insertby LIKE 'graylog-ftp%'),
              (select SUM(hits) from blacklist where insertby LIKE 'graylog-ftp%'));
      END */ ;;
/*!50003 SET time_zone             = @saved_time_zone */ ;;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;;
/*!50003 SET character_set_client  = @saved_cs_client */ ;;
/*!50003 SET character_set_results = @saved_cs_results */ ;;
/*!50003 SET collation_connection  = @saved_col_connection */ ;;
DELIMITER ;
/*!50106 SET TIME_ZONE= @save_time_zone */ ;

--
-- Dumping routines for database 'RTBH'
--
/*!50003 DROP PROCEDURE IF EXISTS `blacklist6` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `blacklist6`( IN ip VARCHAR(255))
BEGIN
    SELECT id, inet6_ntop(sourceip) as ip, cidr, type,inserttime, expiretime, hits, country, comment, insertby, allow_edit FROM blacklist WHERE inet6_ntop(sourceip)=ip;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `delete6` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete6`( IN ip VARCHAR(255))
BEGIN
    DELETE FROM blacklist where inet6_ntop(sourceip)= ip;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `history6` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `history6`(IN ip VARCHAR (255))
BEGIN select count(*) as total from history where  inet6_ntop(sourceip) = ip; end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `insert4` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `insert4`( IN ip VARCHAR(255))
BEGIN
    insert into blacklist (sourceip, cidr, type, inserttime,expiretime,hits,country,comment,insertby,allow_edit) VALUES (inet6_pton(ip),'32','ipv4', NOW(), '9999-12-31 23:59:59',0,'UNK','mysql-api','mysql-api','Y');
    SELECT id, inet6_ntop(sourceip) as ip, cidr, type,inserttime, expiretime, hits, country, comment, insertby, allow_edit FROM blacklist WHERE inet6_ntop(sourceip)=ip;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `insert6` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `insert6`( IN ip VARCHAR(255))
BEGIN
    insert into blacklist (sourceip, cidr, type, inserttime,expiretime,hits,country,comment,insertby,allow_edit) VALUES (inet6_pton(ip),'128','ipv6', NOW(), '9999-12-31 23:59:59',0,'UNK','mysql-api','mysql-api','Y');
    SELECT id, inet6_ntop(sourceip) as ip, cidr, type,inserttime, expiretime, hits, country, comment, insertby, allow_edit FROM blacklist WHERE inet6_ntop(sourceip)=ip;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `select6` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `select6`(IN tab_name VARCHAR(255) )
BEGIN
 SET @t1 =CONCAT('SELECT id, inet6_ntop(sourceip) as sourceip, cidr, type,inserttime, expiretime, hits, country, comment, insertby, allow_edit FROM ',tab_name );
 PREPARE stmt3 FROM @t1;
 EXECUTE stmt3;
 DEALLOCATE PREPARE stmt3;
END ;;
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

-- Dump completed on 2015-10-22  6:50:06
