FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

# Pacchetti di sistema
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    git \
    build-essential \
    python \
    python-dev \
    openjdk-11-jre-headless \
    r-base \
    unzip \
    zlib1g-dev \
    libbz2-dev \
    liblzma-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    locales \
    perl \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Configura la localizzazione
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8  
ENV LANGUAGE=en_US:en  
ENV LC_ALL=en_US.UTF-8

# Installa Miniconda
ENV CONDA_DIR=/opt/conda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh && \
    bash /tmp/miniconda.sh -b -p $CONDA_DIR && \
    rm /tmp/miniconda.sh && \
    $CONDA_DIR/bin/conda clean -afy
ENV PATH=$CONDA_DIR/bin:$PATH

# Configura Conda
RUN conda config --add channels defaults && \
    conda config --add channels conda-forge && \
    conda config --add channels bioconda && \
    conda update -n base -c defaults conda

# Crea due ambienti: uno per AdapterRemoval e uno per Bowtie2
RUN conda create -y -n adapterenv python=3.8 adapterremoval=2.3.3 && \
    conda create -y -n bowtieenv python=2.7 bowtie2=2.3.3.1
    # metaphlan=3.0.14 \
    # checkm-genome \
    # samtools \
    # spades=3.13.0 \
    # metabat2

# Installa pacchetto R utile
RUN Rscript -e "install.packages('optparse', repos='http://cran.rstudio.com/')"

# Copia cartelle nel container
COPY scripts /data/scripts
COPY template /data/template
COPY input /data/input
COPY output /data/output
COPY config /data/config

WORKDIR /data

CMD ["/bin/bash"]
