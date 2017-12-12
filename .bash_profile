parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
parse_cluster() {
   kubectl config view -o=jsonpath={.current-context} | sed -e 's/gke_vibbioexpress//g;s/_us-central1-a_//g'
}

docker_build_project() {
    version="$(mvn help:evaluate -Dexpression=project.version | grep -e '^[^\[]')"
    path="$(pwd)"
    base="us.gcr.io/PROJECT_NAME/"
    file=".dockerignore"
    if test -f $file; then
        echo "Dockerfile exist"
    else 
        echo "Could not find docker file"
        return 
    fi
    echo "Current path: $path"
    if [[ $path = *"frontend-public"* ]]; then
        application="frontend-public"
    elif [[ $path = *"backend"* ]]; then
        application="backend"
    fi
    docker build -t $base$application:$version .
    echo "Build docker image: $base$application:$version"
}

export CLICOLOR=13
export LSCOLORS=GxBxCxDxexegedabagaced
export PS1="\e[0;35m\] \u@\h \e[1;34m\W\e[0;32m\$(parse_git_branch)\e[0;37m\] \$ "
export JAVA_HOME=$(/usr/libexec/java_home)
export PATH=$PATH:/usr/local/sbin

# The next line updates PATH for the Google Cloud SDK.
if [ -f /Users/line/Downloads/google-cloud-sdk/path.bash.inc ]; then
  source '/Users/line/Downloads/google-cloud-sdk/path.bash.inc'
fi

# The next line enables shell command completion for gcloud.
if [ -f /Users/line/Downloads/google-cloud-sdk/completion.bash.inc ]; then
  source '/Users/line/Downloads/google-cloud-sdk/completion.bash.inc'
fi

gi_meg_env() {
    kubectl exec -it "$1" -- printenv | sort 
}

alias docker_build=docker_build_projectb    
alias gimegenv=gi_meg_env
alias getcluster=parse_cluster

alias cloud_sql_proxy='~/Documents/code/cloud_sql_proxy'
alias testcluster='gcloud container clusters get-credentials test-cluster'
alias prodcluster='gcloud container clusters get-credentials prod-cluster'

alias update='source ~/.bash_profile'

source /usr/local/etc/bash_completion

source <(kubectl completion bash)
