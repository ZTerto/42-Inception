# 42-Inception

Este proyecto consiste en el despliegue de un entorno completo usando Docker y Docker Compose, siguiendo la filosofía de contenerización de 42. Se crean servicios como NGINX, WordPress y MariaDB, orquestados en una red interna.

## 🧱 Estructura del Proyecto

- **NGINX**: Servidor web con SSL (HTTPS).
- **WordPress**: CMS conectado a MariaDB.
- **MariaDB**: Base de datos persistente para WordPress.
- **Docker Compose**: Orquestación de servicios.
- **Volumes**: Persistencia de datos para WordPress y MariaDB.

## ⚙️ Uso

### Iniciar el proyecto
```bash
make up
```

### Apagar contenedores
```bash
make down
```

### Limpiar volúmenes e imágenes
```bash
make fclean
```

### Ver logs de servicios
```bash
make logswordpress
make logsnginx
make logsdb
```

### Acceder a la base de datos
```bash
make db
```

## 🔐 Usuarios configurables desde `.env`

Puedes personalizar completamente los **usuarios y contraseñas de WordPress** desde el archivo `.env`:

```env
# Admin principal
WP_ADMIN=zt_admin
WP_ADMIN_PASS=wpadminpass
WP_ADMIN_EMAIL=admin@example.com

# Usuario secundario
WP_USER=wpuser
WP_USER_PASS=wpuserpass
WP_USER_EMAIL=wpuser@example.com
```

Estos valores son aplicados automáticamente la **primera vez** que se ejecuta WordPress.

Si deseas forzar su recreación (por ejemplo, para cambiar contraseñas o usuarios), puedes usar:

```bash
FORCE_RECREATE_USERS=true make wordpress
```

## 📁 Datos persistentes

Los volúmenes montados aseguran que los datos no se pierdan al reiniciar los contenedores:

- `./data/wordpress`
- `./data/mariadb`

## 🌐 Acceso rápido

- 🌍 WordPress: https://zajodar.42.fr/
- 🔧 Panel admin: https://zajodar.42.fr/wp-admin
  - 👤 Usuario: `zt_admin`
  - 🔑 Contraseña: `wpadminpass`

## 📦 Requisitos

- Docker
- Docker Compose
- Make

## ❌ Bonus

Este proyecto se ha centrado en los requisitos obligatorios. No se han implementado servicios opcionales (bonus).

---

¡Proyecto completado y listo para defensa!