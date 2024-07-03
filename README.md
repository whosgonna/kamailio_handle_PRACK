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
The location of the Dockerfiles for kamailio and SIPp are in this location ***./kamailio_handle_PRACK/dockerfiles***
To set up the environment, you need to build a Docker image for Kamailio version 5.7.5 in the ***kamailio_handle_PRACK/dockerfiles/kamailio\ 5.7.5*** directory.
If you already have the kamailio docker image, you can use it and change the value of image in the ***docker-compose.yml*** file. Otherwise, you can use the provided Dockerfile in this repository. Same thing for the SIPp, you can find its dockerfile location here ***kamailio_handle_PRACK/dockerfiles/SIPp***

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

## 5.1. (Optional for Linux Users) Interact with the project using env.bash shortcuts and aliases

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

### 5.1.4. Other important commands
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

## 5.2. Commands Interact with the project
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

bash
Copy code
docker run --name kamailio -d kamailio:5.7.5
SIPp Configuration
The SIP scenarios are defined in XML files. You can copy the provided XML scenarios from this repository.

Example SIPp Command for UAC
bash
Copy code
sipp -sf uac_scenario.xml -i 200.200.200.2 -p 5060 200.200.200.3:5060
Example SIPp Command for UAS
bash
Copy code
sipp -sf uas_scenario.xml -i 200.200.200.4 -p 5060
Scenario Description
UAC sends an INVITE to Kamailio.
Kamailio forwards the INVITE to UAS.
UAS responds with 100 Trying and 180 Ringing (with RSeq and 100rel required).
UAS sends a 486 Busy Here response.
Kamailio processes the 486 response and sends a different response (e.g., 606) to the UAC.
Files in This Repository
Dockerfile: For building the Kamailio Docker image.
kamailio.cfg: Kamailio configuration file.
uac_scenario.xml: SIPp scenario for UAC.
uas_scenario.xml: SIPp scenario for UAS.
Usage
Build and run the Kamailio Docker container.
Run SIPp with the provided UAC and UAS scenarios.
Observe the SIP message flow and the custom response handling by Kamailio.
