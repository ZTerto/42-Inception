.PHONY: up down fclean test db wordpress nginx setup hosts resetusers

COMPOSE_FILE = srcs/docker-compose.yml
DATA_PATH = /home/$(USER)/data

hosts:
	@echo "To access WordPress using a local domain:"
	@echo ""
	@echo "Edit /etc/hosts and add the following line:"
	@echo "127.0.0.1   ajodar.42.fr"
	@echo ""

setup:
	@echo "📁 Preparing persistence directories in $(DATA_PATH)..."
	@mkdir -p $(DATA_PATH)
	@mkdir -p $(DATA_PATH)/mariadb
	@mkdir -p $(DATA_PATH)/wordpress
	@mkdir -p $(DATA_PATH)/nginx
	@chmod -R 755 $(DATA_PATH)
	@echo "🔒 Ensuring entrypoint scripts are executable..."
	@chmod +x srcs/requirements/mariadb/tools/entrypoint.sh || true
	@chmod +x srcs/requirements/nginx/tools/entrypoint.sh || true
	@chmod +x srcs/requirements/wordpress/tools/entrypoint.sh || true
	@echo "✅ Setup completed successfully."

up:
	@echo "🚀 Building and starting the project..."
	@docker compose -f $(COMPOSE_FILE) up --build -d
	@echo ""
	@echo "✅ Proyecto desplegado correctamente."
	@echo ""
	@echo "🔗 Accesos rápidos:"
	@echo " - 🌐 WordPress:        https://ajodar.42.fr/"
	@echo " - 🔧 Admin Panel:      https://ajodar.42.fr/wp-admin"
	@echo "     👤 Admin:          ajodar / wpadminpass"
	@echo "     👤 Usuario:        wpuser / wpuserpass"
	@echo ""

down:
	@echo "🛑 Stopping containers..."
	@docker compose -f $(COMPOSE_FILE) down
	@docker compose -f srcs/docker-compose.yml down -v
	@echo ""

db:
	@echo "\033[1;34m🧠 MariaDB CLI Quick Guide:\033[0m"
	@echo " - Mostrar bases de datos:             \033[1;36mSHOW DATABASES;\033[0m"
	@echo " - Usar una base de datos:             \033[1;36mUSE wordpress;\033[0m"
	@echo " - Mostrar tablas:                     \033[1;36mSHOW TABLES;\033[0m"
	@echo " - Ver columnas de una tabla:          \033[1;36mDESCRIBE wp_users;\033[0m"
	@echo " - Ver contenido de una tabla:         \033[1;36mSELECT * FROM wp_users;\033[0m"
	@echo " - Salir:                              \033[1;36mexit\033[0m"
	@echo ""
	@echo "\033[1;34m🔐 Access credentials:\033[0m"
	@echo " - Usuario:                            \033[1;36mroot\033[0m"
	@echo " - Contraseña:                         \033[1;36mrootpass\033[0m"
	@echo ""
	@echo "📦 Connecting to MariaDB as root..."
	docker exec -it mariadb mariadb -u root -p

resetusers:
	@echo "♻️  Forcing WordPress user recreation..."
	@sed -i 's/^FORCE_RECREATE_USERS=.*/FORCE_RECREATE_USERS=true/' srcs/.env
	@docker compose -f srcs/docker-compose.yml restart wordpress
	@sleep 2
	@sed -i 's/^FORCE_RECREATE_USERS=.*/FORCE_RECREATE_USERS=false/' srcs/.env
	@echo "✅ WordPress users recreated successfully."


fclean: down
	@echo "🧹 Removing Docker images and volumes..."
	@docker system prune -af --volumes
	@echo "🧨 Removing persistent data from $(DATA_PATH)..."
	@sudo rm -rf $(DATA_PATH)/mariadb $(DATA_PATH)/wordpress $(DATA_PATH)/nginx
	@echo "✅ Persistent data removed successfully."


test:
	@echo "🧪 Checking running containers:"
	@docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

wordpress:
	@docker logs -f wordpress

nginx:
	@docker logs -f nginx

