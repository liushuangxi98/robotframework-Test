#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Time    : 2023/1/16 21:59
# @Author  : 刘双喜
# @File    : python_lib.py
# @Description : 自写库
import os

import pandas
from datetime import datetime


def get_html_urls(url):
    """
    获取一个网页的所有url
    :param url: url链接
    :return: 列表，url
    """
    import requests
    import re
    # 爬取数据
    header = {
        'User-agent': 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/93.0.4577.82 Safari/537.36'}
    response = requests.get(url, headers=header)

    url_prefix = url[:url.rfind('/')]
    text = response.text

    urls_list_temp = re.findall("""<a href="(.+?)">""", text)

    urls_list = [f'{url_prefix}/{i}' for i in urls_list_temp]

    return urls_list


def get_map_script(case: str):
    """
    寻找用例匹配的脚本
    :param case:用例名称
    :return:脚本名称
    """
    excel_data = pandas.read_excel('用例和脚本映射表.xlsx')
    script = excel_data[(excel_data['用例'] == case)].values.tolist()
    try:
        return script[0][1] + '.robot'
    except Exception as e:
        raise f'没有找到用例={case}对应的脚本。错误{e}'


def get_case_config(script, case):
    """
    寻找用例在脚本里的配置
    :param script: 脚本名
    :param case: 用例名
    :return: 可入参robot的列表，每个元素为字典
    """
    excel_data = pandas.read_excel(f'.\\用例配置区\\{script.replace("robot", "xlsx")}')
    config = excel_data[(excel_data['用例名称'] == case)].values.tolist()
    try:
        config = config[0]
        title = excel_data.columns.tolist()
        config_dict = [f'{title[i]}:{config[i]}' for i in range(len(title))]
        return config_dict
    except Exception as e:
        raise f'在脚本{script}里没有找到用例{case}的配置。错误{e}'


def get_case_list():
    """
    从run.xlsx获取要测试的用例列表和每个用例的测试次数
    :return:[[用例1,测试次数],[用例2,测试次数],...]
    """
    excel_data = pandas.read_excel('运行用例表.xlsx')
    return [excel_data.iloc[i].tolist() for i in excel_data.index]


def creat_cases_dir():
    """
    创建测试用例列表总的报告存放目录
    :return: 目录路径
    """
    time_now = datetime.now().strftime('%Y-%m-%d-%H-%M-%S')
    report_dir = f'.\\测试报告区\\{time_now}'
    os.mkdir(report_dir)
    return report_dir


def creat_case_dir(loop, case, cases_dir):
    """
    创建测试用例的第n次循环的报告存放路径
    :return:用例目录和用例+n次循环名称
    """
    time_now = datetime.now().strftime('%Y-%m-%d-%H-%M-%S')
    case_name = f'{case}__loop{loop}_{time_now}'
    case_dir = f"{cases_dir}\\{case_name}"
    os.mkdir(case_dir)
    return case_dir, case_name


def split_str(s: str, i: str = ' '):
    """
    分隔字符串
    :param s: 需要分割的字符串
    :param i: 分割标注位
    :return:
    """
    return s.split(i)


def calculate_time(time_end, time_start):
    """
    计算时间花费
    :param time_end: 开始时间
    :param time_start: 结束时间
    :return: 花费的时间，秒
    """
    print(round(time_end - time_start, 2))
    return round(time_end - time_start, 2)


if __name__ == '__main__':
    print(get_case_list())
