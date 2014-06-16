# -*- coding: UTF-8 -*-

import os
import pexpect
from subprocess import call, Popen
from time import sleep, localtime, strftime


TIMER = 2

# the order of these steps is as follows
# 1. before scenario
# 2. before tag
# 3. after scenario
# 4. after tag

def before_scenario(context, scenario):
    try:
        context.log = file('/tmp/log_%s.log' % scenario.name,'w')
        context.log_start_time = strftime("%Y-%m-%d %H:%M:%S", localtime())

    except Exception as e:
        print("Error in before_scenario: %s" % e.message)

#def before_tag(context, tag):
#    if tag == 'dcb':
#        print "---------------------------"
#       print "setting enp3s0f0 profile down "
#        Popen("nmcli connection down id enp3s0f0", shell=True).wait()
#        print "---------------------------"


def after_scenario(context, scenario):
    """
    """
#    try:
    # Attach journalctl logs
    call("sudo journalctl -u NetworkManager --no-pager -o cat --since='%s' > /tmp/journal-nm.log" % context.log_start_time, shell=True)
    data = open("/tmp/journal-nm.log", 'r').read()

    if data:
        context.embed('text/plain', data)

    if hasattr(context, "embed"):
        context.embed('text/plain', open("/tmp/log_%s.log" % scenario.name, 'r').read())

#    except Exception as e:
#        print("Error in after_scenario: %s" % e.message)


def after_tag(context, tag):
    """
    """
    if tag == 'dcb':
        print "---------------------------"
        print "deleting connection dcb"
        Popen("nmcli connection down id dcb", shell=True).wait()
        Popen("nmcli connection delete id dcb", shell=True).wait()
        sleep(10*TIMER)
        #Popen("nmcli connection up id enp3s0f0", shell=True).wait()
        #sleep(5)
        Popen('sudo service beah-beaker-backend restart', shell=True).wait()
        sleep(10*TIMER)
        print "---------------------------"


#def after_all(context):
#    if os.system("nmcli -f NAME c sh -a |grep enp3s0f0") != 0:
#       Popen("nmcli connection up id eth0", shell=True).wait()
#        Popen('sudo service beah-beaker-backend restart', shell=True).wait()
#        sleep(10*TIMER)
#        print "---------------------------"

