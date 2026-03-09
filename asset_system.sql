-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 09, 2026 at 09:27 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `asset_system`
--

-- --------------------------------------------------------

--
-- Table structure for table `items`
--

CREATE TABLE `items` (
  `id` int(11) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `code` varchar(100) DEFAULT NULL,
  `status` varchar(100) DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `items`
--

INSERT INTO `items` (`id`, `name`, `type`, `code`, `status`, `location`, `image`) VALUES
(1, 'Printer', 'Electronic', 'EQ001', 'ปกติ', 'ห้อง101', ''),
(2, 'Computer', 'Electronic', 'EQ002', 'ปกติ', 'ห้อง102', ''),
(3, 'Projector', 'Electronic', 'EQ003', 'ปกติ', 'ห้องประชุม', ''),
(9, 'คอมพิวเตอร์', '1234568', '62828277', 'จำหน่ายออก', 'ไม่ต้องรู้', 'scaled_3458a9b5-3bc5-4eee-b224-1f78bb90d57b1319815583386517411.jpg'),
(10, 'com1', 'computer ', '744000010004-30502-00172', 'ชำรุดรอซ่อม', 'idk', 'scaled_dde85cf3-af33-4a13-96ce-bce943e4fe472860956409148663273.jpg'),
(12, 'com2', 'computer ', '744000010004-30502-00168', 'จำหน่ายออก', 'B415', 'scaled_394b8510-ee6c-4b5c-9302-49cc4a0344f16647054757227031264.jpg'),
(13, 'โต๊ะ', 'โต๊ะคอม', '7110-017-06-12/00188', 'ชำรุดรอซ่อม', 'B415', 'scaled_e98f8265-2707-47e1-be5a-230420f4b89f7147640186673471763.jpg');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(100) DEFAULT NULL,
  `password` varchar(100) DEFAULT NULL,
  `fullname` varchar(255) DEFAULT NULL,
  `role` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `fullname`, `role`) VALUES
(1, 'admin', '1234', 'ผู้ดูแลระบบ', 'admin'),
(3, 'Tanakorn', '123456', 'Tanakorn', 'user'),
(4, 'jeng', '28062546', NULL, 'user');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `items`
--
ALTER TABLE `items`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `items`
--
ALTER TABLE `items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
