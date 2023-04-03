*** Settings ***
Library  SeleniumLibrary
Library  DateTime
Library  ..//公共组件区//common.py
Library  DatabaseLibrary

*** Keywords ***
open_one_url
    [Arguments]     ${url}  ${browser}  ${run_speed}=0.3  ${fail_title}=404 not found
    [Documentation]  自己定义的打开一个浏览器的综合方法
    # 记录开始时间，打印信息
    ${time_start}       Get Current Date        result_format=%Y年%m月%d日%H时%M分%S秒
    # 记录开始时间戳，用于计算花费的时长
    ${speed_time_s}  Evaluate  time.time()  modules=time
    # 打印log
    log  打开浏览器开始时间：${time_start}
    log  正在打开${browser}浏览器的${url}
    # 打开浏览器
    open browser  ${url}  ${browser}
    # 窗口最大化
    MAXIMIZE BROWSER WINDOW
    # 设置运行速度
    Set Selenium Speed    ${run_speed}
    # 获取浏览器的title
    ${url_title}  get title
    # 获取结束时间，打印
    ${time_end}       Get Current Date        result_format=%Y年%m月%d日%H时%M分%S秒
    # 获取结束时间戳，计算花费时长
    ${speed_time_e}  Evaluate  time.time()  modules=time
    # 计算测试花费时间
    ${time_spend}  calculate_time  ${speed_time_e}  ${speed_time_s}
    # 打印log
    log  打开浏览器结束时间：${time_end}
    log  ${url}的标题为${browser}
    # 测试结果判断，title是不是404 not found
    should not be equal  ${url_title}  ${fail_title}
    # 测试结果判断，测试时间不超过10秒
    should be true  ${time_spend}<10
    log to console  测试步骤：${url}在${browser}浏览器打开耗时：${time_spend}s

query_db_table_data
    [Arguments]     ${table}
    [Documentation]  查询数据库某个表的数据,返回为列表，嵌套元组
    Connect to database using custom params  pymysql  host='127.0.0.1',port=3306,user='root',passwd='123456',db='fruitmall',charset='utf8'
    @{table_data}  query  select * from ${table};
    return from keyword  @{table_data}