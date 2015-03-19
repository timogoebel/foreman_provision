# encoding: UTF-8
require 'foreman_api'

module ForemanProvision
  class ComputeResource < BaseResource

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


    # Internal stuff

    # @param [Object] credentials
    # @param [Object] logger
    def initialize(credentials, logger)
      super

      @resource = ForemanApi::Resources::ComputeResource.new(
          @credentials,
          @credentials[:options],
      )
    end
  end
end
