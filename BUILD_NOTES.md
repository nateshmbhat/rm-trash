### Summary : 
+ The package is built using "fpm" package builder , an open source project.
+ The script's help is converted to manpage format using "help2man" utility.

### fpm command : 

```bash
fpm -s dir -t deb -n 'rm-trash' --deb-changelog man/man1/manpage.1 --license LICENSE rm-trash/rm-trash=/usr/bin/rm-trash man/man1/manpage.1=/usr/share/man/man1/rm-trash.1
```

For help regarding `fpm` use : `fpm --help` (has better docs than in website )


### help2man command : 

```bash
help2man ../../rm-trash/rm-trash -n "Put deleted files into trash for safety"  -s 1 -S Debian  > outputpage
```


### NOTE :-
+ If man page is not working after installing debian package, then make a post-install script which copies the manpage.1 file to `/usr/share/man/man1/manpage.1`
+ It is important that the manpage file should be suffixed with **".1"** .
