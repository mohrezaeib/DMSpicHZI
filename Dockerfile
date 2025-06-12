    # 1) keep the faster base image
    FROM rocker/shiny-verse:4.3.2 AS build    

    # 2) single APT install with extra -dev pkgs
    RUN apt-get update && apt-get install -y --no-install-recommends \
    # ------- toolchain -------
    build-essential gfortran                                  \
    # ------- generic headers -------
    libcurl4-openssl-dev libxml2-dev libssl-dev zlib1g-dev     \
    libsodium-dev                                             \
    # ------- graphics / image -------
    libpng-dev libjpeg-dev libtiff-dev libharfbuzz-dev         \
    libfribidi-dev libcairo2-dev libx11-dev libfreetype6-dev   \
    libfontconfig1-dev libmagick++-dev                         \
    # ------- math / science -------
    libblas-dev liblapack-dev libarpack2-dev libfftw3-dev      \
    libglpk-dev                                                \
    # ------- geo / proj -------
    libgeos-dev libgdal-dev libudunits2-dev                    \
    # ------- multimedia -------
    ffmpeg                                                     \
    # ------- runtime tools -------
    git sqlite3 wget ca-certificates                           \
    && rm -rf /var/lib/apt/lists/*


    # Miniconda + rdkit
    ENV CONDA_DIR=/opt/conda
    ENV PATH=$CONDA_DIR/bin:$PATH
    
    RUN wget -qO /tmp/miniconda.sh \
            https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
     && bash /tmp/miniconda.sh -b -p "$CONDA_DIR" \
     && rm /tmp/miniconda.sh \
     && /opt/conda/bin/conda clean -afy
    
    # R packages
    COPY docker/install_packages.R /tmp/


    RUN Rscript /tmp/install_packages.R && rm /tmp/install_packages.R


    
    # DIMSpec source
    ARG DIMSPEC_VER=main
    RUN git clone --depth 2 --branch ${DIMSPEC_VER} \
    https://github.com/usnistgov/dimspec.git /opt/DIMSpec
    
    # --- make the repo the working dir so relative paths resolve---
    WORKDIR /opt/DIMSpec       
    COPY env_glob.txt /opt/DIMSpec/config/env_glob.txt

    #depthPre-cache R packages


    RUN conda env create -f /opt/DIMSpec/inst/rdkit/environment.yml && \
    conda run -n nist_dimspec python -c "import rdkit"

    RUN sed -i '1ilibrary(reticulate)' /opt/DIMSpec/R/compliance.R && \
    sed -i '2iuse_condaenv("/opt/conda/envs/nist_dimspec/bin/python", required = TRUE)' /opt/DIMSpec/R/compliance.R
    #RUN printf 'library(reticulate)\nuse_condaenv("nist_dimspec", required = TRUE)\nrdkit <- import("rdkit.Chem")\n\n' | cat - /opt/DIMSpec/R/compliance.R > /tmp/compliance.R && mv /tmp/compliance.R /opt/DIMSpec/R/compliance.R

    RUN Rscript -e "source('/opt/DIMSpec/R/compliance.R'); q('no')"

    
    EXPOSE 3838 8000 8080 7000 7001 7002 

    
    COPY start.sh /opt/start.sh
    RUN chmod +x /opt/start.sh
    ENTRYPOINT ["/opt/start.sh"]    