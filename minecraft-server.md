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
  
