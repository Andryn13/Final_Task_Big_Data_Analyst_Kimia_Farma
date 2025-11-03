CREATE TABLE `rakamin-kf-analytics-476709.kimia_farma.analisa` AS
SELECT
  t.transaction_id,
  t.date as dates,
  c.branch_id,
  c.branch_name,
  c.kota,
  c.provinsi,
  c.rating AS rating_cabang,
  t.customer_name,
  p.product_id,
  p.product_name,
  t.price AS actual_price,
  t.discount_percentage,
  
  -- Persentase laba kotor berdasarkan harga awal
  CASE
    WHEN t.price <= 50000 THEN 0.1
    WHEN t.price <= 100000 THEN 0.15
    WHEN t.price <= 300000 THEN 0.2
    WHEN t.price <= 500000 THEN 0.25
    ELSE 0.3
  END AS persentase_gross_laba,
  
  -- Harga setelah diskon
  t.price * (1 - t.discount_percentage) AS nett_sales,
  
  -- Nett profit = nett_sales × persentase laba
  (t.price * (1 - t.discount_percentage)) *
    CASE
      WHEN t.price <= 50000 THEN 0.1
      WHEN t.price <= 100000 THEN 0.15
      WHEN t.price <= 300000 THEN 0.2
      WHEN t.price <= 500000 THEN 0.25
      ELSE 0.3
    END AS nett_profit,
    
  t.rating AS rating_transaksi

FROM `rakamin-kf-analytics-476709.kimia_farma.kf_final_transaction` t
JOIN `rakamin-kf-analytics-476709.kimia_farma.kf_product` p
  ON t.product_id = p.product_id
JOIN `rakamin-kf-analytics-476709.kimia_farma.kf_kantor_cabang` c
  ON t.branch_id = c.branch_id
WHERE
  EXTRACT(YEAR FROM t.date) BETWEEN 2020 AND 2023;