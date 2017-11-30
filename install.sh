echo "Setup…"

echo "Changing shell…"
chsh -s /bin/zsh
echo "done"

echo "\n"

echo "Moving zsh configuration files…"
cp -a zsh/ ~/
echo "done"

echo "\n"

echo "Moving Vim .vimrc configuration file…"
cp -a vim/ ~/
echo "done"

echo "\n"

echo "Moving Xcode .lldbinit configuration file"
cp -a lldbinit/ ~/
echo "done"

echo "\n"

echo "Installing Homebrew…"
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
./scripts/homebrew.sh
echo "\ndone"

echo "Installing the latest stable Ruby version…"
latest_ruby_version=$(rbenv install -l | sed -n '/^[[:space:]]*[0-9]\{1,\}\.[0-9]\{1,\}\.[0-9]\{1,\}[[:space:]]*$/ h;${g;p;}')
echo "$latest_ruby_version"
rbenv install $latest_ruby_version
rbenv global $latest_ruby_version
echo "done"

echo "\n"

echo "Installing Bundler…"
sudo gem install bundler
rbenv rehash
echo "\ndone"

echo "Configuring Xcode…"
./scripts/xcode.sh
echo "\ndone"

echo "Configuring VSCode…"
./scripts/vscode.sh
echo "\ndone"
