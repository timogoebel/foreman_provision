# encoding: UTF-8
require 'foreman_api'
require 'foreman_provision/domain'
require 'foreman_provision/host'
require 'foreman_provision/hostgroup'

module ForemanProvision
  class Parameter < BaseResource

    # @param [Hash] params
    # @return [Hash]
    def create(params)
      @_params = resolve_param_owner(params)
      @_params['name'] = params[:name]
      @_params['value'] = params[:value]

      super
    end


    # @param [Hash] params
    # @return [Hash]
    def destroy(params)
      @_params = resolve_param_owner(params)

      if !params.key?(:id)
        @_params['id'] = get_by_name(params)
      else
        @_params['id'] = params[:id]
      end

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
      @_params = resolve_param_owner(params)
      return nil if !@_params

      if !params.key?(:id)
        params[:id] = get_by_name(params)
      end

      @_params['id'] = params[:id]

      return nil if !@_params['id']

      super
    end


    # @param [Hash] params
    # @return [Hash]
    def update(params)
      @_params = resolve_param_owner(params)

      if !params.key?(:id)
        params[:id] = get_by_name(params)
      end

      @_params['id'] = params[:id]
      @_params['name'] = params[:name]
      @_params['value'] = params[:value]

      if params.key?(:test) && params[:test]
        old_res = show(params)

        result = {}
        result['response'] = {
            'name' => params[:name],
            'value_old' => old_res['response'][0]['value'],
            'value_new' => params[:value],
            'needs_update' => old_res['response'][0]['value'] != params[:value],
        }
        return result
      end

      super
    end


    # Helper stuff

    # @param [Hash] params
    # @return [Integer]
    def exists(params)
      if !params.key?(:name) || !params[:name].is_a?(String)
        raise(TypeError)
      end

      get_by_name(params)
    end

    # @param [String] name
    # @return [Integer]
    def get_by_name(params)
      if !params || !params.key?(:name) || !params[:name]
        return nil
      elsif !params[:name].is_a?(String)
        raise(TypeError)
      end

      @_params = resolve_param_owner(params)
      return nil if !@_params

      @_params[:search] = "name=\"#{params[:name]}\""

      @logger.debug("Performing \"#{__method__}\" for #{self.class.to_s} \"#{params[:name]}\" with params #{@_params}")

      result = @resource.index(@_params)[0]["results"].select { |entry| entry["name"]==params[:name] }
      result[0]['id'] if result.any?
    end


    # @param [Hash] params
    # @return [Hash]
    def resolve_param_owner(params)
      if !params.key?(:domain_id) && params.key?('domain')
        retval = @res_domain.get_by_name(params['domain'])
        retval.nil? ? nil : {'domain_id' => retval}

      elsif !params.key?(:host_id) && params.key?('host')
        retval = @res_host.get_by_name(params['host'])
        retval.nil? ? nil : {'host_id' => retval}

      elsif !params.key?(:hostgroup_id) && params.key?('hostgroup')
        retval = @res_hg.get_by_name(params['hostgroup'])
        retval.nil? ? nil : {'hostgroup_id' => retval}

      else
        raise(KeyError)
      end
    end


    # Internal stuff

    # @param [Object] credentials
    # @param [Object] logger
    def initialize(credentials, logger)
      super

      @resource = ForemanApi::Resources::Parameter.new(@credentials, @credentials[:options])

      @res_domain = Domain.new(@credentials, @credentials[:options])
      @res_host = Host.new(@credentials, @credentials[:options])
      @res_hg = Hostgroup.new(@credentials, @credentials[:options])
    end
  end
end
