#
# Cookbook Name:: cloudfoundry-health_manager
# Recipe:: default
#
# Copyright 2012, Trotter Cashion
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

m_nodes = search(:node, "role:cloudfoundry_controller")
m_node = m_nodes.first

node.set[:cloudfoundry_health_manager][:database_host ] = m_node.ipaddress
node.set[:cloudfoundry_health_manager][:database_name] = m_node.cloudfoundry_cloud_controller.database.name
node.set[:cloudfoundry_health_manager][:postgres_password]= m_node.postgresql.password.postgres

node.set[:cloudfoundry_health_manager][:nats_user]= m_node.nats_server.user
node.set[:cloudfoundry_health_manager][:nats_password]= m_node.nats_server.password
node.set[:cloudfoundry_health_manager][:nats_host]= m_node.ipaddress
node.set[:cloudfoundry_health_manager][:nats_port]= m_node.nats_server.port


cloudfoundry_component "health_manager"
