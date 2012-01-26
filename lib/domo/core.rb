# -*- encoding: utf-8 -*-
require 'nokogiri'
require 'mechanize'
require 'highline'

# オレオレ証明を無視する為
require 'openssl'
module OpenSSL
  module SSL
    remove_const :VERIFY_PEER
  end
end
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

# work around problem where HighLine detects an eof on $stdin and raises an
# error.
HighLine.track_eof = false

module Domo

  class Core
    include ERB::Util

    def initialize
      @agent = Mechanize.new
    end

    # 対象とするJenkinsのジョブの一覧を返す
    def list(target, verbose=false)
      login(target) if auth_required?(target)
      jenkins_info = Nokogiri.XML(@agent.get_file("#{target}/api/xml"))
      jenkins_info.css("job>name").map do |name|
        result = name.text
        puts result if verbose
        result
      end
    end

    # ジョブ名一覧ファイルをもとにビルドをトリガリングする
    def trigger(target, job_list, dryrun=true)
      raise "target file unreadable" unless File.readable? job_list
      puts "!!dryrun mode!!" if dryrun
      login(target) if auth_required?(target)
      File.read(job_list).each_line do |name|
        encoded_name = url_encode(name.strip!)
        @agent.post("#{target}/job/#{encoded_name}/build") unless dryrun
        puts "#{name} triggerd"
      end
    end

    # 対象のJenkins上にある全てのジョブを有効/無効化する
    def toggle_all(target, action)
      list(target).each do |name|
        @agent.post("#{target}/job/#{url_encode(name)}/#{action}")
        puts "#{name} #{action}d."
      end
    end

    # ジョブ名一覧ファイルを元に対象のJenkins上にあるジョブを有効/無効化する
    def toggle(target, action, job_list)
      raise "target file unreadable" unless File.readable? job_list
      File.read(job_list).each_line do |name|
        encoded_name = url_encode(name.strip!)
        @agent.post("#{target}/job/#{encoded_name}/#{action}")
        puts "#{name} #{action}d."
      end
    end

    # 対象のJenkinsから全てを削除する
    # 破壊的なメソッドなのでdryrunがデフォルト
    def delete_all(target, dryrun=true)
      puts "!!dryrun mode!!" if dryrun
      list(target).each do |name|
        @agent.post("#{target}/job/#{url_encode(name)}/doDelete") unless dryrun
        puts "#{name} deleted"
      end
    end

    # ジョブ名一覧ファイルをもとに対象のJenkinsからジョブを削除する
    # 破壊的なメソッドなのでdryrunがデフォルト
    def delete(target, job_list, dryrun=true)
      raise "target file unreadable" unless File.readable? job_list
      login(target) if auth_required?(target)
      puts "!!dryrun mode!!" if dryrun
      File.read(job_list).each_line do |name|
        @agent.post("#{target}/job/#{url_encode(name.strip!)}/doDelete") unless dryrun
        puts "#{name} deleted"
      end
    end

    # ジョブ名一覧ファイルを元に、Jenkins AからJenkins BへJobをクローンする
    def clone(from, to, job_list)
      raise "target file unreadable" unless File.readable? job_list

      login(from) if auth_required?(from)
      login(to) if auth_required?(to)
      File.read(job_list).each_line do |name|
        @agent.get("#{from}/job/#{url_encode(name.strip!)}/config.xml") do |res|
          create_job(to, name, res.body)
        end
      end
    end

    # プラグイン一覧ファイルを元にJenkinsにプラグインをインストールする
    # プラグイン一覧ファイルの内容はインストール可能なプラグインページのチェックボックスのname属性値
    def install(target, plugin_list)
      login(target) if auth_required?(target)
      form = @agent.get("#{target}/pluginManager/available").form_with(:action => 'install')
      File.read(plugin_list).each_line do |plugin|
        form.checkbox_with(:name => plugin.strip!) do |checkbox|
          puts "trying to mark: #{plugin}"
          if checkbox != nil
            puts "  => #{plugin} marked as an install target."
            checkbox.check
          end
        end
      end
      form.submit
      puts "plugins installed, please restart your butler after installation done."
      puts "see #{target}/updateCenter/ for instalation progress."
    end

    def backup_config(target, dest)
        list(target).each do |name|
          FileUtils.mkdir_p(dest) unless File.exists?(dest)
          file_to_write = "#{dest}/#{name}.xml"
          File.open(file_to_write, "w") do |f|
            f.write @agent.get_file("#{target}/job/#{url_encode(name)}/config.xml")
          end
          puts "backed up successfully: #{file_to_write}"
        end
    end

    def create_jobs(target, config_dir)
      login(target) if auth_required?(target)
      Dir.glob("#{config_dir}/*.xml").each do |file_name|
        job_name = File.split(file_name)[1].sub(/\.xml$/, "")
        create_job(target, job_name, File.read(file_name))
      end
    end

    def create_job(target, name, config)
      create_api = "#{target}/createItem?name=#{url_encode(name)}"
      @agent.post(create_api, config, {'Content-Type'=>'text/xml'})
      puts "#{name} successfully created at #{target}"

    rescue Mechanize::ResponseCodeError => e
      case e.response_code
      when '400'
        puts "#{name} already exists, so just skiped."
      else
        raise e
      end
    end

    def auth_required?(target)
      ui = HighLine.new
      prompt = "Need login for #{target}?[y|n]: "
      ui.ask(prompt) do |q|
        q.overwrite = false
        q.default = "n"
        q.validate = /y|n|\n/i
        q.responses[:not_valid] = prompt
      end == "y"
    end

    def login(target)
      ui = HighLine.new
      user = ui.ask("User: ")
      pass = ui.ask("Password: ") { |q| q.echo = false }

      puts "logging in... => #{target}"
      @agent.get("#{target}/login") do |page|
        page.form_with(:name => 'login') {|form|
          form['j_username'] = user
          form['j_password'] = pass
        }.submit
      end
    end

    private :login, :auth_required?

  end

end
