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
        checkm-genome \
        samtools \
        spades=3.13.0 \
        metabat2

# Ambiente separato solo per Bowtie2 (richiede Python 2.7 e Perl 5.22)
RUN conda create -y -n bowtieenv python=2.7 bowtie2=2.3.3.1 samtools

# R package utile
RUN Rscript -e "install.packages('optparse', repos='http://cran.rstudio.com/')"

# ...existing code...

# Copia file nel container
COPY scripts /main/scripts
COPY config /main/config
COPY data /main/data
COPY docs /main/docs
COPY examples /main/examples

# Script per attivare l'ambiente Conda
COPY activate_tool.sh /main/activate_tool.sh
# Script per controllare gli strumenti installati
COPY check_tools.sh /main/check_tools.sh
RUN chmod +x /main/activate_tool.sh /main/check_tools.sh

# Working dir
WORKDIR /main

CMD ["/bin/bash"]
# ...existing code...