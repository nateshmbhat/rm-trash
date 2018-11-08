# safe-rm
"safe-rm" puts the files you delete in a shell into the Trash (Recycle bin). The script is meant to be used in place of rm system command in linux . This script will safely delete your files and put them in the trash.

This solves accidental removals. The script is meant to be used as an alias with rm directly and unlike other such scripts , it can handle duplicate files in the trash and works for recursive arguments also . 

### Features :
+ Meant to be used in place of `rm`
+ Handles all arguments that rm can take
+ If the deletion was unsuccessful because of wrong arguments , then it deletes the trashed files to save space.
+ Handles the file name collisions with the files already in trash
+ Handles some permission issues automatically
+ If rm is called from any other script or indirectly then the system 'rm' command is used automatically
+ Shows the appropriate error messages exactly like those which arise in `rm` 


<br>


### How It Works :
It first gets the arguments that you would specify for `rm` command and then if the files have right permissions then saves the files in the trash with the required meta data about it. After saving , it gives the file for deletion to `rm` with the given options.

If deletion of was unsuccesful for some reason , it deletes back the saved file or folder from the trash to save space.   



<br>

## Installation :

Method 1 :

**Put the file in the /usr/local/bin directory and rename it to rm**

```
mv safe-rm.bash /usr/local/bin/rm
```

Method 2 :

**Have an alias for rm pointing to this script in bash_aliases**
```
echo "alias rm=safe-rm" > ~/.bash_aliases
```


## Usage :

Usage is just like we use the rm command normally

```
rm filename
```

Now it shows your filename in the Trash which can then be easily restored to any desired location.