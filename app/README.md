# Application Source — Proprietary Client Code

This directory contains the application source code for the **Repositorio de Muestras** system, developed for [Fundación Huésped](https://huesped.org.ar/) (Buenos Aires, Argentina).

The source code is proprietary and is not included in this public repository.

---

## What lives here (not published)

| Directory / File | Description |
|---|---|
| `src/` | Legacy procedural PHP — ~80 files handling sample management, storage devices, transfers, exports, and admin console |
| `frmwk/` | Laravel 9 bridge — authentication, SSO, user management, API layer |
| `public/` | Web root — front controller (`index.php`), CSS, JS, images. Only this directory is exposed by Apache |
| `composer.json` | App-level Composer dependencies (PhpSpreadsheet, PHPMailer) |

---

## How it connects to the Docker setup

The `Dockerfile` and `docker-compose.yml` at the repo root bind-mount this directory into the container at runtime:

```yaml
volumes:
  - ./app:/var/www/html   # bind mount — app code on host, served by Apache in container
```

The container provides the runtime environment (PHP 8.2, Apache, Composer dependencies). The application logic itself is in this directory and is never baked into the image.

---

## Architecture overview

```
app/public/index.php  ← only entry point exposed to the web
    │
    ├── *.php request  →  app/src/<page>.php   (legacy PHP)
    │
    └── everything else →  app/frmwk/          (Laravel — auth, APIs)
                                │
                                └── MariaDB (cajassistema) via PDO
```

Operational notes for this layer are in the [`docs/`](../docs/) directory.
