FROM ubuntu:18.04
LABEL team="Hydra"

WORKDIR /app

ENV PYTHONUNBUFFERED 1
ENV DISPLAY=:99

SHELL ["/bin/bash", "-c"]

# Install apt dependencies
RUN apt update

# Install dependencies
RUN apt install wget -y
RUN apt install python3 -y
RUN apt install python3-pip -y
RUN apt install openjdk-8-jdk -y
RUN apt install supervisor -y

# Downloading kafka
RUN wget https://archive.apache.org/dist/kafka/2.2.0/kafka_2.12-2.2.0.tgz
RUN tar -xvf kafka_2.12-2.2.0.tgz
RUN mv kafka_2.12-2.2.0 kafka
RUN rm kafka_2.12-2.2.0.tgz

# Install python-kafka
RUN pip3 install kafka-python
RUN pip3 install pandas
RUN pip3 install gdown

# Copy dataset and model
RUN gdown https://drive.google.com/uc?id=1XPcrTJNuDmRU1SC24kTWff8BY3IJImBK
COPY XGBoost_model.pkl /app/XGBoost_model.pkl

# Installing XGBoost
RUN apt install cmake -y
RUN pip3 install --upgrade pip
RUN pip3 install --upgrade setuptools
RUN pip3 install ez_setup
RUN pip3 install wheel
RUN pip3 install sklearn
RUN pip3 install xgboost

# Copy parking stream
COPY parking_stream.py /app/parking_stream.py

# adding kafka_create script
COPY kafka_create.sh /app/kafka_create.sh
RUN chmod u+x /app/kafka_create.sh

# adding twitter_stream script
COPY parking_stream.sh /app/parking_stream.sh
RUN chmod u+x /app/parking_stream.sh

CMD /app/kafka_create.sh && /app/parking_stream.sh

# Configuration of supervisor
# RUN mkdir -p /var/log/supervisor
# RUN mkdir -p /etc/supervisor/conf.d
# COPY supervisor.conf /etc/supervisor.conf

# CMD ["supervisord", "-c", "/etc/supervisor.conf"]