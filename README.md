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
