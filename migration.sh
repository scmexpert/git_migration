CD=`pwd`
repo=$1

newrepo=$(echo "$repo" | awk -F'/' '{print $NF}')
echo $newrepo
test -z $newrepo && echo "Repo name required." 1>&2 && exit 1
token=xxxxxxxxxxxxxx


curl -H "Content-Type:application/json" https://gitlab.com/api/v3/projects?private_token=$token -d "{ \"name\": \"$newrepo\", }"

cd $CD

# Please provide your source git repository
git clone git@github.com:scmexpert/helloworld_ant.git
cd helloworld_ant
pwd > $CD/helloworld_ant_dir
git remote rm origin
git filter-branch --subdirectory-filter $microservice_name -- --all
#incase if you want to keep all your source file under new repository name, uncomment below two lines or if you want to create new repository with your source code in your parent level, leave as it is.

#mkdir <directory 1>
#mv * <directory 1>

git add .
git commit -m "adding new files" --allow-empty

cd $CD
git clone git@github.com:scmexpert/$newrepo.git
cd $newrepo
git remote add repo-A-branch `cat $CD/helloworld_ant_dir`
git pull repo-A-branch master
git remote rm repo-A-branch
git push

 
