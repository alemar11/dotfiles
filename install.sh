echo “Setup…"

echo "Changing shell…"
chsh -s /bin/zsh

echo "Moving zsh configuration files…"
cp -a zsh/ ~/

echo "Moving Vim .vimrc configuration file…"
cp -a vim/ ~/

echo "Moving Xcode .lldbinit configuration file…"
cp -a lldbinit/ ~/

echo "Installing Homebrew…"
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
./scripts/homebrew.sh

echo "Installing latest Ruby version (stable)…"
latest_ruby_version=$(rbenv install -l | sed -n '/^[[:space:]]*[0-9]\{1,\}\.[0-9]\{1,\}\.[0-9]\{1,\}[[:space:]]*$/ h;${g;p;}')
echo "$latest_ruby_version"

rbenv install $latest_ruby_version
rbenv global $latest_ruby_version

echo "Installing Bundler…"
gem install bundler
rbenv rehash

echo "done"