# aliases
alias xcdd='rm -rf ~/Library/Developer/Xcode/DerivedData/*'
alias xcp='xcode-select --print-path'
alias xcsel='sudo xcode-select --switch'
#alias xc='xed .'

# original author: @subdigital
# source: http://gist.github.com/subdigital/5420709
function xc {
  local xcode_proj
  if [[ $# == 0 ]]; then
    xcode_proj=(*.{xcworkspace,xcodeproj,playground}(N))
    if [ -f "Package.swift" ]; then
      xcode_proj+=("Package.swift")
    fi
  else
    xcode_proj=($1/*.{xcworkspace,xcodeproj,playground}(N))
    if [ -f $1/"Package.swift" ]; then
      xcode_proj+=( $1/"Package.swift")
    fi
  fi

  if [[ ${#xcode_proj} -eq 0 ]]; then
    if [[ $# == 0 ]]; then
      echo "⚠️  No Xcode entrypoint file found in the current directory."
    else
      echo "⚠️  No Xcode entrypoint file found in $1."
    fi
    return 1
  else
    echo "✅ Found ${xcode_proj[1]}, opening with Xcode."
    open -a "Xcode" "${xcode_proj[1]}"
  fi
}

function xcb {
  local xcode_proj
  if [[ $# == 0 ]]; then
    xcode_proj=(*.{xcworkspace,xcodeproj,playground}(N))
    if [ -f "Package.swift" ]; then
      xcode_proj+=("Package.swift")
    fi
  else
    xcode_proj=($1/*.{xcworkspace,xcodeproj,playground}(N))
    if [ -f $1/"Package.swift" ]; then
      xcode_proj+=( $1/"Package.swift")
    fi
  fi

  if [[ ${#xcode_proj} -eq 0 ]]; then
    if [[ $# == 0 ]]; then
      echo "⚠️  No Xcode entrypoint file found in the current directory."
    else
      echo "⚠️  No Xcode entrypoint file found in $1."
    fi
    return 1
  else
    echo "✅ Found ${xcode_proj[1]}, opening with Xcode Beta."
    open -a "Xcode-beta" "${xcode_proj[1]}"
  fi
}

# "Xcode select by version" - select Xcode by just version number
# Uses naming convention:
#  - different versions of Xcode are named Xcode-<version>.app or stored
#     in a folder named Xcode-<version>
#  - the special version name "default" refers to the "default" Xcode.app with no suffix
function xcv {
  emulate -L zsh
  if [[ $# == 0 ]]; then
    echo "xcv: error: no option or argument given" >&2
    echo "xcv: see 'xcv -h' for help" >&2
    return 1
  elif [[ $1 == "-p" ]]; then
    xcode_print_active_version
    return
  elif [[ $1 == "-l" ]]; then
    xcode_list_versions
    return
  elif [[ $1 == "-L" ]]; then
    xcode_list_versions short
    return
  elif [[ $1 == "-h" ]]; then
    xcode_print_xcv_usage
    return 0
  elif [[ $1 == -* && $1 != "-" ]]; then
    echo "xcv: error: unrecognized option: $1" >&2
    echo "xcv: see 'xcv -h' for help" >&2
    return 1
  fi
  # Main case: "xcv <version>" to select a version
  local version=$1
  local -A xcode_versions
  xcode_locate_versions
  if [[ -z ${xcode_versions[$version]} ]]; then
    echo "xcv: error: Xcode version '$version' not found" >&2
    return 1
  fi
  app="${xcode_versions[$version]}"
  echo "selecting Xcode $version: $app"
  xcsel "$app"
}

function xcode_print_xcv_usage {
  cat << EOF >&2
Usage: 
  xcv <version>
  xcv [options]

Options:
  <version> set the active Xcode version
  -h        print this help message and exit
  -p        print the active Xcode version
  -l        list installed Xcode versions (long human-readable form)
  -L        list installed Xcode versions (short form, version names only)
EOF
}

# Parses the Xcode version from a filename based on our conventions
# Only meaningful when called from other xcode functions
function xcode_parse_versioned_file {
  local file=$1
  local basename=${app:t}
  local dir=${app:h}
  local parent=${dir:t}
  #echo "parent=$parent basename=$basename verstr=$verstr ver=$ver" >&2
  local verstr
  if [[ $parent == Xcode* ]]; then
    if [[ $basename == "Xcode.app" ]]; then
      # "Xcode-<version>/Xcode.app" format
      verstr=$parent
    else
      # Both file and parent dir are versioned. Reject.
      return 1;
    fi
  elif [[ $basename == Xcode*.app ]]; then
    # "Xcode-<version>.app" format
    verstr=${basename:r}
  else
    # Invalid naming pattern
    return 1;
  fi

  local ver=${verstr#Xcode}
  ver=${ver#[- ]}
  if [[ -z $ver ]]; then
    # Unversioned "default" installation location
    ver="default"
  fi
  print -- "$ver"
}

# Print the active version, using xcv's notion of versions
function xcode_print_active_version {
  emulate -L zsh
  local -A xcode_versions
  local versions version active_path
  xcode_locate_versions
  active_path=$(xcode-select -p)
  active_path=${active_path%%/Contents/Developer*}
  versions=(${(kni)xcode_versions})
  for version ($versions); do
    if [[ "${xcode_versions[$version]}" == $active_path ]]; then
      printf "%s (%s)\n" $version $active_path
      return
    fi
  done
  printf "%s (%s)\n" "<unknown>" $active_path
}

# Locates all the installed versions of Xcode on this system, for this
# plugin's internal use.
# Populates the $xcode_versions associative array variable
# Caller should local-ize $xcode_versions with `local -A xcode_versions`
function xcode_locate_versions {
  emulate -L zsh
  local -a app_dirs
  local app_dir apps app xcode_ver
  # In increasing precedence order:
  app_dirs=(/Applications $HOME/Applications)
  for app_dir ($app_dirs); do
    apps=( $app_dir/Xcode*.app(N) $app_dir/Xcode*/Xcode.app(N) )
    for app ($apps); do
      xcode_ver=$(xcode_parse_versioned_file $app)
      if [[ $? != 0 ]]; then
        continue
      fi
      xcode_versions[$xcode_ver]=$app
    done
  done
}

function xcode_list_versions {
  emulate -L zsh
  local -A xcode_versions
  xcode_locate_versions
  local width=1 width_i versions do_short=0
  if [[ $1 == "short" ]]; then
    do_short=1
  fi
  versions=(${(kni)xcode_versions})
  for version ($versions); do
    if [[ $#version > $width ]]; then
      width=$#version;
    fi
  done
  for version ($versions); do
    if [[ $do_short == 1 ]]; then
      printf "%s\n" $version
    else
      printf "%-${width}s -> %s\n" "$version" "${xcode_versions[$version]}"
    fi
  done
}