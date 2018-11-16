### Summary : 
+ The package is built using "fpm" package builder , an open source project.
+ The script's help is converted to manpage format using "help2man" utility.


### help2man command : 

+ make sure your script has --help and --version flag . The man page generated will have both of these included in output.

```bash
help2man script -n "Put deleted files into trash for safety"  -s 1 -S Debian  > outputpage
```


 NOTE :-
+ If man page is not working after installing debian package, then make a post-install script which copies the manpage.1 file to `/usr/share/man/man1/manpage.1`
+ It is important that the manpage file should be suffixed with **".1"** .


### Build Debian package using **"Debreate"** GUI :

+ Use https://www.youtube.com/watch?v=nhoRyd2CEVs to create the debian folder and edit required files.
+ Use "Debcreate" GUI tool to better create control and copyright  
+ While running `fakeroot` tool , don't build it with `-F` flag but instead , give `-S` flag since launchpad only accepts source package.

```bash
fakeroot dpkg-buildpackage -S --sign-key=MYKEYID
```

### Signing the package : 

+ Once the *.deb file is created , then its time to sign the package and upload it to any PPA .

+ First get the secret key id using `gpg --list-secret-keys name`.

+ Then sign the source.changes file generated using `fpm` command earlier.

```bash
debsign -kMYKEYID source.changes
```

+ Make sure that before signing in , the following fields are present in the source.changes file.

    + Changes
    + Changed-By

+ For details about the format of these fields see : https://www.debian.org/doc/debian-policy/ch-controlfields.html


### Uploading to launchpad :

+ Once all are correctly signed , upload the ppa . 

```
dput ppa:nateshmbhat/rm-trash rm-trash_1.0_amd64.changes 
```

+ If it gets rejected because of "obsolete ubuntu distribution series" or something similar to distro , then choose one of the distros mentioned here : https://wiki.ubuntu.com/Releases