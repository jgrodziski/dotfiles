#!/usr/bin/env bash
sudo scutil --set HostName     "Urania"
sudo scutil --set ComputerName "Urania"

echo "Check if RSA key already exists"
if [ -f ~/.ssh/id_rsa ]; then
	echo "RSA Key already exists"
else
	echo "Generate new RSA key"
	ssh-keygen -t rsa
fi

xcode-select --install

if test ! $(which brew); then
	echo "Install homebrew"
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

echo "Update homebrew"
brew update

echo "Install git"
brew install git

echo "Install JDK 8, 9, 13, 14 and other CLI tools"
brew tap AdoptOpenJDK/openjdk
brew cask install adoptopenjdk8
brew cask install adoptopenjdk9
brew cask install adoptopenjdk13
brew cask install adoptopenjdk14

brew cask install karabiner-elements
brew install tree wget node zsh adr-tools awscli binutils cask clojure cmake curl cowsay dict dnsmasq dos2unix elm tmux mas keychain direnv archey kubectl docker minikube autossh kubectx telnet minica maven jq yarn fzf ag boot-clj vault gpg stern pinentry-mac fswatch asciidoctor

echo "Install Jekyll"
gem install bundler jekyll

echo "Install App Store applications"
#run `mas list` on a mac where the MacAppstore are installed to get the identifiers below
mas install 634108295 # Acorn
mas install 409789998 # Twitter
mas install 736189492 # Notability
mas install 507308266 # InSSIDer
mas install 904280696 # Things
mas install 405399194 # Kindle
mas install 497799835 # Xcode

echo "Install Emacs"
brew tap d12frosted/emacs-plus
brew install emacs-plus --with-modern-icon
brew link emacs-plus
echo "Install Spacemacs"
if [ ! -d ".emacs.d" ]; then
     echo "Clone spacemacs repository"
     git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
fi
echo "Update spacemacs repository"
cd ~/.emacs.d
git checkout develop
git pull
cd ~

echo "Install NPM global package"
npm install -g shadow-cljs

echo "Install vim plugins using vim package"
mkdir -p ~/.vim/pack ~/.vim/pack/themes/opt ~/.vim/pack/tpope/start

git clone https://github.com/lifepillar/vim-solarized8.git ~/.vim/pack/themes/opt/solarized8
git clone https://tpope.io/vim/surround.git ~/.vim/pack/tpope/start/surround
vim -u NONE -c "helptags surround/doc" -c q
git clone git@github.com:guns/vim-sexp.git ~/.vim/pack/vim-sexp
git clone https://github.com/luochen1990/rainbow.git /tmp
cd /tmp/rainbow
cp plugin/* ~/.vim/plugin
cp autoload/* ~/.vim/autoload

cd ~

echo "Install Oh My ZSH..."
curl -L http://install.ohmyz.sh | sh

echo "Install my theme"
curl https://gist.githubusercontent.com/jgrodziski/7405347/raw/ > ~/.oh-my-zsh/themes/jgrodziski.zsh-theme

echo "Install zsh syntax highlighting plugin and other completions"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

echo "Setting ZSH as shell..."
if ! [ -x "$(command -v `which zsh`)" ]; then
	chsh -s /bin/zsh
fi

echo "Install applications with brew cask"
apps=(firefox
      dashlane
      iterm2
      sublime-text
      datagrip
      vlc
      qlmarkdown
      qlstephen
      google-chrome
      dropbox
      docker
      sketch
      slack
      miro-formerly-realtimeboard
      arq
      carbon-copy-cloner
      deepl
      kaleidoscope
      kube-forwarder
      paw
      audirvana
      monodraw
      microsoft-office
      aerial
      grandperspective
      pock
      google-cloud-sdk
      intel-power-gadget
      istat-menus
      hyperdock
      notion)

brew cask install --appdir="/Applications" ${apps[@]}
brew cleanup

echo "Setup kubectl with google-cloud-sdk"
sudo ln /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/bin/kubectl /usr/local/bin/kubectl
gcloud auth configure-docker

echo "Setup MAC OS X defaults"

# Always show scrollbars
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"
# Possible values: `WhenScrolling`, `Automatic` and `Always`

defaults write -g KeyRepeat -int 2 #minimum is 2
defaults write -g InitialKeyRepeat -int 12
echo "Change keyboard behavior for fast key repeat, needs to login again for new conf to be active"

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

echo "Install DotFiles with stow"
git clone git@github.com:jgrodziski/dotfiles.git ~/.dotfiles
cd .dotfiles
git pull
brew install stow
for app in *; do
        echo "link $app to home dir with stow"
	      stow -vRt ~ $app
        echo "$app linked to home dir with stow"
done
echo "Reference my global gitignore coming from my dotfiles with git"
git config --global core.excludesfile ~/.gitignore_global
git config --global commit.gpgsign true
git config --global user.signingkey BD00F4DDBFA50549
echo "pinentry-program /usr/local/bin/pinentry-mac" >> ~/.gnupg/gpg-agent.conf

echo "Install Fonts"
brew tap homebrew/cask-fonts
brew cask install font-inconsolata font-gentium-plus font-gentium-basic font-hack font-source-code-pro


