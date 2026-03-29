Windows
=====================================================================
1. インストーラー取得
---------------------------------------------------------------------

1. OCI コンソール左上のハンバーガーマークをクリックし、``Observability & Management`` → ``Agents`` をクリック

.. image:: ./doc/image/pic1.png
  :scale: 100%

2. ``Download and Keys`` から、``Agent for WINDOWS (X86_64)``` をクリックしてローカルPCにダウンロード

.. image:: ./doc/image/pic2.png
  :scale: 100%

.. note:: 

  * ダウンロード後、対象インスタンスに持ち込む

2. インストールキー作成
---------------------------------------------------------------------

1. 先程の同じ画面にて ``Create key`` をクリック

.. image:: ./doc/image/pic3.png
  :scale: 100%

2. 各種情報を入力し ``Create`` をクリック

.. image:: ./doc/image/pic4.png
  :scale: 100%

3. 作成したインストールキーの情報が含まれる ``レスポンス・ファイル`` をダウンロード

.. image:: ./doc/image/pic5.png
  :scale: 100%

4. ``キー名.rsp`` ファイルがローカルPCにダウンロードされるため、デフォルトから今回の構成に合わせて修正

**windows-key.rsp**

.. code-block:: none
  :emphasize-lines: 15, 16

  ########################################################################
  # Please refer the following Management Agent Installation Guide for more details.
  #
  # https://docs.cloud.oracle.com/iaas/management-agents/index.html
  #
  # Since this file has sensitive information, please make sure that after
  # executing setup.sh you either delete this file or store it in a secure
  # location.
  #
  ########################################################################
  ManagementAgentInstallKey = hogehoge
  AgentDisplayName = 
  #Please uncomment the below tags properties and provide values as needed
  #FreeFormTags = [{"<key1>":"<value1>"}, {"<key2>":"<value2>"}]
  DefinedTags = [{"Common":{"Env":"prd","ManagedByTerraform":"true"}}]
  #CredentialWalletPassword = 
  #Service.plugin.jm-container.download=true
  #Service.plugin.mds.download=true
  #Service.plugin.osmh.download=true
  #Service.plugin.appmgmt.download=true
  #Service.plugin.logan.download=true
  #Service.plugin.dbaas.download=true
  #Service.plugin.jms.download=true
  #Service.plugin.opsiHost.download=true
  #Service.plugin.jm.download=true

.. note:: 

  * `参考 <https://docs.oracle.com/ja-jp/iaas/management-agents/doc/management-agents-administration-tasks.html#OCIAG-GUID-3008AAB9-B871-47B6-BC05-3A6FE5BDD470>`_
  * 修正後、対象インスタンスに持ち込み

3. ``JDK 8`` インストール
---------------------------------------------------------------------

.. note::
  
  * `前提条件 <https://docs.oracle.com/ja-jp/iaas/management-agents/doc/perform-prerequisites-deploying-management-agents.html#OCIAG-GUID-BC5862F0-3E68-4096-B18E-C4462BC76271>`_ に ``JDK`` のインストールが必要のためインストール

.. warning::

  * ``JDK 8`` のみサポート
  * それ以外だとエラー

  .. code-block:: terminal

    C:\Users\opc\Desktop\oracle.mgmt_agent.260128.1501.Windows-x86_64\mgmt_agent>installer.bat c:\Users\opc\Desktop\windows-key.rsp
    Checking pre-requisites

        Checking if previous agent service exists
        Checking if C:\Oracle\mgmt_agent\agent_inst directory exists
        Checking Java version
    "Agent only supports 64 bit and 32 bit JDK 8 (with a minimum upgrade version JDK 8u281). Please set your preferred path in JAVA_HOME"

1. `こちら <https://www.oracle.com/jp/java/technologies/javase/javase8u211-later-archive-downloads.html#:~:text=Java%20SE%20Development%20Kit%208u281>`_ から ``jdk-8u281-windows-x64.exe`` をダウンロード

.. warning::

  * 事前に Oracle アカウントが必要
  * 商用利用の場合はライセンスが必要になるので注意

2. ``exe`` ファイルを実行

.. note::

  * 設定はデフォルトでインストール

参考資料
=====================================================================
リファレンス
---------------------------------------------------------------------
* `管理エージェントのインストール - Oracle Cloud Infrastructureドキュメント <https://docs.oracle.com/ja-jp/iaas/management-agents/doc/install-management-agent-chapter.html>`_
* ` <>`_
* ` <>`_
* ` <>`_