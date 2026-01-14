# Inception

Proyecto del cursus de **42** cuyo objetivo es desplegar una infraestructura completa utilizando **Docker** y **Docker Compose**, siguiendo un enfoque de servicios desacoplados y configurados manualmente.

La infraestructura está compuesta por:
- **NGINX** como servidor web (solo HTTPS)
- **WordPress** con PHP-FPM
- **MariaDB** como base de datos
- Persistencia mediante volúmenes
- Configuración mediante variables de entorno

---

## 🌐 Dominio local (`zajodar.42.fr`)

El proyecto utiliza el dominio:
`zajodar.42.fr`


Para que el navegador lo resuelva correctamente en local, es necesario añadir una entrada en el archivo `/etc/hosts`.

### 👉 Ayuda para configurar el dominio

```bash
make hosts
```
Este comando muestra las instrucciones necesarias para editar el enrutamiento local.


### Entrada requerida en /etc/hosts
```bash
127.0.0.1   zajodar.42.fr
```

### 🚀 Uso del proyecto
1️⃣ Lanzar el proyecto

```bash
make up
```
Este comando:
Prepara las carpetas de persistencia
Construye las imágenes Docker
Inicia todos los contenedores en segundo plano

### 2️⃣ Acceso a los servicios

🌐 WordPress:
https://zajodar.42.fr

🔧 Panel de administración:
https://zajodar.42.fr/wp-admin

Credenciales por defecto:
Administrador: ajodar / wpadminpass
Usuario: wpuser / wpuserpass


### 🛑 Detener el proyecto

```bash
make down
```

🧹 Limpieza completa
```bash
make fclean
```

Este comando elimina:

Contenedores
Imágenes Docker
Volúmenes
Datos persistentes locales


### 🧪 Comprobaciones útiles

Ver contenedores activos:
```bash
make test
```

Ver logs de servicios:
```bash
make nginx
make wordpress
```

### 🔐 HTTPS
NGINX sirve el sitio exclusivamente por HTTPS utilizando un certificado SSL autofirmado, generado dinámicamente en tiempo de ejecución.
Es normal que el navegador muestre un aviso indicando que el certificado no es de confianza.


### 📄 Notas técnicas
Cada servicio se ejecuta en su propio contenedor.
Todas las imágenes están basadas en Alpine Linux.
No se utilizan imágenes latest.
No se incluyen servicios adicionales no solicitados por el subject.
La configuración se realiza mediante un archivo .env.
