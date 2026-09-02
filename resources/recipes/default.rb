# Cookbook:: rb-hub-satellite
# Recipe:: default
# Copyright:: 2026, redborder
# License:: Affero General Public License, Version 3

if node.dig('redborder', 'services', 'redborder-hub')
  include_recipe 'rb-hub-satellite::hub'
end

if node.dig('redborder', 'services', 'redborder-satellite')
  include_recipe 'rb-hub-satellite::satellite'
end

