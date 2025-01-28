FROM docker.io/zmkfirmware/zmk-build-arm:stable

WORKDIR /workspace

COPY config/west.yml config/west.yml

RUN west init -l config
RUN west update --narrow --fetch-opt=--depth=1
RUN west zephyr-export

COPY bin/build.sh ./
RUN chmod +x ./build.sh

CMD ["./build.sh"]
