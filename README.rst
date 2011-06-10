----
Domo
----

Requirements
------------

* ruby-1.9.2
* bundler_

.. _bundler: https://rvm.beginrescueend.com/


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
