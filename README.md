##Recycle Bin for Linux (Terminal Mode) such as i3wm
##Update Log
* v1.2
  - use ```rm -u or rm -user``` to show current user's bin
* v1.1
  - Show Detail when disable/enable font awesome by run ```sudo rm -f {value}```

##Installation
* move ```rbin.sh``` to ```/usr/bin```
* run command ``` sudo chmod 777 /usr/bin/rbin.sh ```
* re-open terminal

##Recommended
* Download and Install FontAwesome for Icon
* if you want to replace ```rm``` with this, you can by follow this step
  - add ```alias sudo="sudo "``` to your .bashrc or your shell init
  - add ```alias rm="rbin.sh"``` to your .bashrc or your shell init
  - re-open terminal
  - now you can call this script by use ```rm``` command

##Usage 
If you add ```alias rm="rbin.sh"``` to your .bashrc you can use ```rm``` instend of ```rbin.sh```. If not, you must use ```rbin.sh``` instend
* First Step you need to init your user (temporary bin will be ```/home/{user}/.local/.rbin/```). You can change user's bin by this command. This script support multi user.
  - ```sudo rm init realtime``` realtime is your username
  - ![alt img](https://raw.githubusercontent.com/RealtimeBagIdea/Rbin/master/screenshot/init.png)

* Remove file to Bin
  - pattern: ```rm {file1} {file2} {file3}```
  - ex1. ```rm file1.txt file2.txt``` remove by select manual
  - ex2. ```rm * .*``` remove all file and directory (include hidden file)
  - ![alt img](https://raw.githubusercontent.com/RealtimeBagIdea/Rbin/master/screenshot/rm.png)

* Delete file from hardisk
  - pattern: ```rm -d {file1} {file2} {file3}```
  - ex1. ```rm -d file1.txt file2.txt``` delete by select manual
  - ex2. ```rm -d * .*``` delete all file and directory (include hidden file)
  - ![alt img](https://raw.githubusercontent.com/RealtimeBagIdea/Rbin/master/screenshot/delete.png)
  
* List file in recycle bin
  - pattern: ```rm -l``` list short of file
  - pattern: ```rm -L``` list file with time
  - ![alt img](https://raw.githubusercontent.com/RealtimeBagIdea/Rbin/master/screenshot/list.png)
  
* Restore file from recycle bin
  - you can see index by ```rm -l```
  - pattern: ```rm -r {Index} {TargetPath}```
  - ex1. ```rm -r 0,1,2 ~/foo``` restore files to ```~/foo```
  - ex2. ```rm -r . ~/foo``` restore all files to ```~/foo```
  - ex3. ```rm -r 0,1``` restore files to current directory
  - ![alt img](https://raw.githubusercontent.com/RealtimeBagIdea/Rbin/master/screenshot/restore.png)
  
* Clean Bin (Delete file from bin)
  - pattern: ```rm -c {Index}```
  - ex1. ```rm -c 0,1,2``` delete manual files from bin
  - ex2. ```rm -c``` delete all files from bin
  - ![alt img](https://raw.githubusercontent.com/RealtimeBagIdea/Rbin/master/screenshot/clean.png)

* Get bin size
  - pattern: ```rm -s```
  
* Enable / Disable FontAwesome (Terminal must support Unicode)
  - pattern: ```sudo rm -f {value 0 or 1}```
  - ex1. ```sudo rm -f 0``` disable FontAwesome
  - ex2. ```sudo rm -f 1``` enable FontAwesome
