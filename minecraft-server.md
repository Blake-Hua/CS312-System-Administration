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
      * Type: ssh
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
  * type chmod 400 mc-key.pem (NOTE: In your terminal, make sure you are in the directory where you downloaded your key)
  * copy the command under "Example:"
<img width="621" alt="ssh command" src="[https://github.com/Blake-Hua/CS312/assets/39657294/03818b05-5801-4210-81a0-372ac4f9f00b](https://cdn.discordapp.com/attachments/736746137188565033/1110657882900410478/ssh_command.png)">

  

#### 8) 
