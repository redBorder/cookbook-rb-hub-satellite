# Cookbook:: rb-hub-satellite
# Resource:: satellite

unified_mode true

resource_name :rbsat_config
provides :rbsat_config

actions :add, :remove
default_action :add

attribute :user, kind_of: String, default: 'redborder-satellite'
attribute :config_dir, kind_of: String, default: '/etc/redborder-satellite'
attribute :hub_url, kind_of: String, default: lazy { "wss://redborder-hub.#{node['redborder']['cdomain']}/ws" }
attribute :auth_token, kind_of: String, default: 'super-secret-agent-token'
attribute :private_key_path, kind_of: String, default: '/etc/redborder-satellite/redborder-satellite.key'
attribute :agent_id, kind_of: String, default: lazy { node['hostname'] }
attribute :insecure_skip_verify, kind_of: [TrueClass, FalseClass], default: true
attribute :commands, kind_of: Hash, default: {}
