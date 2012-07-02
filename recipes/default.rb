#
# Author:: Joe Fitzgerald (<joe.fitzgerald@emc.com>)
# Cookbook Name:: pstools
# Recipe:: default
#
# Copyright 2012, EMC Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

case node[:platform]
when "windows"

  #unless pstools_installed?
    # Create Temporary Directory
    ["#{node[:pstools][:tempdir]}"].each do |dir|
      log("create #{dir} directory if necessary") { level :debug }
      directory "#{dir}" do
        action :create
        not_if { File.exists?("#{dir}") }
        recursive true
      end
    end

    # Download PSTools
    remote_file "#{node[:pstools][:file]}" do      
      action :create
      backup false
      source "#{node[:pstools][:url]}"
      checksum "#{node[:pstools][:checksum]}"
      path "#{node[:pstools][:tempdir]}\\#{node[:pstools][:file]}"
    end
    
    # Unzip PSTools
    windows_batch "unzip_pstools" do
      code <<-EOH
      7z.exe x #{node[:pstools][:tempdir]}\\#{node[:pstools][:file]} -o#{node[:pstools][:home]} -r -y
      EOH
    end  
      
    # Update path
    windows_path node[:pstools][:home] do
      action :add
    end
    
    # Remove Temporary directory
    ["#{node[:pstools][:tempdir]}"].each do |dir|
      log("delete #{dir} directory if necessary") { level :debug }
      directory "#{dir}" do
        action :delete
        recursive true
      end
    end
  #else
  #  Chef::Log.info("PSTools is already installed.")
  #end
else
  Chef::Log.warn('PSTools can only be installed on the Windows platform.')
end


def pstools_installed?
  # TODO
  false
end
