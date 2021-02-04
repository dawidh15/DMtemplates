/****** Object:  Database DW_Metadata 3-Jan-2008 ******/
/*
Copyright 2008, Kimball Group
The Data Warehouse Lifecycle Toolkit, 2nd Edition
Generate database objects for a simple schema to hold business metadata. 
You would typically create a separate schema or database to hold the metadata,
rather than intermingle the tables with the DW tables themselves.

We are using very simple syntax. This script has been tested on SQL Server 2005, but some
syntax might not work in all environments. For example the SysName data type is
not universal. Edit to ensure the statements work in your relational environment. 
*/


/* 
Create table DW_Databases. This table gets one row for each DW database or schema, 
including relational and OLAP databases or schemas.
*/
CREATE TABLE DW_Databases (
   Database_Key  Int NOT NULL	-- Primary key (meaningless surrogate key)
,  Database_ID  Int   NOT NULL	-- Physical identifier for the database in your RDBMS or OLAP system
,  Database_Name  varchar(255)   NOT NULL
,  Database_Short_Descr  varchar(255)   NULL	-- Short description of the database or schema
,  Database_Long_Descr  varchar(2000)   NULL	-- Longer description of the database or schema
,  Database_Type  varchar(100)   NULL	-- The underlying database platform, such as Oracle RDBMS or Microsoft Analysis Services
,  Database_Status  varchar(25)   NULL	-- An Active Database is still in the physical source.  A Cancelled Database is no longer in the physical source.
,  Instance_Name  SysName   NULL	-- Name of the instance in which the database resides
,  Server_Name  SysName   NULL	-- Name of the server on which the database resides
)
GO
ALTER TABLE DW_Databases 
ADD CONSTRAINT PK_DW_Databases 
PRIMARY KEY (Database_Key)
GO


/* 
Create table DW_Subject_Areas, to hold a list of Subject areas. 
Subject areas are groups of objects, like business process data models 
*/
CREATE TABLE DW_Subject_Areas (
   Subject_Area_Key  Int  NOT NULL	-- Primary key (meaningless surrogate key)
,  Database_ID  Int   NOT NULL	-- Physical identifier for the database in your RDBMS or OLAP system
,  Primary_Fact_Table_ID  Int   NULL	-- If the subject area centers around a fact table or cube, put that object ID here
,  Subject_Area_Name  varchar(255)   NOT NULL	-- The name of the Subject Area, such as Sales or Orders
,  Subject_Area_Short_Descr  varchar(255)   NULL	-- One or two sentences that are easily displayed in the summary level browser reports
,  Subject_Area_Long_Descr  varchar(2000)   NULL	-- A longer description that may include user guidance on what the Subject Area contains and how to use it
,  Business_Process_Area  varchar(100)   NOT NULL	-- Name of the Business Process Area to which this Subject Area belongs
,  Subject_Area_Status  varchar(25)   NOT NULL	-- An Active Subject Area is still in the physical source.  A Cancelled Subject Area is no longer in the physical source.
,  Subject_Area_Image  image   NULL	-- The image is typically a screen capture of the subject area star schema data model
)
GO
ALTER TABLE DW_Subject_Areas 
ADD CONSTRAINT PK_DW_Subject_Areas 
PRIMARY KEY (Subject_Area_Key)
GO

/* 
Create table DW_Database_Contents to hold a many-to-many 
mapping between Databases and Subject Areas 
*/
CREATE TABLE DW_Database_Contents (
   Database_Key  Int   NOT NULL
,  Subject_Area_Key  Int   NOT NULL
)
GO
ALTER TABLE DW_Database_Contents 
ADD CONSTRAINT PK_DW_Database_Contents 
PRIMARY KEY (Database_Key, Subject_Area_Key )
GO

ALTER TABLE DW_Database_Contents 
ADD CONSTRAINT FK_DW_Database_Contents_DW_Databases 
FOREIGN KEY (Database_Key) REFERENCES DW_Databases 
GO
ALTER TABLE DW_Database_Contents 
ADD CONSTRAINT FK_DW_Database_Contents_DW_Subject_Areas 
FOREIGN KEY (Subject_Area_Key) REFERENCES DW_Subject_Areas 
GO

/* Create table DW_Objects. Objects are DW related objects (like tables or cubes) */
CREATE TABLE DW_Objects (
   Object_Key  int  NOT NULL	-- Primary key (meaningless surrogate key)
,  Object_Ident  int   NOT NULL		-- The object_id of the object at the table level in the RDBMS, or the dimension cube level in OLAP.
,  Database_ID  Int   NOT NULL	-- Physical identifier for the database in your RDBMS or OLAP system
,  Object_Display_Name  sysname   NULL	-- The object name that is exposed to the business users
,  Object_Physical_Name  sysname   NULL	-- The object name that is used internally in the database
,  Object_Type  varchar(100)   NULL	-- E.g. Table, View, Dimension, Cube
,  Object_Purpose  varchar(255)   NULL	-- What is the object (primarily) used for?
,  Object_Short_Descr  varchar(255)   NULL	-- A short, business-oriented description of the object
,  Object_Long_Descr  varchar(2000)   NULL	-- A longer, more detailed description of the object
,  Object_Usage_Tips  varchar(2000)   NULL	-- Usage tips to help the users figure out how to work with this object.
,  Object_Steward_Contact  varchar(255)   NULL	-- Business owner of the content data quality for this object
,  Last_refresh_date  datetime   NULL	-- Populate from the ETL process or the cube processing
,  Update_Frequency  varchar(50)   NULL	-- E.g. Nightly, Monthly, Hourly
,  Object_Status  varchar(25)   NOT NULL	-- An Active Object still in the physical source.  A Cancelled Object is no longer in the physical source
)
GO
ALTER TABLE DW_Objects 
ADD CONSTRAINT PK_DW_Objects 
PRIMARY KEY (Object_Key)
GO

