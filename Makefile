.PHONY: up down clean fclean

# Date del banner
DATE := $(shell date +%Y%m%d)

# Banner de inicio
BANNER = \
	@echo "══════════════════════════════════════════════════════════════════════════════════"; \
	echo "  8P d8P 88P'888'Y88                                                          d8"; \
	echo "  P d8P  P'  888  'Y   888 88e  888,8,  e88 88e  Y8b Y888P  ,e e,   e88'888  d88"; \
	echo "   d8P d     888       888 888b 888 \"  d888 888b  Y8b Y8P  d88 88b d888  '8 d88888"; \
	echo "  d8P d8     888       888 888P 888    Y888 888P   Y8b Y   888   , Y888   ,  888"; \
	echo " d8P d88     888       888 88\"  888     \"88 88\"     888     \"YeeP\"  \"88,e8'  888"; \
	echo "                       888                          888"; \
	echo "                       888                          888"; \
	echo "ZT Project v.$(DATE) ════════════════════════════════════════════════════════════"; \
	echo ""

COMPOSE_FILE=srcs/docker-compose.yml
DOMAIN_NAME := zajodar.42.fr
PORT_PMA := 5000

up:
	$(BANNER)
	@echo "⛔ Cerrando contenedores existentes..."
	@docker compose -f $(COMPOSE_FILE) down
	@echo ""
	@echo "🚀 Construyendo e iniciando el proyecto..."
	@docker compose -f $(COMPOSE_FILE) up --build -d
	@echo ""
	@echo "✅ Proyecto desplegado correctamente."
	@echo ""
	@echo "🔗 Accesos rápidos:"
	@echo " - 🌐 WordPress:        https://zajodar.42.fr/"
	@echo " - 🔧 Admin Panel:      https://zajodar.42.fr/wp-admin"
	@echo "     👤 Admin:          zt_admin / wpadminpass"
	@echo "     👤 Usuario:        wpuser / wpuserpass"
	@echo " - 📂 phpMyAdmin:       https://zajodar.42.fr:5000/"
	@echo " - 🚪 Nginx:            https://zajodar.42.fr/"
	@echo ""

down:
	@echo "🛑 Deteniendo y eliminando contenedores..."
	@docker compose -f $(COMPOSE_FILE) down

db:
	@echo "\033[1;34m🧠 MariaDB CLI Tutorial:\033[0m"
	@echo " - Mostrar bases de datos:             \033[1;36mSHOW DATABASES;\033[0m"
	@echo " - Usar una base de datos:             \033[1;36mUSE wordpress;\033[0m"
	@echo " - Mostrar tablas:                     \033[1;36mSHOW TABLES;\033[0m"
	@echo " - Ver columnas de una tabla:          \033[1;36mDESCRIBE wp_users;\033[0m"
	@echo " - Ver contenido de una tabla:         \033[1;36mSELECT * FROM wp_users;\033[0m"
	@echo " - Salir:                              \033[1;36mexit\033[0m"
	@echo ""
	@echo "\033[1;34m🔐 Credenciales de acceso:\033[0m"
	@echo " - Usuario:                            \033[1;36mroot\033[0m"
	@echo " - Contraseña:                         \033[1;36mrootpass\033[0m"
	@echo ""
	@echo "📦 Entrando en MariaDB como root..."
	docker exec -it mariadb mariadb -u root -p


fclean: down
	@echo "🧹 Limpiando imágenes y volúmenes..."
	@docker system prune -af --volumes

test:
	@echo "🧪 Comprobando contenedores activos:"
	@docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

logsdb:
	@docker logs -f mariadb

logswordpress:
	@docker logs -f wordpress

logsnginx:
	@docker logs -f nginx

