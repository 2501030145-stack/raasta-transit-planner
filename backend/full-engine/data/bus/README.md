# Bus Datasets (Delhi NCR & Uttar Pradesh)

## Official Sources
1. **Delhi Open Transit Data (OTD)**:
   - Portal: https://otd.delhi.gov.in
   - Provides static GTFS feeds (agencies, routes, trips, stops, stop_times, calendar).
   - Real-time vehicle positions and arrival updates are published under Government of NCT of Delhi Open Data.
2. **Delhi Transport Corporation (DTC)**:
   - Portal: https://dtc.delhi.gov.in
3. **Delhi Integrated Multi-Modal Transit System (DIMTS)**:
   - Cluster bus data.
4. **Uttar Pradesh State Road Transport Corporation (UPSRTC)**:
   - Intercity and regional bus routes across UP: https://upsrtc.com

## Automated Ingestion
Use the automated GTFS importer script:
```bash
python3 scripts/import_bus_gtfs.py --gtfs /path/to/delhi_gtfs.zip
```
Or use the pre-formatted verified sample CSV files:
```bash
python3 scripts/import_bus_gtfs.py --stops data/bus/bus_stops_sample.csv --routes data/bus/bus_routes_sample.csv
```

