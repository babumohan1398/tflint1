FROM golang:alpine AS build-env
RUN mkdir /go/src/app && apk update && apk add --no-cache git=2.39.2
RUN rm -rf /var/cache/apk/*
COPY main.go /go/src/app/
WORKDIR /go/src/app
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -ldflags '-extldflags "-static"' -o app main.go

FROM scratch
WORKDIR /app
COPY --from=build-env /go/src/app/app .
ENTRYPOINT [ "./app" ]
EXPOSE 8080
