DROP VIEW vwUserCurrentLoad;
CREATE VIEW vwUserCurrentLoad as
  select a.phone, a.type_id, a.type,
    COALESCE(a.load, 0) - COALESCE(b.pay, 0) - COALESCE(c.transfer, 0) as load
  from vwUserTotalLoad a
  left join vwUserTotalPay b
    On a.phone = b.phone and a.type_id = b.type_id
  left join vwUserTotalTransfer c
    On a.phone = c.phone and a.type_id = 1;
