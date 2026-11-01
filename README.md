# cosc436-ProjectGroup3-2026
## Description
A DW and ETL process for short-term forecasting models using machine learning (ML). The large project aims to develop practical algorithmic trading strategies based on accurate short-term forecasts for financial time series using machine learning models. To achieve this objective, the project focuses on three sets of activities:
Design a data warehouse that contains the targeted financial and other time-series data useful as input to the machine learning models. Data acquisition, processing, and staging routines required to feed the data warehouse will be evaluated and developed dynamically. A data visualization and business intelligence layer will also be built on the data warehouse.

Deliverables: (1) Design Models; (2) Design Documentation; (3) A DW prototype implementation; (4) A technical report in the form of a research paper

### Data Warehouse
This first iteration contains a small sample set of data from CSV files: three stock files and three bond files, and each file has 100 records. While such a small set has no practical use for anlaysis, it was a simple way to explore schema design and will also help to explore analytical queries to create and incorporate into the BI tool without having to worry about perforance.

Considerations:

The initial plan was to have each market instrument with its own dimension table (e.g. stock_dim, bond_dim), however this design led to having null foreign keys in the fact table. So the decision was made to embrace demoralization and have a single instrument dimension.

Next steps:
- incorporate crude oil and gold.
- load all available CSVs for each instrument
- test and optimize performance on large volume

### BI Tool
tbd

## Getting Started
### Using OC's VM with SQL Developer and Pentaho
1. Create new Oracle schema from command line: -- Optional but recommended:

        sqlplus / as sysdba
        CREATE USER 'workspace-name' IDENTIFIED BY 'password'
        DEFAULT TABLESPACE users
        QUOTA UNLIMITED ON users;
    
    Response: “User created.”

        GRANT CREATE SESSION, CREATE TABLE, CREATE SEQUENCE, CREATE VIEW TO workspace-name;

    Response: “Grant succeeded”

2. Connect SQL Developer and Pentaho to the workspace.
3. Run StarSchemaCREATE.sql
4. Run StarSchemaINSERT.sql
5. Run load_instrument_fact.ktr in Pentaho
