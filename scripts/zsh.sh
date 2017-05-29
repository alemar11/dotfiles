echo "Changing shell…"
chsh -s /bin/zsh
echo "Done"

echo "\n"

echo "Moving zsh configuration files…"
cp -a ../zsh/ ~/
echo "Done"