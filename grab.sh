if [ $# -eq 0 ]
then
  selected=$(ls -p | fzf --bind "ctrl-a:select-all" --bind "ctrl-d:deselect-all" -m)
  if [ -z "$selected" ]
  then
    exit 1
  fi
  
  mkdir -p ~/.grab
  file=~/.grab/selected

  out=""
  IFS=' ' read -ra a <<< $(echo $selected)

  for line in ${a[@]}
  do
    out="$out $PWD/$line"
  done

  echo $out > $file
fi

dir=.

if [ $# -gt 1 ]
then
  dir=$2
fi

if [ $# -gt 0 ]
then
  input="$HOME/.grab/selected"
  IFS=' ' read -ra arr <<< $(cat $input)

  if [ $1 == "cut" ]
  then
    for line in ${arr[@]} 
    do
      mv $line $dir 
    done
  elif [ $1 == "copy" ]
  then
    for line in ${arr[@]} 
    do
      if [[ $line == */ ]]
      then
        cp -r $line $dir 
      else
        cp $line $dir
      fi
    done
  else
    echo "unknown command $1"
    exit 1
  fi
fi

exit 0
