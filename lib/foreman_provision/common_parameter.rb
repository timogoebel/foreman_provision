# encoding: UTF-8
require 'foreman_api'

require 'foreman_provision/base_resource'

module ForemanProvision
  class CommonParameter < BaseResource

    # @param [Hash] params
    # @return [Hash]
    def create(params)
      @_params = {
          'common_parameter' => {
              'name' => params[:name],
              'value' => params[:value],
          }
      }

      super
    end


    # @param [Hash] params
    # @return [Hash]
    def destroy(params)
      @_params = {
          'id' => get_by_name(params[:name]),
      }

      super
    end


    # @param [Hash] params
    # @return [Hash]
    def index(params)
      @_params = {
          'search' => params[:search],
      }

      super
    end


    # @param [Hash] params
    # @return [Hash]
    def show(params)
      @_params = {
          'id' => params[:id],
      }

      super
    end


    # @param [Hash] params
    # @return [Hash]
    def update(params)
      _params = {
          'id' => params[:id],
          'common_parameter' => params[:params]
      }

      super
    end


    # Helper stuff

    # Internal stuff

    # @param [Object] credentials
    # @param [Object] logger
    def initialize(credentials, logger)
      super

      @resource = ForemanApi::Resources::CommonParameter.new(
          @credentials,
          @credentials[:options],
      )
    end
  end
end
