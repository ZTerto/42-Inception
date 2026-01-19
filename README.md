# Inception

Proyecto del cursus de **42** cuyo objetivo es desplegar una infraestructura completa utilizando **Docker** y **Docker Compose**, siguiendo un enfoque de servicios desacoplados y configurados manualmente.

La infraestructura está compuesta por:
- **NGINX** como servidor web (solo HTTPS)
- **WordPress** con PHP-FPM
- **MariaDB** como base de datos
- Persistencia mediante volúmenes
- Configuración mediante variables de entorno

---

## 🔧 Dependencias necesarias para funcionar

```bash
sudo apt remove docker docker-engine docker.io containerd runc
sudo apt update && sudo apt install -y \
    make \
    curl \
    ca-certificates \
    gnupg \
    lsb-release \
    git

sudo apt remove docker docker-engine docker.io containerd runc
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) \
  signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo apt update
sudo apt install -y \
  docker-ce \
  docker-ce-cli \
  containerd.io \
  docker-buildx-plugin \
  docker-compose-plugin

echo '{ "storage-driver": "vfs" }' | sudo tee /etc/docker/daemon.json > /dev/null
sudo systemctl restart docker
sudo usermod -aG docker $USER

git clone https://github.com/ZTerto/42-Inception.git
cd 42-Inception

newgrp docker
```
# 📝 NOTA:
# Este último paso (usermod) requiere cerrar sesión o reiniciar para aplicarse correctamente.
# Si quieres probar sin reiniciar, ejecuta un nuevo shell con:
#   newgrp docker

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