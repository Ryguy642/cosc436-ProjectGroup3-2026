-- drop existing sequences
drop sequence price_seq;
drop sequence date_seq;
drop sequence instrument_seq;

-- drop existing tables
drop table price_fact;
drop table date_dim;
drop table instrument_dim;

-- create sequences
create sequence price_seq start with 1 increment by 1 cache 1000; -- add cache for better performance
create sequence date_seq start with 1 increment by 1 cache 1000;
create sequence instrument_seq start with 1 increment by 1;

-- create tables
create table date_dim (
   date_key    integer,
   time_stamp  date not null,
   constraint date_dim_pk primary key ( date_key ),
   constraint date_dim_stamp_uk unique ( time_stamp )
);

create table instrument_dim (
   instrument_key    integer,
   instrument_symbol varchar2(10) not null,
   instrument_type varchar2(10) not null,
   maturity_years number(4, 2),
   constraint   instrument_dim_pk primary key ( instrument_key ),
   constraint   instrument_dim_symbol_uk unique ( instrument_symbol )
);

create table price_fact (
   price_key    integer,
   date_key     integer not null,
   instrument_key    integer not null,
   open_price   number,
   high_price   number,
   low_price    number,
   close_price  number,
   share_volume number,
   constraint price_fact_pk primary key ( price_key ),
   constraint price_fact_date_fk foreign key ( date_key )
      references date_dim,
   constraint price_fact_instrument_fk foreign key ( instrument_key )
      references instrument_dim,
   constraint price_fact_date_instrument_uk unique ( date_key, instrument_key )
);

