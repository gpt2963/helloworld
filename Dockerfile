#Use CentOS as the base image
FROM centos:7

# Install required dependencies and Maven
RUN yum install -y wget java-11-openjdk-devel \
    && cd /opt \
    && wget https://repo.maven.apache.org/maven2/org/apache/maven/apache-maven/3.9.0/apache-maven-3.9.0-bin.tar.gz --no-check-certificate \
    && tar -xzf apache-maven-3.9.0-bin.tar.gz \
    && mv apache-maven-3.9.0 maven \
    && rm -f apache-maven-3.9.0-bin.tar.gz \
    && yum clean all

# Set Maven environment variables and update PATH
ENV MAVEN_HOME=/opt/maven
ENV PATH=${MAVEN_HOME}/bin:${PATH}

# Set JAVA_HOME environment variable
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk


# Create a directory in the container for the project
RUN mkdir /app/


# Copy local files to the container
COPY  pom.xml /app/.
COPY  index.jsp /app/.
COPY  src     /app/src
# Set the working directory in the container
WORKDIR /app

# Check Maven version
RUN mvn --version

# Build the .war file using Maven
RUN mvn clean package

# Define a volume to mount to the host directory
VOLUME ["/app/opt"]

# Define the command to run the container
CMD ["/bin/bash"]
