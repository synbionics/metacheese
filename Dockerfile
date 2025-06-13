FROM ubuntu:22.04
#20 0 18

ENV DEBIAN_FRONTEND=noninteractive

#https://www.hpc.unipr.it/dokuwiki/doku.php?id=calcoloscientifico:userguide:python
# Installa pacchetti e tools

#input tool da cui partire
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    git \
    build-essential \
    python2=2.7.5 \
    python2-dev \
    openjdk-11-jre-headless \
    r-base \
    unzip \
    zlib1g-dev \
    libbz2-dev \
    liblzma-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    locales \
    && rm -rf /var/lib/apt/lists/*

# Set locale
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8


# Installa Miniconda
ENV CONDA_DIR=/opt/conda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh && \
    bash /tmp/miniconda.sh -b -p $CONDA_DIR && \
    rm /tmp/miniconda.sh && \
    $CONDA_DIR/bin/conda clean -afy
ENV PATH=$CONDA_DIR/bin:$PATH

# Aggiorna conda
RUN conda config --add channels defaults && \
    conda config --add channels conda-forge && \
    conda config --add channels bioconda && \
    conda update -n base -c defaults conda

RUN conda install -y \
    adapterremoval=2.3.3 \
    bowtie2=2.3.3.1 
    #metaphlan=3.0.14 \
    #checkm-genome \
    #samtools \
    #spades=3.13.0 \
    #metabat2

# Installa TORMES
RUN apt-get update && apt-get install -y perl

# Installa pacchetti R
RUN Rscript -e "install.packages('optparse', repos='http://cran.rstudio.com/')"

# Copia le cartelle nella directory /data del container
COPY scripts /data/scripts
COPY template /data/template
COPY input /data/input
COPY output /data/output
COPY config /data/config

# Set the working directory
WORKDIR /data

# Entry point (you can modify it)
CMD ["/bin/bash"]