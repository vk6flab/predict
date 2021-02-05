FROM debian:stable-slim AS builder
LABEL maintainer="cq@vk6flab.com"

ARG DEBIAN_FRONTEND=noninteractive
ARG installPath=/usr/bin

RUN apt-get update
RUN apt-get -y upgrade

RUN apt-get -y install build-essential git wget

RUN git clone https://github.com/vk6flab/predict.git /usr/local/src/predict
RUN apt-get -y install libncurses-dev

WORKDIR /usr/local/src/predict
RUN printf 'char *predictpath={"%s"}, soundcard=%d, *version={"%s"};' "${installPath}" 0 "$(cat .version)" > predict.h
RUN cc -Wall -O3 -s -fomit-frame-pointer predict.c -lm -lncurses -pthread -o predict

FROM debian:stable-slim
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get -y upgrade

RUN apt-get -y install libncurses6
COPY --from=builder /usr/local/src/predict/predict /usr/local/bin/predict

ENTRYPOINT ["predict"]
