### Summary : 
+ The package is built using "fpm" package builder , an open source project.
+ The script's help is converted to manpage format using "help2man" utility.


### help2man command : 

+ make sure your script has --help and --version flag . The man page generated will have both of these included in output.

```bash
help2man script -n "Put deleted files into trash for safety"  -s 1 -S Debian  > commandname.1  
# .1 at the end is used by other programs. Its highly recommended to retain ".1" as suffix
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

### Signing the package (Without building it ): 

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



### Building and Signing the package (Recommended): 

+ Create the following folder structure.
    ```bash
    sandbox #workspace
      |-projectname
            |- debian
            |     |-control   #Generate this using Debreate
            |     |-copyright #Write the copyright info like MIT license
            |     |-manpages  #commandname.1
            |     |-docs      #projectfile2
            |     |-install   #projectfile1  /usr/bin
            |     |-changelog
            |     |-rules
            |
            |- projectfile1
            |- projectfile2
            |- projectfile3
            |- commandname.1  #must end with ".1" This is the manpage
            |-.. so on 
    ```

### Sample debian/files files : 

+ **Sample "debian/rules" file :**
    ```bash
    #!/usr/bin/make -f
    # See debhelper(7) (uncomment to enable)
    # output every command that modifies files on the build system.
    #export DH_VERBOSE = 1

    script="$(CURDIR)/rm-trash"

    DEST1="$(CURDIR)/debian/rm-trash/usr/share/rm-trash"

    # see FEATURE AREAS in dpkg-buildflags(1)
    #export DEB_BUILD_MAINT_OPTIONS = hardening=+all

    # see ENVIRONMENT in dpkg-buildflags(1)
    # package maintainers to append CFLAGS
    #export DEB_CFLAGS_MAINT_APPEND  = -Wall -pedantic
    # package maintainers to append LDFLAGS
    #export DEB_LDFLAGS_MAINT_APPEND = -Wl,--as-needed


    %:
            dh $@


    # dh_make generated override targets
    # This is example for Cmake (See https://bugs.debian.org/641051 )
    # override_dh_auto_configure:
    # dh_auto_configure -- #  -DCMAKE_LIBRARY_PATH=$(DEB_HOST_MULTIARCH)
    ```
+ Sample "debian/changelog" file : 
    ```bash
    rm-trash (1.34-1) bionic; urgency=medium

  * Initial release (Closes: #0)  <0 is the bug number of your ITP>

    -- Natesh M Bhat <nateshmbhatofficial@gmail.com>  Fri, 16 Nov 2018 08:57:17 +0530

    ```

+ Make a tar compressed file of the folder `projectname` which is inside the `sandbox` directory.
+ Go inside the `sandbox/projectname` folder and build the project here using this command with the secret key id got by `gpg --list-secret-key name` earlier (no space between "k" and the key ) : 

    ```bash
    debuild -kMYKEYID -S        
    ```
+ The source package is built and now upload the file using `dput`

    ```bash
    dput ppa:nateshmbhat/rm-trash rm-trash_1.34-1_source.changes
    ```
+ make sure that for any changes or updates in the script code , change only the `changelog` file inside the debian directory (keeping rest of the files untouched) and build the project again using `debuild` as shown before . 
+ If any information regarding the files inside the `debian` folder is to be obtained , use the man page for `dh_filename` . 

    Example : 
    ```bash
    $: man dh_install # or 
    $: man dh_manpages
    ```


### Uploading to launchpad :

+ Once all are correctly built and signed , upload the ppa . 

```
dput ppa:nateshmbhat/rm-trash rm-trash_1.0_amd64.changes 
```

+ If it gets rejected because of "obsolete ubuntu distribution series" or something similar to distro , then choose one of the distros mentioned here : https://wiki.ubuntu.com/Releases