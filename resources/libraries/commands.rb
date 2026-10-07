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

    # Lets redborder-webui manage its ephemeral config-backup FTP/SFTP
    # accounts on a node it can't SSH into (a client proxy), through
    # cookbook-vsftpd's account script. Every argument is checked here and
    # again by the script itself. read's output (gzipped, base64) is capped
    # below the hub's 512 KB message limit; write takes its content on stdin,
    # which needs redborder-satellite's stdin_param support.
    def ftp_backup_satellite_commands
      script = '/usr/lib/redborder/bin/rb_ephemeral_ftp_account.sh'
      username = { 'regex' => '^ftp-[0-9a-f]{20}$', 'required' => true }
      filename = { 'regex' => '^[A-Za-z0-9][A-Za-z0-9._-]{0,127}$', 'required' => true }
      {
        'ftp_backup_account_create' => {
          'executable' => script,
          'args' => ['create'],
          'timeout_seconds' => 30,
        },
        'ftp_backup_account_delete' => {
          'executable' => script,
          'args' => ['delete', '$username'],
          'param_rules' => { 'username' => username },
          'timeout_seconds' => 30,
        },
        'ftp_backup_file_read' => {
          'executable' => script,
          'args' => ['read', '$username', '$filename'],
          'param_rules' => { 'username' => username, 'filename' => filename },
          'max_bytes' => 491520,
          'timeout_seconds' => 60,
        },
        'ftp_backup_file_write' => {
          'executable' => script,
          'args' => ['write', '$username', '$filename'],
          'stdin_param' => 'content',
          'param_rules' => {
            'username' => username,
            'filename' => filename,
            'content' => { 'regex' => '^[A-Za-z0-9+/=]+$', 'required' => true },
          },
          'timeout_seconds' => 60,
        },
      }
    end
  end
end
