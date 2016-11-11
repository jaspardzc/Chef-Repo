#
# Cookbook Name: dev_mongodb_cb
# Recipe:: stop_container
# 
# Copyright (c) 2016 The Auhtors, All Rights Reserved

# Manage required dependencies
require 'docker'

# get container name from environemnt attribute
container_name = node['mongodb']['container']['name']
container_network = node['mongodb']['container']['network']

# stop container using docker_container resource 
docker_container 'stop_mongodb_container' do
    container_name "#{container_name}"
    network_mode "#{container_network}"
    action :stop
end
