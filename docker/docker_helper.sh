#!/bin/zsh

# ワンライナー用引数
mode=$1

# .envを読み込み
source .env

target_yml='docker-compose.yml'

# キャッシュなしビルド
function cleanbuild {
    select_container
    docker-compose -p ${SCHEMA} -f ${target_yml} build --no-cache  ${container}
}

# ビルドのみ
function build {
    select_container
    docker-compose -p ${SCHEMA} -f ${target_yml} build ${container}
}

# up (ビルドあり)
function up {
    select_container
    docker-compose -p ${SCHEMA} -f ${target_yml} up -d --build ${container}
    contents_build
    view_access_info
}

# ワンライナー起動
function all_up {
    docker-compose -p ${SCHEMA} -f ${target_yml} up -d --build
    contents_build
    view_access_info
}

# 起動
function start {
    select_container
    docker-compose -p ${SCHEMA} -f ${target_yml} start ${container}
    view_access_info
}

# 停止
function stop {
    select_container
    docker-compose -p ${SCHEMA} -f ${target_yml} stop ${container}
}

# 再起動
function restart {
    select_container
    docker-compose -p ${SCHEMA} -f ${target_yml} restart ${container}
    view_access_info
}

# Laravelをビルド、マイグレーション実行
function contents_build {
    sh script/contents_build.sh
}

# コンテナ選択
function select_container {
    tmp=`cat $target_yml | grep container_name | grep -v "#"`
    echo "----------------------------"
    echo "対象のコンテナを選択してください"
    echo - : "\033[0;32m all or 入力なしでreturn \033[0;39m"
    echo ${tmp//container_name:\ \$\{SCHEMA\}\-/\\033[0;39m\\n- : \\033[0;32m}

    echo '\033[0;39m'
    read container

    if [ "$container" = 'all' ] ; then
        container=''
    fi

}

# 接続情報表示
function view_access_info {
    echo "==========================================="
    echo
    echo "WebURL http://$LOCAL_IP/"
    echo
    echo "---- DB アクセス ----"
    echo "ホストからの接続"
    echo "Host : $LOCAL_IP"
    echo "Port : 3306"
    echo "User : root or ${DB_USER_NAME}"
    echo "Passwd : ${DB_PASS}"
    echo
    echo "コンテナ内からの接続"
    echo
    echo "Host : ${SCHEMA}-db"
    echo "Port : 3306"
    echo "User : ${DB_USER_NAME}"
    echo "Passwd : ${DB_PASS}"
    echo
    echo
    echo "==========================================="
}

# ローカルループバックアドレス　のチェック
localipcheck=`ifconfig lo0 |grep $LOCAL_IP`
if [[ -z $localipcheck ]]; then
    echo "\033[0;31mローカルループバックアドレス $LOCAL_IP がありません \033[0;39m"
    echo "sudo ifconfig lo0 alias $LOCAL_IP"
    echo "を実行してください"
    exit
fi

# モード選択
if [ -z $mode ] ; then
    echo 実行区分を入力してください
    echo - "\033[0;32m cleanbuild \033[0;39m (--no-cacheオプションが付きます)"
    echo - "\033[0;32m build \033[0;39m"
    echo - "\033[0;32m up \033[0;39m (ビルドオプション付きでupします)"
    echo - "\033[0;32m all_up \033[0;39m (全コンテナをビルドオプション付きでupします)"
    echo - "\033[0;32m start \033[0;39m"
    echo - "\033[0;32m stop \033[0;39m"
    echo - "\033[0;32m restart \033[0;39m"
    echo - "\033[0;32m view_access_info \033[0;39m (接続情報を表示します)"
    echo - "\033[0;32m contents_build \033[0;39m (Laravelの環境構築を行います)"
    read mode 
fi

case "$mode" in
    "cleanbuild" ) cleanbuild ;;
    "build" ) build ;;
    "up" ) up ;;
    "all_up" ) all_up;;
    "start" ) start ;;
    "stop" ) stop ;;
    "restart" ) restart ;;
    "view_access_info" ) view_access_info ;;
    "contents_build" ) contents_build ;;
    * ) echo "オプションが不正です"
esac


