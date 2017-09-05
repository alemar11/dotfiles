echo "Configuring Xcode..."

XCODE_CODESNIPPETS_FOLDER="$HOME/Library/Developer/Xcode/UserData/CodeSnippets"
XCODE_THEMES_FOLDER="$HOME/Library/Developer/Xcode/UserData/FontAndColorThemes"

echo "CodeSnippets"
if [ ! -d $XCODE_CODESNIPPETS_FOLDER ]; then
  mkdir -p $XCODE_CODESNIPPETS_FOLDER;
fi

cp -a ../xcode/CodeSnippets/ $XCODE_CODESNIPPETS_FOLDER

echo "Font and color Themes"
if [ ! -d $XCODE_THEMES_FOLDER ]; then
  mkdir -p $XCODE_THEMES_FOLDER;
fi

cp -a ../xcode/FontAndColorThemes/ $XCODE_THEMES_FOLDER

echo "Done."