####################################################################################
# Cookbook Name: dev_tomcat_cb
# Recipe:: create_container
# Strategy: create the tomcat container iteratively, skip if container already exists
# Copyright (c) 2016 The Auhtors, All Rights Reserved
# Last Updated: 11/19/2016
# Author: kevin.zeng
#####################################################################################

# import dependencies
require 'docker'

# import available tomcat container list from node attributes
tomcat = node['tomcat']['available']

# create the containers iteratively
tomcat.each do |container|
  # using docker resource to create new docker container
  docker_container "create_tomcat_container: #{container['container_name']}" do
    container_name "#{container['container_name']}"
    repo 'DEV-050.node:8082/stdtomcatbox'
    tag '2.0'
    host_name "#{container['container_name']}.ssphosting.net"
    memory Integer('4000000000')
    memory_swap Integer('5000000000')
    open_stdin true
    tty true
    user 'devadmin'
    port "#{container['container_port']}"
    volumes ["/dev/containers/certs:/devcerts", "/dev/containers/#{container['container_name']}:/devext", "/backup/containers/#{container['container_name']}:/backup"]
    network_disabled false
    network_mode "#{container['container_network']}"
    log_opts ['max-size=2m']
    env ['JAVA_MEM_OPTS=-Xms1024m -Xmx4096m -XX:MaxPermSize=512m', 'JAVA_OTH_OPTS=-Denv=prod -DlogBasePath=/devext/softwares/tomcat-a/logs']
    action :create
  end
end
