############### SCALEABLE MAGENTO INFRASTRUCTURE ###################
 created: 2018-04-10<br>
 runs on docker swarm mode 17.12+<br>
 needs at least 3 nodes, stick to odd numbers of nodes for quorum decisions<br>
<br>
 ALL VOLUMES AND CONFIG FILES NEED TO BE AVAILABLE ON ALL NODES, THIS IS DONE BY RSYNCER<br>
<br>
<br>
 all service follow the naming convention <function><software><br>
 e.g. frontendnginx, fullpagecachevarnish, sessionredismaster<br>
 the nodes names are gmt-prod-1, gmt-prod-2, gmt-prod-3<br>
 notes:<br>
 docker swarm mode is not yet able to limit a service to 1 instance per <br>
 the workaround for this is to set a service mode to <br>
 "global" (1 instance per each node) <br>
 and limit its deployment by placement constraints<br>
 this is used here for services that should only run once, <br>
 because the use a writeable volume, e.g. galera.<br>
<br>
 galera specific startup instructions:<br>
 lets assume 3 node with the names gmt-prod-1, gmt-prod-2 and gmt-prod-3<br>
 make sure all node have their <br>
 dbnode and dbseed label set to 0 <br>
 with "docker node update --label-add dbnodegalera=0 <gmt-prod-1, gmt-prod-2, gmt-prod-3>" <br>
 and "docker node update --label-add dbseedgalera=0 <gmt-prod1, gmt-prod-2, gmt-prod-3>" <br>
 (of course one command for each node)<br>
 <br>
 first, you need to log in to the registry with: "docker login registry.devgmt.com"<br>
 after deployment with "docker stack deploy --with-registry-auth -c docker-compose.yml <stackname>"<br>
 e.g. "docker stack deploy --with-registry-auth -c docker-compose.yml magento"<br>
 you should at first start a "seed" node <br>
 with "docker node update --label-add dbseedgalera=1 gmt-prod-1" <br>
 (it does not matter which node, choose the one you guess has <br>
 the most current/intact data)<br>
 <br>
 verify you node is up with "docker ps" on the corresponding node<br>
 verify docker has set the vip and its dns entry with: <br>
 "docker exec <seedcontainerid> getent dbseedgalera"<br>
 it should give you an ip. Otherwise you can enforce it with <br>
 "docker service update --force magento_dbseedgalera" <br>
 but it should only be a temporary fix. <br>
 Fix your docker installation, <br>
 i had trouble with paravirtualized linux xen domU as docker node. It works with <br>
 hvm nodes.<br>
 <br>
 After the seed node is up, start two dbnodegalera on _different_ nodes than <br>
 the seed node by <br>
 "docker node update --label-add dbnodegalera=1 <gmt-prod-2, gmt-prod-3>" <br>
 (again 1 command for each node, the nodes that are _not_ the seed node)<br>
 verify the vip and dns is up, it may take a while: <br>
 "docker exec <seedcontainerid> getent dbnodegalera"<br>
 when the vip is up, check one of the nodes for a completed resync: <br>
 "docker ps" followed by "docker logs <nodecontainerid>"<br>
 when the dbnodes are synced, upgrade the seed node by: <br>
 "docker node update --label-add dbnodegalera=1 node1" <br>
 (or whatever node you have chosen at start).<br>
 <br>
 After the shutdown and restart, disable the dbseed  <br>
 "docker node update --label-add dbseedgalera=0 node1" <br>
 (or whatever node you have chosen at start)<br>
 <br>
 Check if it syncs correctly.<br>
 galera is now working on all 3(5,7) nodes.<br>
 repeat this for each startup, whenever you took down galera. <br>
 Spinning up and down instances is no problem, <br>
 as long as at least a mayority of nodes stays up.<br>
<br>
 these steps can be done with:<br>
 init_db.sh        #  starts the seed<br>
 startup_db.sh     #  starts the nodes<br>
 operate_db.sh     #  swithes seed to node<br>
 <br>
 for smooth shutdown use:<br>
 shutdown_db.sh<br>
 <br>
 All services are placement constrained. This means, all of them need a label<br>
 <servicename>=1 on the node they should be allowed to run on, just like the<br>
 database. E.g. to run frontendnginx on gmt-prod-1 you need to issue:<br>
 docker node update --label-add frontendnginx=1 gmt-prod-1<br>
 This has to be done for each service and node separately, but the labels will<br>
 be retained, so it has to be done only once, when the cluster is created.<br>
 The labels can be used to control _placement_<br> 
 Keep in mind, that scaling is different. If a service is allowed only on one node<br>
 but is set for 3 replicas, all of them will be started on that one node.<br>
 Scaling can be done with:<br>
 "docker service scale magento_frontendnginx=3"<br>
 <br>
 The services should be started in functional order after node creation:<br>
 dbseedgalera<br>
 dbnodegalera<br>
 sessionredismaster<br>
 sessionredisslave<br>
 cacheredismaster<br>
 cacheredisslave<br>
 applicationphp<br>
 backendnginx<br>
 fullpagecachevarnish<br>
 frontendnginx<br>
 <br>
 If we produce a reasonably inviting error page in case of 502, we might start<br>
 frontendnginx in the beginning.<br>
 
File syncronisation is done by the rsyncer service. Mount volume you need synced<br>
below its /opt/synfiles directory. As an exception to the placement rule, it<br>
will start  alongside the applicationphp service and uses its constrainment label.<br>
