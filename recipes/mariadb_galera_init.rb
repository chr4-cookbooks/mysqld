#
# Cookbook Name:: mysqld
# Recipe:: mariadb_galera_init
#
# Copyright 2014, Chris Aumann
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

include_recipe 'mysqld::mariadb_repository'
include_recipe 'mysqld::mariadb_galera_install'

# Configure mysql/mariadb according to attributes, but start with
# --wsrep-new-cluster --wsrep_cluster_address=gcomm://", to initialize a new cluster
mysqld 'galera_init' do
  galera_init true
end

# Set password according to attribute, if set
mysqld_password 'root' do
  password node['mysqld']['root_password']
  only_if { node['mysqld']['root_password'] }
end

# Set debian-sys-maint password on Debian family
mysqld_password 'debian-sys-maint' do
  password node['mysqld']['root_password']
  only_if { node['mysqld']['root_password'] && node['platform_family'] == 'debian' }
end
