export LANG="en_US.UTF-8"

# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="jgrodziski"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Uncomment this to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how often before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
# DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
[[ -s `brew --prefix`/etc/autojump.sh ]] && . `brew --prefix`

plugins=(git docker osx sublime mvn ssh-agent lein brew dircycle history jump z zsh-syntax-highlighting kubectl zsh-completions zsh-autosuggestions)
source $ZSH/oh-my-zsh.sh

# gcloud
source /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc

# Customize to your needs...
setopt auto_cd
cdpath=(~/Dropbox/projects/deepencity/product/backend ~/Dropbox/projects ~/Dropbox/projects/deepencity ~/Dropbox/projects/zenmodeler ~/Google\ Drive/ ~/Dropbox/projects/zm-websites/ ~/Dropbox/projects/deepencity/product  ~/Dropbox/projects/prez ~/Dropbox/projects/electre/refonte)

export PATH=$HOME/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH
export PATH=$PATH:~/Dropbox/projects/deepencity/product/backend/javaByteCodeAnalyzer
export PATH=$PATH:~/Dropbox/projects/deepencity/product/core/city
export JAVA_HOME="$(/usr/libexec/java_home -v 9)"
export PATH=$PATH:$JAVA_HOME/bin
#export JAVA_TOOL_OPTIONS="--add-modules=java.xml.bind"
export MONGO_HOME=/usr/local/Cellar/mongodb/3.0.7
export NEO4J_HOME=/usr/local/cellar/neo4j/2.3.1
export RABBITMQ_HOME=/usr/local/cellar/rabbitmq/3.4.2
export M2_HOME=/usr/local/Cellar/maven/3.3.9/libexec/
export GROOVY_HOME=/usr/local/opt/groovy/libexec
export DATOMIC_HOME=/Users/jeremiegrodziski/datomic-pro-0.9.5067/
export DATOMIC_CONSOLE_HOME=/Users/jeremiegrodziski/datomic-console-0.1.199/
export SONAR_RUNNER_HOME=/usr/local/Cellar/sonar-runner/2.4/libexec
export LEIN_JAVA_CMD=$JAVA_HOME/bin/java
export LEIN_FAST_TRAMPOLINE=y
export LEIN_SNAPSHOTS_IN_RELEASE=true
export PATH="$HOME/.node/bin:$PATH"
export PATH=$PATH:$HOME/google-cloud-sdk/bin
export GRAALVM_HOME=/Applications/graalvm-ce-1.0.0-rc13/Contents/Home
export PATH=$PATH:$GRAALVM_HOME/bin
export ELECTRE_PROFILE=local

alias vi=vim
alias t=todo.sh
alias sbr="mvn spring-boot:run"
alias jks="jekyll serve"
#envfile="$HOME/.gnupg/gpg-agent.env"
#if [[ -e "$envfile" ]] && kill -0 $(grep GPG_AGENT_INFO "$envfile" | cut -d: -f 2) 2>/dev/null; then
#    eval "$(cat "$envfile")"
#else
#    eval "$(gpg-agent --daemon --enable-ssh-support --write-env-file "$envfile")"
#fi
#export GPG_AGENT_INFO  # the env file does not contain the export statement
#export SSH_AUTH_SOCK   # enable gpg-agent for ssh
archey -c -o

export GOPATH=$HOME/go
export GOROOT=/usr/local/opt/go/libexec
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOROOT/bin

############################################################################
#                                                                          #
#               ------- Useful Docker Aliases --------                     #
#                                                                          #
#     # Installation :                                                     #
#     copy/paste these lines into your .bashrc or .zshrc file or just      #
#     type the following in your current shell to try it out:              #
#     wget -O - https://gist.githubusercontent.com/jgrodziski/9ed4a17709baad10dbcd4530b60dfcbb/raw/d84ef1741c59e7ab07fb055a70df1830584c6c18/docker-aliases.sh | bash
#                                                                          #
#     # Usage:                                                             #
#     dcu            : docker-compose up -d                                #
#     dcd            : docker-compose down                                 #
#     dex <container>: execute a bash shell inside the RUNNING <container> #
#     di <container> : docker inspect <container>                          #
#     dim            : docker images                                       #
#     dip            : IP addresses of all running containers              #
#     dl <container> : docker logs -f <container>                          #
#     dnames         : names of all running containers                     #
#     dps            : docker ps                                           #
#     dpsa           : docker ps -a                                        #
#     drmc           : remove all exited containers                        #
#     drmid          : remove all dangling images                          #
#     drun <image>   : execute a bash shell in NEW container from <image>  #
#     dsr <container>: stop then remove <container>                        #
#                                                                          #
############################################################################

function dnames-fn {
	for ID in `docker ps | awk '{print $1}' | grep -v 'CONTAINER'`
	do
    	docker inspect $ID | grep Name | head -1 | awk '{print $2}' | sed 's/,//g' | sed 's%/%%g' | sed 's/"//g'
	done
}

function dip-fn {
	echo "IP addresses of all named running containers"

	for DOC in `dnames-fn`
	do
  		IP=`docker inspect $DOC | grep -m3 IPAddress | cut -d '"' -f 4 | tr -d "\n"`
  		echo $DOC : $IP
	done
}

function dex-fn {
	docker exec -it $1 /bin/bash
}

function di-fn {
	docker inspect $1
}

function dl-fn {
	docker logs -f $1
}

function drun-fn {
	docker run -it $1 /bin/bash
}

function dsr-fn {
	docker stop $1;docker rm $1
}

alias dcu="docker-compose up -d"
alias dcd="docker-compose down"
alias dex=dex-fn
alias di=di-fn
alias dim="docker images"
alias dip=dip-fn
alias dl=dl-fn
alias dnames=dnames-fn
alias dps="docker ps"
alias dpsa="docker ps -a"
alias drmc="docker rm $(docker ps --all -q -f status=exited)"
alias drmid="docker rmi $( docker images -q -f dangling=true)"
alias drun=drun-fn
alias dsr=dsr-fn

# leiningen aliases
alias lu="lein uberjar"
alias li="lein install"
alias lt="lein test"
alias lr="lein repl"
alias lc="lein clean"
alias lrs="lein ring server-headless"
alias lr="lein release"
alias lf="lein figwheel"
alias lfd="lein figwheel dev"
alias lcod="lein cljsbuild once dev"
alias lcom="lein cljsbuild once min"

alias k="kubectl"

eval "$(direnv hook zsh)"

# to get emacs and ssh working correctly
eval `keychain --eval --agents ssh --inherit any id_rsa`

export LOG_FORMAT=TXT
export ELECTRE_PROFILE="default"

 export NVM_DIR="$HOME/.nvm"
  [ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/usr/local/opt/nvm/etc/bash_completion" ] && . "/usr/local/opt/nvm/etc/bash_completion"  # This loads nvm bash_completion
zstyle ':completion:*' menu yes select
