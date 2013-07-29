#
# Cookbook Name:: mysqld
# Recipe:: default
#
# Copyright 2013, Chris Aumann
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

# Install required packages
Array(node['mysqld']['packages']).each { |pkg| package pkg }

# Generate my.cnf from attributes
my_cnf = ''
node['mysqld']['my.cnf'].each do |category, config|
  my_cnf << "[#{category}]\n"
  config.each { |key, value| my_cnf << "#{key} = #{value}\n" }
  my_cnf << "\n"
end

# Add includedir on debian/ubuntu
my_cnf << "!includedir /etc/mysql/conf.d/\n" if node['platform_family'] == 'debian'

template 'my.cnf' do
  path      node['mysqld']['my.cnf_path']
  mode      00644
  source    'my.cnf.erb'
  variables :config => my_cnf
end

service node['mysqld']['service_name'] do
  subscribes :restart, 'template[my.cnf]'
  action   [ :enable, :start ]
end
