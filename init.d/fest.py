# -*- coding: utf-8; indent-tabs-mode: nil; tab-width: 4; c-basic-offset: 4; -*-

"""
- fest process helper
-
- fest.py  [ --test ] | [ --stop ] | [ --start ] | [ --reload ] | [ --state ] | [ --version ] |
-            --path |     --name
-
_
- fest.py --path='/usr/local/etc/fest/fest.yaml' --name='example.com' --test
-
- # fest.yaml
- default: &options
-     user    : www
-     path    : /usr/local/bin/node
-     proxy   : /usr/local/lib/node_modules/fest/lib/proxy.js
-
-
- example.com:
-     <<      : *options
-     pid     : /var/run/fest/example.com.pid
-     log     : /var/log/fest/example.com.log
-     config  : /usr/local/fest/example.com/fest.json
-
-
- @author Alexander Guinness <monolithed@gmail.com>
- @version 0.0.2
- @license: MIT
- @date: Aug 04 04:05:00 2013
"""


import yaml

import sys
import subprocess
# import time



class Fest(object):
    def __init__(self, options):
        self.options = options.__dict__
        self.params = self.__params()

        self.__run()


    def __parse_config(self, name, file):
        try:
            data = yaml.load(file, Loader=yaml.Loader)

            if self.options.get('test'):
                self.log('%s syntax is ok' % name)

        except yaml.YAMLError as error:
            sys.exit(error)

        return data


    def __get_config(self, name):
        try:
            with open(name, 'r', encoding='utf-8') as file:
                return self.__parse_config(name, file)

        except IOError:
            self.log('the file %s was not found' % name, True)


    def log(self, name, exit=''):
        print('[%s]%s %s' % (self.__class__.__name__,
            exit and ' error:', name))

        if exit:
            sys.exit(1)


    def __params(self):
        path = self.options.get('path')
        data = self.__get_config(path)

        if not data:
            self.log('the configuration file %s is not found' %
                path, True)

        name = self.options.get('name')
        data = data[name]

        if not data:
            self.log('there is no the project settings in file %s' %
                path, True)

        return data


    def __run(self):
        exclude = ('name', 'path')

        for key, value in self.options.items():
            if value and key not in exclude:
                return self.__getattribute__(key)()


    def exec(self, command, text=None):
        if text:
            self.log('%s...' % text)

        try:
            process = subprocess.Popen(command, stdout=subprocess.PIPE, shell=True)

            # while process.poll() is None:
            #   time.sleep(.2)
            #
            # if process.returncode is not 0:
            #   self.log('there was an error starting the server', True)

            output, error = process.communicate()

            return output.decode('utf-8')

        except OSError as error:
            self.log('Execution failed: \n%s' % error, True)


    def required(self):
        required = {'user', 'path', 'proxy',
                    'pid', 'log', 'config'}

        result = required <= set(self.params)

        if not result:
            self.log('please see required options: \n %s' %
                required, True)

        return result


    def pid(self):
        process = self.exec("ps aux | grep %(proxy)s | \
            grep -v grep | head -n1 | awk '{print $2}'" % self.params)

        try:
            return int(process)

        except ValueError:
            self.log('nothing to stop', True)


    def test(method):
        return lambda self: \
            self.required() and method(self)


    @test
    def start(self):
        self.exec('su -m %(user)s -c "nohup %(path)s \
            %(proxy)s %(config)s < /dev/null >> %(log)s 2>&1 &"' %
            self.params, 'starting')


    @test
    def stop(self):
        self.exec('kill -9 %s > /dev/null 2>&1' %
            self.pid(), 'stopping')


    @test
    def reload(self):
        self.stop()
        self.start()


    def version(self):
        output = self.exec('%(path)s %(proxy)s --version' %
            self.params)

        self.log(output)


    def state(self):
        command = \
            '''ps axw -o pid,user,%cpu,%mem,command | {
                awk "NR == 1 || /fest/" | grep -vE "awk|--info" ;
            }'''

        output = self.exec(command)
        self.log(output)






if __name__ == '__main__':
    import argparse

    parser = argparse.ArgumentParser(description='Fest')

    params = ('test', 'stop', 'start',
        'reload', 'version', 'state')

    for key in params:
        parser.add_argument('--%s' % key, action='store_true')


    parser.add_argument('--path', required=True)
    parser.add_argument('--name', required=True)

    options = parser.parse_args()
    Fest(options)
