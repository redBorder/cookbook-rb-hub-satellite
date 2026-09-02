# Cookbook:: rb-hub-satellite
# Resource:: hub

unified_mode true

resource_name :rbhub_config
provides :rbhub_config

actions :add, :remove, :register, :deregister
default_action :add

attribute :cdomain, kind_of: String, default: 'redborder.cluster'
attribute :user, kind_of: String, default: 'redborder-hub'
attribute :config_dir, kind_of: String, default: '/etc/redborder-hub'
attribute :hub_hosts, kind_of: Array, default: []
attribute :hub_port, kind_of: Integer, default: 8010
attribute :auth_token, kind_of: String, default: 'super-secret-agent-token'
attribute :authorized_keys_dir, kind_of: String, default: '/etc/redborder-hub/authorized_keys'
attribute :advertise_peers, kind_of: [TrueClass, FalseClass], default: false
