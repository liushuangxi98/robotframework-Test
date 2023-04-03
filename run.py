from 公共组件区.common import *
import robot


if __name__ == '__main__':
    # 创建测试用例套的报告存放目录
    cases_dir = creat_cases_dir()
    # 获取测试的用例和用例测试次数，去循环
    for case, loop in get_case_list():
        for i in range(loop):
            # 创建测试用例的报告的存放目录
            case_dir, case_name = creat_case_dir(i, case, cases_dir)

            test_script = get_map_script(case)
            test_config = get_case_config(test_script, case)

            robot.run(f".\\用例脚本区\\{test_script}",
                      log=f'{case_dir}\\log_{case_name}',
                      report=f'{case_dir}\\report_{case_name}',
                      output=f'{case_dir}\\output_{case_name}',
                      variable=test_config)
