
# add our recursive git push tweak.
file "/usr/local/bin/git-push-recursive" do
  owner "root"
  group "root"
  mode "0755"
  action :create
  content 'find . -type d -name .git -exec sh -c "cd \"{}\"/../ && pwd && git push" \;'
end

# add our recursive git pull tweak.
file "/usr/local/bin/git-pull-recursive" do
  owner "root"
  group "root"
  mode "0755"
  action :create
  content 'find . -type d -name .git -exec sh -c "cd \"{}\"/../ && pwd && git pull" \;'
end