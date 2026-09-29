## Command history configuration
# Use the default history file unless one is already configured.
if [ -z "$HISTFILE" ]; then
    HISTFILE=$HOME/.zsh_history
fi

HISTSIZE=10000 # Maximum number of history entries kept in memory.
SAVEHIST=10000 # Maximum number of history entries saved to disk.
setopt HIST_VERIFY # Review history expansions before executing them.
setopt EXTENDED_HISTORY # Store timestamps and duration fields in the history file.
unsetopt INC_APPEND_HISTORY # SHARE_HISTORY already appends commands incrementally.
setopt SHARE_HISTORY # Import and append history across shell sessions.
setopt HIST_IGNORE_ALL_DUPS # Remove older entries matching a newly added command.
setopt HIST_FIND_NO_DUPS # Skip duplicate matches when searching history.
setopt HIST_REDUCE_BLANKS # Remove unnecessary whitespace from recorded commands.
