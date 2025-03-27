
FROM debian:12-slim

RUN apt update
RUN apt-get update
RUN apt-get install git -y
RUN apt-get install --yes build-essential pkg-config uuid-dev zlib1g-dev libjpeg-dev libsqlite3-dev libcurl4-openssl-dev libpcre3-dev libspeexdsp-dev libldns-dev libedit-dev libtiff5-dev yasm libopus-dev libsndfile1-dev unzip libavformat-dev libswscale-dev liblua5.2-dev liblua5.2-0 cmake libpq-dev unixodbc-dev autoconf automake ntpdate libxml2-dev libpq-dev libpq5 sngrep lua5.2 lua5.2-doc libreadline-dev

RUN apt-get install wget -y
# RUN git config --global --unset http.proxy
# RUN git config --global --unset https.proxy

# RUN python3 -m pip install ansible
WORKDIR /opt
RUN wget https://www.python.org/ftp/python/3.10.12/Python-3.10.12.tgz
RUN tar xzf Python-3.10.12.tgz
WORKDIR ./Python-3.10.12
RUN ./configure
RUN make altinstall
RUN ldconfig
RUN apt install python3-pip -y
RUN python3.10 -m pip install --upgrade pip
# RUN python3.10 -m pip install ansible
RUN apt install ansible -y

WORKDIR /usr/local/src
RUN git clone https://github.com/drachtio/ansible-role-fsmrf.git
WORKDIR ./ansible-role-fsmrf
COPY ./ansible-role-fsmrf/tasks/main.yml tasks/main.yml
RUN ansible-playbook -i "localhost," -c local tasks/main.yml

CMD ["tail", "-f", "/dev/null"]
