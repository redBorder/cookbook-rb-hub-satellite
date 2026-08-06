# Cookbook:: rb-hub-satellite
# Recipe:: default
# Copyright:: 2026, redborder
# License:: Affero General Public License, Version 3

rbhub_config 'Configure redborder-hub' do
  action :add
end

rbsat_config 'Configure redborder-satellite' do
  action :add
end
