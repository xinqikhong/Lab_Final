-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 21, 2023 at 05:06 PM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `barteritdb`
--

-- --------------------------------------------------------

--
-- Table structure for table `tbl_users`
--

CREATE TABLE `tbl_users` (
  `user_id` int(11) NOT NULL,
  `user_email` varchar(50) NOT NULL,
  `user_name` varchar(30) NOT NULL,
  `user_password` varchar(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_users`
--

INSERT INTO `tbl_users` (`user_id`, `user_email`, `user_name`, `user_password`) VALUES
(1, 'kxq@gmail.com', 'kxq', 'Khongq11@'),
(2, 'kxq1@gmail.com', 'kxq1', '$2y$10$OhmpVFQDmU9C4zcko7URaueQ7Txkqc5/B'),
(3, 'kxq2@gmail.com', 'kxq2', '$2y$10$o2Zu9qakvwpZx47PuFE2wOIA.FIAQDhQy'),
(4, 'kxq3@gmail.com', 'kxq3', '$2y$10$jevxqKzUu5AsYPC5yf0JDuDPZJYDnznZ0'),
(5, 'kxq4@gmail.com', 'kxq4', '$2y$10$HEkBnUgDL8Nt7PMvBXyX2.DbH8UbbFRLF'),
(6, 'kxq5@gmail.com', 'kxq5', '$2y$10$hKO.SLf/Ws/evicQ5skPD.KXeQguENTr4'),
(7, 'khong@gmail.com', 'khong', '2b231881a4d88d9194ef66dc2f610895f944c2ee'),
(8, 'xinqi11@gmail.com', 'xinqi', 'd0aa1a7f8f64ae619abc1c8b2b1a21ea5adabe38'),
(9, 'xqk@gmail.com', 'xqk', 'cb5d380d438a850b717fd858e30d436c11a49d41'),
(10, 'qwe@gmail.com', 'qwe', 'eb377796eef1db1c1c83c9dfbe863feed8d274cc'),
(11, 'khongxq@gmail.com', 'khongxinqi', 'd0aa1a7f8f64ae619abc1c8b2b1a21ea5adabe38');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tbl_users`
--
ALTER TABLE `tbl_users`
  ADD PRIMARY KEY (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tbl_users`
--
ALTER TABLE `tbl_users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
