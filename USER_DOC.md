# USER DOCUMENTATION – Inception
Este documento describe cómo utilizar la infraestructura desplegada por el proyecto **Inception** desde el punto de vista de un usuario final.

---

## 🌐 Acceso al sitio web

El proyecto utiliza el siguiente dominio local:

ajodar.42.fr

Para que el navegador pueda resolverlo correctamente, es necesario añadir la siguiente entrada en el archivo `/etc/hosts`:

127.0.0.1   ajodar.42.fr

También se puede ejecutar el siguiente comando de ayuda:
```bash
make hosts
```

### 🚀 Puesta en marcha del proyecto

Antes de ejecutar la primera vez el proyecto se tiene que ejecutar make setup para preparar las carpetas que alojarán los datos que guarda mariadb, nginx y wordpress
```bash
make setup
```

Para iniciar toda la infraestructura, ejecutar:
```bash
make up
```

Este comando:

Prepara las carpetas de persistencia
Construye las imágenes Docker
Inicia todos los contenedores en segundo plano



### 🔐 Acceso a los servicios.

🌐 WordPress
URL: https://ajodar.42.fr

🔧 Panel de administración
URL: https://ajodar.42.fr/wp-admin

Credenciales por defecto
Administrador: ajodar / wpadminpass
Usuario estándar: wpuser / wpuserpass


### 🛑 Detener el proyecto

Para detener los contenedores sin eliminar datos:
```bash
make down
```

### 🧹 Limpieza completa

Para eliminar completamente el proyecto y todos sus datos persistentes:
```bash
make fclean
```

Este comando elimina:
Contenedores
Imágenes Docker
Volúmenes
Datos persistentes locales


### 🔐 HTTPS y certificados
El sitio se sirve exclusivamente mediante HTTPS utilizando un certificado SSL autofirmado generado dinámicamente.
Es normal que el navegador muestre una advertencia de seguridad debido a que el certificado no está firmado por una entidad certificadora reconocida.


### 🧪 Comprobaciones útiles
Ver contenedores activos:
```bash
make test
```

### Ver logs de servicios:
```bash
make nginx
make wordpress
```