delete from price_fact;
delete from date_dim;
delete from instrument_dim;

-- fill date_dim with csv date range
-- using level, dual, and connect by:
--   select level from dual connect by level <= 5; --> 1, 2, 3, 4, 5
insert into date_dim (date_key, time_stamp)
select date_seq.nextval, ts
from (
  select date '2020-08-03' + (level - 1) * interval '5' minute as ts
    from dual
    connect by date '2020-08-03' + (level - 1) * interval '5' minute < date '2026-03-04'
)
where to_number(to_char(ts, 'HH24')) between 4 and 19;

-- fill instrument dim with stock csv -- JUST USE A FEW FOR NOW
insert into instrument_dim (instrument_key, instrument_symbol, instrument_type)
  values (instrument_seq.nextval, 'AAPL', 'STOCK');
  
insert into instrument_dim (instrument_key, instrument_symbol, instrument_type)
  values (instrument_seq.nextval, 'AMD', 'STOCK');
  
insert into instrument_dim (instrument_key, instrument_symbol, instrument_type)
  values (instrument_seq.nextval, 'GE', 'STOCK');

-- fill instrument dim with bond csv
insert into instrument_dim (instrument_key, instrument_symbol, instrument_type, maturity_years)
  values (instrument_seq.nextval, 'US13W', 'BOND', 0.25);

insert into instrument_dim (instrument_key, instrument_symbol, instrument_type, maturity_years)
  values (instrument_seq.nextval, 'US5Y', 'BOND', 5);

insert into instrument_dim (instrument_key, instrument_symbol, instrument_type, maturity_years)
  values (instrument_seq.nextval, 'US10Y', 'BOND', 10);
  
commit;
