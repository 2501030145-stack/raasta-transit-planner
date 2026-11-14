FROM debian:bookworm-slim AS build

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    libcpp-httplib-dev \
    nlohmann-json3-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /src
COPY backend/full-engine/ ./raasta-backend/

RUN cmake -S raasta-backend -B build \
    -DCMAKE_BUILD_TYPE=Release \
    -DRAASTA_ENABLE_MYSQL=OFF \
    -DRAASTA_BUILD_TESTS=OFF \
    && cmake --build build --target raasta-server -j2

FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    libstdc++6 \
    libcpp-httplib0.11 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY --from=build /src/build/raasta-server ./raasta-server
COPY backend/full-engine/data ./data

ENV PORT=8080
ENV SERVER_PORT=8080
ENV DATA_DIR=/app/data

EXPOSE 8080

CMD ["./raasta-server"]
