/*
 Navicat Premium Data Transfer

 Source Server         : localhost
 Source Server Type    : MySQL
 Source Server Version : 80031 (8.0.31)
 Source Host           : localhost:3306
 Source Schema         : ReportDB

 Target Server Type    : MySQL
 Target Server Version : 80031 (8.0.31)
 File Encoding         : 65001

 Date: 07/12/2022 20:37:25
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for Account
-- ----------------------------
DROP TABLE IF EXISTS `Account`;
CREATE TABLE `Account` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` text,
  `email` text,
  `password` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Records of Account
-- ----------------------------
BEGIN;
INSERT INTO `Account` (`id`, `name`, `email`, `password`) VALUES (1, 'name', 'test', 'aaa');
COMMIT;

-- ----------------------------
-- Table structure for ReportContent
-- ----------------------------
DROP TABLE IF EXISTS `ReportContent`;
CREATE TABLE `ReportContent` (
  `id` int NOT NULL AUTO_INCREMENT,
  `accountId` int NOT NULL,
  `dateTime` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `accountId` (`accountId`),
  CONSTRAINT `reportcontent_ibfk_1` FOREIGN KEY (`accountId`) REFERENCES `Account` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Records of ReportContent
-- ----------------------------
BEGIN;
INSERT INTO `ReportContent` (`id`, `accountId`, `dateTime`) VALUES (6, 1, '2022-12-07');
INSERT INTO `ReportContent` (`id`, `accountId`, `dateTime`) VALUES (7, 1, '2022-12-07');
INSERT INTO `ReportContent` (`id`, `accountId`, `dateTime`) VALUES (8, 1, '2022-12-07');
COMMIT;

-- ----------------------------
-- Table structure for ReportDetail
-- ----------------------------
DROP TABLE IF EXISTS `ReportDetail`;
CREATE TABLE `ReportDetail` (
  `id` int NOT NULL AUTO_INCREMENT,
  `content` text,
  `imgPath` text,
  `reportContentId` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `reportContentId` (`reportContentId`),
  CONSTRAINT `reportdetail_ibfk_1` FOREIGN KEY (`reportContentId`) REFERENCES `ReportContent` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Records of ReportDetail
-- ----------------------------
BEGIN;
INSERT INTO `ReportDetail` (`id`, `content`, `imgPath`, `reportContentId`) VALUES (1, 'testContent', '', 6);
INSERT INTO `ReportDetail` (`id`, `content`, `imgPath`, `reportContentId`) VALUES (2, 'testContent', '', 7);
INSERT INTO `ReportDetail` (`id`, `content`, `imgPath`, `reportContentId`) VALUES (3, 'testContent', '', 8);
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;
