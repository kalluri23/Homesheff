#!/usr/bin/env bash
gem update --system
gem install bundler
bundle update --bundler
bundle install

cat Gemfile.lock | grep -A 1 "BUNDLED WITH"
bundle version

pod repo update
