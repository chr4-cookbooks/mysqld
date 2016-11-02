#
# Cookbook Name:: mysqld
# Recipe:: install
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

# This way we force to have updated indexes
include_recipe 'apt'

# Install packages
case node['mysqld']['db_install']
when 'mariadb'
  Array(node['mysqld']['mariadb']['packages']).each { |pkg| package pkg }
when 'percona'
  # Always use the official percona repository, as some distributions
  # use percona-5.6, and the default attributes of this cookbook require 5.7
  include_recipe 'mysqld::percona_repository'
  Array(node['mysqld']['percona']['packages']).each { |pkg| package pkg }
else
  Array(node['mysqld']['mysql']['packages']).each { |pkg| package pkg }
end
