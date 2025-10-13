#!/bin/zsh

backup() {
    target=$1
    if [ -e "$target" ]; then
        if [ ! -L "$target" ]; then
            mv "$target" "$target.$(date '+%Y%m%d').backup"
            echo "-----> Moved your old $target config file to $target.$(date '+%Y%m%d').backup"
        fi
    fi
}

symlink() {
    file=$1
    link=$2
    if [ ! -e "$link" ]; then
        echo "-----> Symlinking your new $link"
        ln -s $file $link
    fi
}

for name in .zshrc; do
    target="$HOME/$name"
    file="$(pwd)/$name"
    backup $target
    symlink $file $target
done

for dir in .zsh .claude; do
    target="$HOME/$dir"
    if [ ! -d "$target" ]; then
        mkdir -p "$target"
    fi

    find "$dir" -type f | while IFS= read -r FILE; do
        base=$(basename "$FILE")
        target="$HOME/$dir/$base"
        file="$(pwd)/$dir/$base"
        backup $target
        symlink $file $target
    done
done

exec zsh
