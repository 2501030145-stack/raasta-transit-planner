# Raasta: Transport Data Coverage & Quality Report

**Last Updated:** 2026-11-13  
**Geographical Scope:** Delhi, Delhi NCR, Uttar Pradesh  
**Data Integrity Policy:** Strict evidence-backed sourcing; zero synthetic, inferred, or proximity-based graph edges.

---

## 1. Verified Network Summary

| Transport Mode | Total Stations | Operational Status Breakdown | Confirmed Connection Rows | In-Memory Directed Edges | Missing Coordinates | Audit Status |
| :--- | :---: | :--- | :---: | :---: | :---: | :---: |
| **Metro** | **306** | 306 Passenger-Operational | 321 | 642 | 0 (0.0%) | **Verified Official** |
| **Namo Bharat (RRTS)** | **16** | 16 Fully Passenger-Operational | 15 | 30 | 0 (0.0%) | **Verified Official** |
| **Indian Railways** | **23** | 23 Passenger-Operational Junctions | 23 | 46 | 0 (0.0%) | **Verified Official** |
| **Bus** | **10** | 10 Operational ISBT / Hub Terminals | 9 | 18 | 0 (0.0%) | **Curated Seed** |
| **Pedestrian Interchanges** | — | Verified Walking FOB / Concourse Links | 21 | 42 | 0 (0.0%) | **Verified Physical** |
| **TOTAL** | **355** | **355 Operational** | **389** | **778** | **0 (0.0%)** | **Controlled Audit Passed** |

*Note: Deferred / unconfirmed motorized feeder connections (such as Ghaziabad Shaheed Sthal to Ghaziabad Railway Station) are tracked separately in `data/interchanges/proposed_feeder_connections.csv` and excluded from the rapid transit graph.*

---

## 2. Operational-Status Distinctions & Corridor Extensions

### A. Namo Bharat (Delhi–Ghaziabad–Meerut RRTS Corridor)
- **Full Operational Corridor (82.15 km, 16 Stations)**:
  - **Inauguration Date**: February 22, 2026 (Commercial passenger service commenced across the complete mainline).
  - **Mainline Stations**: Sarai Kale Khan (`RRTS_SKK`), New Ashok Nagar (`RRTS_NAN`), Anand Vihar (`RRTS_ANV`), Sahibabad (`RRTS_SHB`), Ghaziabad (`RRTS_GZB`), Guldhar (`RRTS_GLD`), Duhai (`RRTS_DUH`), Muradnagar (`RRTS_MDN`), Modinagar South (`RRTS_MNS`), Modinagar North (`RRTS_MNN`), Meerut South (`RRTS_MRS`), Shatabdi Nagar (`RRTS_SHT`), Meerut Central (`RRTS_MCT`), Begumpul (`RRTS_BGP`), Meerut North (`RRTS_MRN`), Modipuram (`RRTS_MDP`).
  - **Delhi Section Status**: Sarai Kale Khan, New Ashok Nagar, and Anand Vihar transitioned from commissioning/trial runs to full commercial revenue service effective 2026-02-22.

### B. Meerut Metro (Intra-City Rapid Rail Transit)
- **Dedicated Local Transit (9 Metro Stations + 4 Shared RRTS Hubs = 13 Stations Total)**:
  - **Infrastructure Sharing**: Meerut Metro shares tracks, electrification, and signalling with the Delhi–Meerut RRTS corridor over a 23.6 km stretch from Meerut South to Modipuram Depot.
  - **Shared Hub Stations**: Meerut South (`RRTS_MRS`), Shatabdi Nagar (`RRTS_SHT`), Begumpul (`RRTS_BGP`), and Modipuram (`RRTS_MDP`).
  - **9 Dedicated Metro Stations**: Partapur (`MM_PRT`), Rithani (`MM_RTH`), Brahmapuri (`MM_BRH`), Meerut Central Metro (`MM_MCT`), Bhaisali (`MM_BHS`), MES Colony (`MM_MES`), Daurli (`MM_DRL`), Meerut North Metro (`MM_MRN`), Modipuram Depot (`MM_MDP_DEP`).
  - **Operational Mode**: High-speed Namo Bharat trains provide regional rapid transit between major regional nodes, while Meerut Metro local trainsets provide high-frequency urban stopping services at all 13 stations.

### C. Multimodal Interchange Links
- **Sarai Kale Khan Mega-Hub**: Direct pedestrian and skywalk links connecting Namo Bharat (`RRTS_SKK`), Delhi Metro Pink Line (`DEL_SKK_M`), Hazrat Nizamuddin Railway Station (`NZM`), and Sarai Kale Khan ISBT (`DTC_SKK`).
- **New Ashok Nagar Multimodal FOB**: Direct 90-meter dedicated foot overbridge between DMRC Blue Line (`DEL_NAN`) and Namo Bharat (`RRTS_NAN`).
- **Anand Vihar Hub**: Multimodal underground concourse integrating DMRC Blue/Pink Lines (`DEL_ANVT`), Anand Vihar Railway Station (`ANVT`), Anand Vihar ISBT (`DTC_ANVT`), and Namo Bharat (`RRTS_ANV`).
- **Agra & Lucknow Integrations**: Preserved physical pedestrian concourse links between Agra Fort Metro (`AGR_AGF`) and Agra Fort Railway (`AF`), as well as Lucknow Charbagh Metro (`LKO_CHR`), Lucknow Charbagh Railway (`LKO`), and Lucknow Junction (`LJN`).

