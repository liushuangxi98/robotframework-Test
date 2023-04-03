*** Settings ***
Library  SeleniumLibrary
Library  DateTime
Library  ..//公共组件区//common.py
Library  DatabaseLibrary
Resource    ..//公共组件区//fun_common.robot

*** Test Cases ***
注册验证测试
    log to console  ${\n}测试开始：'${用例名称}'用例测试开始,${\n}测试描述：${描述}
    注册账号  ${用户名}  ${密码}  ${姓名}  ${电话}  ${收货地址}  ${预期结果}

