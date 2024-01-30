FROM golang:1.21.5

WORKDIR /go/src/app
COPY . .

#RUN go get -d -v ./...
#RUN go install -v ./...
RUN cat /etc/os-release

RUN GOARCH=arm64 GOOS=linux go build -tags lambda.norpc -o golang

RUN apt-get update
RUN apt install zip -y

ADD bootstrap bootstrap

RUN chmod +x bootstrap
RUN chmod +x ./golang

RUN zip -j function.zip bootstrap golang
CMD ["golang"]