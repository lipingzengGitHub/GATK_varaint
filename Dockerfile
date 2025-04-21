#Use a base image with Java and other tools pre-installed
FROM openjdk:11-jdk-slim

#Set environment varaiables
ENV LANG C.UTF-8
ENV DEBIAN_FRONTEND noninteractive

#Install necessary tools and dependencies
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    git \
    bash \
    build-essential \
    samtools \
    bwa \
    zlib1g-dev \
    libncurses5-dev \
    libssl-dev \
    libcurl4-openssl-dev \
    liblzma-dev \
    libbz2-dev \
    bc \
    python3 \
    python3-pip \
    python3-dev \
    gcc \
    g++ \
    libreadline-dev \
    make \
    && apt-get clean

#Install GATK
RUN wget https://github.com/broadinstitute/gatk/releases/download/4.2.6.1/gatk-4.2.6.1.zip \
    && unzip gatk-4.2.6.1.zip \
    && mv gatk-4.2.6.1 /opt/gatk \
    && rm gatk-4.2.6.1.zip

# Install VEP
RUN mkdir -p /opt/vep \
    && cd /opt/vep \
    && wget https://github.com/Ensembl/ensembl-vep/archive/refs/tags/104.zip \
    && unzip 104.zip \
    && rm 104.zip \
    && cd ensembl-vep-104 \
    && perl INSTALL.pl

# Install Nextflow
RUN curl -s https://get.nextflow.io | bash \
    && mv nextflow /usr/local/bin/

# Install ANNOVAR (optional if you want to use ANNOVAR)
RUN wget http://annovar.openbioinformatics.org/en/latest/files/annovar.latest.tar.gz \
    && tar -zxvf annovar.latest.tar.gz \
    && mv annovar /opt/annovar

#Set the working directory
WORKDIR /data

#Default command
ENTRYPOINT ["/bin/bash"]


