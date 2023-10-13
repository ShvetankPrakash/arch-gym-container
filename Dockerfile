# Setting up ArchGym 

# Use the official Ubuntu 20.04 base image 
FROM ubuntu:20.04

# Install required packages
RUN apt-get update -y && \
    apt-get install -y sudo git wget build-essential vim libgmp-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create a user and group for ArchGym
RUN useradd -m -s /bin/bash ArchGym

# Set the password for the user to "archgym"
RUN echo 'ArchGym:archgym' | chpasswd

# Give the user sudo permissions without requiring a password
RUN echo 'ArchGym ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Switch to the new user
USER ArchGym 

# Set the working directory for the new user
WORKDIR /home/ArchGym

# Clone ArchGym Repository
RUN git clone --recursive https://github.com/srivatsankrishnan/oss-arch-gym.git

# Install Miniconda for the non-root user
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    chmod +x Miniconda3-latest-Linux-x86_64.sh && \
    bash ./Miniconda3-latest-Linux-x86_64.sh -b -f -p /home/ArchGym/miniconda && \
    rm Miniconda3-latest-Linux-x86_64.sh

# Initialize Conda in a new bash session
RUN /bin/bash -c "source /home/ArchGym/miniconda/etc/profile.d/conda.sh && conda init"

# Create conda environment for arch-gym which has all the required dependencies
RUN /bin/bash -c "source /home/ArchGym/miniconda/etc/profile.d/conda.sh && conda env create -f oss-arch-gym/environment.yml"

# Source the Conda environment to activate it
RUN /bin/bash -c "source /home/ArchGym/miniconda/etc/profile.d/conda.sh && conda activate base && conda activate arch-gym"

# Install acme
WORKDIR /home/ArchGym/oss-arch-gym/acme
RUN /bin/bash -c "source /home/ArchGym/miniconda/etc/profile.d/conda.sh && \
                 conda init && \
                 conda activate base && \
                 conda activate arch-gym && \
                 pip install .[tf,testing,envs] && \
                 pip install . "
#RUN pip install .[tf,testing,envs,jax]
ENV LD_LIBRARY_PATH=/home/ArchGym/miniconda/envs/arch-gym/lib:$LD_LIBRARY_PATH


# Install Vizier
WORKDIR /home/ArchGym/oss-arch-gym
RUN /bin/bash -c "source /home/ArchGym/miniconda/etc/profile.d/conda.sh && \
                 conda init && \
                 conda activate base && \
                 conda activate arch-gym && \
                 ./install_sim.sh viz "

# Expose port 8888 for Jupyter Notebook
EXPOSE 8888

# Activate Conda environment and start Bash shell
CMD ["/bin/bash", "-c", "source /home/ArchGym/miniconda/etc/profile.d/conda.sh && conda activate arch-gym && /bin/bash"]
