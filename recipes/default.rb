elast_ver = node['pip-elastalert']['version']
elast_repo = node['pip-elastalert']['repository']
elast_es_host = node['pip-elastalert']['elasticsearch']['hostname']
elast_es_port = node['pip-elastalert']['elasticsearch']['port']
elast_es_index = node['pip-elastalert']['elasticsearch']['index']
elast_es_old_index = node['pip-elastalert']['elasticsearch']['index_old']
elast_es_url_prefix = node['pip-elastalert']['elasticsearch']['url_prefix']
elast_es_index_create_opts = node['pip-elastalert']['elasticsearch']['create_index_opts']
elast_group = node['pip-elastalert']['group']
elast_user = node['pip-elastalert']['user']
elast_user_home = node['pip-elastalert']['user_home']
elast_dir = node['pip-elastalert']['directory']
elast_rules_dir = node['pip-elastalert']['rules_directory']
elast_venv = node['pip-elastalert']['virtualenv']['directory']
elast_log_dir = node['pip-elastalert']['log_dir']
supervisor_logfile_path = node['pip-elastalert']['supervisor']['logfile']
supervisor_logfile_size = node['pip-elastalert']['supervisor']['logfile_maxbytes']
supervisor_logfile_backups = node['pip-elastalert']['supervisor']['logfile_backups']
supervisor_err_logfile_path = node['pip-elastalert']['supervisor']['err_logfile']
supervisor_err_logfile_size = node['pip-elastalert']['supervisor']['err_logfile_maxbytes']
supervisor_run_command = node['pip-elastalert']['supervisor']['run_command']

group elast_group

user elast_user do
  group elast_group
  home elast_user_home
  manage_home true
end

directory elast_dir do
  owner elast_user
  group elast_group
  mode '0755'
end

# needed for python
build_essentials = node['platform'] == 'centos' ? %w(make automake gcc gcc-c++ kernel-devel python-devel) : %w(build-essential python-dev)

build_essentials.each do |package|
  package package
end

python_runtime '2' # requriment of elastalert

python_virtualenv elast_venv do
  group elast_group
  user elast_user
  not_if { ::File.exist?(elast_venv) }
end

python_package 'elastalert' do
    group elast_group
    user elast_user
    virtualenv elast_venv
    package_name 'elastalert'
  version elast_ver
end

python_execute 'setup elastalert index' do
  command "#{elast_venv}/bin/elastalert-create-index --host #{elast_es_host} --port #{elast_es_port} --index '#{elast_es_index}' --url-prefix '#{elast_es_url_prefix}' --old-index '#{elast_es_old_index}' #{elast_es_index_create_opts}"
  user elast_user
  group elast_group
  virtualenv elast_venv
  cwd elast_dir
  not_if "curl -XGET 'http://#{elast_es_host}:#{elast_es_port}/#{elast_es_index}/' -s | grep '@timestamp'"
end

directory elast_rules_dir do
    owner elast_user
    group elast_group
    mode '0755'
    recursive true
    action :create
end

include_recipe 'supervisor'

template "#{elast_dir}/config.yml" do
  source 'config.yml.erb'
  owner elast_user
  group elast_group
  mode '0755'
end

directory elast_log_dir do
  user elast_user
  group elast_group
  mode '0755'
end

supervisor_service 'elastalert' do
  action [:enable, :start]
  autostart true
  user elast_user
  stdout_logfile supervisor_logfile_path
  stdout_logfile_maxbytes supervisor_logfile_size
  stdout_logfile_backups supervisor_logfile_backups
  directory '%(here)s'
  serverurl 'unix:///var/run/elastalert_supervisor.sock'
  startsecs 15
  stopsignal 'INT'
  stderr_logfile supervisor_err_logfile_path
  stderr_logfile_maxbytes supervisor_err_logfile_size
  command supervisor_run_command
end
