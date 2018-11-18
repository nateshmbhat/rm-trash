rm-trash 
---------

# rm-trash
"rm-trash" utility puts the files you delete in a shell safely into the Trash (Recycle bin). The script is meant to be used in place of rm system command in linux .

This solves accidental removals. This utility is meant to be used as an alias with rm directly and unlike other such scripts , it can handle duplicate files in the trash and works for recursive arguments and any other options that rm supports. This is a wrapper around rm and thus supports all options of rm. 

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
mv rm-trash.bash /usr/local/bin/rm
```

Method 2 :

**Have an alias for rm pointing to this script in bash_aliases**
```
echo "alias rm=rm-trash" >> ~/.bash_aliases
```


## Usage :

Usage is just like we use the rm command normally and supports all options of rm.

```
rmtrash filename foldername -r
```
Now it shows your filename in the Trash which can then be easily restored to any desired location.


**Options :**

```
--no-trash : no trash option .
```
Add this option to the command to prevent it from putting the files to trash. Useful when you want to remove huge amount of files and sizes.

```
rmtrash folder/ -r --no-trash
```



 -- Natesh M Bhat <nateshmbhatofficial@gmail.com>  Fri, 16 Nov 2018 08:57:17 +0530

