module HubSatellite
  module Commands
    def default_satellite_commands
      {
        'service_ctl' => {
          'executable' => '/usr/bin/systemctl',
          'args' => ['$action', '$service'],
          'param_rules' => {
            'action' => {
              'allowed_values' => %w(status restart reload),
              'required' => true,
            },
            'service' => {
              'regex' => '^[a-zA-Z0-9_-]+$',
              'required' => true,
            },
          },
          'timeout_seconds' => 30,
        },
        'cat_log' => {
          'type' => 'file_read',
          'allowed_paths' => [
            '/var/log/kafka/*.log',
            '/var/log/syslog',
          ],
          'max_bytes' => 524288,
        },
      }
    end
  end
end
