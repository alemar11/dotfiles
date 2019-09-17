# Colors vary depending on time lapsed.
ZSH_THEME_GIT_TIME_SINCE_COMMIT_SHORT="%{$fg[green]%}"
ZSH_THEME_GIT_TIME_SHORT_COMMIT_MEDIUM="%{$fg[yellow]%}"
ZSH_THEME_GIT_TIME_SINCE_COMMIT_LONG="%{$fg[red]%}"
ZSH_THEME_GIT_TIME_SINCE_COMMIT_NEUTRAL="%{$fg[cyan]%}"

function git_parse_dirty() {
  if [[ -n $(git status -s --ignore-submodules=dirty 2> /dev/null) ]]; then
    echo "%{$fg[red]%}"
  else
    echo "%{$fg[green]%}"
  fi
}

# Determine the time since last commit. If branch is clean,
# use a neutral color, otherwise colors will vary according to time.
function git_time_since_commit() {
    if git rev-parse --git-dir > /dev/null 2>&1; then
        # Only proceed if there is actually a commit.
        if git log -n 1  > /dev/null 2>&1; then
            # Get the last commit.
            last_commit=`git log --pretty=format:'%at' -1 2> /dev/null`
            now=`date +%s`
            seconds_since_last_commit=$((now-last_commit))

            # Totals
            MINUTES=$((seconds_since_last_commit / 60))
            HOURS=$((seconds_since_last_commit/3600))

            # Sub-hours and sub-minutes
            DAYS=$((seconds_since_last_commit / 86400))
            SUB_HOURS=$((HOURS % 24))
            SUB_MINUTES=$((MINUTES % 60))

            if [[ -n $(git status -s 2> /dev/null) ]]; then
                if [ "$MINUTES" -gt 120 ]; then
                    COLOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_LONG"
                elif [ "$MINUTES" -gt 60 ]; then
                    COLOR="$ZSH_THEME_GIT_TIME_SHORT_COMMIT_MEDIUM"
                else
                    COLOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_SHORT"
                fi
            else
                COLOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_NEUTRAL"
            fi

            if [ "$HOURS" -gt 24 ]; then
                echo "$COLOR${DAYS}d${SUB_HOURS}h${SUB_MINUTES}m%{$reset_color%}"
            elif [ "$MINUTES" -gt 60 ]; then
                echo "$COLOR${HOURS}h${SUB_MINUTES}m%{$reset_color%}"
            else
                echo "$COLOR${MINUTES}m%{$reset_color%}"
            fi
        else
            COLOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_NEUTRAL"
            echo "$COLOR"
        fi
    fi
}

function git_prompt_info() {
  # Ignore directorys that aren't in git
  if ! git ls-files >& /dev/null; then
    return;
  fi;

  # Ignore the home directory
  if [ "$(git rev-parse --quiet --show-toplevel)" '==' $HOME ]; then
    return;
  fi;

  # Get the branch name and color
  ref=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/') || return
  if [ -z "$ref" ]; then
      echo " $ZSH_THEME_GIT_PROMPT_PREFIX$(git_parse_dirty)No branch%{$reset_color%}$ZSH_THEME_GIT_PROMPT_SUFFIX"
      return;
  fi;
  echo " $ZSH_THEME_GIT_PROMPT_PREFIX$(git_parse_dirty)${ref#refs/heads/}%{$reset_color%}|$(git_time_since_commit)$ZSH_THEME_GIT_PROMPT_SUFFIX%{$reset_color%}"
}

ZSH_THEME_GIT_PROMPT_PREFIX="("
ZSH_THEME_GIT_PROMPT_SUFFIX=")"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$reset_color%}"

PROMPT='%{$fg[magenta]%}%c%{$reset_color%}$%{$reset_color%}$(git_prompt_info) '
#RPROMPT='$(git_prompt_info)'
