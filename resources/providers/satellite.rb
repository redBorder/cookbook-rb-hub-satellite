# Cookbook:: rb-hub-satellite
# Provider:: satellite

provides :rbsat_config

include HubSatellite::Satellite
include HubSatellite::Helper
include HubSatellite::Commands

action :add do
  begin
    user = new_resource.user
    config_dir = new_resource.config_dir
    hub_url = new_resource.hub_url
    auth_token = new_resource.auth_token
    private_key_path = new_resource.private_key_path
    agent_id = new_resource.agent_id
    insecure_skip_verify = new_resource.insecure_skip_verify
    commands_input = new_resource.commands
    service_name = 'redborder-satellite'
    package_name = 'redborder-satellite'

    dnf_package package_name do
      action :upgrade
    end

    directory config_dir do
      owner user
      group user
      mode '0755'
      recursive true
    end

    resource_data = {
      'hub_url' => hub_url,
      'auth_token' => auth_token,
      'private_key_path' => private_key_path,
      'agent_id' => agent_id,
      'insecure_skip_verify' => insecure_skip_verify,
      'commands' => (commands_input && !commands_input.empty?) ? commands_input : default_satellite_commands,
    }

    template "#{config_dir}/satellite.json" do
      source 'satellite.json.erb'
      owner user
      group user
      mode '0644'
      cookbook 'rb-hub-satellite'
      retries 2
      variables(resource: resource_data)
      notifies :restart, "service[#{service_name}]", :delayed
    end

    key_dir = ::File.dirname(private_key_path)

    directory key_dir do
      owner user
      group user
      mode '0700'
      recursive true
      action :create
    end

    execute 'generate-satellite-ed25519-key' do
      command "openssl genpkey -algorithm Ed25519 -out #{private_key_path} && chown #{user}:#{user} #{private_key_path} && chmod 0600 #{private_key_path}"
      creates private_key_path
      notifies :restart, "service[#{service_name}]", :delayed
    end

    # Publish the satellite's public key to Chef Server so that the Hub can synchronize it
    ruby_block 'publish-satellite-public-key' do
      block do
        cmd = "openssl pkey -in #{private_key_path} -pubout -outform DER | tail -c 32 | base64 | tr -d '\n'"
        pub_key_base64 = `#{cmd}`.strip

        if !pub_key_base64.empty? && node.dig('redborder', 'redborder-satellite', 'public_key') != pub_key_base64
          node.normal['redborder']['redborder-satellite']['public_key'] = pub_key_base64
          node.save unless Chef::Config[:solo]
          Chef::Log.info("Public key for satellite #{agent_id} updated in Chef Server.")
        end
      end
      only_if { ::File.exist?(private_key_path) }
    end

    service service_name do
      service_name service_name
      ignore_failure true
      supports status: true, restart: true, start: true, reload: true, enable: true
      action [:enable, :start]
    end

    Chef::Log.info('redborder-satellite has been processed')
  rescue => e
    Chef::Log.error(e.message)
  end
end

action :remove do
  begin
    service 'redborder-satellite' do
      service_name 'redborder-satellite'
      ignore_failure true
      supports status: true, enable: true
      action [:stop, :disable]
    end

    Chef::Log.info('redborder-satellite service has been removed')
  rescue => e
    Chef::Log.error(e.message)
  end
end
