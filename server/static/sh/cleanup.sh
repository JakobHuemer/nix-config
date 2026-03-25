#!/usr/bin/env bash

echo "Removing SSH stubs..."
rm -f ~/.ssh/id_ed25519_sk_rk_github ~/.ssh/id_ed25519_sk_rk_github.pub

echo "Cleaning SSH config..."
if [ -f ~/.ssh/config ]; then
  sed '/Host github.com/,/IdentitiesOnly yes/d' ~/.ssh/config > ~/.ssh/config.tmp && mv ~/.ssh/config.tmp ~/.ssh/config
fi

echo "Reverting Git config..."
git config --global --unset user.name || true
git config --global --unset user.email || true
git config --global --unset commit.gpgsign || true
git config --global --unset gpg.format || true
git config --global --unset user.signingkey || true

echo "Environment cleaned!"
