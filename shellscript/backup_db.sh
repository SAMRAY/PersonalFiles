#!/bin/bash

# 対象テーブルの設定
mariadb_db=(targetdbname1 targetdbname2)

# バックアップ先のディレクトリ・ファイル
bk_dir=/path/to/dist

# 保存する日数
bk_days=1

# タイムスタンプを取得
ts_now=`date +%Y%m%d`
ts_old=`date "-d$bk_days days ago" +%Y%m%d`

# 保存ディレクトリ作成
if [ ! -d $bk_dir ]; then
  mkdir -p $bk_dir
fi

# mariadb(MySql)のバックアップ
for db_name in ${mariadb_db[@]}; do
  # ファイル名を設定
  file_backup=$db_name.$ts_now.gz
  file_remove=$db_name.$ts_old.gz
  cd $bk_dir
  cd mariadb
  if [ $? != 0 ]; then
    echo "Backup directory does not exist."
    exit 1
  fi
  mysqldump $db_name -u USERNAME -p'PASSWORD' --opt | gzip > $file_backup
  if [ $? != 0 -o ! -e $file_backup ]; then
    echo "Cannot dump database."
    exit 1
  fi
  # ローテーション処理
  if [ -e $file_remove ]; then
    rm -f $file_remove
  fi
done

exit 0
