#! /bin/bash

# restore backup of bashrc
cp ~/.bashrc.bak ~/.bashrc

# changes to bashrc

echo "export HIVE_HOME=/app/hive" >> ~/.bashrc
echo "export PATH=$PATH:$HIVE_HOME/bin" >> ~/.bashrc

source ~/.bashrc

# permissions to HDFS

/app/hadoop/bin/hadoop fs -mkdir -p /user/hive/warehouse
/app/hadoop/bin/hadoop fs -mkdir -p /tmp
/app/hadoop/bin/hadoop fs -chmod g+w /user/hive/warehouse
/app/hadoop/bin/hadoop fs -chmod g+w /tmp

echo "export HADOOP_HOME=/app/hadoop" > /app/hive/conf/hive-env.sh
echo "export HADOOP_HEAPSIZE=512" >> /app/hive/conf/hive-env.sh
echo "export HIVE_CONF_DIR=/app/hive/conf" >> /app/hive/conf/hive-env.sh

 
echo '<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
    <property>
        <name>javax.jdo.option.ConnectionURL</name>
        <value>jdbc:derby:;databaseName=/app/hive/metastore_db;create=true</value>
        <description>JDBC connect string for a JDBC metastore.</description>
    </property>
    <property>
        <name>hive.metastore.warehouse.dir</name>
        <value>/user/hive/warehouse</value>
        <description>location of default database for the warehouse</description>
    </property>
    <property>
        <name>hive.metastore.uris</name>
        <value>thrift://localhost:9083</value>
        <description>Thrift URI for the remote metastore.</description>
    </property>
    <property>
        <name>javax.jdo.option.ConnectionDriverName</name>
        <value>org.apache.derby.jdbc.EmbeddedDriver</value>
        <description>Driver class name for a JDBC metastore</description>
    </property>
    <property>
        <name>javax.jdo.PersistenceManagerFactoryClass</name>
        <value>org.datanucleus.api.jdo.JDOPersistenceManagerFactory</value>
        <description>class implementing the jdo persistence</description>
    </property>
    <property>
        <name>hive.server2.enable.doAs</name>
        <value>false</value>
    </property>
</configuration>' > /app/hive/conf/hive-site.xml

mv /app/hive/lib/log4j-slf4j-impl-2.6.2.jar /app/hive/lib/log4j-slf4j-impl-2.6.2.jar.bak

/app/hive/bin/schematool -initSchema -dbType derby