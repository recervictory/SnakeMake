FROM gitpod/workspace-full

# Install Conda
RUN curl -o ~/miniconda.sh -O https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    chmod +x ~/miniconda.sh && \
    ~/miniconda.sh -b -p ~/.conda && \
    rm ~/miniconda.sh && \
    echo "export PATH=~/.conda/bin:$PATH" >> ~/.bashrc

# Set Conda as default package manager
RUN conda init bash

# Install additional packages
RUN conda install -y conda
