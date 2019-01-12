#!/usr/bin/env bash
pod repo update
gem install --conservative bundler:2.0.1
bundle install
pod install
