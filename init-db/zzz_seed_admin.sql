-- Default admin user — auto-created on every DB initialization.
-- Username: admin  |  Password: admin1234  |  Role: ADM
-- Change the password after first login via the account settings.
INSERT INTO `usuarios` (username, password, email, permiso)
VALUES ('admin', '$2y$10$VFbw0tz4ZAI2EpLR4KkHRuLxPF0ZgO7CYTie/rdY.01x3rKQFwZ/i', 'admin@local.dev', 'ADM')
ON DUPLICATE KEY UPDATE permiso = 'ADM';
