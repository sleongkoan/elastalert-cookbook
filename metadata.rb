name 'pip_elastalert'
maintainer 'Stephen Leong Koan'
maintainer_email 'sleongkoan@gmail.com'
license 'Apache 2.0'
description 'Installs/Configures elastalert'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '1.0.1'

supports 'debian'

depends 'poise-python'
depends 'managed_directory'
depends 'supervisor'

source_url 'https://github.com/sleongkoan/pip-elastalert-cookbook' if respond_to?(:source_url)
issues_url 'https://github.com/sleongkoan/pip-elastalert-cookbook/issues' if respond_to?(:issues_url)
