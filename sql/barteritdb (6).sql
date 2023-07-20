-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 20, 2023 at 09:40 PM
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
-- Table structure for table `tbl_carts`
--

CREATE TABLE `tbl_carts` (
  `cart_id` int(5) NOT NULL,
  `item_id` varchar(5) NOT NULL,
  `cart_qty` int(5) NOT NULL,
  `cart_price` float NOT NULL,
  `user_id` varchar(5) NOT NULL,
  `seller_id` varchar(5) NOT NULL,
  `cart_date` datetime(6) NOT NULL DEFAULT current_timestamp(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_item`
--

CREATE TABLE `tbl_item` (
  `item_id` int(5) NOT NULL,
  `user_id` int(5) NOT NULL,
  `item_name` varchar(50) NOT NULL,
  `item_desc` varchar(200) NOT NULL,
  `item_price` varchar(10) NOT NULL,
  `item_qty` varchar(10) NOT NULL,
  `item_lat` varchar(15) NOT NULL,
  `item_long` varchar(15) NOT NULL,
  `item_state` varchar(30) NOT NULL,
  `item_local` varchar(50) NOT NULL,
  `item_date` datetime(6) NOT NULL DEFAULT current_timestamp(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_item`
--

INSERT INTO `tbl_item` (`item_id`, `user_id`, `item_name`, `item_desc`, `item_price`, `item_qty`, `item_lat`, `item_long`, `item_state`, `item_local`, `item_date`) VALUES
(30, 10, 'Sport Watch', 'Colour: Grey', '10', '10', '37.4219983', '-122.084', 'California', 'Mountain View', '2023-07-20 05:54:09.354415'),
(32, 10, 'Storybook', 'Colour: Brown', '25', '3', '37.4219983', '-122.084', 'California', 'Mountain View', '2023-07-21 02:02:07.019681'),
(53, 10, 'Men Wallet', 'abgggggsasasasas', '30', '6', '37.4219983', '-122.084', 'California', 'Mountain View', '2023-07-21 02:26:07.692027'),
(54, 10, 'Girl School Bag', 'Colour: Pink', '30', '10', '37.4219983', '-122.084', 'California', 'Mountain View', '2023-07-21 02:27:14.695651'),
(55, 10, 'Men White Shoes', 'Size: 40, Men, White', '45', '5', '37.4219983', '-122.084', 'California', 'Mountain View', '2023-07-21 02:28:49.180665'),
(56, 10, 'Round Table', 'Colour: Brown', '50', '2', '37.4219983', '-122.084', 'California', 'Mountain View', '2023-07-21 02:29:44.402519'),
(57, 11, 'Women Long Pant', 'Colour: Black', '20', '3', '37.4219983', '-122.084', 'California', 'Mountain View', '2023-07-21 02:31:47.606434'),
(58, 11, 'Child Story Book', 'Go To Zoo Story Book', '30', '10', '37.4219983', '-122.084', 'California', 'Mountain View', '2023-07-21 02:32:48.792086'),
(59, 11, 'Iron', 'Colour: Blue', '25', '5', '37.4219983', '-122.084', 'California', 'Mountain View', '2023-07-21 02:40:12.715540'),
(60, 11, 'Girl Shoes', 'Colour: Pink', '15', '3', '37.4219983', '-122.084', 'California', 'Mountain View', '2023-07-21 02:40:59.977236'),
(61, 11, 'iPhone 13 Pro', 'Colour: Black, Silver', '1000', '2', '37.4219983', '-122.084', 'California', 'Mountain View', '2023-07-21 02:42:27.734891'),
(62, 11, 'Mini Multi Cooker', 'Colour: Green', '26', '6', '37.4219983', '-122.084', 'California', 'Mountain View', '2023-07-21 02:44:02.629982'),
(63, 11, 'Jogging Shoes', 'Colour: Blue', '40', '2', '37.4219983', '-122.084', 'California', 'Mountain View', '2023-07-21 02:45:09.206444'),
(64, 11, 'iPhone 12 ', 'Colour: Gold', '800', '3', '37.4219983', '-122.084', 'California', 'Mountain View', '2023-07-21 02:46:16.866208');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_orderdetails`
--

CREATE TABLE `tbl_orderdetails` (
  `orderdetail_id` int(5) NOT NULL,
  `order_bill` varchar(8) NOT NULL,
  `item_id` varchar(5) NOT NULL,
  `orderdetail_qty` int(5) NOT NULL,
  `orderdetail_paid` float NOT NULL,
  `buyer_id` varchar(5) NOT NULL,
  `seller_id` varchar(5) NOT NULL,
  `orderdetail_date` datetime(6) NOT NULL DEFAULT current_timestamp(6)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_orders`
--

CREATE TABLE `tbl_orders` (
  `order_id` int(5) NOT NULL,
  `order_bill` varchar(8) NOT NULL,
  `order_paid` float NOT NULL,
  `buyer_id` varchar(5) NOT NULL,
  `seller_id` varchar(5) NOT NULL,
  `order_date` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `order_status` varchar(20) NOT NULL,
  `order_lat` varchar(12) NOT NULL,
  `order_lng` varchar(12) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_user`
--

CREATE TABLE `tbl_user` (
  `user_id` int(5) NOT NULL,
  `user_email` varchar(50) NOT NULL,
  `user_name` varchar(100) NOT NULL,
  `user_password` varchar(40) NOT NULL,
  `user_datereg` datetime(6) NOT NULL DEFAULT current_timestamp(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_user`
--

INSERT INTO `tbl_user` (`user_id`, `user_email`, `user_name`, `user_password`, `user_datereg`) VALUES
(10, 'khong@gmail.com', 'Khong', 'd0aa1a7f8f64ae619abc1c8b2b1a21ea5adabe38', '2023-07-20 04:57:02.874420'),
(11, 'khong2@gmail.com', 'khong2', 'd0aa1a7f8f64ae619abc1c8b2b1a21ea5adabe38', '2023-07-20 12:42:38.951794'),
(12, 'khong3@gmail.com', 'Khong Xin Qi', 'd0aa1a7f8f64ae619abc1c8b2b1a21ea5adabe38', '2023-07-21 03:22:21.172376');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tbl_carts`
--
ALTER TABLE `tbl_carts`
  ADD PRIMARY KEY (`cart_id`);

--
-- Indexes for table `tbl_item`
--
ALTER TABLE `tbl_item`
  ADD PRIMARY KEY (`item_id`);

--
-- Indexes for table `tbl_orderdetails`
--
ALTER TABLE `tbl_orderdetails`
  ADD PRIMARY KEY (`orderdetail_id`);

--
-- Indexes for table `tbl_orders`
--
ALTER TABLE `tbl_orders`
  ADD PRIMARY KEY (`order_id`);

--
-- Indexes for table `tbl_user`
--
ALTER TABLE `tbl_user`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `user_email` (`user_email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tbl_carts`
--
ALTER TABLE `tbl_carts`
  MODIFY `cart_id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `tbl_item`
--
ALTER TABLE `tbl_item`
  MODIFY `item_id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=65;

--
-- AUTO_INCREMENT for table `tbl_orderdetails`
--
ALTER TABLE `tbl_orderdetails`
  MODIFY `orderdetail_id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `tbl_orders`
--
ALTER TABLE `tbl_orders`
  MODIFY `order_id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `tbl_user`
--
ALTER TABLE `tbl_user`
  MODIFY `user_id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
