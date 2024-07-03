#!/bin/bash
#This file is helpful for the current bash session you are using
# To use these commands, in your current bash session type "source env.bash"
#if you have changed the name of services in the docker compose file, you have to change them here too so you can interact with them

# get the directory location and docker compose file location
export kamailio_handle_PRACK_project="./"
export kamailio_handle_PRACK_project_dockerfile="./docker-compose.yml"

# command to navigate to the repo
export go_to="cd $kamailio_handle_PRACK_project"

# $up: to start the project
# $down: to terminate and remove all containers of this docker compose file
# $docker_ps: get the docker container status, after executing $up, you should see 3 running containers "UAC, UAS and the kamailio".
export up="docker compose -f $kamailio_handle_PRACK_project_dockerfile up -d"
export down="docker compose -f $kamailio_handle_PRACK_project_dockerfile down -t0"
export docker_ps="docker compose -f $kamailio_handle_PRACK_project_dockerfile ps -a"

# after starting the compose project
# you can make a call from the UAC using only the 'alias' client_call
# $callee: use it when you made some change to the "./sipp_scenarios/uas.xml" in your host to restart the container to take the new scenario.
# $restart_proxy: use it when you've made some changes in the "./kamailio_configuration/kamailio.cfg" in your host
alias client_call='docker compose -f ${kamailio_handle_PRACK_project_dockerfile} exec -it the_caller sh -c "pkill sipp; sipp -aa -trace_err -sf sipp_scenarios/uac.xml -i 200.200.200.2 -p 5080 -s called_party 200.200.200.3:5060 -m 1"'
export callee="docker compose -f $kamailio_handle_PRACK_project_dockerfile restart -t0 the_callee"
export restart_proxy="docker compose -f $kamailio_handle_PRACK_project_dockerfile restart kamailio_sip_proxy -t0"

# $the_caller_sngrep: run the sngrep on the UAC SIPp injector
# $the_callee_sngrep: run the sngrep on the UAS SIPp injector
# $the_proxy_sngrep: run the sngrep on the Kamailio
export the_caller_sngrep="docker compose -f $kamailio_handle_PRACK_project_dockerfile exec -it the_caller sngrep"
export the_callee_sngrep="docker compose -f $kamailio_handle_PRACK_project_dockerfile exec -it the_callee sngrep"
export the_proxy_sngrep="docker compose -f $kamailio_handle_PRACK_project_dockerfile exec -it kamailio_sip_proxy sngrep"

#logs commands
# $the_caller_logs: docker logs of the UAC
# $the_callee_logs: docker logs of the UAS
# $the_proxy_logs: docker logs of the kamailio
export the_proxy_logs="docker compose -f $kamailio_handle_PRACK_project_dockerfile logs -f kamailio_sip_proxy"
export the_caller_logs="docker compose -f $kamailio_handle_PRACK_project_dockerfile logs -f the_caller"
export the_callee_logs="docker compose -f $kamailio_handle_PRACK_project_dockerfile logs -f the_callee"
