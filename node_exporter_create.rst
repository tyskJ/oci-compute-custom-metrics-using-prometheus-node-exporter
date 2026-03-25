Linux
=====================================================================
.. note::

  * ``root`` ユーザーにて実行します

1. バイナリ取得
---------------------------------------------------------------------
* `リリースノート <https://github.com/prometheus/node_exporter/releases>`_ よりインストーラーを取得し解凍します
* CPU は合わせてください
* バイナリを所定の位置に移動させます

.. code-block:: bash

  VER=1.10.2
  wget https://github.com/prometheus/node_exporter/releases/download/v${VER}/node_exporter-${VER}.linux-amd64.tar.gz
  tar xvzf node_exporter-${VER}.linux-amd64.tar.gz
  mv /root/node_exporter-${VER}.linux-amd64/node_exporter /usr/local/bin/

2. 専用システムユーザー作成 & バイナリ所有権変更
---------------------------------------------------------------------
.. code-block:: bash

  useradd -s /sbin/nologin -M node_exporter
  chown node_exporter:node_exporter /usr/local/bin/node_exporter

3. サービス化
---------------------------------------------------------------------
* ``Socket`` ファイル起動とするため、``socket`` ファイルを作成 (あえて)

**/etc/systemd/system/node_exporter.socket**

.. code-block:: bash

  [Unit]
  # このソケットユニットの説明（systemctl status で表示される）
  Description=Node Exporter

  [Socket]
  # TCPポート9100番(デフォルト)で待ち受けする設定
  # systemd自身がこのポートをlistenする（node_exporterではない）
  # 接続が来たタイミングで対応する .service を起動する（socket activation）
  ListenStream=9100

  # （補足）
  # ListenStream は TCP 用
  # UNIXソケットの場合は ListenStream=/path/to/socket も指定可能

  [Install]
  # sockets.target が起動するタイミングでこのソケットを有効化する
  # → systemctl enable すると OS起動時に自動でlisten開始される
  WantedBy=sockets.target

* ソケットがリクエストを受信したら起動させるサービスを作成

**/etc/systemd/system/node_exporter.service**

.. code-block:: bash

  [Unit]
  # サービスの説明（systemctl status などで表示される）
  Description=Node Exporter

  # node_exporter.socket が必ず一緒に起動/停止されるようにする
  Requires=node_exporter.socket

  [Service]
  # 実行ユーザー（rootではなく専用ユーザーでセキュアに動かす）
  User=node_exporter

  # OPTIONS という環境変数を空で初期化（EnvironmentFileが無い場合の保険）
  Environment=OPTIONS=

  # 環境変数ファイルを読み込む（無くてもエラーにしない「-」付き）
  # 例：OPTIONS="--web.listen-address=:9100"
  EnvironmentFile=-/etc/sysconfig/node_exporter

  # 起動コマンド
  # --web.systemd-socket を指定すると、systemdのsocketユニット経由で待ち受けする
  # $OPTIONS は上記の環境変数から展開される
  ExecStart=/usr/local/bin/node_exporter --web.systemd-socket $OPTIONS

  [Install]
  # 通常のターゲット（multi-user.target）で有効化される設定
  # ただし socket activation の場合は .socket 側を enable するのが一般的
  WantedBy=multi-user.target

* ``OPTIONS`` を指定するための ``sysconfig`` ファイルを作成

**/etc/sysconfig/node_exporter**

.. code-block:: bash

  OPTIONS="--collector.disable-defaults --collector.cpu --collector.meminfo --collector.filesystem --collector.systemd --collector.systemd.unit-include=(nginx)\.service"

.. note::

  * 取得対象メトリクスは適宜修正すること

* ソケットを自動起動設定にする

.. code-block:: bash

  systemctl enable --now node_exporter.socket

4. 起動確認
---------------------------------------------------------------------
* 以下コマンドを実行し、メトリクスが表示されればOK

.. code-block:: bash

  curl http://localhost:9100/metrics | grep "node_"

Windows
=====================================================================
1. インストーラー取得
---------------------------------------------------------------------
* `リリースノート <https://github.com/prometheus-community/windows_exporter/releases>`_ よりインストーラーを取得
* ``msi`` ファイル取得 (CPUは合わせること)

2. インストーラー実行
---------------------------------------------------------------------
* 管理者権限で ``Powershell`` を起動し、以下実行

.. code-block:: powershell

  msiexec.exe /i <full-path-to-msi-file> --% ENABLED_COLLECTORS=cpu,logical_disk,memory,process,service

.. note::

  * ``path-to-msi-file`` は適宜変更すること (必ずフルパスで指定してください)
  * 取得対象メトリクスは適宜修正すること
  * コマンド実行後インストールプロンプトが表示されるため、デフォルトで完了させる

3. 起動確認
---------------------------------------------------------------------
* ブラウザにて ``http://localhost:9182/metrics`` を呼び出し、``windows_*`` のメトリクスが表示されればOK
* ``windows_exporter`` サービスが登録されますので、サーバーマネージャーから確認できます

参考資料
=====================================================================
リファレンス
---------------------------------------------------------------------
* `prometheus/node_exporter - GitHub <https://github.com/prometheus/node_exporter>`_
* `prometheus/node_exporter/releases - GitHub <https://github.com/prometheus/node_exporter/releases>`_
* `prometheus-community/windows_exporter - GitHub <https://github.com/prometheus-community/windows_exporter>`_
* `prometheus-community/windows_exporter/releases - GitHub <https://github.com/prometheus-community/windows_exporter/releases>`_