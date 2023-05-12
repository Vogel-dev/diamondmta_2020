-- phpMyAdmin SQL Dump
-- version 4.7.4
-- https://www.phpmyadmin.net/
--
-- Host: 137.74.6.118:3306
-- Czas generowania: 06 Sty 2020, 22:33
-- Wersja serwera: 10.3.18-MariaDB-0+deb10u1
-- Wersja PHP: 7.3.4-1+0~20190412071350.37+stretch~1.gbpabc171

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Baza danych: `db_48513`
--

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `db_admins`
--

CREATE TABLE `db_admins` (
  `id` int(11) NOT NULL,
  `nick` text CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL,
  `rank` int(11) NOT NULL DEFAULT 1,
  `serial` text CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL,
  `reports` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=COMPACT;

--
-- Zrzut danych tabeli `db_admins`
--

INSERT INTO `db_admins` (`id`, `nick`, `rank`, `serial`, `reports`) VALUES
(1, 'Vogel', 4, 's1', 596),

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `db_admin_jail`
--

CREATE TABLE `db_admin_jail` (
  `seg` int(11) NOT NULL,
  `Serial` varchar(128) NOT NULL,
  `Termin` datetime NOT NULL,
  `Cela` int(11) NOT NULL COMMENT 'CELA',
  `Powod` varchar(4092) CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `db_businesses`
--

CREATE TABLE `db_businesses` (
  `id` int(11) NOT NULL,
  `owner` varchar(512) COLLATE utf16_polish_ci NOT NULL,
  `xyz` varchar(512) COLLATE utf16_polish_ci NOT NULL,
  `cost` int(11) NOT NULL,
  `zajety` varchar(1) COLLATE utf16_polish_ci NOT NULL DEFAULT 'n',
  `nazwa` varchar(255) COLLATE utf16_polish_ci NOT NULL,
  `saldo` int(11) NOT NULL DEFAULT 0,
  `data` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf16 COLLATE=utf16_polish_ci ROW_FORMAT=COMPACT;

--
-- Zrzut danych tabeli `db_businesses`
--

INSERT INTO `db_businesses` (`id`, `owner`, `xyz`, `cost`, `zajety`, `nazwa`, `saldo`, `data`) VALUES
(1, '422', '1071.898438,-1382.439453,13.806866', 5000, 't', '\"ZIP\"', 1272, '2020-01-07 19:57:35'),
(2, '51', '2181.903320,-2252.659180,14.773438', 150000, 't', 'Magazyn Ocean Docks', 181860, '2020-01-08 14:10:36'),
(3, '124', '2528.293945,-1538.218750,23.515448', 15000, 't', 'Rdza i złom', 2616, '2020-01-07 19:20:20'),
(4, '1', '2508.840820,-1493.759766,23.997887', 50000, 't', 'Pruszkowska 13', 475060, '2020-01-23 20:40:07'),
(6, '40', '982.017578,-1336.186523,13.541464', 85000, 't', 'Diamond Jewellery', 67048, '2020-01-07 19:28:05'),
(7, '36', '1071.762695,-1316.184570,13.546875', 35000, 't', 'Diamond Pharmacy', 8792, '2020-01-10 12:15:03'),
(8, '513', '965.360352,-1311.130859,13.522038', 47500, 't', 'Diamond GSM', 51281, '2020-01-11 01:44:05'),
(9, '9', '2472.535156,-1523.054688,24.226570', 150000, 't', 'Gringlanka', 1354980, '2020-01-16 23:26:46'),
(10, '201', '1113.761719,-1181.401367,18.656178', 85000, 't', 'Kryjówka meneli', 108868, '2020-01-07 17:13:59');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `db_diamond_exchange`
--

CREATE TABLE `db_diamond_exchange` (
  `id` int(11) NOT NULL,
  `nick` text CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL,
  `cost` int(11) NOT NULL DEFAULT 0,
  `points` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=COMPACT;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `db_exchange`
--

CREATE TABLE `db_exchange` (
  `ID` int(255) NOT NULL,
  `model` text COLLATE utf8_unicode_ci NOT NULL,
  `wlasciciel` text COLLATE utf8_unicode_ci NOT NULL,
  `pojemnosc` text COLLATE utf8_unicode_ci NOT NULL,
  `naped` text COLLATE utf8_unicode_ci NOT NULL,
  `rodzaj` text COLLATE utf8_unicode_ci NOT NULL,
  `przebieg` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `cena` varchar(255) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `db_factions`
--

CREATE TABLE `db_factions` (
  `dbid` int(11) NOT NULL,
  `nick` text NOT NULL,
  `frakcja` text NOT NULL,
  `ranga` text NOT NULL,
  `wyplata` int(11) NOT NULL,
  `minuty` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

--
-- Zrzut danych tabeli `db_factions`
--

INSERT INTO `db_factions` (`dbid`, `nick`, `frakcja`, `ranga`, `wyplata`, `minuty`) VALUES
(1, 'Vogel', 'EMS', 'Dyrektor_Szpitala', 500, 0),

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `db_gangs`
--

CREATE TABLE `db_gangs` (
  `id` int(11) NOT NULL,
  `model` int(11) NOT NULL DEFAULT 0,
  `pos` text CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL,
  `rotation` text CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL,
  `interior` int(11) NOT NULL DEFAULT 0,
  `dim` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `db_garages`
--

CREATE TABLE `db_garages` (
  `id` int(11) NOT NULL,
  `house_id` int(11) NOT NULL DEFAULT 0,
  `pos` text CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL,
  `veh_rot` int(11) NOT NULL DEFAULT 0,
  `places` int(11) NOT NULL DEFAULT 2
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT;

--
-- Zrzut danych tabeli `db_garages`
--

INSERT INTO `db_garages` (`id`, `house_id`, `pos`, `veh_rot`, `places`) VALUES
(1, 3, '859.63287353516,-1419.0557861328,12.978713607788', 0, 2),
(2, 12, '2536.9155273438,-1494.9703369141,24.032264709473,0.19747193157673', 180, 3),
(3, 13, '1449.2559814453,-1552.2403564453,13.549827575684', 0, 2),
(4, 14, '1471.6564941406,-1520.4012451172,13.546875', 270, 2),
(5, 15, '1476.5080566406,-1509.9991455078,13.546875', 180, 2),
(6, 16, '1550.0778808594,-1579.7347412109,13.546875', 90, 1),
(7, 17, '1542.8132324219,-1519.9276123047,13.549827575684', 100, 4),
(8, 35, '2644.7197265625,-2033.6169433594,13.554044723', 0, 2),
(9, 46, '1088.5556640625,-1215.8544921875,17.812009811', 270, 2),
(10, 47, '2505.6159667969,-1685.8377685547,13.556850433', 0, 2),
(11, 49, '2516.4057617188,-1672.5792236328,13.8922', 80, 1),
(12, 72, '2443.8295898438,-1965.3695068359,13.5468', 270, 5);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `db_houses`
--

CREATE TABLE `db_houses` (
  `id` int(11) NOT NULL,
  `wlasciciel` int(11) NOT NULL DEFAULT 0,
  `wlasciciel_nick` text CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL,
  `nazwa` text CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL,
  `motel` int(11) NOT NULL DEFAULT 0,
  `zamek` int(11) NOT NULL DEFAULT 0,
  `data` date NOT NULL,
  `wejscie` text CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL,
  `wyjscie` text CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL,
  `teleport` text CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL,
  `cena` int(11) NOT NULL DEFAULT 0,
  `interior` int(11) NOT NULL DEFAULT 0,
  `lokatorzy` text CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL,
  `organizacja` text CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=COMPACT;

--
-- Zrzut danych tabeli `db_houses`
--

INSERT INTO `db_houses` (`id`, `wlasciciel`, `wlasciciel_nick`, `nazwa`, `motel`, `zamek`, `data`, `wejscie`, `wyjscie`, `teleport`, `cena`, `interior`, `lokatorzy`, `organizacja`) VALUES
(3, 163, 'Pauline_Bush', 'Duży dom', 0, 1, '2020-01-25', '852.1484375,-1422.94921875,14.141721725464', '2365.4267578125, -1135.5837402344, 1050.8825683594', '2365.2380371094, -1133.3608398438, 1050.875', 100, 8, '', ''),
(4, 0, '', 'Pokój hotelowy', 0, 0, '0000-00-00', '725.6240234375,-1440.341796875,13.531820297241', '2218.0671386719, -1076.2176513672, 1050.484375', '2215.6984863281, -1076.0174560547, 1050.484375', 100, 1, '', ''),
(5, 0, '', 'Pokój hotelowy', 0, 0, '0000-00-00', '739.0341796875,-1429.5849609375,13.5234375', '2218.0671386719, -1076.2176513672, 1050.484375', '2215.6984863281, -1076.0174560547, 1050.484375', 100, 1, '', ''),
(6, 105, 'Sean_Forwood', 'Lokal organizacji', 0, 0, '2020-01-19', '969.6787109375,-1296.044921875,13.546875', '2270.3486328125, -1210.5163574219, 1047.5625', '2264.9658203125, -1210.5336914063, 1049.0234375', 100, 10, '', ''),
(7, 40, 'Domenico_Corleone', 'Duży dom', 0, 0, '2020-02-01', '827.8369140625,-858.31640625,70.330810546875', '2365.4267578125, -1135.5837402344, 1050.8825683594', '2365.2380371094, -1133.3608398438, 1050.875', 100, 8, '[ [ ] ]', ''),
(8, 468, 'Nathan_Domputamadre', 'Willa', 0, 0, '2020-01-07', '836.3505859375,-894.400390625,68.768898010254', '140.34725952148, 1366.2322998047, 1083.859375', '140.37799987793, 1368.3272705078, 1083.8627929688', 100, 5, '', ''),
(10, 538, 'Franek_Kaszanka', 'Mieszkanie w kamienicy', 0, 0, '2020-01-08', '2522.1318359375,-1485.828125,24.004859924316', '-42.510841369629, 1405.5737304688, 1084.4296875', '-42.646617889404, 1406.9627685547, 1084.4296875', 100, 8, '', ''),
(11, 51, 'Mike_Mins', 'Mieszkanie w kamienicy', 0, 0, '2020-01-14', '2518.337890625,-1485.822265625,23.987617492676', '-42.510841369629, 1405.5737304688, 1084.4296875', '-42.646617889404, 1406.9627685547, 1084.4296875', 100, 8, '', ''),
(12, 1, 'Vogel', 'Lokal organizacji', 0, 0, '2020-04-06', '2529.583984375,-1493.6123046875,24.02889251709', '2270.3486328125, -1210.5163574219, 1047.5625', '2264.9658203125, -1210.5336914063, 1049.0234375', 100, 10, '', ''),
(13, 35, 'Logan_Acosta', 'Dom', 0, 0, '2020-01-10', '1458.439453125,-1562.8499755859,13.767417907715', '-260.48489379883, 1456.5382080078, 1084.3671875', '-262.38952636719, 1456.6231689453, 1084.3671875', 250, 4, '', ''),
(14, 40, 'Domenico_Corleone', 'Dom', 0, 0, '2020-01-20', '1462.9274902344,-1529.0524902344,13.925000190735', '-260.48489379883, 1456.5382080078, 1084.3671875', '-262.38952636719, 1456.6231689453, 1084.3671875', 350, 4, '', ''),
(15, 513, 'William_Wake', 'Dom', 0, 1, '2020-01-13', '1488.1966552734,-1507.0437011719,14.600732803345', '-260.48489379883, 1456.5382080078, 1084.3671875', '-262.38952636719, 1456.6231689453, 1084.3671875', 350, 4, '', ''),
(16, 34, 'Sergio_Hudson', 'Mały dom', 0, 1, '2020-01-13', '1538.4072265625,-1575.7105712891,13.934900283813', '-42.603530883789, 1412.7408447266, 1084.4296875', '-42.533084869385, 1410.6361083984, 1084.4296875', 250, 8, '', ''),
(17, 69, 'Nikita_Lebiediev', 'Willa', 0, 0, '2020-01-18', '1536.8466796875,-1532.81640625,13.549827575684', '140.34725952148, 1366.2322998047, 1083.859375', '140.37799987793, 1368.3272705078, 1083.8627929688', 800, 5, '', ''),
(18, 605, 'Dimitrij_Peterko', 'Pokój hotelowy', 0, 0, '2020-01-12', '725.4580078125,-1450.3994140625,17.6953125', '2218.0671386719, -1076.2176513672, 1050.484375', '2215.6984863281, -1076.0174560547, 1050.484375', 150, 1, '', ''),
(19, 0, '', 'Mieszkanie', 0, 0, '0000-00-00', '683.65234375,-1436.2802734375,14.8515625', '2365.4267578125, -1135.5837402344, 1050.8825683594', '2365.2380371094, -1133.3608398438, 1050.875', 150, 8, '', ''),
(20, 0, '', 'Mieszkanie', 0, 0, '0000-00-00', '675.1396484375,-1430.501953125,14.8515625', '2365.4267578125, -1135.5837402344, 1050.8825683594', '2365.2380371094, -1133.3608398438, 1050.875', 150, 8, '', ''),
(21, 0, '', 'Mieszkanie', 0, 1, '0000-00-00', '662.5400390625,-1440.4423828125,14.8515625', '2365.4267578125, -1135.5837402344, 1050.8825683594', '2365.2380371094, -1133.3608398438, 1050.875', 175, 8, '', ''),
(22, 0, '', 'Mieszkanie', 0, 0, '0000-00-00', '662.994140625,-1466.607421875,14.8515625', '2365.4267578125, -1135.5837402344, 1050.8825683594', '2365.2380371094, -1133.3608398438, 1050.875', 125, 8, '', ''),
(23, 0, '', 'Mieszkanie', 0, 0, '0000-00-00', '657.3310546875,-1481.287109375,14.8515625', '2365.4267578125, -1135.5837402344, 1050.8825683594', '2365.2380371094, -1133.3608398438, 1050.875', 125, 8, '', ''),
(24, 0, '', 'Mieszkanie', 0, 0, '0000-00-00', '662.431640625,-1487.701171875,14.8515625', '2365.4267578125, -1135.5837402344, 1050.8825683594', '2365.2380371094, -1133.3608398438, 1050.875', 125, 8, '', ''),
(25, 0, '', 'Mieszkanie', 0, 0, '0000-00-00', '662.43359375,-1513.7734375,14.8515625', '2365.4267578125, -1135.5837402344, 1050.8825683594', '2365.2380371094, -1133.3608398438, 1050.875', 125, 8, '', ''),
(26, 0, '', 'Mieszkanie', 0, 0, '0000-00-00', '662.6025390625,-1534.779296875,14.8515625', '2365.4267578125, -1135.5837402344, 1050.8825683594', '2365.2380371094, -1133.3608398438, 1050.875', 125, 8, '', ''),
(27, 0, '', 'Mieszkanie', 0, 0, '0000-00-00', '657.3740234375,-1528.458984375,14.8515625', '2365.4267578125, -1135.5837402344, 1050.8825683594', '2365.2380371094, -1133.3608398438, 1050.875', 125, 8, '', ''),
(28, 1, 'Vogel', 'Lokal organizacji', 0, 0, '2020-03-29', '-1947.1923828125,674.935546875,-80.904586791992', '2270.3486328125, -1210.5163574219, 1047.5625', '2264.9658203125, -1210.5336914063, 1049.0234375', 1000, 10, '', ''),
(29, 1, 'Vogel', 'Willa', 0, 0, '2020-03-25', '690.5517578125,-1276.015625,13.559987068176', '140.34725952148, 1366.2322998047, 1083.859375', '140.37799987793, 1368.3272705078, 1083.8627929688', 2500, 5, '', ''),
(30, 0, '', 'Mały dom', 0, 0, '0000-00-00', '2696.322265625,-1990.8603515625,14.222853660583', '-42.603530883789, 1412.7408447266, 1084.4296875', '-42.533084869385, 1410.6361083984, 1084.4296875', 125, 8, '', ''),
(31, 0, '', 'Mały dom', 0, 0, '0000-00-00', '2672.6669921875,-1989.5830078125,14.324020385742', '-42.603530883789, 1412.7408447266, 1084.4296875', '-42.533084869385, 1410.6361083984, 1084.4296875', 125, 8, '', ''),
(32, 0, '', 'Mały dom', 0, 0, '0000-00-00', '2652.96484375,-1989.78515625,13.998847007751', '-42.603530883789, 1412.7408447266, 1084.4296875', '-42.533084869385, 1410.6361083984, 1084.4296875', 125, 8, '', ''),
(33, 0, '', 'Mały dom', 0, 0, '0000-00-00', '2637.134765625,-1991.669921875,14.324020385742', '-42.603530883789, 1412.7408447266, 1084.4296875', '-42.533084869385, 1410.6361083984, 1084.4296875', 125, 8, '', ''),
(34, 29, 'Esteban_Corleone', 'Mały dom', 0, 0, '2020-01-13', '2635.5634765625,-2012.8544921875,14.144332885742', '-42.603530883789, 1412.7408447266, 1084.4296875', '-42.533084869385, 1410.6361083984, 1084.4296875', 125, 8, '', ''),
(35, 40, 'Domenico_Corleone', 'Mały dom', 0, 0, '2020-02-01', '2650.158203125,-2021.9267578125,14.176628112793', '-42.603530883789, 1412.7408447266, 1084.4296875', '-42.533084869385, 1410.6361083984, 1084.4296875', 125, 8, '', ''),
(36, 0, '', 'Mały dom', 0, 0, '0000-00-00', '2673.1376953125,-2019.8994140625,14.168166160583', '-42.603530883789, 1412.7408447266, 1084.4296875', '-42.533084869385, 1410.6361083984, 1084.4296875', 125, 8, '', ''),
(37, 0, '', 'Mały dom', 0, 0, '0000-00-00', '2695.3056640625,-2020.12109375,14.022284507751', '-42.603530883789, 1412.7408447266, 1084.4296875', '-42.533084869385, 1410.6361083984, 1084.4296875', 125, 8, '', ''),
(38, 416, 'Wladimir_Dziuba', 'Mały dom', 0, 0, '2020-01-21', '1087.732421875,-1192.8115234375,18.169811248779', '-42.603530883789, 1412.7408447266, 1084.4296875', '-42.533084869385, 1410.6361083984, 1084.4296875', 25, 8, '', ''),
(39, 201, 'Carlo_Miller', 'Mały dom', 0, 0, '2020-01-26', '1085.7109375,-1194.55859375,18.1028175354', '-42.603530883789, 1412.7408447266, 1084.4296875', '-42.533084869385, 1410.6361083984, 1084.4296875', 25, 8, '', ''),
(40, 199, 'Sergiew_Dziuba', 'Mały dom', 0, 0, '2020-01-17', '1088.3623046875,-1198.8818359375,17.929904937744', '-42.603530883789, 1412.7408447266, 1084.4296875', '-42.533084869385, 1410.6361083984, 1084.4296875', 25, 8, '', ''),
(41, 272, 'Petro_Dziuba', 'Mały dom', 0, 0, '2020-02-10', '1099.3056640625,-1227.1025390625,15.8203125', '-42.603530883789, 1412.7408447266, 1084.4296875', '-42.533084869385, 1410.6361083984, 1084.4296875', 25, 8, '', ''),
(42, 220, 'Zlatan_Dziuba', 'Mały dom', 0, 0, '2020-03-17', '1091.166015625,-1230.302734375,15.8203125', '-42.603530883789, 1412.7408447266, 1084.4296875', '-42.533084869385, 1410.6361083984, 1084.4296875', 25, 8, '', ''),
(43, 266, 'Sasha_Dziuba', 'Mały dom', 0, 1, '2020-01-10', '1086.0461425781,-1236.2939453125,15.995178222656', '-42.603530883789, 1412.7408447266, 1084.4296875', '-42.533084869385, 1410.6361083984, 1084.4296875', 25, 8, '', ''),
(44, 203, 'Dimitri_Dziuba', 'Mały dom', 0, 0, '2020-02-05', '1088.0400390625,-1248.05859375,15.995178222656', '-42.603530883789, 1412.7408447266, 1084.4296875', '-42.533084869385, 1410.6361083984, 1084.4296875', 25, 8, '', ''),
(45, 199, 'Sergiew_Dziuba', 'Mały dom', 0, 0, '2020-02-11', '1118.3486328125,-1246.541015625,15.945278167725', '-42.603530883789, 1412.7408447266, 1084.4296875', '-42.533084869385, 1410.6361083984, 1084.4296875', 25, 8, '', ''),
(46, 124, 'Wasyliv_Dziuba', 'Mały dom', 0, 0, '2020-01-15', '1099.0521240234,-1244.9794921875,16.675241470337', '-42.603530883789, 1412.7408447266, 1084.4296875', '-42.533084869385, 1410.6361083984, 1084.4296875', 50, 8, '', ''),
(47, 509, 'Vladimir_Klimow', 'Dom', 0, 1, '2020-03-21', '2495.4794921875,-1690.517578125,14.765625', '-260.48489379883, 1456.5382080078, 1084.3671875', '-262.38952636719, 1456.6231689453, 1084.3671875', 145, 4, '', ''),
(48, 23, 'Olivier_Masseria', 'Mały dom', 0, 0, '2020-02-23', '2514.384765625,-1691.3740234375,14.046038627625', '-42.6, 1412.74, 1084.42', '-42.53, 1410.63, 1084.42', 80, 8, '', ''),
(49, 14, 'Borys_Iwanov', 'Dom', 0, 0, '2021-05-24', '2523.2724609375,-1679.3232421875,15.496999740601', '-260.48, 1456.53, 1084.36', '-262.38, 1456.62, 1084.36', 120, 4, '', ''),
(50, 281, 'Don_Rudy', 'Mały dom', 0, 0, '2020-01-07', '2524.7080078125,-1658.65625,15.824020385742', '-42.6, 1412.74, 1084.42', '-42.53, 1410.63, 1084.42', 80, 8, '', ''),
(51, 234, 'Bartosz_Nowicki', 'Mały dom', 0, 1, '2020-01-09', '2513.6962890625,-1650.228515625,14.355666160583', '-42.6, 1412.74, 1084.42', '-42.53, 1410.63, 1084.42', 80, 8, '', ''),
(52, 163, 'Pauline_Bush', 'Mały dom', 0, 0, '2020-04-14', '2498.4599609375,-1642.509765625,13.782609939575', '-42.6, 1412.74, 1084.42', '-42.53, 1410.63, 1084.42', 80, 8, '', ''),
(53, 657, 'Fernando_Escobar', 'Mały dom', 0, 0, '2020-01-07', '2486.578125,-1644.533203125,14.077178955078', '-42.6, 1412.74, 1084.42', '-42.53, 1410.63, 1084.42', 80, 8, '', ''),
(54, 464, 'Ivan_Aristow', 'Mały dom', 0, 0, '2020-01-08', '2469.5859375,-1646.396484375,13.780097007751', '-42.6, 1412.74, 1084.42', '-42.53, 1410.63, 1084.42', 80, 8, '', ''),
(55, 290, 'Luca_Gotti', 'Mały dom', 0, 0, '2020-01-07', '2459.49609375,-1691.421875,13.545011520386', '-42.6, 1412.74, 1084.42', '-42.53, 1410.63, 1084.42', 80, 8, '', ''),
(56, 636, 'Pablo_Escobarek', 'Mały dom', 0, 1, '2020-01-08', '2451.892578125,-1641.41015625,14.066207885742', '-42.6, 1412.74, 1084.42', '-42.53, 1410.63, 1084.42', 80, 8, '', ''),
(57, 638, 'El_Chapo', 'Mały dom', 0, 0, '2020-01-08', '2413.7470703125,-1646.787109375,14.011916160583', '-42.6, 1412.74, 1084.42', '-42.53, 1410.63, 1084.42', 80, 8, '', ''),
(58, 645, 'El_Zapert', 'Mały dom', 0, 0, '2020-01-13', '2393.1611328125,-1646.0341796875,13.905097007751', '-42.6, 1412.74, 1084.42', '-42.53, 1410.63, 1084.42', 80, 8, '', ''),
(59, 0, '', 'Mały dom', 0, 1, '0000-00-00', '2362.8544921875,-1643.2216796875,14.3515625', '-42.6, 1412.74, 1084.42', '-42.53, 1410.63, 1084.42', 80, 8, '', ''),
(60, 464, 'Logan_White', 'Mały dom', 0, 1, '2020-01-17', '2368.2109375,-1675.3427734375,14.168166160583', '-42.6, 1412.74, 1084.42', '-42.53, 1410.63, 1084.42', 80, 8, '', ''),
(61, 519, 'Jony_James', 'Mały dom', 0, 0, '2020-01-11', '2384.4951171875,-1675.48046875,14.915221214294', '-42.6, 1412.74, 1084.42', '-42.53, 1410.63, 1084.42', 80, 8, '', ''),
(62, 512, 'John_Creck', 'Mały dom', 0, 0, '2020-01-07', '2409.0361328125,-1674.73046875,14.339389801025', '-42.6, 1412.74, 1084.42', '-42.53, 1410.63, 1084.42', 80, 8, '', ''),
(63, 42, 'Vasco_Rivera', 'Mały dom', 0, 0, '2020-01-13', '2437.904296875,-2020.6572265625,13.902541160583', '-42.6, 1412.74, 1084.42', '-42.53, 1410.63, 1084.42', 105, 8, '', ''),
(64, 549, 'CarlBlue', 'Mały dom', 0, 0, '2020-01-11', '2465.228515625,-2020.7939453125,14.124163627625', '-42.6, 1412.74, 1084.42', '-42.53, 1410.63, 1084.42', 105, 8, '', ''),
(65, 0, '', 'Mały dom', 0, 1, '0000-00-00', '2486.4150390625,-2021.546875,13.998847007751', '-42.6, 1412.74, 1084.42', '-42.53, 1410.63, 1084.42', 105, 8, '', ''),
(66, 23, 'Olivier_Masseria', 'Mały dom', 0, 0, '2020-01-26', '2507.78125,-2021.048828125,14.210101127625', '-42.6, 1412.74, 1084.42', '-42.53, 1410.63, 1084.42', 105, 8, '', ''),
(67, 39, 'Juan_Rivera', 'Mały dom', 0, 0, '2020-01-26', '2522.658203125,-2019.09375,14.074416160583', '-42.6, 1412.74, 1084.42', '-42.53, 1410.63, 1084.42', 105, 8, '', ''),
(68, 42, 'Vasco_Rivera', 'Mały dom', 0, 0, '2020-01-28', '2524.4755859375,-1998.4365234375,14.113082885742', '-42.6, 1412.74, 1084.42', '-42.53, 1410.63, 1084.42', 105, 8, '', ''),
(69, 0, '', 'Mały dom', 0, 0, '0000-00-00', '2508.1787109375,-1998.3671875,13.902541160583', '-42.6, 1412.74, 1084.42', '-42.53, 1410.63, 1084.42', 105, 8, '', ''),
(70, 0, '', 'Mały dom', 0, 0, '0000-00-00', '2483.3671875,-1995.34765625,13.834323883057', '-42.6, 1412.74, 1084.42', '-42.53, 1410.63, 1084.42', 105, 8, '', ''),
(71, 0, '', 'Mały dom', 0, 0, '0000-00-00', '2465.2021484375,-1995.7548828125,14.019332885742', '-42.6, 1412.74, 1084.42', '-42.53, 1410.63, 1084.42', 105, 8, '', ''),
(72, 39, 'Juan_Rivera', 'Lokal organizacji', 0, 0, '2020-01-07', '2447.7529296875,-1962.7939453125,13.546875', '2270.34, -1210.51, 1047.56', '2264.9, -1210.53, 1049.02', 205, 10, '', ''),
(73, 509, 'Vladimir_Klimow', 'Mały dom', 0, 1, '2020-04-10', '-328.5185546875,835.578125,14.2421875', '-42.6, 1412.74, 1084.42', '-42.53, 1410.63, 1084.42', 100, 8, '', ''),
(74, 513, 'William_Wake', 'Mały dom', 0, 1, '2020-01-15', '-911.4384765625,2672.970703125,42.370262145996', '-42.6, 1412.74, 1084.42', '-42.53, 1410.63, 1084.42', 250, 8, '', '');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `db_interiors`
--

CREATE TABLE `db_interiors` (
  `id` int(11) NOT NULL,
  `nazwa` text CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL,
  `wejscie` text CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL,
  `wyjscie` text CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL,
  `wejscie_teleport` text CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL,
  `wyjscie_teleport` text CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL,
  `interior` int(11) NOT NULL DEFAULT 0,
  `dimension` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT;

--
-- Zrzut danych tabeli `db_interiors`
--

INSERT INTO `db_interiors` (`id`, `nazwa`, `wejscie`, `wyjscie`, `wejscie_teleport`, `wyjscie_teleport`, `interior`, `dimension`) VALUES
(1, 'Urząd miasta\r\nLos Santos', '1480.9279785156,-1770.9552001953,18.795755386353', '389.82528686523,173.79333496094,1008.3828125', '387.0085144043,173.74212646484,1008.3828125', '1481.1292724609,-1767.9274902344,18.795755386353', 3, 0),
(2, 'Diamond BANK', '1310.1522216797,-1367.9708251953,13.542978286743', '834.46374511719,7.4215207099915,1004.1870117188', '832.78057861328,7.3052144050598,1004.1796875', '1310.2219238281,-1370.4127197266,13.575280189514', 3, 0),
(3, 'Sklep z ubraniami\r\nZIP', '1073.1667480469,-1384.8074951172,13.868677139282', '2402.7663574219,-1730.9061279297,1070.4281005859', '2400.3127441406,-1730.8905029297,1070.4281005859', '1071.3170166016,-1386.7625732422,13.821591377258', 1, 0),
(4, 'Szkoła latania\r\n\"Zostań ptakiem\"', '1982.0671386719,-2188.685546875,13.546875', '-2026.8486328125,-103.60200500488,1035.1833496094', '-2028.6159667969,-105.07423400879,1035.171875', '1982.1280517578,-2190.859375,13.546875', 3, 0),
(5, 'Zarząd Wędkarstwa w\r\nLos Santos', '2818.712890625,-1614.5075683594,11.080269813538', '285.88372802734,-86.431411743164,1001.5228881836', '285.87026977539,-84.647010803223,1001.515625', '2821.1713867188,-1615.603515625,11.088433265686', 4, 0),
(6, 'Szpital Główny\r\nw Los Santos', '1172.5426025391,-1323.3179931641,15.402931213379', '2542.6857910156,-1690.1022949219,9916.828125', '2542.5988769531,-1687.8485107422,9916.828125', '1175.2008056641,-1323.4342041016,14.390625', 1, 0),
(7, 'Komenda Policji\r\nw Los Santos', '1554.7969970703,-1675.6149902344,16.1953125', '238.65249633789,139.04905700684,1003.0234375', '238.71420288086,141.24586486816,1003.0234375', '1551.3333740234,-1675.4869384766,15.802450180054', 3, 0),
(8, 'Sklep z bronia\r\n\"Kopyto pod komodą\"', '1368.5622558594,-1279.8558349609,13.546875', '285.40600585938,-41.748825073242,1001.515625', '285.55548095703,-39.620384216309,1001.515625', '1365.7189941406,-1279.8197021484,13.546875', 1, 0),
(9, 'Ośrodek Szkolenia Kierowców\r\n\"Kręć kólkiem\"\r\nw Los Santos', '1781.7446289063,-1721.3507080078,13.547760009766', '2433.3159179688,-1655.982421875,1016.1433105469', '2435.3828125,-1656.0794677734,1016.1433105469', '1781.6740722656,-1723.3898925781,13.546875', 1, 0),
(10, 'Salon samochodowy\r\n\"Złota kierownica\"', '1111.9252929688,-1370.1466064453,13.98437', '2485.8190917969,-1644.3712158203,1022.9204711914', '2485.6965332031,-1646.7346191406,1022.9204711914', '1111.9436035156,-1373.1721191406,13.98437', 0, 0),
(11, 'Restauracja\r\n\"Gringlanka\"', '2472.4565429688,-1530.1553955078,24.182909011841', '1948.3061523438,-1691.8680419922,990.02813720703', '1951.1038818359,-1691.8887939453,990.02813720703', '2475.130859375,-1530.1213378906,24.107383728027', 1, 0),
(13, 'Wejście tylne', '1568.6088867188,-1690.7268066406,5.890625', '288.74154663086,167.59078979492,1007.171875', '288.93478393555,170.06231689453,1007.1794433594', '1568.7679443359,-1692.5924072266,5.890625', 3, 0),
(14, '', '-1715.7357177734,-41.794769287109,3.5546875', '2392.8122558594,-1648.7355957031,11988.24609375', '2394.984375,-1648.5440673828,11988.24609375', '-1716.9948730469,-40.47477722168,3.5546875', 1, 0),
(15, '', '12794.2170410156,2222.3032226563,10.6203125', '12562.4953613281,-1640.56640625,17158.857421875', '12564.916015625,-1640.724609375,17158.857421875', '12794.1169433594,2225.3869628906,10.8203125', 1, 0),
(16, 'Jubiler\r\n\"Diamond Jewellery\"', '984.16912841797,-1336.4449462891,13.546875', '2480.0893554688,-1608.1151123047,18089.17578125', '2479.9582519531,-1610.6514892578,18089.173828125', '984.42395019531,-1333.9958496094,13.546875', 1, 0),
(17, 'Apteka\r\n\"Diamond Pharmacy\"', '1072.1105957031,-1313.1319580078,13.546875', '2604.5310058594,-1662.0130615234,20002.2578125', '2602.5402832031,-1662.0904541016,20002.2578125', '1069.4537353516,-1312.8898925781,13.546875', 1, 0),
(18, 'Operator komórkowy\r\n\"Diamond GSM\"', '967.81750488281,-1310.8996582031,13.518437385559', '2482.7641601563,-1697.7021484375,21912.048828125', '2484.7785644531,-1697.6651611328,21912.048828125', '967.85192871094,-1312.5892333984,13.51838684082', 1, 0),
(19, 'Siłownia\r\n\"Dupsko kuj, rośnij w chuj\"', '0, 0, -999', '2573.361328125,-1643.5112304688,15712.927734375', '2571.482421875,-1643.6848144531,15712.92773437', '0, 0, -999', 1, 0),
(20, 'Lombard\r\n\"Zajeb, przytargaj, opierdol\"', '0, 0, -999', '2526.1640625,-1676.4956054688,26904.728515625', '2527.0212402344,-1674.6831054688,26904.728515625', '0, 0, -999', 1, 0);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `db_items`
--

CREATE TABLE `db_items` (
  `id` int(11) NOT NULL,
  `dbid` int(11) NOT NULL,
  `nick` text NOT NULL,
  `nazwa` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

--
-- Zrzut danych tabeli `db_items`
--

INSERT INTO `db_items` (`id`, `dbid`, `nick`, `nazwa`) VALUES
(1, 1, 'Vogel', 'Kij baseballowy'),

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `db_jail`
--

CREATE TABLE `db_jail` (
  `seg` int(11) NOT NULL,
  `Serial` varchar(128) NOT NULL,
  `Termin` datetime NOT NULL,
  `Cela` int(11) NOT NULL COMMENT 'CELA',
  `Powod` varchar(4092) CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `db_objects`
--

CREATE TABLE `db_objects` (
  `id` int(11) NOT NULL,
  `model` int(11) NOT NULL DEFAULT 0,
  `pos` text CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL,
  `rotation` text CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL,
  `interior` int(11) NOT NULL DEFAULT 0,
  `dim` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT;

--
-- Zrzut danych tabeli `db_objects`
--

INSERT INTO `db_objects` (`id`, `model`, `pos`, `rotation`, `interior`, `dim`) VALUES
(3, 849, '[ [ 876.5648200000001, -1353.8658, 12.91743 ] ]', '[ [ 0, 0, 0 ] ]', 0, 0),
(4, 1328, '[ [ 877.6156, -1354.6859, 13.150737 ] ]', '[ [ 0, 0, 0 ] ]', 0, 0),
(7, 3606, '[ [ 1982.1123, -2183.9014, 15.886913 ] ]', '[ [ 0, 0, 0 ] ]', 0, 0),
(8, 1965, '[ [ 2518.0322, -1486.5674, 24.102684 ] ]', '[ [ 0, 0, 0 ] ]', 0, 0),
(9, 1965, '[ [ 2522.4634, -1485.1006, 23.999443 ] ]', '[ [ 0, 1.25, 180 ] ]', 0, 0),
(10, 3260, '[ [ 2518.8005, -1493.0533, 22.8 ] ]', '[ [ 0, 0, 0 ] ]', 0, 0),
(11, 3260, '[ [ 2518.8005, -1493.0533, 25.8 ] ]', '[ [ 0, 0, 0 ] ]', 0, 0),
(12, 1532, '[ [ 2472.0163, -1530.9004, 23.191547 ] ]', '[ [ 0,0,90 ] ]', 0, 0),
(13, 2957, '[ [ -1770.0889, 981.7093, 24.083672 ] ]', '[ [ 0, 0, 270] ]', 0, 0),
(14, 2957, '[ [ -1770.0889, 985.0293, 24.083672 ] ]', '[ [ 0, 0, 270] ]', 0, 0),
(15, 2957, '[ [ -1770.0889, 988.0293, 24.083672 ] ]', '[ [ 0, 0, 270] ]', 0, 0),
(16, 2957, '[ [ -1770.0889, 981.7093, 27.083672 ] ]', '[ [ 180, 0, 270] ]', 0, 0),
(17, 2957, '[ [ -1770.0889, 985.0293, 27.083672 ] ]', '[ [ 180, 0, 270] ]', 0, 0),
(18, 2957, '[ [ -1770.0889, 988.0293, 27.083672 ] ]', '[ [ 180, 0, 270] ]', 0, 0),
(22, 3512, '[ [ 1013.6822, -1310.7876, 16.727821 ] ]', '[ [ 0, 0, 0 ] ]', 0, 0),
(23, 3512, '[ [ 1091.1035, -1369.6445, 17.714979 ] ]', '[ [ 0, 0, 0 ] ]', 0, 0),
(24, 3512, '[ [ 1478.9541, -1639.9365, 17.452713 ] ]', '[ [ 0, 0, 0 ] ]', 0, 0),
(25, 3512, '[ [ 1522.416, -1509.3125, 17.02527 ] ]', '[ [ 0, 0, 0 ] ]', 0, 0),
(26, 3512, '[ [ 1549.7217, -1681.791, 16.991112 ] ]', '[ [ 0, 0, 0 ] ]', 0, 0),
(27, 3512, '[ [ 1702.0977, -1752.2773, 17.0245 ] ]', '[ [ 0, 0, 0 ] ]', 0, 0),
(28, 3512, '[ [ 1953.7471, -1760.418, 16.969273 ] ]', '[ [ 0, 0, 0 ] ]', 0, 0),
(29, 3512, '[ [ 1183.1412, -1319.8916, 16.990328 ] ]', '[ [ 0, 0, 0 ] ]', 0, 0),
(30, 3512, '[ [ 1025.7285, -1336.1617, 17.095871 ] ]', '[ [ 0, 0, 0 ] ]', 0, 0),
(31, 3512, '[ [ 986.04395, -1389.2109, 16.502871 ] ]', '[ [ 0, 0, 0 ] ]', 0, 0),
(32, 3512, '[ [ 2488.3997, -1518.9158, 27.389261 ] ]', '[ [ 0, 0, 0 ] ]', 0, 0),
(33, 3512, '[ [ 1396.7621, -1615.3612, 16.947344 ] ]', '[ [ 0, 0, 0 ] ]', 0, 0);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `db_organizations`
--

CREATE TABLE `db_organizations` (
  `id` int(11) NOT NULL,
  `organizacja` text CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL,
  `rank_1` text CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL,
  `rank_2` text CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL,
  `rank_3` text CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL,
  `rank_4` text CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

--
-- Zrzut danych tabeli `db_organizations`
--

INSERT INTO `db_organizations` (`id`, `organizacja`, `rank_1`, `rank_2`, `rank_3`, `rank_4`) VALUES
(1, 'Lertivo', 'Soldato', 'Caporegime', 'Capobastone', 'Don'),
(2, 'Los Santos Vagos', 'Soldato', 'Loco', 'Bajo El Jefe', 'Jefe'),
(3, 'Gokudō Boys', '49ers', 'Red Pole', 'Officer', 'Dragon Head'),
(4, 'SA_Famillia_Dziuba', 'Dzióba', 'Dziuba', 'vLider', 'Lider');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `db_punishments`
--

CREATE TABLE `db_punishments` (
  `id` int(11) NOT NULL,
  `type` text CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL,
  `nick` text CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL,
  `serial` text CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL,
  `ip` text CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL,
  `admin` text CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL,
  `first_date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `date` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `reason` text CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL,
  `active` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT;

--
-- Zrzut danych tabeli `db_punishments`
--

INSERT INTO `db_punishments` (`id`, `type`, `nick`, `serial`, `ip`, `admin`, `first_date`, `date`, `reason`, `active`) VALUES
(2, 'mute', 'Vittorio_Lertivo', '7A070007535FDEB0AD27A94FF09C2812', '88.156.139.183', 'Vogel', '2019-11-28 19:22:20', '2019-11-25 16:29:37', 'test', 0),

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `db_reports`
--

CREATE TABLE `db_reports` (
  `id` int(11) NOT NULL,
  `kto` text NOT NULL,
  `kogo` text NOT NULL,
  `kiedy` text NOT NULL,
  `powod` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

--
-- Zrzut danych tabeli `db_reports`
--

INSERT INTO `db_reports` (`id`, `kto`, `kogo`, `kiedy`, `powod`) VALUES

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `db_updates`
--

CREATE TABLE `db_updates` (
  `id` int(11) NOT NULL,
  `text` text CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL,
  `admin` text CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL,
  `data` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=COMPACT;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `db_users`
--

CREATE TABLE `db_users` (
  `id` int(11) NOT NULL,
  `login` text CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL,
  `logged` int(11) NOT NULL DEFAULT 0,
  `email` varchar(90) DEFAULT '0',
  `password` text CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL,
  `money` int(11) NOT NULL DEFAULT 0,
  `bank_money` int(11) NOT NULL DEFAULT 0,
  `zarobione` int(11) NOT NULL DEFAULT 0,
  `konto_bankowe` int(11) NOT NULL DEFAULT 0,
  `roleplay` int(11) NOT NULL DEFAULT 0,
  `prawkoA` int(11) NOT NULL DEFAULT 0,
  `prawkoB` int(11) NOT NULL DEFAULT 0,
  `prawkoC` int(11) NOT NULL DEFAULT 0,
  `prawkoL` int(11) NOT NULL DEFAULT 0,
  `licencjaR` int(11) NOT NULL DEFAULT 0,
  `licencjaB` int(11) NOT NULL DEFAULT 0,
  `reputation` int(11) NOT NULL,
  `premium_date` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `premium_points` int(11) NOT NULL DEFAULT 0,
  `serial` text CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL,
  `lastlogin` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `registered` timestamp NOT NULL DEFAULT current_timestamp(),
  `online` int(11) NOT NULL DEFAULT 0,
  `level` int(11) NOT NULL DEFAULT 1,
  `exp` int(11) NOT NULL DEFAULT 0,
  `save` int(11) NOT NULL DEFAULT 0,
  `tutorial` varchar(3) NOT NULL DEFAULT 'NIE',
  `nowe_przelewy` int(11) NOT NULL DEFAULT 0,
  `skin` int(11) NOT NULL DEFAULT 26,
  `faction` text CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL,
  `frank` int(11) NOT NULL DEFAULT 0,
  `ftime` int(11) NOT NULL DEFAULT 0,
  `org` text CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL,
  `orank` int(11) NOT NULL,
  `achievements` text CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL,
  `mandates` text CHARACTER SET utf8 COLLATE utf8_polish_ci DEFAULT NULL,
  `food` int(11) NOT NULL DEFAULT 100,
  `drink` int(11) NOT NULL DEFAULT 100,
  `health` int(11) NOT NULL DEFAULT 100,
  `cut` varchar(3) CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL DEFAULT 'NIE',
  `shaders` text CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL,
  `settings` text CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL,
  `pos` text NOT NULL,
  `justcola` int(11) NOT NULL DEFAULT 0,
  `sold_drugs` int(11) NOT NULL DEFAULT 0,
  `weed1` int(11) NOT NULL DEFAULT 0,
  `weed2` int(11) NOT NULL DEFAULT 0,
  `meth1` int(11) NOT NULL DEFAULT 0,
  `meth2` int(11) NOT NULL DEFAULT 0,
  `coke1` int(11) NOT NULL DEFAULT 0,
  `coke2` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Zrzut danych tabeli `db_users`
--


-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `db_whitelist`
--

CREATE TABLE `db_whitelist` (
  `ID` int(255) NOT NULL,
  `nick` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `serial` varchar(255) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `logs_admin`
--

CREATE TABLE `logs_admin` (
  `id` int(11) NOT NULL,
  `nick` text CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL,
  `serial` text CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL,
  `text` text NOT NULL,
  `date` timestamp NOT NULL DEFAULT current_timestamp(),
  `type` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Zrzut danych tabeli `logs_admin`
--

--
-- Indeksy dla zrzutów tabel
--

--
-- Indexes for table `db_admins`
--
ALTER TABLE `db_admins`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `db_admin_jail`
--
ALTER TABLE `db_admin_jail`
  ADD PRIMARY KEY (`seg`);

--
-- Indexes for table `db_businesses`
--
ALTER TABLE `db_businesses`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `db_diamond_exchange`
--
ALTER TABLE `db_diamond_exchange`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `db_exchange`
--
ALTER TABLE `db_exchange`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `db_garages`
--
ALTER TABLE `db_garages`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `db_houses`
--
ALTER TABLE `db_houses`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `db_interiors`
--
ALTER TABLE `db_interiors`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `db_items`
--
ALTER TABLE `db_items`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `db_jail`
--
ALTER TABLE `db_jail`
  ADD PRIMARY KEY (`seg`);

--
-- Indexes for table `db_objects`
--
ALTER TABLE `db_objects`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `db_punishments`
--
ALTER TABLE `db_punishments`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `db_reports`
--
ALTER TABLE `db_reports`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `db_updates`
--
ALTER TABLE `db_updates`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `db_users`
--
ALTER TABLE `db_users`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `db_vehicles`
--
ALTER TABLE `db_vehicles`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `db_whitelist`
--
ALTER TABLE `db_whitelist`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `logs_admin`
--
ALTER TABLE `logs_admin`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `logs_businesses`
--
ALTER TABLE `logs_businesses`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `logs_chat`
--
ALTER TABLE `logs_chat`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `logs_diamond`
--
ALTER TABLE `logs_diamond`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `logs_factions`
--
ALTER TABLE `logs_factions`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `logs_illegal`
--
ALTER TABLE `logs_illegal`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `logs_jobs`
--
ALTER TABLE `logs_jobs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `logs_licences`
--
ALTER TABLE `logs_licences`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `logs_transfers`
--
ALTER TABLE `logs_transfers`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `logs_vehicle`
--
ALTER TABLE `logs_vehicle`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT dla tabeli `db_admins`
--
ALTER TABLE `db_admins`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=295;

--
-- AUTO_INCREMENT dla tabeli `db_admin_jail`
--
ALTER TABLE `db_admin_jail`
  MODIFY `seg` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT dla tabeli `db_businesses`
--
ALTER TABLE `db_businesses`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT dla tabeli `db_diamond_exchange`
--
ALTER TABLE `db_diamond_exchange`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=170;

--
-- AUTO_INCREMENT dla tabeli `db_exchange`
--
ALTER TABLE `db_exchange`
  MODIFY `ID` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT dla tabeli `db_garages`
--
ALTER TABLE `db_garages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT dla tabeli `db_houses`
--
ALTER TABLE `db_houses`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=75;

--
-- AUTO_INCREMENT dla tabeli `db_interiors`
--
ALTER TABLE `db_interiors`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT dla tabeli `db_items`
--
ALTER TABLE `db_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=49195;

--
-- AUTO_INCREMENT dla tabeli `db_jail`
--
ALTER TABLE `db_jail`
  MODIFY `seg` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=47;

--
-- AUTO_INCREMENT dla tabeli `db_objects`
--
ALTER TABLE `db_objects`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- AUTO_INCREMENT dla tabeli `db_punishments`
--
ALTER TABLE `db_punishments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=112;

--
-- AUTO_INCREMENT dla tabeli `db_reports`
--
ALTER TABLE `db_reports`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2820;

--
-- AUTO_INCREMENT dla tabeli `db_updates`
--
ALTER TABLE `db_updates`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT dla tabeli `db_users`
--
ALTER TABLE `db_users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=729;

--
-- AUTO_INCREMENT dla tabeli `db_vehicles`
--
ALTER TABLE `db_vehicles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=234;

--
-- AUTO_INCREMENT dla tabeli `logs_admin`
--
ALTER TABLE `logs_admin`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19672;

--
-- AUTO_INCREMENT dla tabeli `logs_businesses`
--
ALTER TABLE `logs_businesses`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=186;

--
-- AUTO_INCREMENT dla tabeli `logs_chat`
--
ALTER TABLE `logs_chat`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=132586;

--
-- AUTO_INCREMENT dla tabeli `logs_diamond`
--
ALTER TABLE `logs_diamond`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=564;

--
-- AUTO_INCREMENT dla tabeli `logs_factions`
--
ALTER TABLE `logs_factions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5858;

--
-- AUTO_INCREMENT dla tabeli `logs_illegal`
--
ALTER TABLE `logs_illegal`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=121182;

--
-- AUTO_INCREMENT dla tabeli `logs_jobs`
--
ALTER TABLE `logs_jobs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=65035;

--
-- AUTO_INCREMENT dla tabeli `logs_licences`
--
ALTER TABLE `logs_licences`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1687;

--
-- AUTO_INCREMENT dla tabeli `logs_transfers`
--
ALTER TABLE `logs_transfers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6302;

--
-- AUTO_INCREMENT dla tabeli `logs_vehicle`
--
ALTER TABLE `logs_vehicle`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17192;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
