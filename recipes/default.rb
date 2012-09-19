#
# Cookbook Name cloudfoundry-health_manager
# Recipe default
#
# Copyright 2012, Trotter Cashion
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http//www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
if Chef::Config[:solo]
 Chef::Log.warn("This recipe uses search. Chef Solo does not support search.")

else 

  m_nodes = search(:node, "role:cloudfoundry_controller")
  m_node = m_nodes.first
  if m_nodes.count > 0 
    node.set['cloudfoundry_health_manager']['database_host '] = m_node.ipaddress
    node.set['cloudfoundry_health_manager']['database_name'] = m_node.cloudfoundry_cloud_controller.database.name
    node.set['cloudfoundry_health_manager']['postgres_password']= m_node.postgresql.password.postgres
  end 

  nats_nodes = search(:node, "role:cloudfoundry_nats_server")
  nats_node_first = nats_nodes.first
  if nats_nodes.count > 0  
    node.set['cloudfoundry_health_manager']['nats_user']= nats_node_first.nats_server.user
    node.set['cloudfoundry_health_manager']['nats_password']= nats_node_first.nats_server.password
    node.set['cloudfoundry_health_manager']['nats_host']= nats_node_first.ipaddress
    node.set['cloudfoundry_health_manager']['nats_port']= nats_node_first.nats_server.port
  end 

end

cloudfoundry_component "health_manager"


