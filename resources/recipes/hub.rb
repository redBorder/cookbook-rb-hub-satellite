# Cookbook:: rb-hub-satellite
# Recipe:: hub
# Copyright:: 2026, redborder
# License:: Affero General Public License, Version 3

rbhub_config 'Configure redborder-hub' do
  cdomain node['redborder']['cdomain']
  action :add
end
