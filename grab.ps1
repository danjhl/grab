if ($args.Count -eq 0) {
    $childItems = Get-ChildItem -Force

    $arr = @()

    foreach ($item in $childItems) {
        $arr = $arr + $item.Name
    }

    $selected = $(echo $arr | fzf --bind "ctrl-a:select-all" --bind "ctrl-d:deselect-all" -m)
    if ($selected) {
        md -Force $HOME/.grab | Out-Null
        $file = "$HOME/.grab/selected"

        $items = $selected -split " "
        $out = ""

        foreach ($item in $items) {
            $out = $out + "$PWD/$item "
        }

        echo $out.Trim() > $file
    } else {
        exit 1
    }
}

$dir = "."
if ($args.Count -gt 1) {
    $dir = $args[1]
}

if ($args.Count -gt 0) {
    $file = "$HOME/.grab/selected"
    $items = $(cat $file) -split " "
    $command = $args[0]
    
    foreach ($item in $items) {
        if ($command -eq "cut") {
            mv $item $dir
        } elseif ($command -eq "copy") {
            cp -r $item $dir
        } else {
            echo "unknown command $command"
            exit 1
        }
    }
}
