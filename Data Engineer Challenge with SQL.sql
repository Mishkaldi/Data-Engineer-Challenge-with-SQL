--Querying DQLab Mart Product Database 
--Data Engineer Challenge with SQL (From DQLab Project)

--Select columns from database
SELECT * FROM ms_produk WHERE harga BETWEEN 50000 AND 150000;

--Select columns based on keyword
SELECT * FROM ms_produk WHERE nama_produk LIKE '%Flashdisk%';

--Select customer columns based on their title
SELECT no_urut, kode_pelanggan, nama_pelanggan, alamat 
FROM ms_pelanggan WHERE nama_pelanggan like "%S.H." or nama_pelanggan like "Ir.%" or nama_pelanggan like "%Drs.";

--Order customers name 
SELECT nama_pelanggan FROM ms_pelanggan ORDER BY nama_pelanggan asc;

--Order customers name without title
SELECT nama_pelanggan FROM ms_pelanggan 
ORDER BY CASE WHEN LEFT(nama_pelanggan,3) = 'Ir.' THEN substring(nama_pelanggan,5,100) ELSE nama_pelanggan END asc;

--Order customers name which have the longest name
select nama_pelanggan from ms_pelanggan where nama_pelanggan = 'Mureu Reunte Seruet' or nama_pelanggan ='Djiki Wurdiyi, Drs.';

--Order customers name which have the longest name with title
SELECT nama_pelanggan FROM ms_pelanggan 
WHERE LENGTH(nama_pelanggan) IN (SELECT MAX(LENGTH(nama_pelanggan)) FROM ms_pelanggan) 
OR LENGTH(nama_pelanggan) IN (SELECT MIN(LENGTH(nama_pelanggan)) FROM ms_pelanggan) ORDER BY LENGTH(nama_pelanggan) DESC;

--Select products which most sold
SELECT ms_produk.kode_produk, ms_produk.nama_produk, sum(tr_penjualan_detail.qty) as total_qty FROM ms_produk 
JOIN tr_penjualan_detail
ON ms_produk.kode_produk = tr_penjualan_detail.kode_produk
GROUP BY ms_produk.kode_produk, ms_produk.nama_produk
HAVING total_qty=7;

--Select customers which have the highest transaction value
SELECT a.kode_pelanggan, a.nama_pelanggan, sum(c.harga_satuan*c.qty) as total_harga
FROM ms_pelanggan a
JOIN tr_penjualan b ON a.kode_pelanggan=b.kode_pelanggan
JOIN tr_penjualan_detail c ON b.kode_transaksi=c.kode_transaksi
GROUP BY a.kode_pelanggan, a.nama_pelanggan
ORDER BY total_harga desc limit 1;

--Select customers which have never shopped
SELECT a.kode_pelanggan, a.nama_pelanggan, a.alamat
FROM ms_pelanggan a
WHERE a.kode_pelanggan NOT IN (SELECT kode_pelanggan FROM tr_penjualan);

--Select transactions which have more than 1 shopping list
SELECT 
  a.kode_transaksi,
  a.kode_pelanggan,
  b.nama_pelanggan,
  a.tanggal_transaksi,
  count(c.kode_produk) as jumlah_detail
FROM
  tr_penjualan a
JOIN ms_pelanggan b ON a.kode_pelanggan=b.kode_pelanggan
JOIN tr_penjualan_detail c ON a.kode_transaksi=c.kode_transaksi
GROUP BY
  a.kode_transaksi,
  a.kode_pelanggan,
  b.nama_pelanggan,
  a.tanggal_transaksi
HAVING count(c.kode_produk)>1 ;