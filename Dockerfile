FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

# Pacchetti di base
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    git \
    build-essential \
    python \
    python-dev \
    openjdk-11-jre-headless \
    unzip \
    zlib1g-dev \
    libbz2-dev \
    liblzma-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    locales \
    perl \
    && apt-get clean && rm -rf /var/lib/apt/lists/*


# Installa R 4.2 da CRAN (repository ufficiale aggiornato)
RUN apt-get update && apt-get install -y software-properties-common dirmngr gnupg apt-transport-https ca-certificates && \
    wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | gpg --dearmor > /etc/apt/trusted.gpg.d/cran-r.gpg && \
    echo "deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran40/" >> /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y r-base


# Installa i pacchetti R necessari (inclusi phyloseq e microbiome)
COPY install_R_packages.R /tmp/
RUN Rscript /tmp/install_R_packages.R

# Localizzazione
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8  
ENV LANGUAGE=en_US:en  
ENV LC_ALL=en_US.UTF-8

# Miniconda
ENV CONDA_DIR=/opt/conda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh && \
    bash /tmp/miniconda.sh -b -p $CONDA_DIR && \
    rm /tmp/miniconda.sh && \
    $CONDA_DIR/bin/conda clean -afy

ENV PATH=$CONDA_DIR/bin:$PATH

# Inizializzazione Conda e canali
RUN conda init bash && \
    conda config --add channels defaults && \
    conda config --add channels conda-forge && \
    conda config --add channels bioconda && \
    conda update -n base -c defaults conda

# installa la Go-yq di mikefarah
RUN wget -qO /usr/local/bin/yq \
     https://github.com/mikefarah/yq/releases/download/v4.34.1/yq_linux_amd64 && \
    chmod +x /usr/local/bin/yq


# Ambiente base per la maggior parte degli strumenti bioinformatici
RUN conda create -y -n bioenv python=3.8 && \
    conda run -n bioenv conda install -y \
        adapterremoval=2.3.3 \
        metaphlan=3.0.14 \
        spades=3.15.5 \
        metabat2

#RUN conda create -y -n humannenv python=3.8 && \
#    conda run -n bioenv conda install -y \
#        humann=3.9
        

# Ambiente per CheckM e CheckM2
#RUN conda create -y -n checkmenv python=3.8 && \
#    conda run -n checkmenv conda install -y \
#        checkm-genome \
#        checkm2=1.1.0

#RUN conda run -n checkmenv checkm2 database --download

# Ambiente separato solo per Bowtie2 (richiede Python 2.7 e Perl 5.22)
#RUN conda create -y -n bowtieenv python=2.7 bowtie2=2.3.3.1 samtools


# Copia file nel container
COPY scripts /main/scripts
COPY config /main/config
COPY data /main/data
COPY docs /main/docs
COPY examples /main/examples


#COPY scripts/utils/fix_checkm2_models.sh /main/scripts/utils/
#RUN bash /main/scripts/utils/fix_checkm2_models.sh


# Working dir
WORKDIR /main

CMD ["/bin/bash"]
