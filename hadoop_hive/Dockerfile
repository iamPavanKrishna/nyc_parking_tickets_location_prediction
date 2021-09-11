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
RUN apt install openssh-server openssh-client -y

# Downloading hadoop
RUN wget https://archive.apache.org/dist/hadoop/common/hadoop-2.8.5/hadoop-2.8.5.tar.gz
RUN tar -xvf hadoop-2.8.5.tar.gz
RUN mv hadoop-2.8.5 hadoop
RUN rm hadoop-2.8.5.tar.gz

# Backup original bashrc and hadoop-env.sh
RUN cp ~/.bashrc ~/.bashrc.bak
RUN cp /app/hadoop/etc/hadoop/hadoop-env.sh /app/hadoop/etc/hadoop/hadoop-env.sh_bak

# adding hadoop_config script
COPY hadoop_config.sh /app/hadoop_config.sh
RUN chmod u+x /app/hadoop_config.sh
RUN /app/hadoop_config.sh

# Adding SSH authentication
RUN ssh-keygen -q -t rsa -N '' -f ~/.ssh/id_rsa
RUN cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

# Allow SSH local connections
RUN echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config

# update bashrc
RUN source ~/.bashrc

# Format HDFS file System
RUN /app/hadoop/bin/hdfs namenode -format

# Downloading Hive
RUN wget http://archive.apache.org/dist/hive/hive-2.3.5/apache-hive-2.3.5-bin.tar.gz
RUN tar -xvf apache-hive-2.3.5-bin.tar.gz
RUN mv apache-hive-2.3.5-bin hive
RUN rm apache-hive-2.3.5-bin.tar.gz

# Backup original bashrc and hive-env.sh
RUN cp ~/.bashrc ~/.bashrc.bak

# adding hive_config script
COPY hive_config.sh /app/hive_config.sh
RUN chmod u+x /app/hive_config.sh
RUN /app/hive_config.sh

CMD source ~/.bashrc && /etc/init.d/ssh start && /app/hadoop/sbin/start-dfs.sh && /app/hive/bin/hive --service metastore
