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

echo "Install JDK 8, 9 and 13 and other CLI tools"
brew tap AdoptOpenJDK/openjdk
brew cask install adoptopenjdk8
brew cask install adoptopenjdk9
brew cask install adoptopenjdk13
brew install tree wget node zsh adr-tools awscli binutils cask clojure cmake curl cowsay dict dnsmasq dos2unix elm tmux mas keychain direnv archey kubectl docker minikube autossh 

echo "Install App Store applications"
#run `mas list` on a mac where the MacAppstore are installed to get the identifiers below
mas install 634108295 # Acorn
mas install 409789998 # Twitter
mas install 736189492 # Notability
mas install 507308266 # InSSIDer
mas install 904280696 # Things
mas install 405399194 # Kindle

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


echo "Install Vim Pathogen"
mkdir -p ~/.vim/autoload ~/.vim/bundle && \
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

echo "Install vim plugins"
cd ~/.vim/bundle
git clone git@github.com:sjl/badwolf.git
git clone git@github.com:mileszs/ack.vim.git
git clone git@github.com:jiangmiao/auto-pairs.git
git clone git@github.com:luochen1990/rainbow.git
git clone git@github.com:vim-scripts/vim-auto-save.git
git clone git@github.com:lifepillar/vim-solarized8.git
git clone git@github.com:tpope/vim-surround.git
git clone git@github.com:guns/vim-sexp.git
git clone git@github.com:kana/vim-arpeggio.git
git clone git@github.com:altercation/vim-colors-solarized.git
git clone git@github.com:kien/rainbow_parentheses.vim.git

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
      vlc
      qlmarkdown
      qlstephen
      google-chrome
      dropbox
      docker
      sketch
      slack
      arq
      carbon-copy-cloner
      deepl
      kaleidoscope
      paw
      audirvana
      monodraw
      microsoft-office
      aerial
      grandperspective
      google-cloud-sdk
      intel-power-gadget
      istat-menus
      hyperdock)

brew cask install --appdir="/Applications" ${apps[@]}
brew cleanup

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

echo "Install Fonts"
brew tap homebrew/cask-fonts 
brew cask install font-inconsolata font-gentium-plus font-gentium-basic font-hack font-source-code-pro


