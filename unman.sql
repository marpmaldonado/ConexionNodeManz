-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 08-03-2024 a las 01:46:10
-- Versión del servidor: 10.4.28-MariaDB
-- Versión de PHP: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `unman`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `manzanas`
--

CREATE TABLE `manzanas` (
  `id_manzanas` int(11) NOT NULL,
  `Nombre` varchar(50) DEFAULT NULL,
  `Direccion` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `manzanas`
--

INSERT INTO `manzanas` (`id_manzanas`, `Nombre`, `Direccion`) VALUES
(1, 'Bosa', 'Kra 103 10-25'),
(2, 'Chapinero', 'Kra 63 10-25'),
(3, 'Suba', 'Kra 114F 10-25');


INSERT into manzanas (`id_manzanas`, `Nombre`, `Direccion`) VALUES
(4, 'Usaquén', 'Calle 170'),
(5, 'Santa Fe', 'Trasversal 0'),
(6, 'Kennedy', 'Carrera 81')


-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `manzana_servicios`
--

CREATE TABLE `manzana_servicios` (
  `id_m` int(11) DEFAULT NULL,
  `id_s` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `manzana_servicios`
--

INSERT INTO `manzana_servicios` (`id_m`, `id_s`) VALUES
(1, 1),
(1, 2),
(1, 3),
(1, 4),
(1, 5),
(2, 6),
(2, 4),
(2, 5),
(2, 7),
(3, 6),
(3, 3),
(3, 8);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `servicios`
--

CREATE TABLE `servicios` (
  `id_servicios` int(11) NOT NULL,
  `Nombre` varchar(50) DEFAULT NULL,
  `Tipo` varchar(25) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `servicios`
--

INSERT INTO `servicios` (`id_servicios`, `Nombre`, `Tipo`) VALUES
(1, 'Clases de Baile', 'Entretenimiento'),
(2, 'Cine', 'Entretenimiento'),
(3, 'Piscina', 'Deporte'),
(4, 'Gimnasio', 'Deporte'),
(5, 'Yoga', 'Deporte'),
(6, 'Cocina', 'Gastronomia'),
(7, 'Coser', 'Maquina'),
(8, 'Lavandería', 'Aseo');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `solicitudes`
--

CREATE TABLE `solicitudes` (
  `id_solicitudes` int(11) NOT NULL,
  `fecha` datetime DEFAULT NULL,
  `id1` int(10) DEFAULT NULL,
  `codigoS` int(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `solicitudes`
--

INSERT INTO `solicitudes` (`id_solicitudes`, `fecha`, `id1`, `codigoS`) VALUES
(23, '2024-03-05 11:41:00', 27, 5),
(24, '2024-03-09 12:50:00', 27, 6),
(25, '2024-03-05 12:53:00', 27, 4),
(26, '2024-03-05 16:53:00', 27, 5),
(27, '2024-03-06 10:46:00', 27, 4),
(28, '2024-03-29 10:51:00', 27, 7),
(29, '2024-03-06 10:55:00', 27, 5),
(30, '2024-03-06 11:02:00', 27, 4),
(31, '2024-03-06 02:27:00', 27, 6),
(32, '2024-03-08 10:37:00', 28, 4),
(33, '2024-03-30 19:14:00', 28, 3);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario`
--

CREATE TABLE `usuario` (
  `id_user` int(2) NOT NULL,
  `Nombre` varchar(30) DEFAULT NULL,
  `Tipo` varchar(30) DEFAULT NULL,
  `Documento` varchar(10) DEFAULT NULL,
  `id_manzanas` int(11) DEFAULT NULL,
  `rol` set('usuario','administrador') DEFAULT 'usuario'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuario`
--

INSERT INTO `usuario` (`id_user`, `Nombre`, `Tipo`, `Documento`, `id_manzanas`, `rol`) VALUES
(24, 'Harold', 'CC', '1031420778', 1, 'usuario'),
(25, 'Santiago', 'CC', '1031420777', 3, 'usuario'),
(26, 'JACK', 'CC', '8620', 3, 'administrador'),
(27, 'Jackson', 'CC', '0000', 2, 'usuario'),
(28, 'Anyelo', 'CC', '1018404962', 1, 'usuario');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `manzanas`
--
ALTER TABLE `manzanas`
  ADD PRIMARY KEY (`id_manzanas`);

--
-- Indices de la tabla `manzana_servicios`
--
ALTER TABLE `manzana_servicios`
  ADD KEY `fk_id4` (`id_s`),
  ADD KEY `fk_id5` (`id_m`);

--
-- Indices de la tabla `servicios`
--
ALTER TABLE `servicios`
  ADD PRIMARY KEY (`id_servicios`);

--
-- Indices de la tabla `solicitudes`
--
ALTER TABLE `solicitudes`
  ADD PRIMARY KEY (`id_solicitudes`),
  ADD UNIQUE KEY `fecha` (`fecha`),
  ADD KEY `fk_idsoli` (`id1`);

--
-- Indices de la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`id_user`),
  ADD UNIQUE KEY `Documento` (`Documento`),
  ADD KEY `fk_id1` (`id_manzanas`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `manzanas`
--
ALTER TABLE `manzanas`
  MODIFY `id_manzanas` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `servicios`
--
ALTER TABLE `servicios`
  MODIFY `id_servicios` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT de la tabla `solicitudes`
--
ALTER TABLE `solicitudes`
  MODIFY `id_solicitudes` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT de la tabla `usuario`
--
ALTER TABLE `usuario`
  MODIFY `id_user` int(2) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `manzana_servicios`
--
ALTER TABLE `manzana_servicios`
  ADD CONSTRAINT `fk_id4` FOREIGN KEY (`id_s`) REFERENCES `servicios` (`id_servicios`),
  ADD CONSTRAINT `fk_id5` FOREIGN KEY (`id_m`) REFERENCES `manzanas` (`id_manzanas`);

--
-- Filtros para la tabla `solicitudes`
--
ALTER TABLE `solicitudes`
  ADD CONSTRAINT `fk_idsoli` FOREIGN KEY (`id1`) REFERENCES `usuario` (`id_user`);

--
-- Filtros para la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD CONSTRAINT `fk_id1` FOREIGN KEY (`id_manzanas`) REFERENCES `manzanas` (`id_manzanas`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
