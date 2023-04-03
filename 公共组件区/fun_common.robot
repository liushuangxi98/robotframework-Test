*** Settings ***
Resource  rf_common.robot
Library  SeleniumLibrary

*** Keywords ***
注册账号
    [Arguments]     ${account}  ${password}  ${name}  ${phone}  ${address}  ${expect_result}=OK
    [Documentation]  注册账号的业务功能
    # 打开浏览器
    open_one_url  http://localhost:8999/emall_ssm_mysql_war_exploded/index/login  edge  0.1
    sleep  1
    # 单击,定位到注册
    click element  xpath=//*[@id="searchss"]/div/div[4]/div[1]/a[3]
    sleep  1
    # 输入账户名,定位到输入账户名栏目
    input text  xpath=//*[@id="main"]/div/div/div/form/ul/li[1]/input  ${account}
    # 输入密码,定位到输入密码栏目
    input text  xpath=//*[@id="main"]/div/div/div/form/ul/li[2]/input  ${password}
    # 输入姓名,定位到输入姓名栏目
    input text  xpath=//*[@id="main"]/div/div/div/form/ul/li[3]/input  ${name}
    # 输入电话,定位到输入电话栏目
    input text  xpath=//*[@id="main"]/div/div/div/form/ul/li[4]/input  ${phone}
    # 输入地址，定位到地址栏目
    input text  xpath=//*[@id="main"]/div/div/div/form/ul/li[5]/input  ${address}
    sleep  1
    # 单击立即注册,定位到立即注册按钮
    click element  xpath=//*[@id="main"]/div/div/div/form/input
    sleep  1
    # 检查注册是否成功,判断title是不是变成了登录
    ${url_title}  get title
    ${result}  run keyword if  '${url_title}'=='登录'  Set Variable  YES
    ...  ELSE  Set Variable  NO
    # 关闭浏览器
    close browser
    # 打印log
    log  当前注册账号${result},预期注册${expect_result}
    should be equal  注册结果${result}  注册结果${expect_result}
    log to console  测试步骤：当前注册账号${result},预期注册${expect_result}，结果一致注册验证测试PASS
    # 当预期为注册成功时，检查数据库的数据是否写入
    run keyword if   '${expect_result}'=='YES'  log to console  测试步骤：注册成功，开始判断数据库是否写入
        @{db_result}  查询数据库用户账号
        # 检查数据库用户账号表最后一个用户名
        ${db_last_account}   set variable  ${db_result[-1][1]}
        should be equal  用户名${db_last_account}  用户名${account}
        log to console  测试步骤：设置的用户名为:${account},数据库最后一个写入的用户名为${db_last_account}，数据库写入数据一致，注册测试PASS


查询数据库用户账号
    [Documentation]  查询数据库用户账号表单的数据的业务功能
    @{user_data}  query_db_table_data  users
    log to console  测试步骤：查询数据库用户账号：账号[${uesr_data}]
    return from keyword  @{user_data}

查询数据库订单
    [Documentation]  查询数据库订单表单的数据的业务功能，返回最后一个订单
    @{orders}  query_db_table_data  orders
    log to console  测试步骤：查询数据库订单：订单[${orders[-1]}]
    return from keyword  @{orders[-1]}

登录用户账号
    [Arguments]    ${account}  ${password}
    [Documentation]  登录用户账号的业务功能封装关键字
    open_one_url  http://localhost:8999/emall_ssm_mysql_war_exploded/index/login  edge
    sleep  1
    # 输入账号
    input text  xpath=//*[@id="main"]/div/div/div/form/ul/li[1]/input  ${account}
    # 输入密码
    input text  xpath=//*[@id="main"]/div/div/div/form/ul/li[2]/input  ${password}
    # 点击立即登录
    click element  xpath=//*[@id="main"]/div/div/div/form/input
    # 验证title
    title should be  首页
    log to console  测试步骤：登录用户账号：账号[${account}]

搜索并加购物车
    [Arguments]    ${name}  ${num}=1
    [Documentation]  在搜索栏搜索name商品
    # 点击搜索框并输入
    input text  xpath=//*[@id="searchss"]/div/div[2]/form/input  ${name}
    sleep  1

    sleep  1
    # 点击加入购物车
    FOR  ${idx}  IN RANGE  ${num}
    # 点击搜索
        click element  xpath=//*[@id="searchss"]/div/div[2]/form/button
        sleep  1
        click element  xpath=//*[@id="main"]/div[1]/div/div/p[3]
    END
    log to console  测试步骤：搜索并加购物车：商品[${name}],数量[${num}]

进入购物车
    [Arguments]
    [Documentation]  点击进入购物车,并返回当前购物车的总额
    click element  xpath=//*[@id="searchss"]/div/div[3]/a/p
    log to console  测试步骤：进入购物车

点击结算
    [Arguments]  ${pay}
    [Documentation]  点击结算,并返回当前购物车的总额
    click element  xpath=//*[@id="myCart"]/div[4]/div/a/span
    sleep  1
    ${goods_price}  get text  xpath=//*[@id="shifu"]
    # 如果结算用wx，则点击微信支付，否则点击支付宝支付
    run keyword if   '${pay}'=='微信'  click element  xpath=//*[@id="payway"]/div[2]/div[1]
    run keyword if   '${pay}'=='支付宝'    click element  xpath=//*[@id="payway"]/div[2]/div[2]
    # 点击立即支付
    click element  xpath=//*[@id="tijiao"]
    log to console  测试步骤：点击结算：金额[${goods_price}]
    return from keyword  ${goods_price}


查看订单
    [Arguments]
    [Documentation]  到订单界面查看订单
    click element  xpath=//*[@id="main"]/div/a/p
    sleep  1
