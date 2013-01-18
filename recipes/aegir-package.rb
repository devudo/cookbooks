# this is the simple way to get started.
# We let apt handle installing aegir... for now

apt_repository "koumbit-stable" do
  uri "http://debian.koumbit.net/debian"
  components ["stable", "main"]
  key "http://debian.koumbit.net/debian/key.asc"
  action :add
end
package "aegir"
