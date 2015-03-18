# encoding: UTF-8
require 'foreman_api'

module ForemanProvision
  class BaseResource

    # @param [Hash] params
    # @return [Hash]
    def create(params)
      @logger.debug("Performing \"#{__method__}\" for #{self.class.to_s} \"#{params[:name]}\" with params #{@_params}")

      result = {}
      result['response'] = @resource.create(@_params)
      result['success'] = true #TODO
      result
    end


    # @param [Hash] params
    # @return [Hash]
    def destroy(params)
      @logger.debug("Performing \"#{__method__}\" for #{self.class.to_s} \"#{params[:name]}\" with params #{@_params}")

      result = {}
      result['response'] = @resource.destroy(@_params)
      result['success'] = true #TODO
      result
    end


    # @param [Hash] params
    # @return [Hash]
    def index(params)
      @logger.debug("Performing \"#{__method__}\" for #{self.class.to_s} \"#{params[:name]}\" with params #{@_params}")

      result = {}
      result['response'] = @resource.index(@_params)
      result['success'] = true #TODO
      result
    end


    # @param [Hash] params
    # @return [Hash]
    def show(params)
      @logger.debug("Performing \"#{__method__}\" for #{self.class.to_s} \"#{params[:name]}\" with params #{@_params}")

      result = {}
      result['response'] = @resource.show(@_params)
      result['success'] = true #TODO
      result
    end


    # @param [Hash] params
    # @return [Hash]
    def update(params)
      @logger.debug("Performing \"#{__method__}\" for #{self.class.to_s} \"#{params[:name]}\" with params #{@_params}")

      result = {}
      result['response'] = @resource.update(@_params)
      result['success'] = true #TODO
      result
    end


    # Helper stuff

    # @param [Hash] params
    # @return [Integer]
    def exists(params)
      if !params.key?(:name) || !params[:name].is_a?(String)
        raise(TypeError)
      end

      retval = get_by_name(params[:name])
      if !retval
        false
      else
        retval
      end
    end


    # @param [String] name
    # @return [Integer]
    def get_by_name(name)
      if !name
        return nil
      elsif !name.is_a?(String)
        raise(TypeError)
      end

      result = @resource.index({:search => "name=\"#{name}\""})[0]["results"].select{|entry| entry["name"]==name }
      result[0]['id'] if result.any?
    end


    # Internal stuff

    # @param [Object] credentials
    # @param [Object] logger
    def initialize(credentials, logger)
      @credentials = credentials
      @logger = logger
    end
  end
end
