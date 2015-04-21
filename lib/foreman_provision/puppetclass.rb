# encoding: UTF-8
require 'foreman_api'

module ForemanProvision
  class Puppetclass < BaseResource

    # @param [Hash] params
    # @return [Hash]
    def create(params)
      @_params = {
      }

      super
    end


    # @param [Hash] params
    # @return [Hash]
    def destroy(params)
      @_params = {
      }

      super
    end


    # @param [Hash] params
    # @return [Hash]
    def index(params)
      @_params = {
      }

      super
    end


    # @param [Hash] params
    # @return [Hash]
    def show(params)
      @_params = {
      }

      super
    end


    # @param [Hash] params
    # @return [Hash]
    def update(params)
      @_params = {
      }

      super
    end


    # @param [String] name
    # @return [Integer]
    def get_by_name(name)
      if !name
        return nil
      elsif !name.is_a?(String)
        raise(TypeError)
      end

      result = @resource.index({:search => "name=\"#{name}\""})[0]["results"].select{|k, v| v[0]["name"]==name }
      result[result.keys.first][0]['id'] if result.any?
    end


    # Internal stuff

    # @param [Object] credentials
    # @param [Object] logger
    def initialize(credentials, logger)
      super

      @resource = ForemanApi::Resources::Puppetclass.new(
          @credentials,
          @credentials[:options],
      )
    end
  end
end
