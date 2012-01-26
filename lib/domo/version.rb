# -*- encoding: utf-8 -*-

module Domo

  class Version

    def self.to_s
      File.read(File.expand_path("../../../VERSION", __FILE__))
    end

  end

end
