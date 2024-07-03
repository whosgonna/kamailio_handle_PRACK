
# Summary
[1.Components](#1.-Components)

[2. Network Configuration](#2.-Network-Configuration)

[3. Building the Docker Images](#3.-Building-the-Docker-Images)


[4. Steps to Build Docker Image](#4.-Steps-to-Build-Docker-Image)


[5. Interact with the docker compose project](5.-Interact-with-the-docker-compose-project)


[6. Steps to follow](#6.-Steps-to-follow)


[7. Expected results](#7.-Expected-results)


[8. Files and directories description in this Repository](#8.-Files-and-directories-description-in-this-Repository)


[9. Conclusion](#9.-Conclusion)

# Kamailio SIP INVIE-PRACK-Negative SIP Response Scenario Handling
This repository is a docker compose containing Kamailio as a SIP Proxy and SIPp as the UAC and UAS. It handles a scenario when Kamailio receives a negative SIP response (e.g., 486) from the UAS, processes it in the ***failure_route***, and sends a different SIP response to the UAC.

# 1. Components
- Kamailio 5.7.5 (SIP Proxy)
- SIPp (SIP injector for UAC and UAS)

# 2. Network Configuration
- UAC SIP Address: **200.200.200.2:5080**
- Kamailio SIP Address: **200.200.200.3:5060**
- UAS SIP Address: **200.200.200.4:5060**
  
# 3. Building the Docker Images
The Dockerfiles for Kamailio and SIPp are located in ***./kamailio_handle_PRACK/dockerfiles***. To set up the environment, you need to build a Docker image for Kamailio version 5.7.5 in the ***kamailio_handle_PRACK/dockerfiles/kamailio\ 5.7.5*** directory. If you already have the Kamailio Docker image, you can use it _and change the image value_ in the **docker-compose.yml** file. The same applies to the SIPp Dockerfile located in ***kamailio_handle_PRACK/dockerfiles/SIPp***.

# 4. Steps to Build Docker Image
# 4.1. Building kamailio 5.7.5 docker image
Navigate to the directory containing the kamailio 5.7.5 Dockerfile, then run the build command:
```bash
cd ./kamailio_handle_PRACK/dockerfiles/kamailio\ 5.7.5
docker builder build -t debian_11_kamailio:5.7.5 .
#or
docker  build -t debian_11_kamailio:5.7.5 .
```

# 4.2. Building SIPp docker image
Navigate to the directory containing the SIPp Dockerfile, then run the build command:
```bash
cd ./kamailio_handle_PRACK/dockerfiles/SIPp
docker builder build -t debian-sipp:latest .
#or
docker build -t debian-sipp:latest .
```

# 5. Interact with the docker compose project
You can interact with this docker compose project in two ways, the first one it to type directly the commands to launch the SIPp call, launch the sngrep application and gettings logs or execute the ***./kamailio_handle_PRACK/env.bash*** bash file which contains bash shortcuts to interact with the docker containrs like making calls, launching the sngrep on the containers... Read the ***./kamailio_handle_PRACK/env.bash*** file for more details.

## 5.1. Choice 1: Using env.bash Shortcuts and Aliases (Optional for Linux Users)

### 5.1.1. Execute the *env.bash* file
Navigate to the directory containing the ***env.bash*** file, then execute it:
```bash
cd ./kamailio_handle_PRACK/
source env.bash
```

### 5.1.2. Basic commands from env.bash
To **start** the docker compose containers, type:
```bash
$up
```
To **stop** the docker compose project, type:
```bash
$down
```
To get the stats of containers, type
```bash
$docker_ps
```

### 5.1.3. Commands to get the container's logs & launch SNGRep
To **get logs** of each container, type:
```bash
 $the_proxy_logs #get the kamailio container's logs
 $the_caller_logs #get the UAC container's logs
 $the_callee_logs #get the UAS container's logs
```
To **launch SNGRep application** on each container type:
```bash
$the_proxy_sngrep #launch sngrep on the kamailio container
$the_caller_sngrep #launch sngrep on the UAC container
$the_callee_sngrep #launch snrep on the UAS container
```

### 5.1.4. Other important commands (start the UAC, restart UAS and kamailio)
Launch the call from the UAC, type the following alias **client_call** (note: it is not a shortcut starting with $):
```bash
client_call #this alias is well defined in the env.bash file, it starts the sipp as UAC and sends SIP requests to the kamailio
```
In case you did some changes to the UAS xml file scenario located in the host ***./kamailio_handle_PRACK/sipp_scenarios/uas.xml*** and you want to resart the UAS SIPp container type:
```bash
$callee #this will just restart the container
```
In case you did some changes to the kamailio configuration file located in the host ***./kamailio_handle_PRACK/kamailio_configuration/kamailio.cfg*** and you want to resart kamailio, type:
```bash
$restart_proxy
```

## 5.2. Choice 2: Direct Interaction with Docker Compose
### 5.2.1. Basic commands
To **start** the docker compose containers, type:
```bash
docker compose up -d
```
To **stop** the docker compose project, type:
```bash
docker compose down -t0
```
To get the stats of containers, type
```bash
docker compose ps -a
```
### 5.2.2. Commands to get the container's logs & launch SNGRep
To **get logs** of each container, type:
```bash
 docker compose logs -f container_name
```
To **launch SNGRep application** on each container type:
```bash
docker compose exec -it conainer_name sngrep
```

### 5.2.3. Other important commands (start the UAC, restart UAS and kamailio)
Launch the call from the UAC, type the following alias **client_call** (note: it is not a shortcut starting with $):
```bash
docker compose exec -it the_caller sh -c "pkill sipp; sipp -aa -trace_err -sf sipp_scenarios/uac.xml -i 200.200.200.2 -p 5080 -s called_party 200.200.200.3:5060 -m 1"
```
In case you did some changes to the UAS xml file scenario located in the host ***./kamailio_handle_PRACK/sipp_scenarios/uas.xml*** and you want to resart the UAS SIPp container type:
```bash
docker compose restart -t0 the_callee
```
In case you did some changes to the kamailio configuration file located in the host ***./kamailio_handle_PRACK/kamailio_configuration/kamailio.cfg*** and you want to resart kamailio, type:
```bash
docker compose restart kamailio_sip_proxy -t0
```

# 6. Steps to follow
1. Build the Docker images or use your own Docker images.
2. If using your own Docker images, ensure to change the volumes path in the **docker-compose.yml file** to take the kamailio configuration file.
3. Start the Docker Compose project.
4. Start SNGRep on each container to capture SIP traffic or use SNGRep on your host machine.
5. Launch the call from the UAC. The UAS is already running (check the docker-compose.yml file).
6. Check SNGRep in Kamailio to see the changes made to the "To" tag in the forwarded Negative SIP message reply.

# 7. SIP Scenario Description
1. UAC sends an INVITE to Kamailio (including 100rel in Require & Supported headers).
2. Kamailio replies to the INVITE with 100 Trying.
3. Kamailio forwards the INVITE to UAS.
4. UAS responds with 100 Trying and 180 Ringing (with RSeq and 100rel required), the 180 Ringing contains the "To" Tag.
5. Kamailio forwards the 180 Ringing reply to the UAC.
6. UAC sends PRACK (with RAck header).
7. Kamailio forwards the PRACK to UAS.
8. UAS responds with 200 OK to the PRACK.
9. Kamailio forwards the 200 OK to the UAC.
10. UAS responds with **486 Busy Here** final response to the INVITE transaction and sends it to Kamailio.
11. Kamailio receives the final response from the UAS, enters the failure_route, and sends a new reply using **send_reply** or **t_send_reply**. The reply sent from Kamailio has a different "To" tag from the previous SIP messages.
12. UAC receives the final response from Kamailio.
13. UAC sends an ACK to finish the INVITE transaction.


# 7. Expected results
When Kamailio receives the Client Error SIP Reply "486 Busy here in this case, you can change to what ever >399 SIP Response, the same behaviour occurs" and executes the **send_reply** or **t_send_reply** methods, it should keep the same "To" tag in the generated SIP response.

# 8. Files and directories description in this Repository
- docker-compose.yml: A file which defines the services/containers, each with a volume to take the new configuration of kamailio.cfg and SIPp scenarios, as well as the network configuration.
- env.bash: A file contains important shortcuts to execute commands
- sipp_scenarios: Directory containing the XML files for UAC and UAS scenarios:
  - uac.xml: UAC scenario.
  - uas.xml UAS scenario.
- kamailio_configuration: Directory containing the kamailio.cfg file, which you can configure or change.
- dockerfiles: A directory containing subdirectories for Kamailio and SIPp, each with a Dockerfile to build the respective Docker image.

# 9. Conclusion
Thank you for taking the time to explore this project and help to fix the problem. If you have any suggestion or need further informations, please feel free to contact me at oualla.simohamed@gmail.com.