---

## 3. Fare Structure & Discount Rules Audit

### A. Namo Bharat (RRTS) Tariff & Concessions
1. **Statutory 35% Base Fare Concession**:
   - **Origin & Policy**: Under the Metro Railways (Operation and Maintenance) Act framework, the statutory ceiling rate permitted higher base tariffs. In a written notification by the Ministry of Housing and Urban Affairs (MoHUA) via the Press Information Bureau (PIB) and Lok Sabha proceedings, an introductory 35% reduction on the base tariff was instituted for commuters.
   - **Engine Implementation**: The published tariff matrix (ranging from ₹20 for $\le 8\text{ km}$ to ₹210 for the full 82.15 km corridor) already embeds this 35% statutory reduction. Fares are not arbitrarily reduced by an additional 35% at runtime.
2. **Loyalty Program / Digital Ticketing (10% Concession)**:
   - **Rules**: Commuters using the National Common Mobility Card (NCMC) or the official Namo Bharat Connect app receive 1 loyalty point per rupee spent, redeemable for discounts, and a direct 10% concession on standard fares.
   - **Engine Implementation**: Evaluated when `is_smart_card == true` in `RRTSFareCalculator`, calculating `discount_applied = std::round(fare * 0.10)`.

### B. Meerut Metro Tariff
- **Distance Slabs**:
  - $0 - 4\text{ km}$: ₹20
  - $4 - 8\text{ km}$: ₹30
  - $8 - 12\text{ km}$: ₹40
  - $12 - 16\text{ km}$: ₹50
  - $> 16\text{ km}$: ₹60
- **Smart Card Discount**: 10% discount applied for NCMC / Smart Card holders.

---

## 4. Data Source Provenance & Retrieval Dates

| Dataset | Operating Agency | Source Document / Portal | Verification Date | Scope & Evidence |
| :--- | :--- | :--- | :---: | :--- |
| **Namo Bharat (RRTS)** | NCRTC | `https://ncrtc.in` / `https://namobharat.ncrtc.in` | Feb 2026 | Full 82.15 km corridor alignment, 16 stations, and official gazette tariff matrix. |
| **Meerut Metro** | NCRTC / UPMRC | `https://ncrtc.in` / `https://meerutline.in` | Feb 2026 | 23.6 km Phase 1 alignment, 13 stations (9 dedicated, 4 shared), and local fare schedule. |
| **Delhi Metro** | DMRC | `https://delhimetrorail.com` | Nov 2024 / Feb 2026 | All 10 lines + Airport Express; verified against DMRC network map & fare gazette. |
| **Noida Metro** | NMRC | `https://www.nmrcnoida.com` | Nov 2024 | Aqua Line Sector 51 to Depot. |
| **Rapid Metro** | HMRTC / GMCBL | `https://www.rapidmetrogurgaon.com` | Nov 2024 | Cyber City loop and Sector 55-56 extension. |
| **UP Metro** | UPMRC | `https://www.lmrcl.com` | Nov 2024 | Lucknow Red Line, Kanpur Orange Line, Agra Yellow Line. |
| **Indian Railways** | Ministry of Railways | `https://enquiry.indianrail.gov.in` (NTES) | Nov 2024 | 23 Class A-1/A junction stations and 23 verified track segments. |
| **Bus (Sample)** | DTC / UPSRTC | `https://otd.delhi.gov.in` / `https://dtc.delhi.gov.in` | Nov 2024 | 10 major ISBT hubs and 9 trunk routes. |

---

## 5. Summary of Code & Dataset Enhancements

1. **Backups Created**: All pre-modification CSV files archived in `data/backups_20261113/`.
2. **Station Coverage**: Expanded Namo Bharat to 16 stations and added 9 dedicated Meerut Metro stations.
3. **Connections Extended**: Complete 15-hop continuous Namo Bharat rapid rail alignment from Sarai Kale Khan to Modipuram, plus 12-hop Meerut Metro Line 1 alignment.
4. **Interchanges Enriched**: Added New Ashok Nagar FOB, Sarai Kale Khan high-capacity skywalk, and Meerut interchange concourses.
5. **Fare Logic Updated**: Full corridor distance brackets (up to 82.15 km), statutory 35% discount transparency, NCMC/Loyalty 10% discount, and Meerut Metro fare calculation.
6. **Test Coverage**: 100% CTest pass rate across all 6 test suites including end-to-end routing from Sarai Kale Khan to Modipuram and Meerut Metro local transit.
