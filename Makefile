all:
	git submodule update --init
	git submodule foreach git pull origin master

refresh:
	imba refresh.imba bundle > .gitmodules

add-new:
	vim +PluginInstall +qa
	make
	make refresh
