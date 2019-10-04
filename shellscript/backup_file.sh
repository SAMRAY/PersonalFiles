#!/bin/bash

# 対象ディレクトリの設定
# [name] [path]
dirs=(
  'archivename1 /path/to/targetdir'
  'archivename2 /path/to/targetdir'
)

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

# ファイルのバックアップ処理
for dir in "${dirs[@]}"; do
  data=(${dir[@]})
  backup_name=${data[0]}
  target_path=${data[1]}
  if [ ! -d $target_path ]; then
    continue
  fi
  # ファイル名を設定
  file_backup=$backup_name.$ts_now.tar.gz
  file_remove=$backup_name.$ts_old.tar.gz

  tar -zcf $bk_dir/$file_backup $target_path

  cd $bk_dir
  if [ $? != 0 -o ! -e $file_backup ]; then
    echo "Cannot compression files."
    exit 1
  fi
  # ローテーション処理
  if [ -e $file_remove ]; then
    rm -f $file_remove
  fi
done

# rsyncで送信
rsync -aq $bk_dir rsync://target_uri

exit 0
