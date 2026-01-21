# DEVELOPER DOCUMENTATION – Inception

Este documento describe los aspectos técnicos, la arquitectura y el proceso de configuración del proyecto **Inception** desde el punto de vista del desarrollador.

---

## 🎯 Objetivo del proyecto
El objetivo del proyecto **Inception** es desplegar una infraestructura web completa utilizando **Docker** y **Docker Compose**, siguiendo un enfoque de servicios desacoplados, configurados manualmente y sin utilizar imágenes preconstruidas.

---

## 🧱 Arquitectura general
La infraestructura está compuesta por los siguientes servicios:

- **NGINX** como servidor web, sirviendo exclusivamente por HTTPS
- **WordPress** ejecutándose con PHP-FPM
- **MariaDB** como sistema gestor de bases de datos
- Persistencia de datos mediante volúmenes Docker
- Configuración centralizada mediante variables de entorno

Cada servicio se ejecuta en su propio contenedor Docker y se comunica a través de una red Docker privada definida en `docker-compose.yml`.

---

## 🔧 Dependencias necesarias
El proyecto requiere una instalación limpia y actualizada de Docker y Docker Compose en un sistema basado en **Ubuntu**.

Los comandos descritos en el `README.md` permiten:
- Eliminar versiones antiguas de Docker
- Instalar las dependencias necesarias
- Configurar Docker para su uso sin privilegios de superusuario

---

## 🗂️ Estructura del proyecto
- `srcs/` contiene todos los archivos de configuración del proyecto
- Un Dockerfile por cada servicio
- `docker-compose.yml` gestiona la orquestación
- `.env` centraliza las variables de entorno
- `Makefile` simplifica la gestión del ciclo de vida del proyecto

Esta estructura permite una separación clara de responsabilidades y facilita el mantenimiento.

---

## 🐳 Docker y contenedores
- No se utilizan imágenes preconstruidas desde Docker Hub
- Todas las imágenes se construyen manualmente
- Las imágenes están basadas en Alpine Linux
- No se utiliza la etiqueta `latest`
- Cada contenedor ejecuta un único proceso principal (PID 1)
- No se emplean comandos artificiales para mantener contenedores vivos

---

## 🌐 Red Docker
La comunicación entre servicios se realiza a través de una red Docker definida explícitamente en `docker-compose.yml`.

Esta red permite:
- Aislar los servicios del host
- Facilitar la comunicación interna por nombre de servicio
- Controlar qué servicios están expuestos externamente

---

## 💾 Persistencia de datos
Los datos de WordPress y MariaDB se almacenan mediante volúmenes Docker montados en el sistema de archivos del host en:
/home/<login>/data/

Esto garantiza la persistencia de los datos incluso tras:
- Reiniciar contenedores
- Reconstruir imágenes
- Reiniciar la máquina virtual

---

## 🔄 Ciclo de vida del proyecto
El proyecto se gestiona mediante un `Makefile` que expone los siguientes comandos:

- `make up` → Construye e inicia la infraestructura
- `make down` → Detiene los contenedores
- `make fclean` → Elimina contenedores, imágenes y volúmenes
- `make test` → Muestra el estado de los contenedores
- `make nginx` / `make wordpress` → Muestra logs de servicios

---

## 🔐 Seguridad
- Acceso web únicamente por HTTPS (puerto 443)
- TLS 1.2 o superior
- Certificado SSL autofirmado
- No exposición innecesaria de puertos
- Comunicación interna restringida a la red Docker

---

## 🧪 Persistencia y reinicios
Tras reiniciar la máquina virtual o reconstruir los contenedores, la infraestructura conserva:
- La base de datos de WordPress
- Usuarios creados
- Contenido del sitio

Esto valida el correcto uso de volúmenes Docker.
