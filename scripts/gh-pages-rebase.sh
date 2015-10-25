#!/bin/bash

#http://lea.verou.me/2011/10/easily-keep-gh-pages-in-sync-with-master/

git checkout gh-pages
git rebase master
git push origin gh-pages
git checkout master
