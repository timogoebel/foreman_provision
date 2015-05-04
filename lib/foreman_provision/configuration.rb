# encoding: UTF-8
require 'logger'
require 'yaml'
require 'singleton'

module ForemanProvision
  # Singleton Class to manage foreman-provision configuration data
  class Configuration
    include Singleton

    # instance of +Logger+
    attr_accessor :logger

    # Method to initalize logging
    # @param [String] file
    # @param [Integer] level
    # @return [Logger]
    def set_logger(file, level)
      file ? (@logger = Logger.new(file)) : @logger = Logger.new(STDOUT)
      @logger.level = level
      @logger
    end


    # Method to load credentials form a YAML file
    # @param [String] file
    # @return [Hash]
    def load_credentials(file)
      if File.file?(file)
        credentials = YAML.load_file(file)
      else
        raise("Unable to load file \"#{file}\" in #{__method__}")
      end

      raise(TypeError) unless credentials.is_a?(Hash)

      @logger.debug("loaded credentials from file \"#{file}\": \"#{credentials}\" in #{__method__} ")

      credentials
    end


    # @param [String] dir
    def yaml_read_dir(dir)
      Dir.glob("#{dir}/*.yaml").each_with_object({}) do |f, data|
        if File.file?(f)
          data[f] = YAML.load_file(f)
        elsif File.directory?(f)
          data[f] = yaml_read_dir(f)
        end
      end
    end


    # Method to load configuration form a YAML file
    # @param [String] file
    # @return [Hash]
    def load_config(file)
      config_merged, config = {}

      if File.file?(file)
        config_merged = YAML.load_file(file)
      elsif File.directory?(file)
        config = yaml_read_dir(file)
        config_merged = config.clone

        config.each do |filepath, data|
          if !data.instance_of?(Hash) && !data.instance_of?(Array)
            next
          end

          data.each do |k, v_new|
            if v_new.is_a?(Array)
              config_merged[k] = config_merged.fetch(k, []).concat(v_new)
            else
              config_merged[k].merge!(v_new)
            end
          end
        end
      else
        raise("Unable to load file \"#{file}\" in #{__method__}")
      end

      raise(TypeError) unless config_merged.is_a?(Hash)

      @logger.debug("Foreman_config: #{config_merged}")

      config_merged
    end
  end
end
