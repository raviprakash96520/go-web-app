FROM golang:1.22.5 as base

WORKDIR /app
# dependencies to /app
COPY go.mod .   
# build
RUN go mod download
# copy source code to image
COPY . .

RUN go build -o main .

#final stageb- Distroless images

FROM gcr.io/distroless/base

COPY --from=base /app/main .

COPY --from=base /app/static ./static

EXPOSE 8080

CMD [ "./main" ]