#! /bin/bash

# restore backup of bashrc
cp ~/.bashrc.bak ~/.bashrc

# changes to bashrc

echo "export HADOOP_HOME=/app/hadoop" >> ~/.bashrc
echo "export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop" >> ~/.bashrc
echo "export HADOOP_HDFS_HOME=$HADOOP_HOME" >> ~/.bashrc
echo "export HADOOP_INSTALL=$HADOOP_HOME" >> ~/.bashrc
echo "export HADOOP_MAPRED_HOME=$HADOOP_HOME" >> ~/.bashrc
echo "export HADOOP_COMMON_HOME=$HADOOP_HOME" >> ~/.bashrc
echo "export HADOOP_HDFS_HOME=$HADOOP_HOME" >> ~/.bashrc
echo "export YARN_HOME=$HADOOP_HOME" >> ~/.bashrc
echo "export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native" >> ~/.bashrc
echo "export PATH=$PATH:$HADOOP_HOME/sbin:$HADOOP_HOME/bin" >> ~/.bashrc
echo "export HADOOP_OPTS='-Djava.library.path=$HADOOP_HOME/lib/native'" >> ~/.bashrc
echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64" >> ~/.bashrc

source ~/.bashrc

# restore backup of hadoop-env.sh
cp /app/hadoop/etc/hadoop/hadoop-env.sh_bak /app/hadoop/etc/hadoop/hadoop-env.sh

# changes to hadoop-env.sh

echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64" >> /app/hadoop/etc/hadoop/hadoop-env.sh
echo "export HADOOP_CONF_DIR=${HADOOP_CONF_DIR:-'/app/hadoop/etc/hadoop'}" >> /app/hadoop/etc/hadoop/hadoop-env.sh

# changes to core-site.xml

echo '<?xml version="1.0" encoding="UTF-8"?>
 <?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
 <configuration>
 <property>
 <name>fs.default.name</name>
 <value>hdfs://localhost:9000</value>
 </property>
 </configuration>' > /app/hadoop/etc/hadoop/core-site.xml

# changes to hdfs-site.xml

echo '<?xml version="1.0" encoding="UTF-8"?>
 <?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
 <configuration>
 <property>
 <name>dfs.replication</name>
 <value>1</value>
 </property>
 <property>
 <name>dfs.permission</name>
 </property>
 </configuration>' > /app/hadoop/etc/hadoop/hdfs-site.xml