# Notify when a long command is finished
# Requires terminal-notifier (brew install terminal-notifier)
local COMMAND=""
local COMMAND_TIME=""
precmd() {
    if [ "$COMMAND_TIME" -ne 0 ]; then
        local d=$(date +%s)
        d=$(expr $d - $COMMAND_TIME)
        if [ $d -ge 30 ]; then
            COMMAND="${COMMAND} "
            terminal-notifier -title "${${(s: :)COMMAND}[-1]}" -subtitle "Finished long command" -message "${COMMAND}" -sound Bloww
            say "Finished long command: ${${(s: :)COMMAND}[-1]}"
        fi
    fi
    COMMAND=""
    COMMAND_TIME=0
}
preexec() {
    COMMAND="${1}"
    COMMAND_TIME=$(date +%s)
}
