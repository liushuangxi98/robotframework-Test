*** Settings ***
Library  SeleniumLibrary
Library  DateTime
Library  ..//公共组件区//common.py
Library  DatabaseLibrary
Resource    ..//公共组件区//fun_common.robot
Test Setup  购物结算初始化

*** Keywords ***
购物结算初始化
    @{商品列表}  split_str  ${商品}  _
    @{商品数量}  split_str  ${数量}  _
    ${length}  Get Length  ${商品列表}
    Set Suite Variable    @{商品列表}  @{商品列表}
    Set Suite Variable    @{商品数量}  @{商品数量}
    Set Suite Variable    ${length}  ${length}

*** Test Cases ***
购物结算测试
    log to console  ${\n}测试开始：'${用例名称}'用例测试开始,${\n}测试描述：${描述}
    # 1、登录账号
    登录用户账号    ${用户名}  ${密码}
    # 2、搜索商品
    FOR  ${i}  IN RANGE  ${length}
        搜索并加购物车  ${商品列表[${i}]}  ${商品数量[${i}]}
    END
    # 3、查看购物车
    进入购物车
    # 4、结算
    ${商品金额}  点击结算   ${支付方式}
    # 5、查看订单
    查看订单
    # 6、查看数据库订单
    @{订单}  查询数据库订单
    # 7、测试结果判断
    should be equal  ${商品金额}  ${预期金额}
    should be equal  ${订单[1]}  ${${预期金额}}





