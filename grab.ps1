if ($args.Count -eq 0) {
    $files = Get-ChildItem -File
    $directories = Get-ChildItem -Directory

    $arr = @()

    foreach ($file in $files) {
        $arr = $arr + $file.Name
    }
    foreach ($dir in $directories) {
        $arr = $arr + "$dir/"
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
    $dir = $args[2]
}

if ($args.Count -gt 0) {
    $file = "$HOME/.grab/selected"
    $items = $(cat $file) -split " "
    $command = $args[0]
    
    foreach ($item in $items) {
        if ($command -eq "cut") {
            mv $item $dir
        } elseif ($command -eq "copy") {
            if ($item.endsWith("/")) {
                cp -r $item $dir
            } else {
                cp $item $dir
            }
        } else {
            echo "unknown command $command"
            exit 1
        }
    }
}
