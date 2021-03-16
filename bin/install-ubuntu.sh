#!/bin/bash

echo 'installing dependencies'
sudo apt install python3-pip gawk &&\
pip3 install pre-commit
tfdocs_latest_dl_url=$(curl -sL https://api.github.com/repos/terraform-docs/terraform-docs/releases/latest | grep -o -E "https://.+?-linux-amd64" | tail -n1)
curl -L "$tfdocs_latest_dl_url" > terraform-docs && chmod +x terraform-docs && sudo mv terraform-docs /usr/bin/
curl -L "$(curl -sL https://api.github.com/repos/terraform-linters/tflint/releases/latest | grep -o -E "https://.+?_linux_amd64.zip")" > tflint.zip && unzip tflint.zip && rm tflint.zip && sudo mv tflint /usr/bin/
env GO111MODULE=on go get -u github.com/liamg/tfsec/cmd/tfsec
git clone https://github.com/tfutils/tfenv.git ~/.tfenv || true
mkdir -p ~/.local/bin/
. ~/.profile
ln -s ~/.tfenv/bin/* ~/.local/bin

echo 'installing pre-commit hooks'
pre-commit install

echo 'setting pre-commit hooks to auto-install on clone in the future'
git config --global init.templateDir ~/.git-template
pre-commit init-templatedir ~/.git-template

echo 'installing terraform with tfenv'
tfenv install latest:^0.13
tfenv use latest:^0.13
