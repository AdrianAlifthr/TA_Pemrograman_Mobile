-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 16, 2025 at 06:40 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `resto_management`
--

-- --------------------------------------------------------

--
-- Table structure for table `kitchen_tasks`
--

CREATE TABLE `kitchen_tasks` (
  `task_number` int(11) NOT NULL,
  `order_id` varchar(10) NOT NULL,
  `kitchen_status` enum('waiting','cooking','ready') NOT NULL,
  `started_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `kitchen_tasks`
--

INSERT INTO `kitchen_tasks` (`task_number`, `order_id`, `kitchen_status`, `started_at`) VALUES
(12, 'O_69365aee', 'ready', '2025-12-08 11:58:33');

-- --------------------------------------------------------

--
-- Table structure for table `menu_categories`
--

CREATE TABLE `menu_categories` (
  `MENU_ID` varchar(10) NOT NULL,
  `MENU_NAME` varchar(100) NOT NULL,
  `CATEGORY_ID` varchar(50) NOT NULL,
  `PRICE` int(10) UNSIGNED NOT NULL,
  `AVAILABLE` tinyint(1) DEFAULT 1,
  `ESTIMATION` decimal(5,2) NOT NULL,
  `PATH` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `menu_categories`
--

INSERT INTO `menu_categories` (`MENU_ID`, `MENU_NAME`, `CATEGORY_ID`, `PRICE`, `AVAILABLE`, `ESTIMATION`, `PATH`) VALUES
('M_1', 'Beef Wellington', 'MainCourse', 420000, 1, 25.00, 'https://images.unsplash.com/photo-1675718341348-65224936b742?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8QmVlZiUyMFdlbGxpbmd0b258ZW58MHx8MHx8fDA%3D'),
('M_10', 'Black Cod Miso', 'MainCourse', 300000, 1, 10.00, 'https://media.istockphoto.com/id/2210115341/id/foto/sand-grilled-cod-fish.jpg?s=612x612&w=0&k=20&c=BWklz7Gk6SdSCghBvFx0scB3zEyNvUuQgG8G0TtiNAM='),
('M_11', 'Chocolate Lava Cake', 'Dessert', 120000, 1, 14.00, 'https://media.istockphoto.com/id/497895949/id/foto/kue-lava.jpg?s=612x612&w=0&k=20&c=AuAL-tlPQBURpPJmB4ZRstxqedx-U51jwLgLD3Y6SXc='),
('M_12', 'Cr?me Br?l?e', 'Dessert', 90000, 1, 5.00, 'https://media.istockphoto.com/id/1147248293/id/foto/creme-brulee-makanan-penutup-dengan-kerak-karamel-dan-buah-beri.jpg?s=612x612&w=0&k=20&c=vur4Tj4X9nBUFKS1MrS6eUl4lxFbKLJspaU_9kfa9RU='),
('M_13', 'Pistachio Millefeuille', 'Dessert', 130000, 1, 5.00, 'https://media.istockphoto.com/id/897896168/id/foto/turki-konya-dessert-sac-arasi-dengan-pistachio-powder-kunefe-kadayif-atau-katmer.jpg?s=612x612&w=0&k=20&c=NAGZ8cEKqJbM6kYW_kZuJqXKMqaqqTUqJjFhRmJPvVI='),
('M_14', 'Tiramisu Classic', 'Dessert', 85000, 1, 3.00, 'https://media.istockphoto.com/id/480487494/id/foto/tiramisu.jpg?s=612x612&w=0&k=20&c=br7zBgZ5VSCcC3dGI_MMOkuYTPz-QUl--mIPgH2gi8o='),
('M_15', 'Lemon Tart with Meringue', 'Dessert', 80000, 1, 6.00, 'https://media.istockphoto.com/id/1926904499/id/foto/tartlet-lemon-dengan-meringue-pada-latar-belakang-terang-dengan-ruang-salin.jpg?s=612x612&w=0&k=20&c=RN7uuMunzZYWBEA---aE9RiqUQz9d3SsBG7PKO4EN4Y='),
('M_16', 'Vanilla Bean Panna Cotta', 'Dessert', 70000, 0, 3.00, 'https://media.istockphoto.com/id/126209251/id/foto/panna-cotta-dengan-kacang-cokelat-dan-vanili.jpg?s=612x612&w=0&k=20&c=G38pyS5AZHGHah4JcTX8gylApc-pETBcsLAQzPugRto='),
('M_17', 'Matcha Opera Slice', 'Dessert', 110000, 1, 3.00, 'https://media.istockphoto.com/id/1497351408/id/foto/mini-slice-kue-pistachio-hijau-warna-warni-kue-krim-lezat-dengan-latar-belakang-gelap.jpg?s=612x612&w=0&k=20&c=1MxXh4L9_ecmxBxqhi48_Ck97o9B23h770lQ_wqcbRY='),
('M_18', 'Cheese Platter (artisan)', 'Dessert', 150000, 1, 3.00, 'https://media.istockphoto.com/id/2218340707/id/foto/pilihan-keju-gourmet-di-atas-piring-kayu-dengan-bumbu-segar-dalam-cahaya-redup.jpg?s=612x612&w=0&k=20&c=LCaLG8gxupJnOFcsDMQDgzq0e4L0nkkgo2_t6yoZkSY='),
('M_19', 'Sorbet Trio (seasonal)', 'Dessert', 65000, 0, 2.00, 'https://media.istockphoto.com/id/1500866612/id/foto/bola-es-krim-raspberry-sorbet-di-atas-meja-kayu.jpg?s=612x612&w=0&k=20&c=uKeJ1TfUviZbmAPgoH0ZzpqYymDAjGkQsEVCptix_FA='),
('M_2', 'Pan-Seared Salmon with Truffle', 'MainCourse', 320000, 1, 10.00, 'https://media.istockphoto.com/id/1257693806/id/foto/salmon-berlapis-dengan-truffle-dan-saus.jpg?s=612x612&w=0&k=20&c=_pLB-dGNpLU8ZW7a8f3BfAUthadVNSzunwUlvXX1XT4='),
('M_20', 'Baked Alaska', 'Dessert', 140000, 0, 8.00, 'https://media.istockphoto.com/id/1158692445/id/foto/alaska-panggang-buatan-sendiri.jpg?s=612x612&w=0&k=20&c=GZts0ekPSSUa4lU91cTdtQAckUGu0Q6DgZdGlVwSoTI='),
('M_21', 'Classic Martini', 'Drinks', 120000, 1, 3.00, 'https://media.istockphoto.com/id/1672572485/id/foto/dua-gelas-martini-dengan-zaitun.jpg?s=612x612&w=0&k=20&c=Vq2SbWKzDzwzGAGEYYve6GbSkZvA0QG3MkMTeiHKnbg='),
('M_22', 'Old Fashioned', 'Drinks', 120000, 1, 3.00, 'https://media.istockphoto.com/id/1286685532/id/foto/koktail-kuno-dengan-sentuhan-oranye.jpg?s=612x612&w=0&k=20&c=B4ZY2YpFoBSm5rDQ2T25byC68DuGP4xq4cfh3rRpl2s='),
('M_23', 'Signature Mocktail - Sunset', 'Drinks', 70000, 1, 4.00, 'https://media.istockphoto.com/id/1551971455/id/foto/koktail-dengan-ceri.jpg?s=612x612&w=0&k=20&c=YrRHylvxcnbWmHIB702AnsC3xyB10jIFpaJzAapZims='),
('M_24', 'Freshly Squeezed Orange', 'Drinks', 45000, 1, 4.00, 'https://media.istockphoto.com/id/674152818/id/foto/jus-jeruk-diperas-dalam-botol-kaca-dengan-dana-pedesaan.jpg?s=612x612&w=0&k=20&c=NQoHeq6O29zIFq2343FfODslqWnC5xZ7578Z3uThtgg='),
('M_25', 'Barista Espresso', 'Drinks', 35000, 1, 2.00, 'https://media.istockphoto.com/id/1358132613/id/foto/menyegarkan-secangkir-kopi-panas-di-kafe.jpg?s=612x612&w=0&k=20&c=03oUJwlKSuf7a4I7x_Px9IdZX6IfeMa6S8sTwmgIT64='),
('M_26', 'Iced Matcha Latte', 'Drinks', 60000, 1, 3.00, 'https://media.istockphoto.com/id/2160690084/id/foto/gambar-dua-gelas-minum-es-matcha-latte-dingin-minuman-non-alkohol-hijau-dan-putih-dua-warna.jpg?s=612x612&w=0&k=20&c=goWOCwGdoJ1oFT1JD7jxPL5WZLHZuTOJ7diN8o804r0='),
('M_27', 'Vintage Red Wine (glass)', 'Drinks', 110000, 0, 1.00, 'https://media.istockphoto.com/id/1171684337/id/foto/pilihan-anggur-merah-untuk-mencicipi-anggur-anggur-merah-kering-semi-kering-manis-dalam-gelas.jpg?s=612x612&w=0&k=20&c=SuMCnN2JEM2nU9tykV-BrfDQxpfkWX9QaG__KDMTkrc='),
('M_28', 'Sparkling Water (750ml)', 'Drinks', 40000, 1, 1.00, 'https://media.istockphoto.com/id/2243856654/id/foto/water-bottle-mockup-green-and-clear-glass.jpg?s=612x612&w=0&k=20&c=2G6k7UoXmF1pJRo0yU7ivfLKJKZZL9Oc3N7HxC78rjI='),
('M_29', 'Champagne (flute)', 'Drinks', 200000, 1, 1.00, 'https://media.istockphoto.com/id/175448533/id/foto/seruling-sampanye-siluet-di-latar-belakang-putih.jpg?s=612x612&w=0&k=20&c=4TDVkRFVzCNJ_XHEVRmw6lw521k5h87f-LMGa0ujrDc='),
('M_3', 'Lobster Thermidor', 'MainCourse', 380000, 0, 18.00, 'https://media.istockphoto.com/id/1410900159/id/foto/lobster-thermidor.jpg?s=612x612&w=0&k=20&c=H21UmDLCs1e-GRQFNcteRLgWgquf0liDx0vPj31ZG20='),
('M_30', 'Citrus Gin Fizz', 'Drinks', 95000, 1, 4.00, 'https://media.istockphoto.com/id/1502197806/id/foto/tonik-menyegarkan-non-alkohol-dengan-buah-jeruk-dua-gelas-minum-koktail-dingin-detoks-musim.jpg?s=612x612&w=0&k=20&c=dpeP-28Yl2QibIFcGhKaFvkMAHbxGIED9ViOBCt1JxQ='),
('M_31', 'Foie Gras Terrine', 'Appetizer', 180000, 1, 4.00, 'https://media.istockphoto.com/id/1367256339/id/foto/pate-hati-ayam-pada-roti-renyah-dengan-selai-kismis-merah-dan-hijau-mikro-bruschetta-dengan.jpg?s=612x612&w=0&k=20&c=jjwaxTZqwCRRTEfHIbY8YKfFwnoqn2GqondtxbjmbOc='),
('M_32', 'Tuna Tartare', 'Appetizer', 140000, 1, 6.00, 'https://media.istockphoto.com/id/1131990891/id/foto/salad-tuna.jpg?s=612x612&w=0&k=20&c=HmOn-K7ZLQLFkniH1ff2C7fL8va3PB-Fzkq9g5dID-Y='),
('M_33', 'Truffle Fries', 'Appetizer', 85000, 1, 7.00, 'https://media.istockphoto.com/id/1867541332/id/foto/close-up-french-fries-dengan-keju-dan-saus-truffle-hitam.jpg?s=612x612&w=0&k=20&c=vlDKam8Bvlstc6FMZUh6MeJbqc4D6p2dgOhuonw8NJ8='),
('M_34', 'Burrata & Heirloom Tomatoes', 'Appetizer', 130000, 1, 4.00, 'https://media.istockphoto.com/id/1279418414/id/foto/piring-dengan-tomat-pusaka-yang-baru-dipanen.jpg?s=612x612&w=0&k=20&c=mIkLeypme3KDZu0t3jwxnHqqoN_YlGIXG4xS_4Brn48='),
('M_35', 'Oysters on Ice (3 pcs)', 'Appetizer', 160000, 1, 3.00, 'https://media.istockphoto.com/id/621263426/id/foto/tiram-dengan-lemon-di-piring.jpg?s=612x612&w=0&k=20&c=7Z5sBo4U8rFdNr8Kal8FiMOtRiQTQOuJBmAgRgjEPxQ='),
('M_36', 'Charred Octopus', 'Appetizer', 170000, 1, 9.00, 'https://media.istockphoto.com/id/147917684/id/foto/gurita-panggang.jpg?s=612x612&w=0&k=20&c=s7WGYhD3snK64UoInTFGCiU3vCUYlZOvOtcTpCODxB4='),
('M_37', 'Beetroot Carpaccio', 'Appetizer', 90000, 1, 4.00, 'https://media.istockphoto.com/id/152054827/id/foto/vegetarian-carpaccio-dengan-bit-kacang-kacangan-dan-roti-panggang.jpg?s=612x612&w=0&k=20&c=ADubQI_79uoAkZZGPtlOpb_C3IP82m2aPixUE1Z1kUI='),
('M_38', 'Prosciutto & Melon', 'Appetizer', 95000, 1, 3.00, 'https://media.istockphoto.com/id/475045278/id/foto/konsep-makanan-italia.jpg?s=612x612&w=0&k=20&c=oOXk6KS62Mw8CRUtfwUVD9XiNhpvr4A4Q6uVf7_NnME='),
('M_39', 'Mini Crab Cakes', 'Appetizer', 120000, 1, 8.00, 'https://media.istockphoto.com/id/1291485439/id/foto/kue-tuna-dan-ricotta-renyah-dengan-bawang-hijau-paprika-merah-dan-saus-tarter-dip.jpg?s=612x612&w=0&k=20&c=urEgJj2pAQsvDIs7DCD3MlpJrK4K9T2HUV_RnYNFVR0='),
('M_4', 'Wagyu Ribeye 250g', 'MainCourse', 450000, 1, 10.00, 'https://media.istockphoto.com/id/1133398872/id/foto/wagyu-steak-daging-sapi-di-piring-kayu-dengan-bumbu.jpg?s=612x612&w=0&k=20&c=fp-51KF9S6ZUKU5Dyp-gbvLmOqzkuCD4NroG2maQgzo='),
('M_40', 'Goug?res (cheese puffs)', 'Appetizer', 55000, 1, 6.00, 'https://media.istockphoto.com/id/1388547322/id/foto/puff-keju-tradisional-prancis-atau-goug%C3%A8res-dalam-piring.jpg?s=612x612&w=0&k=20&c=GcMyottqsFHEhWGRYa7_hoMP-9GxQXVtGWm-C5bRIio='),
('M_5', 'Duck Confit with Orange Glaze', 'MainCourse', 280000, 1, 15.00, 'https://media.istockphoto.com/id/457965521/id/foto/bebek-loranye.jpg?s=612x612&w=0&k=20&c=YuWPQqkruVmz_Ww7VskaWfkSdv5V1jvrApLYif9xuKI='),
('M_6', 'Herb-Crusted Lamb Chops', 'MainCourse', 350000, 0, 12.00, 'https://media.istockphoto.com/id/2220328311/id/foto/daging-domba-berkulit-ramuan.jpg?s=612x612&w=0&k=20&c=CDKRu62DfjYoK9ZiFiuQOvX7l3LW4MFftFgaPxHLyg0='),
('M_7', 'Seared Scallops, Lemon Butter', 'MainCourse', 260000, 1, 8.00, 'https://media.istockphoto.com/id/1264102562/id/foto/kerang-direbus-dalam-saus-mentega-dan-bawang-putih.jpg?s=612x612&w=0&k=20&c=S44is93fcm7ir1JO4qkefjUNeXct9x-al1WUs1tK7IQ='),
('M_8', 'Truffle Mushroom Risotto', 'MainCourse', 220000, 1, 15.00, 'https://media.istockphoto.com/id/1470517016/id/foto/risotto-dengan-jamur-porcini-dan-truffle-hitam-disajikan-dalam-tampilan-atas-piring-gourmet.jpg?s=612x612&w=0&k=20&c=CWFxL0IJ4yucs20rt9PNC-81_VjJX2el3nl5bi5lfys='),
('M_9', 'Gnocchi with Pesto & Burrata', 'MainCourse', 180000, 1, 7.00, 'https://media.istockphoto.com/id/2177188316/id/foto/gourmet-pesto-pasta-with-parmesan-on-elegant-plate.jpg?s=612x612&w=0&k=20&c=vTZ21yIbt7vCtn3JJuL_PItZL0i9OOklAo4wAt0t5PA=');

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `order_id` varchar(10) NOT NULL,
  `table_id` varchar(10) NOT NULL,
  `order_status` enum('waiting','cooking','ready','served') NOT NULL,
  `order_total_amount` decimal(10,2) NOT NULL,
  `order_created_date` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`order_id`, `table_id`, `order_status`, `order_total_amount`, `order_created_date`) VALUES
('O_69365aee', 'T_10', 'served', 230000.00, '2025-12-08 11:58:22');

-- --------------------------------------------------------

--
-- Table structure for table `order_items`
--

CREATE TABLE `order_items` (
  `ORDER_ITEMS_ID` int(11) NOT NULL,
  `order_id` varchar(10) NOT NULL,
  `menu_item_id` varchar(10) NOT NULL,
  `quantity` int(11) NOT NULL,
  `unit_price` decimal(10,2) NOT NULL,
  `status` enum('waiting','cooking','ready','served') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `order_items`
--

INSERT INTO `order_items` (`ORDER_ITEMS_ID`, `order_id`, `menu_item_id`, `quantity`, `unit_price`, `status`) VALUES
(61, 'O_69365aee', 'M_20', 1, 140000.00, 'waiting'),
(62, 'O_69365aee', 'M_37', 1, 90000.00, 'waiting');

-- --------------------------------------------------------

--
-- Table structure for table `tables`
--

CREATE TABLE `tables` (
  `table_id` varchar(10) NOT NULL,
  `status` enum('AVAILABLE','BOOKED','CLEANING') NOT NULL,
  `time_ordered` datetime DEFAULT NULL,
  `input_reservation_in` datetime DEFAULT NULL,
  `input_reservation_out` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tables`
--

INSERT INTO `tables` (`table_id`, `status`, `time_ordered`, `input_reservation_in`, `input_reservation_out`) VALUES
('T_1', 'BOOKED', NULL, NULL, '0000-00-00 00:00:00'),
('T_10', 'CLEANING', NULL, NULL, '0000-00-00 00:00:00'),
('T_2', 'BOOKED', '2025-11-21 09:05:00', '2025-11-21 19:00:00', '2025-11-21 21:30:00'),
('T_3', 'AVAILABLE', NULL, NULL, '0000-00-00 00:00:00'),
('T_4', 'CLEANING', NULL, NULL, '0000-00-00 00:00:00'),
('T_5', 'AVAILABLE', '2025-11-21 10:20:00', '2025-11-21 18:30:00', '2025-11-21 20:30:00'),
('T_6', 'AVAILABLE', NULL, NULL, '0000-00-00 00:00:00'),
('T_7', 'AVAILABLE', '2025-11-21 11:00:00', '2025-11-21 18:00:00', '2025-11-21 22:00:00'),
('T_8', 'AVAILABLE', NULL, NULL, '0000-00-00 00:00:00'),
('T_9', 'BOOKED', NULL, NULL, '0000-00-00 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `USER_ID` varchar(10) NOT NULL,
  `FULLNAME` varchar(100) NOT NULL,
  `ROLE` varchar(50) NOT NULL,
  `ACTIVE` tinyint(1) DEFAULT 0,
  `USERNAME` varchar(50) NOT NULL,
  `PASSWORD` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`USER_ID`, `FULLNAME`, `ROLE`, `ACTIVE`, `USERNAME`, `PASSWORD`) VALUES
('ID_1', 'Dira Putri', 'waiter', 1, 'dira.waiter', 'dira123'),
('ID_2', 'Rizky Hartono', 'waiter', 1, 'rizky.waiter', 'rizky123'),
('ID_3', 'Andi Prasetya', 'chef', 1, 'andi.cook', 'andi123'),
('ID_4', 'Sari Wijaya', 'chef', 1, 'sari.cook', 'sari123'),
('ID_5', 'Ayu Lestari', 'manager', 1, 'ayu.manager', 'ayu123');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `kitchen_tasks`
--
ALTER TABLE `kitchen_tasks`
  ADD PRIMARY KEY (`task_number`),
  ADD KEY `order_id` (`order_id`);

--
-- Indexes for table `menu_categories`
--
ALTER TABLE `menu_categories`
  ADD PRIMARY KEY (`MENU_ID`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`order_id`),
  ADD KEY `table_id` (`table_id`);

--
-- Indexes for table `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`ORDER_ITEMS_ID`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `menu_item_id` (`menu_item_id`);

--
-- Indexes for table `tables`
--
ALTER TABLE `tables`
  ADD PRIMARY KEY (`table_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`USER_ID`),
  ADD UNIQUE KEY `USER_NAME` (`USERNAME`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `kitchen_tasks`
--
ALTER TABLE `kitchen_tasks`
  MODIFY `task_number` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `order_items`
--
ALTER TABLE `order_items`
  MODIFY `ORDER_ITEMS_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=63;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `kitchen_tasks`
--
ALTER TABLE `kitchen_tasks`
  ADD CONSTRAINT `kitchen_tasks_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`);

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`table_id`) REFERENCES `tables` (`table_id`);

--
-- Constraints for table `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`),
  ADD CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`menu_item_id`) REFERENCES `menu_categories` (`MENU_ID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
