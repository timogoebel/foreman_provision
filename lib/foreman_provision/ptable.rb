# encoding: UTF-8
require 'foreman_api'

module Foreman_Provision
  class Ptable

    # @param [Hash] params
    # @return [Hash]
    def create(params)
      _params = {
      }

      @logger.debug("Performing \"#{__method__}\" for #{self.class.to_s} \"#{params[:name]}\" with params #{_params}")

      result = {}
      result['response'] = @resource.create(_params)
      result['success'] = true #TODO
      result
    end


    # @param [Hash] params
    # @return [Hash]
    def destroy(params)
      _params = {
      }

      result = {}
      result['response'] = @resource.destroy(_params)
      result['success'] = true #TODO
      result
    end


    # @param [Hash] params
    # @return [Hash]
    def index(params)
      _params = {
      }

      result = {}
      result['response'] = @resource.index(_params)
      result['success'] = true #TODO
      result
    end


    # @param [Hash] params
    # @return [Hash]
    def show(params)
      _params = {
      }

      result = {}
      result['response'] = @resource.show(_params)
      result['success'] = true #TODO
      result
    end


    # @param [Hash] params
    # @return [Hash]
    def update(params)
      _params = {
      }

      result = {}
      result['response'] = @resource.update(_params)
      result['success'] = true #TODO
      result
    end


    # Helper stuff

    # @param [Hash] params
    # @return [Integer]
    def exists(params)
      if !params.has_key?(:name) || !params[:name].is_a?(String)
        raise(TypeError)
      end

      get_by_name(params[:name])
    end


    # @param [String] name
    # @return [Integer]
    def get_by_name(name)
      if name.nil?
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
      @resource = ForemanApi::Resources::Ptable.new(
          @credentials,
          @credentials[:options],
      )
    end
  end
end