+ The package is built using "fpm" package builder , an open source project.
+ The script's help is converted to manpage format using "help2man" utility.

### fpm command : 

`fpm -s dir -t deb -n project_name  --deb-changelog manpagefile.1  --deb-copyright LICENSE  source_folder`

For help regarding `fpm` use : `fpm --help` (has better docs than in website )


### help2man command : 

`help2man scriptfile`  # the script should have --help and --version options


### NOTE :-
+ If man page is not working after installing debian package, then make a post-install script which copies the manpage.1 file to `/usr/share/man/man1/manpage.1`
+ It is important that the manpage file should be suffixed with **".1"** .

