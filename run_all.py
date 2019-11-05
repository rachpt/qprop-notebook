#!/usr/bin/env python3
# -*- encoding: utf-8 -*-
'''
@File    : run_all.py
@Time    : 2019/11/05 14:16:34
@Author  : rachpt
@Version : 0.1
@Contact : rachpt@126.com
@Desc    : 批量提交计算任务 
'''

import os
import threading
from time import sleep

INCLUDE = '/srv/space/rigged/include.sh'

PWD = '/srv/space/rigged/jobs/电离率'
cpus = 7

# ------------------------------------------ #
lst = os.listdir(PWD)
total = len(lst)


def call(dr):
    print('start task: ' + dr)
    _pwd = 'cd "' + PWD + '/' + dr + '" && source ' + INCLUDE + ' >/dev/null && '
    cmd = _pwd + 'h1 >/dev/null && h2 >/dev/null'
    # os.system(cmd)
    print(cmd)
    print('end task: ' + dr)


threads = {}
n = 0
for i in range(total):
    threads[i] = threading.Thread(target=call, args=(lst[n], ))
    n += 1

if __name__ == '__main__':
    n = 0
    while True:
        if threading.active_count() < cpus:
            threads[n].start()
            n += 1
            if n >= total:
                break
        else:
            # print('hold on')
            sleep(10)
    print("All submitted! Waitting last calc.")
    while True:
        if threading.active_count() == 1:
            print("Done！")
            break
        else:
            sleep(10)