/* Create table DW_Subject_Area_Contents to hold a many-to-many 
mapping between Subject Areas and contents */
CREATE TABLE DW_Subject_Area_Contents (
   Subject_Area_Key  Int   NOT NULL
,  Object_Key  Int   NOT NULL
,  Join_Column  sysname   NOT NULL	-- Name of the join column(s) in your RDBMS.
)
GO
ALTER TABLE DW_Subject_Area_Contents 
ADD CONSTRAINT PK_DW_Subject_Area_Contents 
PRIMARY KEY (Subject_Area_Key, Object_Key, Join_Column)
GO

ALTER TABLE DW_Subject_Area_Contents 
ADD CONSTRAINT FK_DW_Subject_Area_Contents_DW_Subject_Areas 
FOREIGN KEY (Subject_Area_Key) REFERENCES DW_Subject_Areas 
GO
ALTER TABLE DW_Subject_Area_Contents 
ADD CONSTRAINT FK_DW_Subject_Area_Contents_DW_Objects 
FOREIGN KEY (Object_Key) REFERENCES DW_Objects 
GO



/* Create table DW_Attributes. DW_Attributes contains the columns or 
attributes in the data warehouse.  Attributes belong to an Object. */
CREATE TABLE DW_Attributes (
   Attribute_Key  Int  NOT NULL	-- Primary key (meaningless surrogate key)
,  Attribute_ID  varchar(100)   NOT NULL	-- A combination of the Object_ID and the Attribute_Sequence (the Column_ID in the RDBMS)
,  Database_ID  Int   NOT NULL	-- The physical identifier for the database
,  Object_Ident  Int   NOT NULL	-- The physical identifier for the object in the RDBMS or OLAP database
,  Attribute_Sequence  Int   NOT NULL	-- The Column ID for the attribute in the RDBMS or OLAP database
,  Attribute_Display_Name  varchar(100)   NULL	-- The attribute name that is exposed to the business users
,  Attribute_Physical_Name  varchar(100)   NULL	-- The attribute name that is used internally in the database
,  Attribute_Group_Name  varchar(255)  DEFAULT 'Default' NOT NULL	-- It is nice to group attributes to aid navigation, though few user tools use this grouping
,  Datatype  varchar(20)   NULL	-- The data type of the attribute
,  Attribute_Length  Int   NULL	-- The maximum length of the attribute
,  Attribute_Short_Descr  varchar(255)   NULL	-- A short, business-oriented description of the attribute
,  Attribute_Long_Descr  varchar(2000)   NULL	-- A longer, more detailed description of the attribute, potentially including information about where it came from, how it is defined and how it should be used.
,  Attribute_Example_Values  varchar(512)   NULL	-- Relevant example values of the contents of this attribute
,  Attribute_Comment  varchar(2000)   NULL	-- Any other comments about the attribute, usually having to do with its source
,  Attribute_Default_Value  varchar(512)   NULL	-- Default value, if specified
,  Attribute_ETL_Rules  varchar(2000)   NULL	-- ETL rules from the original data model design spreadsheet
,  Source_System  varchar(255)   NULL	-- Source system for this attribute
,  Attribute_Usage_Tips  varchar(2000)   NULL	-- Usage tips to help the users figure out how to work with this attribute
,  Attribute_Steward_Contact  varchar(255)   NULL	-- Business owner of the content data quality for this attribute
,  Attribute_Status  varchar(25)   NOT NULL	-- An Active Attribute still in the physical source.  A Cancelled Attribute is no longer in the physical source
) 
GO
ALTER TABLE DW_Attributes 
ADD CONSTRAINT PK_DW_Attributes 
PRIMARY KEY (Attribute_Key)
GO


/* Create table DW_Object_Contents, to hold the many-to-many mapping between Objects and Attributes */
CREATE TABLE DW_Object_Contents (
   Object_Key  Int   NOT NULL
,  Attribute_Key  Int   NOT NULL
,  Content_Map_Name  Varchar(250)   DEFAULT 'Default' NOT NULL	-- This allows the creation of multiple mappings between Objects and Attributes.
)
GO
ALTER TABLE DW_Object_Contents 
ADD CONSTRAINT PK_DW_Object_Contents 
PRIMARY KEY (Object_Key, Attribute_Key, Content_Map_Name)
GO

ALTER TABLE DW_Object_Contents 
ADD CONSTRAINT FK_DW_Object_Contents_DW_Objects 
FOREIGN KEY (Object_Key) REFERENCES DW_Objects 
GO
ALTER TABLE DW_Object_Contents 
ADD CONSTRAINT FK_DW_Object_Contents_DW_Attributes 
FOREIGN KEY (Attribute_Key) REFERENCES DW_Attributes 
GO