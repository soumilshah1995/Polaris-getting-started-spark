
# Clone the project
```
git clone https://github.com/apache/polaris.git
cd ~/polaris
docker compose -f docker-compose.yml up --build -d
```

## Get Client and Secret keys
```
Exec into Container and Search for "realm: default-realm root principal credentials:"
Copy the items it should be in format <CLIENT_ID>:<YCLIENT_SECRETY>

```
## Set env variables
```
8d8dfb128249afc3:9ce93abf1f19bdc666e61766befe81da
export CLIENT_ID=8d8dfb128249afc3
export CLIENT_SECRET=9ce93abf1f19bdc666e61766befe81da
export PRINCIPAL_TOKEN="principal:root;realm:default-realm"
```

# SET THESE 
```agsl
export CLIENT_ID=8d8dfb128249afc3
export CLIENT_SECRET=9ce93abf1f19bdc666e61766befe81da
export PRINCIPAL_TOKEN="principal:root;realm:default-realm"
export POLARIS_URI="http://localhost:8181/api/catalog"
export POLARIS_CATALOG_NAME="polaris"
export JAVA_HOME=/opt/homebrew/opt/openjdk@11

```
# Pyspark Shell 
```agsl
pyspark \
--packages "org.apache.iceberg:iceberg-spark-runtime-3.4_2.12:1.3.0,software.amazon.awssdk:bundle:2.20.160,software.amazon.awssdk:url-connection-client:2.20.160,org.apache.hadoop:hadoop-aws:3.4.0" \
--conf spark.sql.catalog.spark_catalog=org.apache.iceberg.spark.SparkSessionCatalog \
--conf spark.sql.extensions=org.apache.iceberg.spark.extensions.IcebergSparkSessionExtensions \
--conf spark.sql.catalog.polaris=org.apache.iceberg.spark.SparkCatalog \
--conf spark.sql.catalog.polaris.type=rest \
--conf spark.sql.catalog.polaris.uri=${POLARIS_URI} \
--conf spark.sql.catalog.polaris.token-refresh-enabled=true \
--conf spark.sql.catalog.polaris.credential=${CLIENT_ID}:${CLIENT_SECRET} \
--conf spark.sql.catalog.polaris.warehouse=${POLARIS_CATALOG_NAME} \
--conf spark.sql.catalog.polaris.scope=PRINCIPAL_ROLE:ALL \
--conf spark.sql.catalog.polaris.header.X-Iceberg-Access-Delegation=true \
--conf spark.sql.catalog.polaris.io-impl=org.apache.iceberg.io.ResolvingFileIO 

```

# Sql command 
```agsl
spark.sql("SHOW catalogs").show()
spark.sql("CREATE NAMESPACE IF NOT EXISTS polaris.db").show()
spark.sql("CREATE TABLE polaris.db.names (name STRING) USING iceberg").show()
spark.sql("INSERT INTO polaris.db.names VALUES ('Alex Merced'), ('Andrew Madson')").show()
spark.sql("SELECT * FROM polaris.db.names").show()

```

# Spark SQL 
```agsl

spark-sql \
--packages "org.apache.iceberg:iceberg-spark-runtime-3.4_2.12:1.3.0,software.amazon.awssdk:bundle:2.20.160,software.amazon.awssdk:url-connection-client:2.20.160,org.apache.hadoop:hadoop-aws:3.4.0" \
--conf spark.sql.catalog.spark_catalog=org.apache.iceberg.spark.SparkSessionCatalog \
--conf spark.sql.extensions=org.apache.iceberg.spark.extensions.IcebergSparkSessionExtensions \
--conf spark.sql.catalog.polaris=org.apache.iceberg.spark.SparkCatalog \
--conf spark.sql.catalog.polaris.type=rest \
--conf spark.sql.catalog.polaris.uri=${POLARIS_URI} \
--conf spark.sql.catalog.polaris.token-refresh-enabled=true \
--conf spark.sql.catalog.polaris.credential=${CLIENT_ID}:${CLIENT_SECRET} \
--conf spark.sql.catalog.polaris.warehouse=${POLARIS_CATALOG_NAME} \
--conf spark.sql.catalog.polaris.scope=PRINCIPAL_ROLE:ALL \
--conf spark.sql.catalog.polaris.header.X-Iceberg-Access-Delegation=true \
--conf spark.sql.catalog.polaris.io-impl=org.apache.iceberg.io.ResolvingFileIO
```

```agsl

-- Show available catalogs
SHOW CATALOGS;

-- Create a namespace
CREATE NAMESPACE IF NOT EXISTS polaris.db;

-- Create a table
CREATE TABLE polaris.db.names (name STRING) USING iceberg;

-- Insert data into the table
INSERT INTO polaris.db.names VALUES ('Alex Merced'), ('Andrew Madson');

-- Query the table
SELECT * FROM polaris.db.names;
```
