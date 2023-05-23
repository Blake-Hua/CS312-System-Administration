# How to Setup a Minecraft Server

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
      * Description: SSH
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

#### 4) After creating the four rules we can launch the instance

#### 5) Click on the instance ID link leading to the instance you created

#### 6) Highlight the instance and click Connect 

#### 7) Go to the SSH Client tab and open your terminal
  * Type ```chmod 400 mc-key.pem``` (NOTE: In your terminal, make sure you are in the directory where you downloaded your key)
  * Copy the command under "Example:" and paste it into your terminal (NOTE: Mine will look different from yours)
  ```ssh -i "mc-key.pem" ubuntu@ec2-34-221-244-198.us-west-2.compute.amazonaws.com```

#### 8) Once you are in the server, we will type a list of commands to setup and download useful packages
<img width="714" alt="in server terminal" src="https://cdn.discordapp.com/attachments/736746137188565033/1110669647453376542/in_server_terminal.png">

Run these commands in the following order:
  * ```sudo apt update``` 
  * ```sudo apt upgrade```
  * ```sudo add-apt-repository ppa:linuxuprising/java```
  * ```sudo apt install oracle-java17-installer``` 
    * A screen will pop up where you will need to press "Ok" and "Yes" by using the arrow keys and Enter

#### 9) Creating the server files
When the packages are done installing:
  * ```mkdir minecraft``` make a folder and cd into it ```cd minecraft```
  * Visit https://www.minecraft.net/en-us/download/server 
    * Right click "minecraft_server..jar" and copy link address 
    ![copy link address](https://cdn.discordapp.com/attachments/736746137188565033/1110672539262390342/copy_link_address.png)
  * Go back to your terminal, type wget and paste the link address
  ```wget https://piston-data.mojang.com/v1/objects/8f3112a1049751cc472ec13e397eade5336ca7ae/server.jar```
  * A file should appear named server.jar
    1. ```chmod 777 server.jar``` give it permissions
    2. ```mv server.jar minecraft_server_1.19.4.jar``` rename it so that we know what version the server is on (best practice)
    3. ```java -Xmx1024M -Xms1024M -jar minecraft_server_1.19.4.jar nogui``` taken from https://www.minecraft.net/en-us/download/server
    4. An error should appear notifying you to agree to the EULA
       * ```vi eula.txt```
       * Update eula=false to eula=true and save/close out of vim
          <img width="600" height="400" alt="eula" src="https://github.com/Blake-Hua/CS312/assets/39657294/4afea29d-542f-4d2f-b75a-2c213392f4c1">

#### 10) Setting up auto-start and launching the Minecraft server (FINAL STEP)
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
    * Sample output:
     <img width="600" height="400" alt="sample output" src="https://cdn.discordapp.com/attachments/736746137188565033/1110684380227174492/sample_output.png">

#### 11) Joining the server
  * Grab the Public IPv4 Address, EC2 > Instances > highlight mc-server and copy
     <img width="800" alt="ipv4 addres" src="https://cdn.discordapp.com/attachments/736746137188565033/1110686458085376080/ipv4_addres.png">
  * Open Minecraft and click Add Server, paste the Public IPv4 Address
     <img width="800" height="700" alt="add server minecraft" src="https://cdn.discordapp.com/attachments/736746137188565033/1110687697867128852/add_server_minecraft.png">
  * The server is up and running!
     <img width="800" height="700" alt="working server" src="https://cdn.discordapp.com/attachments/736746137188565033/1110688462450987139/working_server.png">


   
