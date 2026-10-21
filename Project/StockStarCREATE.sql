-- drop existing sequences
drop sequence price_seq;
drop sequence date_seq;
drop sequence stock_seq;

-- drop existing tables
drop table price_fact;
drop table date_dim;
drop table stock_dim;

-- create sequences
create sequence price_seq start with 1 increment by 1; -- can add cache for better performance
create sequence date_seq start with 1 increment by 1;
create sequence stock_seq start with 1 increment by 1;

-- create tables
create table date_dim (
   date_key    integer,
   time_stamp  date not null,
   constraint date_dim_pk primary key ( date_key ),
   constraint date_dim_stamp_uk unique ( time_stamp )
);

create table stock_dim (
   stock_key    integer,
   stock_symbol varchar2(10) not null,
   constraint   stock_dim_pk primary key ( stock_key ),
   constraint   stock_dim_symbol_uk unique ( stock_symbol )
);

create table price_fact (
   price_key    integer,
   date_key     integer not null,
   stock_key    integer not null,
   open_price   number,
   high_price   number,
   low_price    number,
   close_price  number,
   share_volume number,
   constraint price_fact_pk primary key ( price_key ),
   constraint price_fact_date_fk foreign key ( date_key )
      references date_dim,
   constraint price_fact_stock_fk foreign key ( stock_key )
      references stock_dim,
   constraint price_fact_date_stock_uk unique ( date_key, stock_key )
);
  