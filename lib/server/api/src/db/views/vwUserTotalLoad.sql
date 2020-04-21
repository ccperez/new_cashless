DROP VIEW vwUserTotalLoad;
CREATE VIEW vwUserTotalLoad as
  select ul.phone, ul.type_id, lt.type,
    sum(COALESCE(ul.amount, 0)) as load
  from users_load_detail ul
  inner join load_type lt On lt.id = ul.type_id
  group by ul.phone, ul.type_id, lt.type;
