#!/bin/bash
#Functions and aliases to speed up routine kubernetes operations

function GetPodLogs() {
    if [ -z "$1" ]; then
        echo "Please supply a pod name."
        echo "Available pods:"
        kubectl get pods
        return 1
    fi

    if [ -z "$2" ]; then
        kubectl logs "$1" --tail=50
    else
        kubectl logs "$1" $2
    fi
};

function GetDeploymentImages() {
    if [ -z "$1" ]; then
        echo "Must pass a deployment!"
        echo "Current deployments: "
        kubectl get deployments
        return 1
    fi
    kubectl get deployment ${1} -o json | jq .spec.template.spec.containers[].image -r
}

alias get-pods="kubectl get pods -o wide --sort-by=""{.spec.nodeName}"" "
alias get-logs="GetPodLogs "
alias get-jobs="kubectl get jobs "
alias get-nodes="kubectl get nodes "
alias get-image="GetDeploymentImages "

alias describe-pods="kubectl describe pods "