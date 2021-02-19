#!/bin/bash
gitlab-runner register --non-interactive --url $GITLAB_URL --registration-token $GITLAB_TOKEN --executor "shell" --tag-list $GITLAB_TAGS || true
gitlab-runner start && bash
