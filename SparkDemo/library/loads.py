
def loaddf(spark,filelocation):
    df = (spark
                .read
                .format("csv")
                .option("header",True)
                .option("inferSchema",True)
                .load(filelocation))
    return df

def loadschemadf(spark, filelocation, schema):
    df = (spark
                .read
                .format("csv")
                .schema(schema)
                .option("header",True)
                .load(filelocation))
    return df
