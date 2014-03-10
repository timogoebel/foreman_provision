# encoding: UTF-8
require 'logger'
require 'yaml'
require 'singleton'

module Foreman_Provision
  # Singleton Class to manage foreman-provision configuration data
  #
  # @author: Nils Domrose
  #
  # * *Example* :
  #  config = Foreman_Provision::Configuration.instance
  class Configuration
    include Singleton

    # instance of +Logger+
    attr_accessor :logger

    # Method to initalize logging
    #
    # * *Example* :
    #  set_logger('/tmp/provision.log, Logger::INFO')
    # * *Args*    :
    #   - +file+ -> logfile
    #   - +level+ -> Log Level (integer) Constant i.e. Logger::INFO
    # * *Returns* :
    #   - +Logger+ instance
    # * *Raises* :
    #   - +Errno+ -> if logfile can't be created
    #
    def set_logger (file, level)
      file ? (@logger = Logger.new(file)) : @logger = Logger.new(STDOUT)
      @logger.level = level
      @logger
    end


    # Method to load credentials form a YAML file
    #
    # * *Example* :
    #  load_credentials('./conf/forman.yaml')
    # * *Args*    :
    #   - +file+ -> YAML file containing the foreman credentials
    # * *Returns* :
    #   - +Hash+ containing the foreman credentials
    # * *Raises* :
    #   - +TypeError+ -> if credentials can't be parsed as hash
    #   - +RuntimeError+ -> if file doesn't exist
    #
    def load_credentials(file)
      File.file?(file) ? ( credentials = YAML.load_file(file)) : (raise "Unable to load file \"#{file}\" in #{__method__}")
      raise TypeError unless credentials.is_a? Hash

      @logger.debug("loaded credentials from file \"#{file}\": \"#{credentials}\" in #{__method__} ")

      credentials
    end


    # Method to load configuration form a YAML file
    #
    # * *Example* :
    #  load_config('./conf/config.yaml')
    # * *Args*    :
    #   - +file+ -> YAML file containing the provisioning config data
    # * *Returns* :
    #   - Hash containing the provisioning config data
    # * *Raises* :
    #   - +TypeError+ -> if config can't be parsed as hash
    #   - +RuntimeError+ -> if file doesn't exist
    #
    def load_config file
      File.file?(file) ? (config = YAML.load_file(file)) : (raise "Unable to load File \"#{file}\" in #{__method__}")
      raise TypeError unless config.is_a? Hash

      @logger.debug("Foreman_config: #{config}")

      config
    end
  end
end
