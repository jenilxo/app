#!/bin/bash
sed "s/tagVersion/$1/g" deployment.yml > node-app-deploy.yml
