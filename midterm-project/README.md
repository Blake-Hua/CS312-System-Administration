# How to Setup a Minecraft Server with AWS

### Welcome! I will show you how to create a Minecraft server on AWS EC2 and connect to it from the client.

#### 1) Go to your AWS Dashboard and click EC2 

#### 2) Create/Launch new instance
  * Name: mc-server (or whatever you want)
  * Amazon Machine Image (AMI): Ubuntu 22.04 LTS (HVM), SSD Volume Type
  * Architecture: 64-bit (x86)
  * Instance type: t2.medium 
  * Keypair: Create new keypair 
    * Name: mc-key
    * Key pair type: RSA
    * Private key file format: .pem and save, a file should be downloaded to your computer

#### 3) Before launching instance click edit in network settings
  * VPC: Default
  * Subnet: No preference
  * Auto-assign public IP: Enable
  * Firewall (security groups): Select create security group
  * Security group name: launch-wizard-X
  * Description: launch-wizard-X created 2023-05-23T18:47:56.387Z
  * Inbound security groups rules:
    * **Security group rule 1**
      * Type: SSH
      * Protocol: TCP
      * Port range: 22
      * Source type: Custom
      * Source: 0.0.0.0/0
    * Add security group rule
    * **Security group rule 2**
      * Type: Custom UDP
      * Protocol: UDP
      * Port range: 19131-19132
      * Source type: Custom
      * Source: 0.0.0.0/0
      * Description: Minecraft_Port
    * Add security group rule
    * **Security group rule 3**
      * Type: Custom UDP
      * Protocol: UDP
      * Port range: 25565
      * Source type: Custom
      * Source: 0.0.0.0/0
    * Add security group rule
    * **Security group rule 4**
      * Type: Custom TCP
      * Protocol: TCP
      * Port range: 25565
      * Source type: Custom
      * Source: 0.0.0.0/0

#### 4) After creating the four rules click launch instance

#### 5) Go to the EC2 page > Instances running, highlight the instance and click Connect 

#### 6) Go to the SSH Client tab and open your terminal
  * Type ```chmod 400 mc-key.pem``` (NOTE: In your terminal, make sure you are in the directory where you downloaded your key)
  * Copy the command under "Example:" and paste it into your terminal (NOTE: Mine will look different from yours)
  ```ssh -i "mc-key.pem" ubuntu@ec2-34-221-244-198.us-west-2.compute.amazonaws.com```

#### 7) Once you are in the server, we will type a list of commands to setup and download useful packages

Run these commands in the following order:
  * ```sudo apt update``` 
  * ```sudo apt upgrade```
  * ```sudo add-apt-repository ppa:linuxuprising/java```
  * ```sudo apt install oracle-java17-installer``` 
    * A screen will pop up where you will need to press "Ok" and "Yes" by using the arrow keys and Enter

#### 8) Creating the server files
When the packages are done installing:
  * ```mkdir minecraft``` make a folder and cd into it ```cd minecraft```
  * Visit [Minecraft Server](https://www.minecraft.net/en-us/download/server) 
    * Right click "minecraft_server..jar" and copy link address 
  * Go back to your terminal, type wget and paste the link address
  ```wget https://piston-data.mojang.com/v1/objects/8f3112a1049751cc472ec13e397eade5336ca7ae/server.jar```
  * A file should appear named server.jar
    1. ```chmod 777 server.jar``` give it permissions
    2. ```mv server.jar minecraft_server_1.19.4.jar``` rename it so that we know what version the server is on (best practice)
    3. ```java -Xmx1024M -Xms1024M -jar minecraft_server_1.19.4.jar nogui``` taken from [Minecraft Server](https://www.minecraft.net/en-us/download/server)
    4. An error should appear notifying you to agree to the EULA
       * ```vi eula.txt```
       * Update eula=false to eula=true and save/close out of vim

#### 9) Setting up auto-start and launching the Minecraft server
  * Navigate to system files ```cd /etc/systemd/system/``` 
  * Create myapp.service ```sudo vim myapp.service``` and paste content into file (below)
    
    ```
    [Unit]
    Description=Manage Java service

    [Service]
    WorkingDirectory=/home/ubuntu/minecraft
    ExecStart=/bin/java -Xms1024M -Xmx1024M -jar /home/ubuntu/minecraft/minecraft_server_1.19.4.jar nogui
    User=ubuntu
    Type=simple
    Restart=on-failure
    RestartSec=20

    [Install]
    WantedBy=multi-user.target
    ```
  * Reload to make sure changes are saved ```sudo systemctl daemon-reload```
  * Start service ```sudo systemctl start myapp.service```
  * Check status ```systemctl status myapp```

#### 10) Joining the server (FINAL STEP)
  * Grab the Public IPv4 Address, EC2 > Instances > highlight mc-server and copy
  * Open Minecraft and click Add Server, paste the Public IPv4 Address
  * Congratulations you have successfully created a Minecraft Server!!


   

