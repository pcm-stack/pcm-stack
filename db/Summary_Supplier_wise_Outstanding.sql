SELECT supp_firm_name
,  BILL_AMT
,  Discount
,  Deduction
, GR
,  Pay
, (BILL_AMT - Discount - Deduction - GR - Pay ) AS BAL FROM 
( SELECT
  supp_firm_name
, IFNULL(SUM(bill_amount),0)      AS BILL_AMT
, IFNULL(SUM(dis_amount),0)       AS Discount
, IFNULL(SUM(deduction_amount),0) AS Deduction
, IFNULL(SUM(bill_gr_amt),0)      AS GR
, IFNULL(SUM(payment_received),0) AS Pay

FROM
  (
    SELECT
      voucher_date
    , bill_entry_id
    , bill_number
    , bill_date
    , supplier_account_code
    , Supplier.firm_name AS supp_firm_name
    , buyer_account_code
    , Buyer.firm_name AS buy_firm_name
    , bill_amount
    , discount_percentage
    , DATEDIFF(CURDATE(),bill_date) AS days
    FROM
      txt_bill_entry
    , view_supplier AS Supplier
    , view_buyer    AS Buyer
    WHERE
      txt_bill_entry.delete_tag='FALSE'
      -- AND Buyer.company_id     ='101'
      AND supplier_account_code=Supplier.company_id
      AND buyer_account_code   =Buyer.company_id
      AND bill_entry_id NOT IN
      (
        SELECT
          bill_entry_id
        FROM
          txt_payment_bill_entry
        WHERE
          delete_tag           ='FALSE'
          AND bill_payment_type='Full'
      )
      -- AND buyer_account_code='101'
      AND bill_date <='2022-03-31'
    ORDER BY
      buy_firm_name
    , supp_firm_name
    , bill_date
    , bill_number
  )
  AS t1
  LEFT JOIN
    (
      SELECT
        bill_entry_id AS t2_bill_entry_id
      , payment_entry_id
      , payment_entry_vou_date
      , dis_amount
      , deduction_amount
      , bill_gr_amt
      , payment_received
      , balance_amount
      FROM
        txt_payment_bill_entry
      WHERE
        delete_tag='FALSE'
      ORDER BY
        payment_entry_vou_date ASC
      , payment_entry_id ASC
    )
    AS t2
    ON
      t1.bill_entry_id=t2.t2_bill_entry_id
GROUP BY
  supp_firm_name ) AS comp
  -- buy_firm_name
  -- , supp_firm_name
  -- , bill_date
  -- , bill_number