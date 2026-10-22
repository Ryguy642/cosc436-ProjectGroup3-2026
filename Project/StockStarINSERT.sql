delete from price_fact;
delete from date_dim;
delete from stock_dim;

-- fill date_dim with csv date range
insert into date_dim (date_key, time_stamp)
select date_seq.nextval, ts
from (
  select date '2020-08-03' + (level - 1) * interval '5' minute as ts
    from dual
    connect by date '2020-08-03' + (level - 1) * interval '5' minute < date '2026-03-04'
)
where to_number(to_char(ts, 'HH24')) between 4 and 19;

-- fill stock dim with csv -- JUST USE A COUPLE STOCKS FOR NOW
insert into stock_dim (stock_key, stock_symbol)
  values (stock_seq.nextval, 'AAPL');
  
insert into stock_dim (stock_key, stock_symbol)
  values (stock_seq.nextval, 'AMD');
  
insert into stock_dim (stock_key, stock_symbol)
  values (stock_seq.nextval, 'GE');
  
commit;