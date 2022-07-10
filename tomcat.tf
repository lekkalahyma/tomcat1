provider "aws" {
  region = var.region
}
resource "aws_instance" "tomcat" {
  ami                    = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.tomcat-sg.id]
  key_name               = var.key_name
  user_data              = <<EOF
 #!/bin/bash
#!/bin/bash
wget https://download.java.net/java/GA/jdk13.0.1/cec27d702aa74d5a8630c65ae61e4305/9/GPL/openjdk-13.0.1_linux-x64_bin.tar.gz
tar -xvf openjdk-13.0.1_linux-x64_bin.tar.gz
mv jdk-13.0.1 /opt/
JAVA_HOME='/opt/jdk-13.0.1'
PATH="$JAVA_HOME/bin:$PATH"
export PATH
wget https://mirrors.estointernet.in/apache/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz
tar -xvf apache-maven-3.6.3-bin.tar.gz
mv apache-maven-3.6.3 /opt/
M2_HOME='/opt/apache-maven-3.6.3'
PATH="$M2_HOME/bin:$PATH"
export PATH
wget https://dlcdn.apache.org/tomcat/tomcat-8/v8.5.81/bin/apache-tomcat-8.5.81.zip
unzip apache-tomcat-8.5.81.zip
mv apache-tomcat-8.5.81 tomcat
chmod -R 755 tomcat
mv tomcat /opt
cd /opt
cd tomcat/
cd bin
./startup.sh
EOF

  tags = {
    Name = "tomcat"
  }
}
