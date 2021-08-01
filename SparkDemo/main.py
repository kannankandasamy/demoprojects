from pyspark.sql import *
from pyspark.sql.types import *
from lib.utils import get_app_spark_config
from lib.loads import *

def print_hi(name):
    print(f'Hi, {name}')  # Press ⌘F8 to toggle the breakpoint.


# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    conf = get_app_spark_config()
    spark = SparkSession.builder \
    .config(conf=conf) \
    .getOrCreate()

    print_hi('kannan')
    conf_out = spark.sparkContext.getConf()
    #print(conf_out.toDebugString())

    #/Users/kannan/Documents/MicroMasters/movielens/ml-20m
    #fileloc = "/Users/kannan/Documents/MicroMasters/movielens/ml-20m/movies.csv"
    fileloc = "/Users/kannan/Downloads/50000SalesRecords.csv"
    schema = StructType([ \
        StructField("Region", StringType(), True), \
        StructField("Country", StringType(), True), \
        StructField("ItemType", StringType(), True), \
        StructField("SalesChannel", StringType(), True), \
        StructField("OrderPriority", StringType(), True), \
        StructField("OrderDate", DateType(), True), \
        StructField("OrderID", StringType(), True), \
        StructField("ShipDate", DateType(), True), \
        StructField("UnitsSold", IntegerType(), True), \
        StructField("UnitPrice", FloatType(), True), \
        StructField("UnitCost", DoubleType(), True), \
        StructField("TotalRevenue", DoubleType(), True), \
        StructField("TotalCost", DoubleType(), True), \
        StructField("TotalProfit", DoubleType(), True) \
        ])

    salesdf = loadschemadf(spark,fileloc, schema)

    print(salesdf.count())
    salesdf.printSchema()
    #salesdf.show()

    fildf = (salesdf
             .where("SalesChannel = 'Online'")
             .select("Region", "OrderID", "UnitsSold", "UnitPrice")
             )

    salesdf.createOrReplaceTempView("salestbl")
    resdf = spark.sql("select Region, count(*) as cnt from salestbl group by Region")
    resdf.show()

    #print(grpdf.count())
    #fildf.show()
# See PyCharm help at https://www.jetbrains.com/help/pycharm/
