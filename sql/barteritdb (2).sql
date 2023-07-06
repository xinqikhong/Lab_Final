-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 06, 2023 at 09:32 AM
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
-- Table structure for table `tbl_items`
--

CREATE TABLE `tbl_items` (
  `item_id` int(5) NOT NULL,
  `item_owner` int(30) NOT NULL,
  `item_name` varchar(50) NOT NULL,
  `item_desc` text NOT NULL,
  `item_value` varchar(10) NOT NULL,
  `item_state` varchar(50) NOT NULL,
  `item_local` varchar(50) NOT NULL,
  `item_lat` varchar(50) NOT NULL,
  `item_long` varchar(50) NOT NULL,
  `item_date` datetime(6) NOT NULL DEFAULT current_timestamp(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_items`
--

INSERT INTO `tbl_items` (`item_id`, `item_owner`, `item_name`, `item_desc`, `item_value`, `item_state`, `item_local`, `item_lat`, `item_long`, `item_date`) VALUES
(21, 11, 'Women Pants', 'Black colour, long', '39', 'California', 'Mountain View', '37.4219983', '-122.084', '2023-06-13 03:18:30.142458'),
(22, 11, 'School Bag', 'Pink Colour, Big', '45', 'California', 'Mountain View', '37.4219983', '-122.084', '2023-06-13 03:33:51.305311'),
(23, 11, 'Sport Shoes', 'White colour', '70', 'California', 'Mountain View', '37.4220936', '-122.083922', '2023-06-13 03:35:01.617580'),
(24, 11, 'Table', 'Round table', '40', 'California', 'Mountain View', '37.4219983', '-122.084', '2023-06-13 05:45:54.251086'),
(25, 11, 'Television', 'Suitable for Family', '500', 'California', 'Mountain View', '37.4219983', '-122.084', '2023-06-13 06:54:44.510952'),
(28, 12, 'Women White Shoes', 'Colour: White, Size: UK7', '50', 'California', 'Mountain View', '37.4219983', '-122.084', '2023-07-06 01:55:59.374350'),
(29, 12, 'Women Wallet ', 'Colour: Brown, Brand: Coach', '100', 'California', 'Mountain View', '37.4219983', '-122.084', '2023-07-06 01:58:13.814466'),
(30, 12, 'Sport Watch', 'Colour: Purple, Brand: Red Mi', '150', 'California', 'Mountain View', '37.4219983', '-122.084', '2023-07-06 01:59:19.317153'),
(31, 12, 'Girls Shoes', 'Size: UK5, Brand: Sketches', '150', 'California', 'Mountain View', '37.4219983', '-122.084', '2023-07-06 02:00:59.279589'),
(32, 13, 'Go To Zoo Story Book', 'Bedtime Story Book Kids English', '80', 'California', 'Mountain View', '37.4219983', '-122.084', '2023-07-06 02:07:04.451059'),
(33, 13, 'iPhone 13 Pro Case', 'Phone Case for iphone 13 Pro', '30', 'California', 'Mountain View', '37.4219983', '-122.084', '2023-07-06 02:08:37.361885'),
(34, 13, 'Kids Shoes', 'Colour: Pink, For Girls', '60', 'California', 'Mountain View', '37.4219983', '-122.084', '2023-07-06 02:13:02.189057');

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
(11, 'khongxq@gmail.com', 'khongxinqi', 'd0aa1a7f8f64ae619abc1c8b2b1a21ea5adabe38'),
(12, 'lyq@gmail.com', 'Lim Yu Qi', 'd0aa1a7f8f64ae619abc1c8b2b1a21ea5adabe38'),
(13, 'tjh@gmail.com', 'Tan Jie Hui', 'd0aa1a7f8f64ae619abc1c8b2b1a21ea5adabe38'),
(14, 'john@gmail.com', 'John', 'd0aa1a7f8f64ae619abc1c8b2b1a21ea5adabe38'),
(15, 'lim@gmail.com', 'Lim', 'd0aa1a7f8f64ae619abc1c8b2b1a21ea5adabe38');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tbl_items`
--
ALTER TABLE `tbl_items`
  ADD PRIMARY KEY (`item_id`);

--
-- Indexes for table `tbl_users`
--
ALTER TABLE `tbl_users`
  ADD PRIMARY KEY (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tbl_items`
--
ALTER TABLE `tbl_items`
  MODIFY `item_id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- AUTO_INCREMENT for table `tbl_users`
--
ALTER TABLE `tbl_users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
