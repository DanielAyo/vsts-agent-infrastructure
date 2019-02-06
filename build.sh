#!/bin/bash
docker build -t vsts-agent-infrastructure --build-arg VCS_REF="git rev-parse --short HEAD" .
docker tag vsts-agent-infrastructure danielayo/vsts-agent-infrastructure
docker push danielayo/vsts-agent-infrastructure