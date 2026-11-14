#!/usr/bin/env bash
# Raasta Backend API Verification Test Suite
# Tests distance, travel time, dwell time, transfer penalties, and multi-operator fares.

BASE_URL="http://127.0.0.1:8088"

echo "═════════════════════════════════════════════════════════════════"
echo "  Raasta API Verification Suite"
echo "  Target: $BASE_URL"
echo "═════════════════════════════════════════════════════════════════"
echo ""

# 1. Health & Readiness
echo "▶ [1/7] Health Check: GET /health"
curl -s "$BASE_URL/health" | python3 -m json.tool || echo "Server not reachable"
echo ""

# 2. Network Overview
echo "▶ [2/7] Network Overview: GET /api/v1/network/overview"
curl -s "$BASE_URL/api/v1/network/overview" | python3 -m json.tool
echo ""

# 3. Station Search (Testing Metro, Railway, RRTS, Bus)
echo "▶ [3/7] Station Search (Kashmere Gate): GET /api/v1/stations/search?q=Kashmere"
curl -s "$BASE_URL/api/v1/stations/search?q=Kashmere" | python3 -m json.tool
echo ""

# 4. Route Calculation (Fastest with Transfer Penalties)
echo "▶ [4/7] Route Optimization (Fastest): POST /api/v1/routes/plan"
curl -s -X POST "$BASE_URL/api/v1/routes/plan" \
  -H "Content-Type: application/json" \
  -d '{
    "source_station_id": 1,
    "destination_station_id": 10,
    "criteria": "fastest",
    "is_smart_card": true,
    "departure_time": "14:00",
    "day_type": "weekday"
  }' | python3 -m json.tool
echo ""

# 5. Route Comparison (Dijkstra Fastest, Shortest, Lowest Fare, BFS Min Stops)
echo "▶ [5/7] Route Comparison: POST /api/v1/routes/compare"
curl -s -X POST "$BASE_URL/api/v1/routes/compare" \
  -H "Content-Type: application/json" \
  -d '{
    "source_station_id": 1,
    "destination_station_id": 10,
    "is_smart_card": true,
    "departure_time": "14:00"
  }' | python3 -m json.tool
echo ""

# 6. Detailed Fare Calculation (DMRC Non-Peak Smart Card Discount)
echo "▶ [6/7] Fare Calculation (DMRC 20% Non-Peak Smart Card): POST /api/v1/fares/calculate"
curl -s -X POST "$BASE_URL/api/v1/fares/calculate" \
  -H "Content-Type: application/json" \
  -d '{
    "transport_type_id": 1,
    "distance_km": 18.0,
    "operator_id": 1,
    "is_smart_card": true,
    "departure_time": "14:30",
    "day_type": "weekday"
  }' | python3 -m json.tool
echo ""

# 7. Detailed Fare Calculation (Namo Bharat RRTS Premium Coach)
echo "▶ [7/7] Fare Calculation (Namo Bharat Premium): POST /api/v1/fares/calculate"
curl -s -X POST "$BASE_URL/api/v1/fares/calculate" \
  -H "Content-Type: application/json" \
  -d '{
    "transport_type_id": 4,
    "distance_km": 25.0,
    "fare_class": "premium"
  }' | python3 -m json.tool
echo ""

echo "═════════════════════════════════════════════════════════════════"
echo "  Verification Complete"
echo "═════════════════════════════════════════════════════════════════"
