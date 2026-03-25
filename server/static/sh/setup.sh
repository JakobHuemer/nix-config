#!/usr/bin/env bash
set -e

echo "Tap YubiKey to extract SSH stub..."
mkdir -p ~/.ssh && cd ~/.ssh
ssh-keygen -K

git config --global user.name "Jakob Huemer-Fistelberger"
git config --global user.email "j.huemer-fistelberger@htblaleonding.ac.at"
git config --global commit.gpgsign true
git config --global gpg.format ssh
git config --global user.signingkey ~/.ssh/id_ed25519_sk_rk_github.pub

echo "Writing ~/.ssh/config..."
cat << 'EOF' > ~/.ssh/config
Host github.com
  User git
  IdentityFile ~/.ssh/id_ed25519_sk_rk_github
  IdentitiesOnly yes
EOF
chmod 600 ~/.ssh/config

echo "Done!"
