-- --------------------------------------------------------------------------------------------------
-- Microsoft SQL Server/MySQL向けテーブル作成スクリプト（その他の製品でも少々の変更で使えるはず）
-- adhocという名のデータベースで作成する想定で作られています。
-- Microsoft SQL Serverの場合はスキーマはデフォルトのdboとなります。
-- ご使用の環境に合わせて適宜、変更ください。
-- --------------------------------------------------------------------------------------------------

USE adhoc;

CREATE TABLE product_category_master(
  product_category_id varchar(50),
  category_layer1 varchar(50),
  category_layer2 varchar(50)
)
;


