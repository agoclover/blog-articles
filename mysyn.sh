#! /bin/bash

B_FROM=/Users/amos/blog/source/_posts
B_TO=/Users/amos/Learning/BlogArticles/Contents
B_Dir=/Users/amos/Learning/BlogArticles

# 遍历
for file in $(ls $B_FROM)
do
	# 查询其 inode 号
	FILE_INODE=`ls -il $B_FROM | grep -i $file | awk -F ' ' '{print $1}'`
	SEARCH_RES=`ls -il $B_TO | grep -i $FILE_INODE | wc -l`
    # 判断是否为空
    # if [ ! -n $SEARCH_RES ];then
    if [ $SEARCH_RES -eq 0 ]; then	
  		ln $B_FROM/"$file" $B_TO/"$file"
  		echo "Back up $file to BlogArticles."
	fi
done
echo "All articles backed up."
cd $B_Dir
git add -A
git commit -m "Synchronize blog articles"
git push -u origin master