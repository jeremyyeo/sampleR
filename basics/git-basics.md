# Folder Navigation

Go into specific folder

    cd foldername

Go back up a level

    cd ..

# Git Basics

Good idea to always check the status of repository

    git status

Also pull in the latest changes before doing a push

    git pull
    
Stage changes for a specific file

    git add filename.ext
    
Stage changes all files (including newly created files)

    git add -A

Commit with message

    git commit -m "this is a descriptive commit message"

To stage all changes (excludes newly created files) and commit in one command

    git commit -am "this is a descriptive commit message"

Push commits to remote origin

    git push
