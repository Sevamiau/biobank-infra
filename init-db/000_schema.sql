-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 30-04-2026 a las 15:57:28
-- Versión del servidor: 10.4.24-MariaDB
-- Versión de PHP: 8.2.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `cajassistema`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cajas`
--

CREATE TABLE `cajas` (
  `id` int(11) NOT NULL,
  `nombre_caja` varchar(255) NOT NULL,
  `freezer_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `cajas`
--


-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `freezers`
--

CREATE TABLE `freezers` (
  `id` int(11) NOT NULL,
  `nombre_freezer` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `freezers`
--


-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `log_movimientos`
--

CREATE TABLE `log_movimientos` (
  `id` int(11) NOT NULL,
  `usuario` varchar(100) DEFAULT NULL,
  `accion` varchar(50) DEFAULT NULL,
  `detalle` text DEFAULT NULL,
  `fecha` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `log_movimientos`
--


-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `log_repo`
--

CREATE TABLE `log_repo` (
  `id` int(11) NOT NULL,
  `usuario` varchar(100) NOT NULL,
  `accion` varchar(100) NOT NULL,
  `detalle` text NOT NULL,
  `fecha` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `log_repo`
--


-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `migrations`
--


-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `muestras`
--

CREATE TABLE `muestras` (
  `id` int(11) NOT NULL,
  `paciente_id` varchar(255) NOT NULL,
  `muestra_id` varchar(255) NOT NULL,
  `estado` enum('Activa','Inactiva') NOT NULL DEFAULT 'Activa',
  `inst_id` varchar(255) NOT NULL,
  `tipo_muestra` enum('Sangre','Laboratorio','Genotipo','Cáncer') NOT NULL,
  `alicuota_numero` varchar(255) NOT NULL,
  `volumen_muestra` varchar(255) DEFAULT NULL,
  `unidad_volumen` enum('uL','mL','cm3','L','dL','cL','nL','pL','fL','aL') DEFAULT NULL,
  `fecha_recoleccion` date NOT NULL,
  `hora_recoleccion` time DEFAULT NULL,
  `protocolo` text NOT NULL,
  `observaciones` text DEFAULT NULL,
  `tecnico_iniciales` varchar(255) DEFAULT NULL,
  `tipo_disp` enum('Frío','Ambiente') DEFAULT NULL,
  `u_almac_def` enum('Heladera','Freezer','Ultrafreezer','Nitrógeno','Parafina','Vidrio','Temporal') DEFAULT NULL,
  `u_almac_a` varchar(255) NOT NULL,
  `u_almac_b` varchar(255) NOT NULL,
  `u_almac_c` varchar(255) NOT NULL,
  `u_almac_d` varchar(255) NOT NULL,
  `u_almac_e` varchar(255) NOT NULL,
  `u_almac_f` varchar(255) NOT NULL,
  `u_almac_g` varchar(255) NOT NULL,
  `tras_status` enum('Activa','Inactiva','Finalizada') NOT NULL DEFAULT 'Inactiva',
  `tras_fecha` date DEFAULT NULL,
  `tras_hora` time DEFAULT NULL,
  `tras_lugar` varchar(255) DEFAULT NULL,
  `tras_obs` text DEFAULT NULL,
  `tras_transport` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `muestras`
--


-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `muestras_arch`
--

CREATE TABLE `muestras_arch` (
  `id` int(11) NOT NULL,
  `paciente_id` varchar(255) NOT NULL,
  `muestra_id` varchar(255) NOT NULL,
  `inst_id` varchar(255) NOT NULL,
  `tipo_muestra` enum('Sangre','Laboratorio','Genotipo','Cáncer') NOT NULL,
  `alicuota_numero` varchar(255) NOT NULL,
  `volumen_muestra` varchar(255) DEFAULT NULL,
  `fecha_recoleccion` date NOT NULL,
  `hora_recoleccion` time DEFAULT NULL,
  `protocolo` text NOT NULL,
  `observaciones` text DEFAULT NULL,
  `tecnico_iniciales` varchar(255) DEFAULT NULL,
  `u_almac_a` varchar(255) NOT NULL,
  `u_almac_b` varchar(255) NOT NULL,
  `u_almac_c` varchar(255) NOT NULL,
  `u_almac_d` varchar(255) NOT NULL,
  `u_almac_e` varchar(255) NOT NULL,
  `u_almac_f` varchar(255) NOT NULL,
  `u_almac_g` varchar(255) NOT NULL,
  `tras_lugar` varchar(255) DEFAULT NULL,
  `tras_fecha` date DEFAULT NULL,
  `tras_transport` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `muestras_arch`
--


-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `muestras_protocolos`
--

CREATE TABLE `muestras_protocolos` (
  `muestra_id` int(11) NOT NULL,
  `protocolo_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `muestras_protocolos`
--


-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `password_resets`
--

CREATE TABLE `password_resets` (
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `password_resets`
--


-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `protocolos`
--

CREATE TABLE `protocolos` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `protocolos`
--


-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `unidades_almacen`
--

CREATE TABLE `unidades_almacen` (
  `id` int(11) NOT NULL,
  `u_almac_a` varchar(255) NOT NULL,
  `tipo_unidad` varchar(50) NOT NULL,
  `creado_por` varchar(100) DEFAULT NULL,
  `creado_en` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id` int(11) NOT NULL,
  `username` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `nombre` varchar(100) DEFAULT NULL,
  `apellido` varchar(100) DEFAULT NULL,
  `email` varchar(255) NOT NULL,
  `email_sec` varchar(255) DEFAULT NULL,
  `institucion` varchar(255) DEFAULT NULL,
  `fecha_creac_us` date DEFAULT NULL,
  `fecha_caduc_us` date DEFAULT NULL,
  `observ_us` text DEFAULT NULL,
  `permiso` varchar(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `usuarios`
--


--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `cajas`
--
ALTER TABLE `cajas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `freezer_id` (`freezer_id`);

--
-- Indices de la tabla `freezers`
--
ALTER TABLE `freezers`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `log_movimientos`
--
ALTER TABLE `log_movimientos`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `log_repo`
--
ALTER TABLE `log_repo`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `muestras`
--
ALTER TABLE `muestras`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `muestras_arch`
--
ALTER TABLE `muestras_arch`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `muestras_protocolos`
--
ALTER TABLE `muestras_protocolos`
  ADD PRIMARY KEY (`muestra_id`,`protocolo_id`),
  ADD KEY `protocolo_id` (`protocolo_id`);

--
-- Indices de la tabla `password_resets`
--
ALTER TABLE `password_resets`
  ADD KEY `password_resets_email_index` (`email`);

--
-- Indices de la tabla `protocolos`
--
ALTER TABLE `protocolos`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nombre` (`nombre`);

--
-- Indices de la tabla `unidades_almacen`
--
ALTER TABLE `unidades_almacen`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_u_almac_a` (`u_almac_a`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_username` (`username`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `cajas`
--
ALTER TABLE `cajas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT de la tabla `freezers`
--
ALTER TABLE `freezers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `log_movimientos`
--
ALTER TABLE `log_movimientos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25054;

--
-- AUTO_INCREMENT de la tabla `log_repo`
--
ALTER TABLE `log_repo`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `muestras`
--
ALTER TABLE `muestras`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1210;

--
-- AUTO_INCREMENT de la tabla `muestras_arch`
--
ALTER TABLE `muestras_arch`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1194;

--
-- AUTO_INCREMENT de la tabla `protocolos`
--
ALTER TABLE `protocolos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `unidades_almacen`
--
ALTER TABLE `unidades_almacen`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=50;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `cajas`
--
ALTER TABLE `cajas`
  ADD CONSTRAINT `cajas_ibfk_1` FOREIGN KEY (`freezer_id`) REFERENCES `freezers` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `muestras_protocolos`
--
ALTER TABLE `muestras_protocolos`
  ADD CONSTRAINT `muestras_protocolos_ibfk_1` FOREIGN KEY (`muestra_id`) REFERENCES `muestras` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `muestras_protocolos_ibfk_2` FOREIGN KEY (`protocolo_id`) REFERENCES `protocolos` (`id`) ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
