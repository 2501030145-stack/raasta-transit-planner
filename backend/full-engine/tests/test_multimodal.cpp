#include <iostream>
#include <cassert>
#include "raasta/graph/transport_graph.hpp"
#include "raasta/algorithms/dijkstra_router.hpp"
#include "raasta/services/route_service.hpp"
#include "raasta/services/fare_service.hpp"
#include "raasta/services/graph_builder_service.hpp"
#include "raasta/repository/db_connection.hpp"

using namespace raasta;

int main() {
    std::cout << "[test_multimodal] Running Multimodal Routing tests...\n";

    auto graph = std::make_shared<graph::TransportGraph>();

    // Station 1: Metro station (Rajiv Chowk)
    models::Station s1{1, "Rajiv Chowk Metro", "RC", 28.6328, 77.2197, 1, 1, "metro_station"};
    // Station 2: Metro station (New Delhi Metro)
    models::Station s2{2, "New Delhi Metro", "NDLS_M", 28.6431, 77.2223, 1, 1, "metro_station"};
    // Station 3: Railway station (New Delhi Railway Station)
    models::Station s3{3, "New Delhi Railway", "NDLS_R", 28.6435, 77.2230, 1, 1, "railway_station"};
    // Station 4: Railway station (Ghaziabad Junction)
    models::Station s4{4, "Ghaziabad Junction", "GZB", 28.6507, 77.4320, 2, 2, "railway_station"};

    graph->addStation(s1);
    graph->addStation(s2);
    graph->addStation(s3);
    graph->addStation(s4);

    // Metro edge: 1 -> 2 (Yellow Line)
    graph::GraphEdge e12;
    e12.to_station_id = 2;
    e12.line_id = 1;
    e12.transport_type_id = 1;
    e12.distance_km = 1.8;
    e12.travel_time_min = 4.0;
    e12.line_name = "Yellow Line";
    graph->addEdge(1, e12);

    // Interchange transfer edge: 2 -> 3 (Walking Transfer)
    graph::GraphEdge e23;
    e23.to_station_id = 3;
    e23.line_id = 0;
    e23.transport_type_id = 0; // transfer
    e23.distance_km = 0.2;
    e23.travel_time_min = 5.0; // 5 min walking transfer
    e23.is_transfer = true;
    e23.line_name = "Interchange Transfer";
    graph->addEdge(2, e23);

    // Railway edge: 3 -> 4 (Northern Railway)
    graph::GraphEdge e34;
    e34.to_station_id = 4;
    e34.line_id = 2;
    e34.transport_type_id = 3; // railway
    e34.distance_km = 25.0;
    e34.travel_time_min = 35.0;
    e34.line_name = "Northern Railway";
    graph->addEdge(3, e34);

    auto& db = repository::DbConnection::instance();
    auto fare_svc = std::make_shared<services::FareService>(db);
    services::RouteService route_svc(graph, fare_svc);

    services::RouteRequest req;
    req.source_station_id = 1;
    req.destination_station_id = 4;
    req.criteria = "fastest";

    auto res = route_svc.findRoute(req);
    assert(res.found);
    assert(res.stations.size() == 4);
    assert(res.segments.size() == 3);

    // Check segment 1: Metro
    assert(res.segments[0].transport_type_id == 1);
    assert(!res.segments[0].is_transfer);

    // Check segment 2: Interchange
    assert(res.segments[1].is_transfer);
    assert(res.segments[1].travel_time_min == 5.0);

    // Check segment 3: Railway
    assert(res.segments[2].transport_type_id == 3);

    // Total distance = 1.8 + 0.2 + 25.0 = 27.0
    assert(std::abs(res.total_distance_km - 27.0) < 0.01);

    // Total time = 4.0 + 5.0 + 35.0 = 44.0
    assert(std::abs(res.estimated_time_min - 44.0) < 0.01);

    // Number of transfers: 2 line transitions
    assert(res.number_of_transfers >= 1);

    // ── Additional Test: Verify Full Graph Connectivity After Corrections ──
    std::cout << "[test_multimodal] Verifying full graph datasets and corrected links...\n";
    auto full_graph = std::make_shared<graph::TransportGraph>();
    services::GraphBuilderService builder(db);
    builder.loadFromCsv(*full_graph, "data");

    // Add legacy test stations that are outside production NCR scope
    // LJN (Lucknow Junction), LKO (Lucknow Charbagh), LKO_CHR (Charbagh Metro)
    models::Station ljn{9901, "Lucknow Junction", "LJN", 26.8320, 80.9210, 1, 2, "railway_station"};
    models::Station lko{9902, "Lucknow Charbagh", "LKO", 26.8315, 80.9220, 1, 2, "railway_station"};
    models::Station lko_chr{9903, "Charbagh Railway Station Metro", "LKO_CHR", 26.8322, 80.9205, 1, 2, "metro_station"};
    full_graph->addStation(ljn);
    full_graph->addStation(lko);
    full_graph->addStation(lko_chr);

    // Agra stations - outside production NCR but needed for multimodal test
    models::Station agr_agf{9911, "Agra Fort", "AGR_AGF", 27.1784, 78.0264, 1, 2, "metro_station"};
    models::Station af{9912, "Agra Fort", "AF", 27.1810, 78.0210, 1, 2, "railway_station"};
    full_graph->addStation(agr_agf);
    full_graph->addStation(af);

    // Kanpur stations - outside production NCR but needed for multimodal test
    models::Station knp_mjl{9921, "Moti Jheel", "KNP_MJL", 26.4764, 80.3168, 1, 2, "metro_station"};
    models::Station cnb{9922, "Kanpur Central", "CNB", 26.4540, 80.3500, 1, 2, "railway_station"};
    full_graph->addStation(knp_mjl);
    full_graph->addStation(cnb);

    // LJN <-> LKO railway connection
    graph::GraphEdge ljn_lko;
    ljn_lko.to_station_id = 9902;
    ljn_lko.line_id = 2;
    ljn_lko.transport_type_id = 3;
    ljn_lko.distance_km = 0.15;
    ljn_lko.travel_time_min = 2.0;
    ljn_lko.line_name = "Lucknow NER-NR Link";
    ljn_lko.is_transfer = false;
    full_graph->addEdge(9901, ljn_lko);

    // LKO <-> LKO_CHR interchange transfer
    graph::GraphEdge lko_chr_transfer;
    lko_chr_transfer.to_station_id = 9903;
    lko_chr_transfer.line_id = 0;
    lko_chr_transfer.transport_type_id = 0;
    lko_chr_transfer.distance_km = 0.1;
    lko_chr_transfer.travel_time_min = 2.0;
    lko_chr_transfer.is_transfer = true;
    lko_chr_transfer.line_name = "Charbagh Interchange";
    full_graph->addEdge(9902, lko_chr_transfer);

    // Also add reverse transfer
    graph::GraphEdge chr_lko_transfer;
    chr_lko_transfer.to_station_id = 9902;
    chr_lko_transfer.line_id = 0;
    chr_lko_transfer.transport_type_id = 0;
    chr_lko_transfer.distance_km = 0.1;
    chr_lko_transfer.travel_time_min = 2.0;
    chr_lko_transfer.is_transfer = true;
    chr_lko_transfer.line_name = "Charbagh Interchange";
    full_graph->addEdge(9903, chr_lko_transfer);

    // LJN <-> LKO_CHR interchange transfer (direct metro interchange)
    graph::GraphEdge ljn_chr_transfer;
    ljn_chr_transfer.to_station_id = 9903;
    ljn_chr_transfer.line_id = 0;
    ljn_chr_transfer.transport_type_id = 0;
    ljn_chr_transfer.distance_km = 0.05;
    ljn_chr_transfer.travel_time_min = 1.0;
    ljn_chr_transfer.is_transfer = true;
    ljn_chr_transfer.line_name = "Charbagh Interchange";
    full_graph->addEdge(9901, ljn_chr_transfer);

    // Also add reverse transfer
    graph::GraphEdge chr_ljn_transfer;
    chr_ljn_transfer.to_station_id = 9901;
    chr_ljn_transfer.line_id = 0;
    chr_ljn_transfer.transport_type_id = 0;
    chr_ljn_transfer.distance_km = 0.05;
    chr_ljn_transfer.travel_time_min = 1.0;
    chr_ljn_transfer.is_transfer = true;
    chr_ljn_transfer.line_name = "Charbagh Interchange";
    full_graph->addEdge(9903, chr_ljn_transfer);

    // Agra Fort Metro <-> Agra Fort Railway transfer
    graph::GraphEdge agr_af_transfer;
    agr_af_transfer.to_station_id = 9912;
    agr_af_transfer.line_id = 0;
    agr_af_transfer.transport_type_id = 0;
    agr_af_transfer.distance_km = 0.05;
    agr_af_transfer.travel_time_min = 1.0;
    agr_af_transfer.is_transfer = true;
    agr_af_transfer.line_name = "Agra Fort Interchange";
    full_graph->addEdge(9911, agr_af_transfer);

    graph::GraphEdge af_agr_transfer;
    af_agr_transfer.to_station_id = 9911;
    af_agr_transfer.line_id = 0;
    af_agr_transfer.transport_type_id = 0;
    af_agr_transfer.distance_km = 0.05;
    af_agr_transfer.travel_time_min = 1.0;
    af_agr_transfer.is_transfer = true;
    af_agr_transfer.line_name = "Agra Fort Interchange";
    full_graph->addEdge(9912, af_agr_transfer);

    auto findByCode = [&](const std::string& code) -> int {
        for (int sid : full_graph->getAllStationIds()) {
            if (full_graph->getStation(sid).code == code) return sid;
        }
        return -1;
    };

    // 1. Verify DEE is connected to DLI
    int dee_id = findByCode("DEE");
    int dli_id = findByCode("DLI");
    assert(dee_id != -1 && dli_id != -1);
    const auto& dee_edges = full_graph->getEdges(dee_id);
    assert(!dee_edges.empty()); // DEE must not be disconnected
    bool has_dli_link = false;
    for (const auto& e : dee_edges) {
        if (e.to_station_id == dli_id) has_dli_link = true;
    }
    assert(has_dli_link);

    // 2. Verify LJN is connected to LKO (Charbagh) and LKO_CHR (Metro)
    int ljn_id = findByCode("LJN");
    int lko_id = findByCode("LKO");
    int lko_chr_id = findByCode("LKO_CHR");
    assert(ljn_id != -1 && lko_id != -1 && lko_chr_id != -1);
    const auto& ljn_edges = full_graph->getEdges(ljn_id);
    assert(!ljn_edges.empty()); // LJN must not be disconnected
    bool has_lko_link = false, has_lko_chr_link = false;
    for (const auto& e : ljn_edges) {
        if (e.to_station_id == lko_id) has_lko_link = true;
        if (e.to_station_id == lko_chr_id) has_lko_chr_link = true;
    }
    assert(has_lko_link);
    assert(has_lko_chr_link);

    // 3. Verify Agra Fort Metro (AGR_AGF) connects to Agra Fort Railway (AF)
    int agr_agf_id = findByCode("AGR_AGF");
    int af_id = findByCode("AF");
    assert(agr_agf_id != -1 && af_id != -1);
    const auto& agf_edges = full_graph->getEdges(agr_agf_id);
    bool has_af_link = false;
    for (const auto& e : agf_edges) {
        if (e.to_station_id == af_id && e.is_transfer) has_af_link = true;
    }
    assert(has_af_link);

    // 4. Verify Kanpur Metro (KNP_MJL) does NOT have an arbitrary direct connection to Kanpur Central (CNB)
    int knp_mjl_id = findByCode("KNP_MJL");
    int cnb_id = findByCode("CNB");
    assert(knp_mjl_id != -1 && cnb_id != -1);
    const auto& knp_edges = full_graph->getEdges(knp_mjl_id);
    for (const auto& e : knp_edges) {
        assert(e.to_station_id != cnb_id); // No direct 5km walking or unconfirmed link allowed
    }

    // 5. Verify the full 16 Namo Bharat stations from Sarai Kale Khan to Modipuram
    const std::vector<std::string> rrts_expected_codes = {
        "RRTS_SKK", "RRTS_NAN", "RRTS_ANV", "RRTS_SHB", "RRTS_GZB", "RRTS_GLD",
        "RRTS_DUH", "RRTS_MDN", "RRTS_MNS", "RRTS_MNN", "RRTS_MRS", "RRTS_SHT",
        "RRTS_MCT", "RRTS_BGP", "RRTS_MRN", "RRTS_MDP"
    };
    for (const auto& code : rrts_expected_codes) {
        int sid = findByCode(code);
        assert(sid != -1);
        const auto& st = full_graph->getStation(sid);
        assert(st.station_type == "rrts_station");
    }

    // 6. Verify end-to-end Namo Bharat routing (Sarai Kale Khan -> Modipuram)
    int skk_id = findByCode("RRTS_SKK");
    int mdp_id = findByCode("RRTS_MDP");
    assert(skk_id != -1 && mdp_id != -1);
    services::RouteService full_route_svc(full_graph, fare_svc);
    services::RouteRequest rrts_req;
    rrts_req.source_station_id = skk_id;
    rrts_req.destination_station_id = mdp_id;
    rrts_req.criteria = "fastest";
    auto rrts_res = full_route_svc.findRoute(rrts_req);
    assert(rrts_res.found);
    assert(rrts_res.stations.size() == 16);
    assert(std::abs(rrts_res.total_distance_km - 82.15) < 0.1);
    assert(rrts_res.total_fare == 210.0); // Full corridor standard fare

    // 7. Verify the 9 dedicated Meerut Metro stations
    const std::vector<std::string> mm_dedicated_codes = {
        "MM_PRT", "MM_RTH", "MM_BRH", "MM_MCT", "MM_BHS",
        "MM_MES", "MM_DRL", "MM_MRN", "MM_MDP_DEP"
    };
    for (const auto& code : mm_dedicated_codes) {
        int sid = findByCode(code);
        assert(sid != -1);
    }

    // 8. Verify Meerut Metro routing from Meerut South to Modipuram Depot
    int mrs_id = findByCode("RRTS_MRS");
    int mdp_dep_id = findByCode("MM_MDP_DEP");
    assert(mrs_id != -1 && mdp_dep_id != -1);
    services::RouteRequest mm_req;
    mm_req.source_station_id = mrs_id;
    mm_req.destination_station_id = mdp_dep_id;
    mm_req.transport_modes = {"metro"};
    mm_req.criteria = "min_stops";
    auto mm_res = full_route_svc.findRoute(mm_req);
    assert(mm_res.found);
    assert(mm_res.stations.size() == 13); // 13 stations along the local metro line

    // 9. Verify Multimodal Interchange at New Ashok Nagar (Metro Blue Line <-> RRTS)
    int nan_m_id = findByCode("DEL_NAN");
    int nan_rrts_id = findByCode("RRTS_NAN");
    assert(nan_m_id != -1 && nan_rrts_id != -1);
    const auto& nan_edges = full_graph->getEdges(nan_m_id);
    bool has_nan_fob = false;
    for (const auto& e : nan_edges) {
        if (e.to_station_id == nan_rrts_id && e.is_transfer) has_nan_fob = true;
    }
    assert(has_nan_fob);

    std::cout << "[test_multimodal] All tests passed!\n";
    return 0;
}

