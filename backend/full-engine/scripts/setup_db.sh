#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Load .env if exists
if [ -f "$PROJECT_ROOT/.env" ]; then
    export $(grep -v '^#' "$PROJECT_ROOT/.env" | xargs)
fi

DB_HOST="${DB_HOST:-127.0.0.1}"
DB_PORT="${DB_PORT:-3306}"
DB_USER="${DB_USER:-root}"
DB_PASSWORD="${DB_PASSWORD:-}"
DB_NAME="${DB_NAME:-raasta_db}"

echo "═══════════════════════════════════════"
echo "  Raasta Database Setup"
echo "═══════════════════════════════════════"
echo "Host: $DB_HOST:$DB_PORT"
echo "Database: $DB_NAME"
echo ""

MYSQL_CMD="mysql -h $DB_HOST -P $DB_PORT -u $DB_USER"
if [ -n "$DB_PASSWORD" ]; then
    MYSQL_CMD="$MYSQL_CMD -p$DB_PASSWORD"
fi

echo "[1/8] Running core schema migration..."
$MYSQL_CMD < "$PROJECT_ROOT/migrations/001_core_schema.sql"

echo "[2/8] Running fare schema migration..."
$MYSQL_CMD < "$PROJECT_ROOT/migrations/002_fare_schema.sql"

echo "[3/8] Running admin auth migration..."
$MYSQL_CMD < "$PROJECT_ROOT/migrations/003_admin_auth.sql"

echo "[4/8] Seeding reference data..."
$MYSQL_CMD < "$PROJECT_ROOT/migrations/004_seed_reference_data.sql"

if [ -f "$PROJECT_ROOT/migrations/005_import_metro_seed.sql" ]; then
    echo "[5/8] Seeding verified Metro network..."
    $MYSQL_CMD < "$PROJECT_ROOT/migrations/005_import_metro_seed.sql"
fi

if [ -f "$PROJECT_ROOT/migrations/006_import_rrts_seed.sql" ]; then
    echo "[6/8] Seeding verified Namo Bharat (RRTS) corridor..."
    $MYSQL_CMD < "$PROJECT_ROOT/migrations/006_import_rrts_seed.sql"
fi

if [ -f "$PROJECT_ROOT/migrations/007_import_railway_seed.sql" ]; then
    echo "[7/8] Seeding verified Indian Railways network..."
    $MYSQL_CMD < "$PROJECT_ROOT/migrations/007_import_railway_seed.sql"
fi

if [ -f "$PROJECT_ROOT/migrations/008_import_bus_seed.sql" ]; then
    echo "[8/8] Seeding verified Bus network..."
    $MYSQL_CMD < "$PROJECT_ROOT/migrations/008_import_bus_seed.sql"
fi

echo ""
echo "✓ Complete database setup and dataset ingestion finished successfully!"
