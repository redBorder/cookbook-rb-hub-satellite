cookbook-rb-hub-satellite CHANGELOG
===============

## 1.1.0

  - Miguel Negrón
    - [5472f4f] Merge pull request #5 from redBorder/feature/#26715_make_backup_policy_compatible_with_proxies
  - manegron
    - [5472f4f] Merge pull request #5 from redBorder/feature/#26715_make_backup_policy_compatible_with_proxies
    - [4fdcafe] Merge branch 'development' into feature/#26715_make_backup_policy_compatible_with_proxies
  - Juan Soto
    - [300a899] Add device_shell option to rbsat_config to register the device_shell command
    - [3ba28c9] Add device_shell satellite command to run rb_device_shell on proxies
    - [15c198d] Add ftp_backup option to rbsat_config to register the FTP backup commands
    - [b50e4df] Add ftp_backup satellite commands to manage config-backup FTP accounts

## 1.0.0

  - Miguel Negrón
    - [d915256] Merge pull request #6 from redBorder/improvement/#157_do_not_use_a_standard_auth_token
  - Juan Soto
    - [463beb2] Restrict rendered satellite.json permissions to 0640
    - [ff7ef4b] Skip hub configuration without an auth_token, render registration_token and use 0640 for hub.json
    - [bf556cc] Remove the hardcoded default auth_token from the hub and satellite resources

## 0.1.1

  - manegron
    - [3e80963] Upload cookbook only if opscode-erchef is active

## 0.1.0

  - Nils
    - [01da697] fix bug if redborder-hub was down on 1 node

## 0.0.2

  - vimesa
    - [2daeedc] Add cookbook-rb-hub-satellite

## 0.0.1

  - vimesa
    - [aa2d5c7] Initial skel

