.PHONY: up down fclean test db wordpress nginx setup hosts resetusers

COMPOSE_FILE = srcs/docker-compose.yml
DATA_PATH = /home/$(USER)/data

hosts:
	@echo "Para acceder a WordPress por dominio:"
	@echo ""
	@echo "Edita /etc/hosts y añade:"
	@echo "127.0.0.1   zajodar.42.fr"
	@echo ""

setup:
	@echo "📁 Preparando carpetas de persistencia en $(DATA_PATH)..."
	@mkdir -p $(DATA_PATH)
	@mkdir -p $(DATA_PATH)/mariadb
	@mkdir -p $(DATA_PATH)/wordpress
	@mkdir -p $(DATA_PATH)/nginx
	@chmod -R 755 $(DATA_PATH)
	@echo "✅ Carpetas de datos listas."

up: setup
	@echo "⛔ Cerrando contenedores existentes..."
	@docker compose -f $(COMPOSE_FILE) down
	@docker compose -f srcs/docker-compose.yml down -v
	@docker volume prune -f
	@echo ""
	@echo "🚀 Construyendo e iniciando el proyecto..."
	@docker compose -f $(COMPOSE_FILE) up --build -d
	@echo ""
	@echo "✅ Proyecto desplegado correctamente."
	@echo ""
	@echo "🔗 Accesos rápidos:"
	@echo " - 🌐 WordPress:        https://zajodar.42.fr/"
	@echo " - 🔧 Admin Panel:      https://zajodar.42.fr/wp-admin"
	@echo "     👤 Admin:          ajodar / wpadminpass"
	@echo "     👤 Usuario:        wpuser / wpuserpass"
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

resetusers:
	@echo "♻️  Forzando recreación de usuarios de WordPress..."
	@sed -i 's/^FORCE_RECREATE_USERS=.*/FORCE_RECREATE_USERS=true/' srcs/.env
	@docker compose -f srcs/docker-compose.yml restart wordpress
	@sleep 2
	@sed -i 's/^FORCE_RECREATE_USERS=.*/FORCE_RECREATE_USERS=false/' srcs/.env
	@echo "✅ Usuarios recreados correctamente."


fclean: down
	@echo "🧹 Limpiando imágenes y volúmenes..."
	@docker system prune -af --volumes
	@echo "🧨 Borrando datos persistentes en $(DATA_PATH)..."
	@sudo rm -rf $(DATA_PATH)/mariadb $(DATA_PATH)/wordpress $(DATA_PATH)/nginx
	@echo "✅ Datos persistentes borrados."


test:
	@echo "🧪 Comprobando contenedores activos:"
	@docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

wordpress:
	@docker logs -f wordpress

nginx:
	@docker logs -f nginx

