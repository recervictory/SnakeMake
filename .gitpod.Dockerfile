image:
  file: .gitpod.Dockerfile
  
# List the extensions you want to install
vscode:
  extensions:
    - ms-python.python

# List the packages you want to install with conda
tasks:
  - init: conda init bash && conda create -n myenv python=3.8
  - command: conda activate myenv && conda install -y pandas numpy matplotlib
