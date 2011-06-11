----
Domo
----

Super-duper simple command client for Jenkins.

Requirements
------------

* ruby-1.9.2 (probably work with 1.8 as well)
* bundler_


Install
-------

::

  gem install domo

Usage
-----

::

  Usage: domo [command] [options]
  Commands:
    domo help [command]                                              # show help for domo
    domo list <jenkins_url>                                          # list the all of jobs on target jenkins
    domo trigger <jenkins_url> <job_list_path> [options]             # trigger jobs specified in the list file
    domo toggle_all <jenkins_url> <enable|disable>                   # en[dis]able all jobs specified jenkins owns
    domo toggle <jenkins_url> <enable|disable> <job_list>            # en[dis]able jobs specified in the list file
    domo clone <src_jenkins_url> <dest_jenkins_url> <job_list_path>  # clone jobs from jenkins to another jenkins
    domo delete <jenkins_url> <job_list_path> [options]              # delete jobs specified in the list file
    domo delete_all <jenkins_url> [options]                          # delete all jobs that specified jenkins owns
    domo install <jenkins_url> <plugin_list_path>                    # install plugins specified in the list file
    domo backup_config <jenkins_url> [options]                       # backup all job configs that specified jenkins owns
    domo create_jobs <jenkins_url> <config_files_dir>                # create jobs from specified 'config.xml's
    domo version                                                     # show version information

License
-------

::

  Copyright (c) <2011> cynipe

  Permission is hereby granted, free of charge, to any person obtaining
  a copy of this software and associated documentation files (the "Software"),
  to deal in the Software without restriction, including without limitation
  the rights to use, copy, modify, merge, publish, distribute, sublicense,
  and/or sell copies of the Software, and to permit persons to whom the
  Software is furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included
  in all copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
  CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
  TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
  SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

.. _bundler: https://rvm.beginrescueend.com/
