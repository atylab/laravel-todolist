FROM --platform=linux/x86_64 mysql:8.0-debian

RUN apt-get update && \
    apt-get install -y locales && \
    rm -rf /var/lib/apt/lists/* && \
    echo "ja_JP.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen jp_JP.UTF-8
ENV LC_ALL jp_JP.UTF-8