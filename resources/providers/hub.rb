# Cookbook:: rb-hub-satellite
# Provider:: hub

provides :rbhub_config

include HubSatellite::Hub

action :add do
  begin
    user = new_resource.user
    config_dir = new_resource.config_dir
    cdomain = new_resource.cdomain
    hub_hosts = new_resource.hub_hosts
    hub_port = new_resource.hub_port
    auth_token = new_resource.auth_token
    authorized_keys_dir = new_resource.authorized_keys_dir
    advertise_peers = new_resource.advertise_peers
    service_name = 'redborder-hub'
    package_name = 'redborder-hub'



    dnf_package package_name do
      action :upgrade
    end

    directory config_dir do
      owner user
      group user
      mode '0755'
      recursive true
    end

    directory authorized_keys_dir do
      owner user
      group user
      mode '0755'
      recursive true
      action :create
    end

    def resolve_ip(n)
      ip = n['ipaddress_sync']
      ip = n['ipaddress'] if ip.nil? || ip.to_s.empty?
      ip
    end

    my_ip = resolve_ip(node)
    my_url = "http://#{my_ip}:#{hub_port}"

    own_short_hostname = node['hostname'].to_s.split('.').first
    peer_urls = []

    hub_hosts.each do |hub_hostname|
      short_hostname = hub_hostname.to_s.split('.').first
      next if short_hostname.nil? || short_hostname == own_short_hostname

      peer_node = search(:node, "hostname:#{short_hostname}").first
      next if peer_node.nil?

      peer_ip = resolve_ip(peer_node)
      next if peer_ip.nil? || peer_ip.to_s.empty?

      peer_urls << "http://#{peer_ip}:#{hub_port}"
    end

    resource_data = {
      'addr' => ":#{hub_port}",
      'auth_token' => auth_token,
      'authorized_keys_dir' => authorized_keys_dir,
      'my_url' => my_url,
      'peers' => peer_urls.sort.uniq,
      'advertise_peers' => advertise_peers,
    }

    template "#{config_dir}/hub.json" do
      source 'hub.json.erb'
      owner user
      group user
      mode '0644'
      cookbook 'rb-hub-satellite'
      retries 2
      variables(resource: resource_data)
      notifies :restart, "service[#{service_name}]", :delayed
    end

    service service_name do
      service_name service_name
      ignore_failure true
      supports status: true, restart: true, start: true, reload: true, enable: true
      action [:enable, :start]
    end

    Chef::Log.info('redborder-hub has been processed')
  rescue => e
    Chef::Log.error(e.message)
  end
end

action :remove do
  begin
    service 'redborder-hub' do
      service_name 'redborder-hub'
      ignore_failure true
      supports status: true, enable: true
      action [:stop, :disable]
    end

    Chef::Log.info('redborder-hub service has been removed')
  rescue => e
    Chef::Log.error(e.message)
  end
end

action :register do
  begin
    hub_port = new_resource.hub_port

    unless node['redborder']['redborder-hub']['registered']
      query = {}
      query['ID'] = "redborder-hub-#{node['hostname']}"
      query['Name'] = 'redborder-hub'
      query['Address'] = node['ipaddress'].to_s
      query['Port'] = hub_port
      query['Tags'] = ['hub']
      json_query = Chef::JSONCompat.to_json(query)

      execute 'Register redborder-hub in consul' do
        command "curl -s -X PUT http://localhost:8500/v1/agent/service/register -d '#{json_query}' &>/dev/null"
        retries 3
        retry_delay 2
        action :nothing
      end.run_action(:run)

      node['redborder']['redborder-hub']['registered'] = true
      Chef::Log.info('redborder-hub service has been registered to consul')
    end
  rescue => e
    Chef::Log.error(e.message)
  end
end

action :deregister do
  begin
    if node['redborder']['redborder-hub']['registered']
      execute 'Deregister redborder-hub in consul' do
        command "curl -s -X PUT http://localhost:8500/v1/agent/service/deregister/redborder-hub-#{node['hostname']} &>/dev/null"
        action :nothing
      end.run_action(:run)

      node['redborder']['redborder-hub']['registered'] = false
      Chef::Log.info('redborder-hub service has been deregistered from consul')
    end
  rescue => e
    Chef::Log.error(e.message)
  end
end
