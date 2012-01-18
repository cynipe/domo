# -*- encoding: utf-8 -*-
require "thor"
require "domo"

module Domo

  class CLI < Thor

    def initialize(args=[], options={}, config={})
      super(args, options, config)
      @domo = Domo::Core.new
    end

    map "-v" => :version, "--version" => :version, "-h" => :help, "--help" => :help

    desc "list <jenkins_url>", "list the all of jobs on target jenkins"
    def list(target)
      @domo.list(target, true)
    end

    desc "trigger <jenkins_url> <job_list_path> [options]", "trigger jobs specified in the list file"
    method_option :dryrun, 
                  :desc => "execute except actually send request", 
                  :type => :boolean, 
                  :default => true
    def trigger(target, job_list)
      @domo.trigger(target, job_list, options[:dryrun])
    end

    desc "toggle_all <jenkins_url> <enable|disable>", "en[dis]able all jobs specified jenkins owns"
    def toggle_all(target, action)
      @domo.toggle_all(target, action)
    end

    desc "toggle <jenkins_url> <enable|disable> <job_list>", "en[dis]able jobs specified in the list file"
    def toggle(target, action, job_list)
      @domo.toggle(target, action, job_list)
    end

    desc "clone <src_jenkins_url> <dest_jenkins_url> <job_list_path>", "clone jobs from jenkins to another jenkins"
    def clone(src, dest, job_list)
      @domo.clone(src, dest, job_list)
    end


    desc "delete <jenkins_url> <job_list_path> [options]", "delete jobs specified in the list file"
    method_option :dryrun, 
                  :desc => "execute except actually send request", 
                  :type => :boolean, 
                  :default => true
    def delete(target, job_list)
      @domo.delete(target, job_list, options[:dryrun])
    end

    desc "delete_all <jenkins_url> [options]", "delete all jobs that specified jenkins owns"
    method_option :dryrun, 
                  :desc => "execute except actually send request", 
                  :type => :boolean, 
                  :default => true
    def delete_all(target)
      @domo.delete_all(target, options[:dryrun])
    end

    desc "install <jenkins_url> <plugin_list_path>",  "install plugins specified in the list file"
    def install(target, plugin_list)
      @domo.install(target, plugin_list)
    end

    desc "backup_config <jenkins_url> [options]",  "backup all job configs that specified jenkins owns"
    method_option :dest, 
                  :desc => "config.xml dest dir", 
                  :type => :string, 
                  :default => "#{Dir::pwd}/jobs"
    def backup_config(target)
      @domo.backup_config(target, options[:dest])
    end

    desc "create_jobs <jenkins_url> <config_files_dir>", "create jobs from specified 'config.xml's"
    def create_jobs(target, config_dir)
      @domo.create_jobs(target, config_dir)
    end

    desc "version", "show version information"
    def version
      puts Domo::Version.to_s
    end

    desc "help [command]", "show help for domo"
    def help(*args)
      super(*args)
    end

    def self.help(shell, *)
      list = printable_tasks
      shell.say "Usage: domo [command] [options]"
      shell.say "Commands:"
      shell.print_table(list, :ident => 2, :truncate => true)
      shell.say
      class_options_help(shell)
    end

  end

end
