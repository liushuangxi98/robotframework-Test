*** Settings ***
Library  SeleniumLibrary
Library  DateTime
Library  ..//公共组件区//common.py
Resource    ..//公共组件区//rf_common.robot
Test Setup  链接检查初始化

*** Keywords ***
链接检查初始化
    @{browser_list}   split_str  ${浏览器列表}
    @{url_list}   split_str  ${链接}
    Set Suite Variable    @{browser_list}  @{browser_list}
    Set Suite Variable    @{url_list}  @{url_list}

open_many_url
    [Arguments]     ${url_list}  ${browser}  ${run_speed}  ${fail_title}
    [Documentation]  自己定义的打开多个浏览器的综合方法
    FOR  ${url}  IN   @{url_list}
        open_one_url  ${url}  ${browser}  ${run_speed}  ${fail_title}
        # 关闭浏览器
        close browser
    END

*** Test Cases ***
链接检查测试
    log to console  ${\n}'${用例名称}'用例测试开始,描述:${描述}
    # 1、不同浏览器打开链接
    FOR  ${i_browser}  IN  @{browser_list}
        open_many_url   ${url_list}  ${i_browser}  ${打开速度}  ${失败断言}
    END

