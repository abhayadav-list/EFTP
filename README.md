
**EFTP**

steps up unitl now(log for self) 

*Sprint 0&1*

step1: create database in postgre

step2: once the the database is made go to pentaho

step3: click on new database connection and configure it to connect to the just created database

step4: analysing the dataset thoroughly to find the schema and possible relationship 

step5: within postgre database create a new schema named staging 

step6: once the schema is done within the schema go to table open query tool and create tables simultaneously for each of the table connections from the datasets

step7: finally save this  query as staging_ddl.sql in the sql directory

Step8: one by one create new transformation for each data injestion (input data step -> add constand(for timestamp and batch id) -> tableout put)
connect each of the transformations to the corresponding table and map the feilds to their respective feilds within each table , and save the ktr file for each 
transformation in pentaho/transformation/ directory

Step9: Add error handling step to each of the injestion (input step) and then save the text file output for each within the bronze/error>


*Sprint 2 and futher*

