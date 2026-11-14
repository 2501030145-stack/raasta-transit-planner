FROM alpine:3.20 AS build

RUN apk add --no-cache build-base cmake pkgconf mariadb-connector-c-dev

WORKDIR /src

COPY backend ./backend
COPY data ./data

RUN cmake -S backend -B build -DCMAKE_BUILD_TYPE=Release && cmake --build build -j2

FROM alpine:3.20

RUN apk add --no-cache libstdc++ libgcc mariadb-connector-c

WORKDIR /app

COPY --from=build /src/build/raasta-api ./raasta-api
COPY data ./data

ENV PORT=8080
ENV RAASTA_DEMO_DATA=true
ENV RAASTA_DATA_FILE=/app/data/network.json

EXPOSE 8080

CMD ["./raasta-api"]
