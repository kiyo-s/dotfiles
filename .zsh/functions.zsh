## ghqとの連携。ghqの管理化にあるリポジトリを一覧表示する。ctrl - ]にバインド。
function peco-src () {
    local selected_dir=$(ghq list -p | peco --prompt="repositories >" --query "$LBUFFER")
    if [ -n "$selected_dir" ]; then
        BUFFER="cd ${selected_dir}"
        zle accept-line
    fi
    zle clear-screen
}
zle -N peco-src
bindkey '^]' peco-src

function gwt() {
# Git worktree を作成する便利関数
# 使用方法: gwt <branch-name>
#
# 機能:
# - ブランチが存在しない場合は作成（リモートブランチがあれば追跡、なければ現在のブランチから作成）
# - worktree を ${リポジトリ名}-${ブランチ名} のディレクトリに作成
# - ブランチ名の "/" と "_" は "-" に変換s
    local branch_name="$1"

    # 引数チェック
    if [[ -z "$branch_name" ]]; then
        echo "Error: ブランチ名を指定してください"
        echo "使用方法: gwt <branch-name>"
        return 1
    fi

    # Git リポジトリかどうか確認
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        echo "Error: Git リポジトリではありません"
        return 1
    fi

    # Git リポジトリのルートディレクトリを取得
    local repo_root
    repo_root=$(git rev-parse --show-toplevel)

    # Git リポジトリ名を取得（ディレクトリ名から取得）
    local repo_name
    repo_name=$(basename "$repo_root")

    # ブランチ名を正規化（/ と _ を - に変換）
    local normalized_branch
    normalized_branch=$(echo "$branch_name" | sed 's/[/_]/-/g')

    # worktree を作成するパス
    local worktree_path
    worktree_path="${repo_root}/../${repo_name}-${normalized_branch}"

    # 既に worktree が存在するかチェック
    if git worktree list | grep -q "$branch_name"; then
        local existing_path
        existing_path=$(git worktree list | grep "$branch_name" | awk '{print $1}')
        echo "Error: ブランチ '$branch_name' の worktree は既に存在します"
        echo "パス: $existing_path"
        return 1
    fi

    # 作成先ディレクトリが既に存在するかチェック
    if [[ -e "$worktree_path" ]]; then
        echo "Error: ディレクトリ '$worktree_path' は既に存在します"
        return 1
    fi

    # リモートの情報を更新
    echo "リモートの情報を取得中..."
    git fetch --prune > /dev/null 2>&1

    # ローカルブランチの存在確認
    local local_branch_exists=false
    if git show-ref --verify --quiet "refs/heads/$branch_name"; then
        local_branch_exists=true
    fi

    # リモートブランチの存在確認
    local remote_branch_exists=false
    local remote_name=""
    if git show-ref --verify --quiet "refs/remotes/origin/$branch_name"; then
        remote_branch_exists=true
        remote_name="origin/$branch_name"
    fi

    # worktree を作成
    echo "Worktree を作成中: $worktree_path"

    if $local_branch_exists; then
        # ローカルブランチが既に存在する場合
        echo "既存のローカルブランチ '$branch_name' を使用します"
        git worktree add "$worktree_path" "$branch_name"
    elif $remote_branch_exists; then
        # リモートブランチが存在する場合は追跡
        echo "リモートブランチ '$remote_name' を追跡する新しいブランチを作成します"
        git worktree add "$worktree_path" -b "$branch_name" --track "$remote_name"
    else
        # どちらも存在しない場合は現在のブランチから新規作成
        local current_branch
        current_branch=$(git branch --show-current)
        echo "現在のブランチ '$current_branch' から新しいブランチ '$branch_name' を作成します"
        git worktree add "$worktree_path" -b "$branch_name"
    fi

    if [[ $? -eq 0 ]]; then
        echo "✓ Worktree を作成しました: $worktree_path"
        echo ""
        echo "移動するには: cd $worktree_path"
        return 0
    else
        echo "Error: Worktree の作成に失敗しました"
        return 1
    fi
}
