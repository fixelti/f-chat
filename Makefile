include .env
export

PSQL_URL = postgres://$(POSTGRES_USER):$(POSTGRES_PASSWORD)@$(HOST):5432/$(POSTGRES_DB)?sslmode=disable
PSQL_MIGRATIONs_PATH ?= migrations/psql

.PHONY: container-start
container-start:
	docker-compose up -d

.PHONY: container-down
container-down:
	docker-compose down

.PHONY: add-migration
add-migration:
	@read -p "Print database type: " DB_TYPE; \
	read -p "Print migration name: " MIGRATION_NAME; \
	if [ "$$DB_TYPE" == "psql" ]; then \
		migrate create -ext sql -dir migrations/psql -seq "$$MIGRATION_NAME"; \
	else \
		echo "Wrong database type"; \
	fi

.PHONY: migration-up
migration-up:
	migrate -database $(PSQL_URL) -path $(PSQL_MIGRATIONs_PATH) up

.PHONY: migration-down
migration-down:
	if [ "$$ENV" = "local" ]; then \
		migrate -database "$(PSQL_URL)" -path "$(PSQL_MIGRATIONs_PATH)" down; \
	else \
		echo "MIGRATIONS CAN ONLY BE ROLLBACK IN THE LOCAL ENVIRONMENT"; \
	fi

.PHONY: todo
	@done=$$(grep -c "\[x\]" TODO.md); \
	total=$$(grep -c "\[ \]" TODO.md); \
	echo "✅ Done: $$done"; \
	echo "❌ Left: $$total"; \
	echo "📊 Progress: $$((100*$$done/($$done+$$total)))%"; \
	echo
	@cat TODO.md