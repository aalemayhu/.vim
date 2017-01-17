#! /bin/bash

refresh_modules()
{
  # FROM: https://github.com/jfrazelle/.vim/blob/master/update.sh
  git submodule foreach git pull origin master &
}

generate_readme()
{
  output=README.md
  echo "# .vim" > $output
  echo >> $output
  echo "My [dot vim](https://github.com/scanf/.vim/blob/master/.vimrc) and the plugins." >> $output
  echo "This repository was orginaly based on" >> $output
  echo "[jfrazelle/.vim](https://github.com/jfrazelle/.vim.git)." >> $output
  echo >> $output

  echo "## Plugins" >> $output
  echo >> $output
  for plugin in bundle/*;
  do
    readme=`find $plugin -maxdepth 1 -iname 'README.*'`
    if [ -n $readme ]; then
      echo "`cat $readme|head -n1|tr '#' '-'` - [link]($plugin)" >> $output
      echo >> $output
    fi
  done
}

refresh_modules
generate_readme

git add .
git commit -m "update" .

