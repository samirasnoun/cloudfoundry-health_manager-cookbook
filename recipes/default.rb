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


# For the nokogiri dependency
#package "libxml2"
#package "libxml2-dev"
#package "libxslt1-dev"

# For the sqlite3 dependency
#package "sqlite3"
#package "libsqlite3-dev"

Chef::Log.warn("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")

Chef::Log.warn("node['cloudfoundry_health_manager']['cf_session']['cf_id'] = " +  node['cloudfoundry_health_manager']['cf_session']['cf_id'] )

Chef::Log.warn("node['cloudfoundry_cloud_controller']['cf_session']['cf_id'] = " +  node['cloudfoundry_cloud_controller']['cf_session']['cf_id'] )

#Chef::Log.warn("node['cloudfoundry_dea']['cf_session']['cf_id'] = " +  node['cloudfoundry_dea']['cf_session']['cf_id'] )

Chef::Log.warn("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")



  cf_id_node = node['cloudfoundry_health_manager']['cf_session']['cf_id']
  m_nodes = search(:node, "role:cloudfoundry_controller AND cf_id:#{cf_id_node}" )

       while m_nodes.count < 1 
        Chef::Log.warn("Waiting for Controller .... I am sleeping 7 sec")
        sleep 7
        m_nodes = search(:node, "role:cloudfoundry_controller AND cf_id:#{cf_id_node}")        
       end

  k = node
          node.set['cloudfoundry_health_manager']['database_host'] = k['ipaddress']
          node.set['cloudfoundry_health_manager']['database_name'] = k['cloudfoundry_cloud_controller']['database']['name']
          node.set['cloudfoundry_health_manager']['postgres_password']= k['postgresql']['password']['postgres']

#   if(node['cloudfoundry_health_manager']['database_host'] == nil ) then 
#        Chef::Log.warn("No cloud controller found for this cloud foundry session =  " + node.ipaddress)
#   end 
  
  nats_nodes = search(:node, "role:cloudfoundry_nats_server AND cf_id:#{cf_id_node}" )
 
       while nats_nodes.count < 1     
        Chef::Log.warn("Waiting for Nats .... I am sleeping 7 sec")
        sleep 7
        nats_nodes = search(:node, "role:cloudfoundry_nats_server AND cf_id:#{cf_id_node}")      
       end

       j= nats_nodes.first
      	    node.set['searched_data']['nats_user']= j['nats_server']['user']
            node.set['searched_data']['nats_password'] = j['nats_server']['password']
            node.set['searched_data']['nats_host']= j['ipaddress']
            node.set['searched_data']['nats_port']= j['nats_server']['port']
       
  # if(node['']['nats_server']['host'] == nil ) then 
#	        Chef::Log.warn("No nats servers found for this cloud foundry session =  " + node.ipaddress)
#   end 

cloudfoundry_component "health_manager"
node.save

# For the nokogiri dependency
package "libxml2"
package "libxml2-dev"
package "libxslt1-dev"

# For the sqlite3 dependency
package "sqlite3"
package "libsqlite3-dev"


end
