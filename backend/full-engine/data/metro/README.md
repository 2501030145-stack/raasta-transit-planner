# Metro Datasets (Delhi NCR & Uttar Pradesh)

## Scope
Verified operational metro stations, lines, and connections for:
- **Delhi Metro (DMRC)**: Red, Yellow, Blue Main & Branch, Green, Violet, Pink, Magenta, Grey, Airport Express
- **Noida Metro (NMRC)**: Aqua Line (Noida Sector 51 to Depot Greater Noida)
- **Gurugram Rapid Metro (GMCBL)**: Sikanderpur to Cyber City & Sector 55-56
- **Lucknow Metro (UPMRC)**: North-South Corridor (CCS Airport to Munshi Pulia)
- **Kanpur Metro (UPMRC)**: Priority Section (IIT Kanpur to Motijheel)
- **Agra Metro (UPMRC)**: Priority Corridor (Taj East Gate to Mankameshwar)

## Files
- `metro_lines.csv`: Official lines, line codes, operators, transport types, and hex colors.
- `metro_stations.csv`: Stations with official codes, coordinates (lat/long), cities, states, line associations, interchange markers, and source provenance.
- `metro_connections.csv`: Operational consecutive connections with verified distances in km, estimated travel times in minutes, and bidirectionality flags.

## Provenance
- DMRC Network Map & Station Info: https://delhimetrorail.com
- NMRC Official: https://www.nmrcnoida.com
- UPMRC Official (Lucknow, Kanpur, Agra): https://www.lmrcl.com
- Rapid Metro Gurgaon: https://www.rapidmetrogurgaon.com
- Last Verified Date: 2024-11-01
- Data Status: `verified` for operational network topology and coordinates.

