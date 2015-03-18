# encoding: UTF-8
require 'foreman_api'

module Foreman_Provision
  class SmartProxy < BaseResource

    # @param [Hash] params
    # @return [Hash]
    def create(params)
      location_ids = []
      organization_ids = []

      params.each(:locations, []).each {|i| location_ids.push(@res_loc.get_by_name(i))}
      params.fetch(:organizations, []).each {|i| organization_ids.push(@res_org.get_by_name(i))}

      @_params = {
          'smart_proxy' => {
              'location_ids' => location_ids,
              'name' => params[:name],
              'organization_ids' => organization_ids,
              'url' => params[:url],
          }
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

      @resource = ForemanApi::Resources::SmartProxy.new(
          @credentials,
          @credentials[:options],
      )
    end
  end
end
