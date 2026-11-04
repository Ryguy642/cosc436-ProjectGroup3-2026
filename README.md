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

### Installing Oracle APEX on the course VM (Claude Summary)

> Only one VM needs APEX: whichever will host the final demo.
> Requires sudo on the VM. Tested on Oracle Database 19c (19.3, non-CDB `ORCL`).
> Because the database is 19.3, use **APEX 24.2**. APEX 26.x requires 19c Release Update 19.18 or newer.

#### 1. Check prerequisites

```bash
sudo su - oracle
sqlplus / as sysdba
```

At the `SQL>` prompt:

```sql
show con_name;                                         -- expect ORCL
select version_full from product_component_version;    -- expect 19.3.0.0.0
select file_name, bytes/1024/1024 as mb, autoextensible
from dba_data_files where tablespace_name = 'SYSAUX';  -- expect AUTOEXTENSIBLE = YES
exit
```

Then `exit` again to return to the student user. Also confirm a few GB of free disk with `df -h`.

#### 2. Point the oracle user at Java 17

ORDS needs Java 17+. The system default is Java 11, which Pentaho needs, so leave that alone and set Java 17 for the oracle user only:

```bash
sudo su - oracle
echo 'export JAVA_HOME=/usr/lib/jvm/jre-17-openjdk' >> ~/.bash_profile
echo 'export PATH=$JAVA_HOME/bin:$PATH' >> ~/.bash_profile
exit
```

Verify in a fresh session:

```bash
sudo su - oracle
java -version     # should say 17
exit
java -version     # as student: should still say 11
```

#### 3. Download APEX and ORDS

As student:

```bash
sudo mkdir -p /opt/oracle
sudo chown oracle:oinstall /opt/oracle
```

As oracle:

```bash
sudo su - oracle
cd /opt/oracle
curl -LO https://download.oracle.com/otn_software/apex/apex_24.2.zip
curl -LO https://download.oracle.com/otn_software/java/ords/ords-latest.zip
ls -lh            # APEX ~290 MB, ORDS ~190 MB
unzip -q apex_24.2.zip
unzip -q ords-latest.zip -d ords
```

#### 4. Install APEX into the database

Run from inside the `apex` folder, since the installer uses relative paths:

```bash
cd /opt/oracle/apex
sqlplus / as sysdba
```

```sql
@apexins.sql SYSAUX SYSAUX TEMP /i/
```

This takes roughly 10–30 minutes. When it finishes, check the end of the output for `ORA-` or `PLS-` errors.

#### 5. Set the APEX admin password and unlock the public user

```bash
sqlplus / as sysdba
```

```sql
@apxchpwd.sql
-- accept ADMIN as the username; password needs uppercase, a number and punctuation

alter user apex_public_user account unlock identified by "<choose a password>";
exit
```

#### 6. Create an ORDS installer account

ORDS needs an admin login with a password; `/ as sysdba` doesn't work for it. Rather than changing the SYS password, create a dedicated account. Still in SQL*Plus:

```sql
create user ords_installer identified by "<choose a password>";
@/opt/oracle/ords/scripts/installer/ords_installer_privileges.sql ords_installer
exit
```

Store all passwords from steps 5 and 6 privately. Do not commit them to the repo.

#### 7. Install ORDS

As oracle (run this command on its own, since it's interactive):

```bash
mkdir -p /opt/oracle/ords-config
ords --config /opt/oracle/ords-config install
```

Answers:

- **TNS net service name:** choose `1` (ORCL)
- **Administrator user:** `ords_installer`, then its password
- **Summary screen:** choose `9` (APEX static resources location) and enter `/opt/oracle/apex/images`, then `A` to accept

It installs into the database and then starts ORDS automatically. Once you see "Oracle REST Data Services initialized", press **Ctrl+C** to stop it for the next step.

#### 8. Point ORDS at APEX's request validation

By default ORDS uses its own allow list, which blocks APEX's pages (error ORDS-22001, "procedure named apex_admin could not be accessed"). Switch to APEX's validation function:

```bash
ords --config /opt/oracle/ords-config config set security.requestValidationFunction wwv_flow_epg_include_modules.authorize
```

#### 9. Start ORDS and log in

```bash
ords --config /opt/oracle/ords-config serve
```

Leave this terminal open; closing it or pressing Ctrl+C stops ORDS. Once you see "Oracle REST Data Services initialized", open the VM's browser to:

```
http://localhost:8080/ords/apex_admin
```

Sign in as `ADMIN` with the password from step 5.

#### Starting ORDS again later

ORDS doesn't start automatically after a reboot or after closing its terminal. To start it again:

```bash
sudo su - oracle
ords --config /opt/oracle/ords-config serve
```

#### Troubleshooting

To see detailed errors in the browser, turn on debug output, restart ORDS, and reload the page:

```bash
ords --config /opt/oracle/ords-config config set debug.printDebugToScreen true
```

Set it back to `false` (and restart) when done.

#### 10. Create a workspace linked to the warehouse

In Administration Services (`http://localhost:8080/ords/apex_admin`, signed in as `ADMIN`), click **Create Workspace**:

- **Identify Workspace:** a name such as `DW_GROUP3`
- **Identify Schema:** set **Re-use existing schema?** to **Yes** and choose `DWPROJ`
- **Identify Administrator:** your own APEX username, password and email (this is separate from `ADMIN`)
- **Confirm:** click **Create Workspace**

#### 11. Sign in to the workspace and verify the connection

Sign out of Administration Services, then go to:

```
http://localhost:8080/ords/apex
```

Enter the workspace name, your username and your password. You may be asked to change the password on first login.

To confirm the workspace can see the warehouse, open **SQL Workshop → SQL Commands** and run:

```sql
desc price_fact;
```

If it returns the table's columns, the workspace is connected to `DWPROJ`.
