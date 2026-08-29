FROM golang:1.20 as build
WORKDIR /helloworld
# Copy dependencies list
COPY go.mod go.sum ./
# Build with optional lambda.norpc tag
COPY main.go .
RUN go build -tags lambda.norpc -o main main.go

# Copy artifacts to a clean image
FROM public.ecr.aws/lambda/provided:al2.2026.08.29.12
COPY --from=build /helloworld/main ./main
ENTRYPOINT [ "./main" ]