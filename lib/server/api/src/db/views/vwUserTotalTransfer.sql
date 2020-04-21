DROP VIEW vwUserTotalTransfer;
CREATE VIEW vwUserTotalTransfer as
  select phone,
    sum(COALESCE(amount, 0)) as transfer
  from users_load_transfer_detail
  group by phone;
