DROP VIEW vwUserTotalPay;
CREATE VIEW vwUserTotalPay as
  select up.phone, up.type_id, lt.type,
    sum(COALESCE(up.amount, 0)) as pay
  from users_pay_detail up
  inner join load_type lt On lt.id = up.type_id
  group by up.phone, up.type_id, lt.type;
