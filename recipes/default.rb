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

case node['platform']
when "windows"

  unless pstools_installed?
unless
    windows_batch "unzip_pstools" do
      code <<-EOH
      7z.exe x #{node['pstools']['url']} -o#{node['pstools']['home']} -r -y
      EOH
    end    
  else
    Chef::Log.info("PSTools is already installed.")
  end
else
  Chef::Log.warn('PSTools can only be installed on the Windows platform.')
end


def pstools_installed?
  # TODO
  false
end
