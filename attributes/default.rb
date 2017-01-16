default['pip-elastalert']['version'] = nil

default['pip-elastalert']['elasticsearch']['hostname'] = 'localhost'
default['pip-elastalert']['elasticsearch']['port'] = 9200
default['pip-elastalert']['elasticsearch']['index'] = 'elastalert_status'
default['pip-elastalert']['elasticsearch']['index_old'] = ''
default['pip-elastalert']['elasticsearch']['url_prefix'] = ''
default['pip-elastalert']['elasticsearch']['create_index_opts'] = '--no-auth --no-ssl'
default['pip-elastalert']['elasticsearch']['run_every']['unit'] = 'minutes'
default['pip-elastalert']['elasticsearch']['run_every']['value'] = 1
default['pip-elastalert']['elasticsearch']['buffer_time']['unit'] = 'minutes'
default['pip-elastalert']['elasticsearch']['buffer_time']['value'] = 15
default['pip-elastalert']['elasticsearch']['alert_time_limit']['unit'] = 'days'
default['pip-elastalert']['elasticsearch']['alert_time_limit']['value'] = 2
default['pip-elastalert']['log_dir'] = '/var/log/elastalert'

default['pip-elastalert']['user'] = 'elastalert'
default['pip-elastalert']['user_home'] = "/home/#{node['elastalert']['user']}"
default['pip-elastalert']['group'] = 'elastalert'
default['pip-elastalert']['directory'] = '/opt/elastalert'
default['pip-elastalert']['rules_directory'] = "#{node['elastalert']['directory']}/rules"
default['pip-elastalert']['virtualenv']['directory'] = "#{node['elastalert']['directory']}/.env"

default['pip-elastalert']['supervisor']['logfile'] = "#{node['elastalert']['log_dir']}/elastalert_supervisord.log"
default['pip-elastalert']['supervisor']['logfile_maxbytes'] = '1MB'
default['pip-elastalert']['supervisor']['logfile_backups'] = 2
default['pip-elastalert']['supervisor']['err_logfile'] = "#{node['elastalert']['log_dir']}/elastalert_stderr.log"
default['pip-elastalert']['supervisor']['err_logfile_maxbytes'] = '5MB'
default['pip-elastalert']['supervisor']['run_command'] = "#{node['elastalert']['virtualenv']['directory']}/bin/elastalert --config #{node['elastalert']['directory']}/config.yml --verbose"
