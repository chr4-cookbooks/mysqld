#
# Cookbook Name:: mysqld
# Provider:: password
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
require 'shellwords'

action :set do
  r = execute "Assign mysql password for #{new_resource.user} user" do
    query = "UPDATE user SET authentication_string = PASSWORD('#{Shellwords.escape(new_resource.password)}') WHERE User = '#{Shellwords.escape(new_resource.user)}'"
    command %(mysql #{Shellwords.escape(new_resource.auth)} mysql -e "#{query}; FLUSH PRIVILEGES;")
    only_if %(mysql #{Shellwords.escape(new_resource.auth)} -e 'SHOW DATABASES;')
  end
  new_resource.updated_by_last_action(true) if r.updated_by_last_action?

  # Update debian.cnf if password for debian-sys-maint user is changed
  template '/etc/mysql/debian.cnf' do
    mode 0o600
    source 'debian.cnf.erb'
    variables password: Shellwords.escape(new_resource.password)
    only_if { new_resource.user == 'debian-sys-maint' }
  end
end
