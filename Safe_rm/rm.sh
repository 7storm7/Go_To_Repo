# Protection from accidental rm
# TODO: Find way to support file names with space
function rm ()
{
  local real_rm="/usr/bin/rm"
  if [[ $1 == "--real" ]]
  then
     shift
     $real_rm $@
     return
  fi

  gio trash $@
  echo "File/folder moved to trash..."
}
