-- 0. Drop jika sudah ada (opsional)
DROP DATABASE IF EXISTS `DATABASE_RESTORAN_MOPRO`;

-- 1. Create database
CREATE DATABASE `DATABASE_RESTORAN_MOPRO`
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_general_ci;

USE `DATABASE_RESTORAN_MOPRO`;

-- 2. Tabel USER_TB
CREATE TABLE `USER_TB` (
  `USER_ID` VARCHAR(50) NOT NULL,
  `FULL_NAME` VARCHAR(255) NOT NULL,
  `ROLE` VARCHAR(50) NOT NULL,
  `ACTIVE` ENUM('TRUE','FALSE') NOT NULL DEFAULT 'TRUE',
  PRIMARY KEY (`USER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 3. Tabel TABLE_TB
CREATE TABLE `TABLE_TB` (
  `TABLE_ID` VARCHAR(50) NOT NULL,
  `STATUS` ENUM('Available','Cleaning','Booked') NOT NULL DEFAULT 'Available',
  `TIME_ORDERED` TIMESTAMP NULL DEFAULT NULL,
  `INPUT_RESERVATION_IN` TIMESTAMP NULL DEFAULT NULL,
  `INPUT_RESERVATION_OUT` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`TABLE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 4. Tabel MENU_TB
CREATE TABLE `MENU_TB` (
  `MENU_ID` VARCHAR(50) NOT NULL,
  `MENU_NAME` VARCHAR(255) NOT NULL,
  `CATEGORY_ID` VARCHAR(100) NOT NULL, -- e.g. MainCourse, Dessert, Drinks, Appetizer
  `PRICE` DECIMAL(12,2) NOT NULL, -- numeric price in local currency units (no "Rp" prefix)
  `AVAILABLE` ENUM('TRUE','FALSE') NOT NULL DEFAULT 'TRUE',
  `PATH` TEXT,
  PRIMARY KEY (`MENU_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 5. Tabel ORDERS_TB
CREATE TABLE `ORDERS_TB` (
  `ORDER_ID` VARCHAR(50) NOT NULL,
  `TABLE_ID` VARCHAR(50) NOT NULL,
  `ORDER_STATUS` ENUM('waiting','cooking','ready','served') NOT NULL DEFAULT 'waiting',
  `ORDER_TOTAL_AMOUNT` DECIMAL(12,2) NOT NULL,
  `ORDER_CREATED_DATE` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`ORDER_ID`),
  INDEX `idx_orders_table` (`TABLE_ID`),
  CONSTRAINT `fk_orders_table`
    FOREIGN KEY (`TABLE_ID`) REFERENCES `TABLE_TB`(`TABLE_ID`)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 6. Tabel KITCHEN_TASKS_TB
CREATE TABLE `KITCHEN_TASKS_TB` (
  `TASK_ID` VARCHAR(50) NOT NULL,
  `ORDER_ID` VARCHAR(50) NOT NULL,
  `KITCHEN_STATUS` ENUM('waiting','ready','cooking') NOT NULL DEFAULT 'waiting',
  `ASSIGNED_TO_USER_ID` VARCHAR(50) NULL, -- optional: refer to USER_TB.USER_ID
  `STARTED_AT` TIMESTAMP NULL DEFAULT NULL,
  `CREATED_AT` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`TASK_ID`),
  INDEX `idx_task_order` (`ORDER_ID`),
  CONSTRAINT `fk_task_order`
    FOREIGN KEY (`ORDER_ID`) REFERENCES `ORDERS_TB`(`ORDER_ID`)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT `fk_task_user`
    FOREIGN KEY (`ASSIGNED_TO_USER_ID`) REFERENCES `USER_TB`(`USER_ID`)
    ON UPDATE CASCADE
    ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- ============================
-- 7. Insert data: USER_TB

-- 2. Masukkan data baru
INSERT INTO user_tb (USER_ID, FULL_NAME, ROLE, ACTIVE, USER_NAME, PASSWORD) VALUES
('ID_1', 'Dira Putri', 'waiter', TRUE, 'dira.waiter', 'dira123'),
('ID_2', 'Rizky Hartono', 'waiter', TRUE, 'rizky.waiter', 'rizky123'),
('ID_3', 'Andi Prasetya', 'chef', TRUE, 'andi.cook', 'andi123'),
('ID_4', 'Sari Wijaya', 'chef', TRUE, 'sari.cook', 'sari123'),
('ID_5', 'Ayu Lestari', 'manager', TRUE, 'ayu.manager', 'ayu123');

-- ============================
INSERT INTO `USER_TB` (`USER_ID`,`FULL_NAME`,`ROLE`,`ACTIVE`) VALUES
('ID_1','Dira Putri','waiter','TRUE'),
('ID_2','Rizky Hartono','waiter','TRUE'),
('ID_3','Andi Prasetya','cook','TRUE'),
('ID_4','Sari Wijaya','cook','TRUE'),
('ID_5','Ayu Lestari','manager','TRUE');

-- ============================
-- 8. Insert data: TABLE_TB
-- NOTE: convert dates from dd/mm/yyyy hh:mm:ss -> yyyy-mm-dd hh:mm:ss
-- EMPTY values -> NULL
-- Adjust STATUS casing to enum values ('Available','Booked','Cleaning')
-- ============================
INSERT INTO `TABLE_TB` (`TABLE_ID`,`STATUS`,`TIME_ORDERED`,`INPUT_RESERVATION_IN`,`INPUT_RESERVATION_OUT`) VALUES
('T_1','Available', NULL, NULL, NULL),
('T_2','Booked', '2025-11-21 09:05:00', '2025-11-21 19:00:00', '2025-11-21 21:30:00'),
('T_3','Available', NULL, NULL, NULL),
('T_4','Cleaning', NULL, NULL, NULL),
('T_5','Booked', '2025-11-21 10:20:00', '2025-11-21 18:30:00', '2025-11-21 20:30:00'),
('T_6','Available', NULL, NULL, NULL),
('T_7','Booked', '2025-11-21 11:00:00', '2025-11-21 18:00:00', '2025-11-21 22:00:00'),
('T_8','Available', NULL, NULL, NULL),
('T_9','Available', NULL, NULL, NULL),
('T_10','Cleaning', NULL, NULL, NULL);

-- ============================
-- 9. Insert data: MENU_TB
-- PRICE converted from "Rpxxx,xxx" => numeric without separators
-- ============================
INSERT INTO `MENU_TB` (`MENU_ID`,`MENU_NAME`,`CATEGORY_ID`,`PRICE`,`AVAILABLE`,`PATH`) VALUES
('M_1','Beef Wellington','MainCourse', 420000.00,'TRUE','https://images.unsplash.com/photo-1675718341348-65224936b742?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8QmVlZiUyMFdlbGxpbmd0b258ZW58MHx8MHx8fDA%3D'),
('M_2','Pan-Seared Salmon with Truffle','MainCourse', 320000.00,'TRUE','https://media.istockphoto.com/id/1257693806/id/foto/salmon-berlapis-dengan-truffle-dan-saus.jpg?s=612x612&w=0&k=20&c=_pLB-dGNpLU8ZW7a8f3BfAUthadVNSzunwUlvXX1XT4='),
('M_3','Lobster Thermidor','MainCourse', 380000.00,'TRUE','https://media.istockphoto.com/id/1410900159/id/foto/lobster-thermidor.jpg?s=612x612&w=0&k=20&c=H21UmDLCs1e-GRQFNcteRLgWgquf0liDx0vPj31ZG20='),
('M_4','Wagyu Ribeye 250g','MainCourse', 450000.00,'TRUE','https://media.istockphoto.com/id/1133398872/id/foto/wagyu-steak-daging-sapi-di-piring-kayu-dengan-bumbu.jpg?s=612x612&w=0&k=20&c=fp-51KF9S6ZUKU5Dyp-gbvLmOqzkuCD4NroG2maQgzo='),
('M_5','Duck Confit with Orange Glaze','MainCourse', 280000.00,'TRUE','https://media.istockphoto.com/id/457965521/id/foto/bebek-loranye.jpg?s=612x612&w=0&k=20&c=YuWPQqkruVmz_Ww7VskaWfkSdv5V1jvrApLYif9xuKI='),
('M_6','Herb-Crusted Lamb Chops','MainCourse', 350000.00,'TRUE','https://media.istockphoto.com/id/2220328311/id/foto/daging-domba-berkulit-ramuan.jpg?s=612x612&w=0&k=20&c=CDKRu62DfjYoK9ZiFiuQOvX7l3LW4MFftFgaPxHLyg0='),
('M_7','Seared Scallops, Lemon Butter','MainCourse', 260000.00,'TRUE','https://media.istockphoto.com/id/1264102562/id/foto/kerang-direbus-dalam-saus-mentega-dan-bawang-putih.jpg?s=612x612&w=0&k=20&c=S44is93fcm7ir1JO4qkefjUNeXct9x-al1WUs1tK7IQ='),
('M_8','Truffle Mushroom Risotto','MainCourse', 220000.00,'TRUE','https://media.istockphoto.com/id/1470517016/id/foto/risotto-dengan-jamur-porcini-dan-truffle-hitam-disajikan-dalam-tampilan-atas-piring-gourmet.jpg?s=612x612&w=0&k=20&c=CWFxL0IJ4yucs20rt9PNC-81_VjJX2el3nl5bi5lfys='),
('M_9','Gnocchi with Pesto & Burrata','MainCourse', 180000.00,'TRUE','https://media.istockphoto.com/id/2177188316/id/foto/gourmet-pesto-pasta-with-parmesan-on-elegant-plate.jpg?s=612x612&w=0&k=20&c=vTZ21yIbt7vCtn3JJuL_PItZL0i9OOklAo4wAt0t5PA='),
('M_10','Black Cod Miso','MainCourse', 300000.00,'TRUE','https://media.istockphoto.com/id/2210115341/id/foto/sand-grilled-cod-fish.jpg?s=612x612&w=0&k=20&c=BWklz7Gk6SdSCghBvFx0scB3zEyNvUuQgG8G0TtiNAM='),
('M_11','Chocolate Lava Cake','Dessert', 120000.00,'TRUE','https://media.istockphoto.com/id/497895949/id/foto/kue-lava.jpg?s=612x612&w=0&k=20&c=AuAL-tlPQBURpPJmB4ZRstxqedx-U51jwLgLD3Y6SXc='),
('M_12','Crème Brûlée','Dessert', 90000.00,'TRUE','https://media.istockphoto.com/id/1147248293/id/foto/creme-brulee-makanan-penutup-dengan-kerak-karamel-dan-buah-beri.jpg?s=612x612&w=0&k=20&c=vur4Tj4X9nBUFKS1MrS6eUl4lxFbKLJspaU_9kfa9RU='),
('M_13','Pistachio Millefeuille','Dessert', 130000.00,'TRUE','https://media.istockphoto.com/id/897896168/id/foto/turki-konya-dessert-sac-arasi-dengan-pistachio-powder-kunefe-kadayif-atau-katmer.jpg?s=612x612&w=0&k=20&c=NAGZ8cEKqJbM6kYW_kZuJqXKMqaqqTUqJjFhRmJPvVI='),
('M_14','Tiramisu Classic','Dessert', 85000.00,'TRUE','https://media.istockphoto.com/id/480487494/id/foto/tiramisu.jpg?s=612x612&w=0&k=20&c=br7zBgZ5VSCcC3dGI_MMOkuYTPz-QUl--mIPgH2gi8o='),
('M_15','Lemon Tart with Meringue','Dessert', 80000.00,'TRUE','https://media.istockphoto.com/id/1926904499/id/foto/tartlet-lemon-dengan-meringue-pada-latar-belakang-terang-dengan-ruang-salin.jpg?s=612x612&w=0&k=20&c=RN7uuMunzZYWBEA---aE9RiqUQz9d3SsBG7PKO4EN4Y='),
('M_16','Vanilla Bean Panna Cotta','Dessert', 70000.00,'TRUE','https://media.istockphoto.com/id/126209251/id/foto/panna-cotta-dengan-kacang-cokelat-dan-vanili.jpg?s=612x612&w=0&k=20&c=G38pyS5AZHGHah4JcTX8gylApc-pETBcsLAQzPugRto='),
('M_17','Matcha Opera Slice','Dessert', 110000.00,'TRUE','https://media.istockphoto.com/id/1497351408/id/foto/mini-slice-kue-pistachio-hijau-warna-warni-kue-krim-lezat-dengan-latar-belakang-gelap.jpg?s=612x612&w=0&k=20&c=1MxXh4L9_ecmxBxqhi48_Ck97o9B23h770lQ_wqcbRY='),
('M_18','Cheese Platter (artisan)','Dessert', 150000.00,'TRUE','https://media.istockphoto.com/id/2218340707/id/foto/pilihan-keju-gourmet-di-atas-piring-kayu-dengan-bumbu-segar-dalam-cahaya-redup.jpg?s=612x612&w=0&k=20&c=LCaLG8gxupJnOFcsDMQDgzq0e4L0nkkgo2_t6yoZkSY='),
('M_19','Sorbet Trio (seasonal)','Dessert', 65000.00,'TRUE','https://media.istockphoto.com/id/1500866612/id/foto/bola-es-krim-raspberry-sorbet-di-atas-meja-kayu.jpg?s=612x612&w=0&k=20&c=uKeJ1TfUviZbmAPgoH0ZzpqYymDAjGkQsEVCptix_FA='),
('M_20','Baked Alaska','Dessert', 140000.00,'TRUE','https://media.istockphoto.com/id/1158692445/id/foto/alaska-panggang-buatan-sendiri.jpg?s=612x612&w=0&k=20&c=GZts0ekPSSUa4lU91cTdtQAckUGu0Q6DgZdGlVwSoTI='),
('M_21','Classic Martini','Drinks', 120000.00,'TRUE','https://media.istockphoto.com/id/1672572485/id/foto/dua-gelas-martini-dengan-zaitun.jpg?s=612x612&w=0&k=20&c=Vq2SbWKzDzwzGAGEYYve6GbSkZvA0QG3MkMTeiHKnbg='),
('M_22','Old Fashioned','Drinks', 120000.00,'TRUE','https://media.istockphoto.com/id/1286685532/id/foto/koktail-kuno-dengan-sentuhan-oranye.jpg?s=612x612&w=0&k=20&c=B4ZY2YpFoBSm5rDQ2T25byC68DuGP4xq4cfh3rRpl2s='),
('M_23','Signature Mocktail - Sunset','Drinks', 70000.00,'TRUE','https://media.istockphoto.com/id/1551971455/id/foto/koktail-dengan-ceri.jpg?s=612x612&w=0&k=20&c=YrRHylvxcnbWmHIB702AnsC3xyB10jIFpaJzAapZims='),
('M_24','Freshly Squeezed Orange','Drinks', 45000.00,'TRUE','https://media.istockphoto.com/id/674152818/id/foto/jus-jeruk-diperas-dalam-botol-kaca-dengan-dana-pedesaan.jpg?s=612x612&w=0&k=20&c=NQoHeq6O29zIFq2343FfODslqWnC5xZ7578Z3uThtgg='),
('M_25','Barista Espresso','Drinks', 35000.00,'TRUE','https://media.istockphoto.com/id/1358132613/id/foto/menyegarkan-secangkir-kopi-panas-di-kafe.jpg?s=612x612&w=0&k=20&c=03oUJwlKSuf7a4I7x_Px9IdZX6IfeMa6S8sTwmgIT64='),
('M_26','Iced Matcha Latte','Drinks', 60000.00,'TRUE','https://media.istockphoto.com/id/2160690084/id/foto/gambar-dua-gelas-minum-es-matcha-latte-dingin-minuman-non-alkohol-hijau-dan-putih-dua-warna.jpg?s=612x612&w=0&k=20&c=goWOCwGdoJ1oFT1JD7jxPL5WZLHZuTOJ7diN8o804r0='),
('M_27','Vintage Red Wine (glass)','Drinks', 110000.00,'TRUE','https://media.istockphoto.com/id/1171684337/id/foto/pilihan-anggur-merah-untuk-mencicipi-anggur-anggur-merah-kering-semi-kering-manis-dalam-gelas.jpg?s=612x612&w=0&k=20&c=SuMCnN2JEM2nU9tykV-BrfDQxpfkWX9QaG__KDMTkrc='),
('M_28','Sparkling Water (750ml)','Drinks', 40000.00,'TRUE','https://media.istockphoto.com/id/2243856654/id/foto/water-bottle-mockup-green-and-clear-glass.jpg?s=612x612&w=0&k=20&c=2G6k7UoXmF1pJRo0yU7ivfLKJKZZL9Oc3N7HxC78rjI='),
('M_29','Champagne (flute)','Drinks', 200000.00,'TRUE','https://media.istockphoto.com/id/175448533/id/foto/seruling-sampanye-siluet-di-latar-belakang-putih.jpg?s=612x612&w=0&k=20&c=4TDVkRFVzCNJ_XHEVRmw6lw521k5h87f-LMGa0ujrDc='),
('M_30','Citrus Gin Fizz','Drinks', 95000.00,'TRUE','https://media.istockphoto.com/id/1502197806/id/foto/tonik-menyegarkan-non-alkohol-dengan-buah-jeruk-dua-gelas-minum-koktail-dingin-detoks-musim.jpg?s=612x612&w=0&k=20&c=dpeP-28Yl2QibIFcGhKaFvkMAHbxGIED9ViOBCt1JxQ='),
('M_31','Foie Gras Terrine','Appetizer', 180000.00,'TRUE','https://media.istockphoto.com/id/1367256339/id/foto/pate-hati-ayam-pada-roti-renyah-dengan-selai-kismis-merah-dan-hijau-mikro-bruschetta-dengan.jpg?s=612x612&w=0&k=20&c=jjwaxTZqwCRRTEfHIbY8YKfFwnoqn2GqondtxbjmbOc='),
('M_32','Tuna Tartare','Appetizer', 140000.00,'TRUE','https://media.istockphoto.com/id/1131990891/id/foto/salad-tuna.jpg?s=612x612&w=0&k=20&c=HmOn-K7ZLQLFkniH1ff2C7fL8va3PB-Fzkq9g5dID-Y='),
('M_33','Truffle Fries','Appetizer', 85000.00,'TRUE','https://media.istockphoto.com/id/1867541332/id/foto/close-up-french-fries-dengan-keju-dan-saus-truffle-hitam.jpg?s=612x612&w=0&k=20&c=vlDKam8Bvlstc6FMZUh6MeJbqc4D6p2dgOhuonw8NJ8='),
('M_34','Burrata & Heirloom Tomatoes','Appetizer', 130000.00,'TRUE','https://media.istockphoto.com/id/1279418414/id/foto/piring-dengan-tomat-pusaka-yang-baru-dipanen.jpg?s=612x612&w=0&k=20&c=mIkLeypme3KDZu0t3jwxnHqqoN_YlGIXG4xS_4Brn48='),
('M_35','Oysters on Ice (3 pcs)','Appetizer', 160000.00,'TRUE','https://media.istockphoto.com/id/621263426/id/foto/tiram-dengan-lemon-di-piring.jpg?s=612x612&w=0&k=20&c=7Z5sBo4U8rFdNr8Kal8FiMOtRiQTQOuJBmAgRgjEPxQ='),
('M_36','Charred Octopus','Appetizer', 170000.00,'TRUE','https://media.istockphoto.com/id/147917684/id/foto/gurita-panggang.jpg?s=612x612&w=0&k=20&c=s7WGYhD3snK64UoInTFGCiU3vCUYlZOvOtcTpCODxB4='),
('M_37','Beetroot Carpaccio','Appetizer', 90000.00,'TRUE','https://media.istockphoto.com/id/152054827/id/foto/vegetarian-carpaccio-dengan-bit-kacang-kacangan-dan-roti-panggang.jpg?s=612x612&w=0&k=20&c=ADubQI_79uoAkZZGPtlOpb_C3IP82m2aPixUE1Z1kUI='),
('M_38','Prosciutto & Melon','Appetizer', 95000.00,'TRUE','https://media.istockphoto.com/id/475045278/id/foto/konsep-makanan-italia.jpg?s=612x612&w=0&k=20&c=oOXk6KS62Mw8CRUtfwUVD9XiNhpvr4A4Q6uVf7_NnME='),
('M_39','Mini Crab Cakes','Appetizer', 120000.00,'TRUE','https://media.istockphoto.com/id/1291485439/id/foto/kue-tuna-dan-ricotta-renyah-dengan-bawang-hijau-paprika-merah-dan-saus-tarter-dip.jpg?s=612x612&w=0&k=20&c=urEgJj2pAQsvDIs7DCD3MlpJrK4K9T2HUV_RnYNFVR0='),
('M_40','Gougères (cheese puffs)','Appetizer', 55000.00,'TRUE','https://media.istockphoto.com/id/1388547322/id/foto/puff-keju-tradisional-prancis-atau-goug%C3%A8res-dalam-piring.jpg?s=612x612&w=0&k=20&c=GcMyottqsFHEhWGRYa7_hoMP-9GxQXVtGWm-C5bRIio=');

-- ============================
-- 10. Insert data: ORDERS_TB
-- Convert ORDER_TOTAL_AMOUNT from "Rpxxx,xxx" -> numeric
-- Convert date format dd/mm/yyyy -> yyyy-mm-dd
-- ============================
INSERT INTO `ORDERS_TB` (`ORDER_ID`,`TABLE_ID`,`ORDER_STATUS`,`ORDER_TOTAL_AMOUNT`,`ORDER_CREATED_DATE`) VALUES
('O_1','T_2','cooking', 420000.00, '2025-11-21 19:05:00'),
('O_2','T_6','waiting', 260000.00, '2025-11-21 18:40:00'),
('O_3','T_3','ready', 300000.00, '2025-11-21 18:55:00'),
('O_4','T_7','cooking', 520000.00, '2025-11-21 19:20:00'),
('O_5','T_5','waiting', 350000.00, '2025-11-21 18:35:00'),
('O_6','T_1','served', 180000.00, '2025-11-21 12:30:00'),
('O_7','T_4','cooking', 220000.00, '2025-11-21 19:10:00'),
('O_8','T_8','waiting', 95000.00, '2025-11-21 19:00:00'),
('O_9','T_9','ready', 65000.00, '2025-11-21 18:50:00'),
('O_10','T_10','waiting', 280000.00, '2025-11-21 18:00:00'),
('O_11','T_2','cooking', 200000.00, '2025-11-21 19:40:00'),
('O_12','T_7','waiting', 360000.00, '2025-11-21 19:45:00'),
('O_13','T_5','ready', 140000.00, '2025-11-21 19:15:00'),
('O_14','T_6','cooking', 320000.00, '2025-11-21 19:05:00'),
('O_15','T_1','waiting', 90000.00, '2025-11-21 19:25:00'),
('O_16','T_3','served', 240000.00, '2025-11-20 20:10:00'),
('O_17','T_8','ready', 110000.00, '2025-11-21 20:00:00'),
('O_18','T_4','waiting', 160000.00, '2025-11-21 19:50:00'),
('O_19','T_9','cooking', 200000.00, '2025-11-21 20:05:00'),
('O_20','T_10','waiting', 75000.00, '2025-11-21 20:10:00');

-- ============================
-- 11. (Optional) Insert sample KITCHEN_TASKS_TB rows (tidak diminta, tetapi contoh)
-- Jika Anda ingin menambahkan task contoh, berikut formatnya:
-- ============================
INSERT INTO `KITCHEN_TASKS_TB` (`TASK_ID`,`ORDER_ID`,`KITCHEN_STATUS`,`ASSIGNED_TO_USER_ID`,`STARTED_AT`) VALUES
('KT_1','O_1','cooking','ID_3','2025-11-21 19:06:00'),
('KT_2','O_4','waiting','ID_4', NULL),
('KT_3','O_11','cooking','ID_3','2025-11-21 19:41:00');

-- ============================
-- 12. Contoh index/constraint checks (opsional)
-- ============================

-- Selesai
