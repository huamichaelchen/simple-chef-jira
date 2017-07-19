#
# Cookbook:: jira-vm-creation
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

# Step 1: download JIRA

directory '/etc/atlassian/jira' do
  owner 'root'
  group 'root'
  mode '0755'
  recursive true
  action :create
end

remote_file '/etc/atlassian/jira/atlassian-jira-software-7.4.1-x64.bin' do
  source 'https://www.atlassian.com/software/jira/downloads/binary/atlassian-jira-software-7.4.1-x64.bin'
  owner 'root'
  group 'root'
  mode '0755'
  action :create
  not_if { File.exist? ('/etc/atlassian/jira/atlassian-jira-software-7.4.1-x64.bin') }
end

template '/etc/atlassian/jira/response.varfile' do
  source 'response.varfile.erb'
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

# Step 2: install Java (Oracle)

execute 'install wget' do
  command 'sudo yum install -y wget'
  action :run
  not_if 'which wget'
end

execute 'download java' do
  command "wget --no-cookies --no-check-certificate --header 'Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie' 'http://download.oracle.com/otn-pub/java/jdk/8u141-b15/336fa29ff2bb4ef291e347e091f7f4a7/jdk-8u141-linux-x64.rpm'"
  action :run
  not_if { File.exist?('./jdk-8u141-linux-x64.rpm') }
end

# Step 4: Install JIRA
execute 'run command to install jira' do
  command '/etc/atlassian/jira/atlassian-jira-software-7.4.1-x64.bin -q -varfile /etc/atlassian/jira/response.varfile'
  action :run
  not_if { File.exist?('/etc/init.d/jira') }
end
