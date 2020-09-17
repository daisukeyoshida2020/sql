-- --------------------------------------------------------------------------------------------------
-- Microsoft SQL Server/MySQL向けテーブル作成スクリプト（その他の製品でも少々の変更で使えるはず）
-- adhocという名のデータベースで作成する想定で作られています。
-- Microsoft SQL Serverの場合はスキーマはデフォルトのdboとなります。
-- ご使用の環境に合わせて適宜、変更ください。
-- --------------------------------------------------------------------------------------------------

use adhoc;

CREATE TABLE bi_calendar(
  DayDate date,
  year int,
  month int,
  quarter_term varchar(50),
  half_year_term varchar(50),
  first_day_of_month date,
  last_day_of_month date,
  day_of_week_short varchar(50),
  day_of_week_long varchar(50),
  month_name_short varchar(50),
  month_name_long varchar(50),
  seq_num int
)
;
