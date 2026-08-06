# Flags
# =====================================
# Default Settings for Redborder Hub
# =====================================

default['redborder']['redborder-hub']['registered'] = false
default['redborder']['redborder-hub']['port']   = 8010

# Default settings for the local upstream (127.0.0.1)
default['redborder']['redborder-hub']['local']['weight']       = 6
default['redborder']['redborder-hub']['local']['max_fails']    = 3
default['redborder']['redborder-hub']['local']['fail_timeout'] = 5

# Default settings for remote nodes in the cluster
default['redborder']['redborder-hub']['remote']['weight']       = 4
default['redborder']['redborder-hub']['remote']['max_fails']    = 3
default['redborder']['redborder-hub']['remote']['fail_timeout'] = 120

default['redborder']['redborder-hub']['auth_token'] ='super-secret-agent-token'
default['redborder']['redborder-hub']['authorized_keys_dir'] = '/etc/redborder-hub/authorized_keys'

default['redborder']['redborder-hub']['advertise_peers'] = false

# ===========================================
# Default Settings for Redborder Satellite
# ===========================================

default['redborder']['redborder-satellite']['hub_url'] = 'wss://redborder-hub.redborder.cluster/ws'

# Global authentication token for satellite agents
default['redborder']['redborder-satellite']['auth_token'] = 'super-secret-agent-token'

default['redborder']['redborder-satellite']['private_key_path'] = '/etc/redborder-satellite/redborder-satellite.key'

default['redborder']['redborder-satellite']['agent_id'] = node['hostname']

default['redborder']['redborder-satellite']['insecure_skip_verify'] = true

# List of remote commands allowed to be executed by the Hub
default['redborder']['redborder-satellite']['commands'] = {}
