function fixperms -d "fix permissions"
  set -g fixperms_version 0.0.1
  set args (getopt -s sh hvfd: $argv); or __fixperms_usage

  set -l target_path (realpath $argv[-1])
  set -l perms_files 644
  set -l perms_directories 755
  set -l fixed_directories 0
  set -l fixed_files 0


  # echo $argv

  for idx in (seq (count $argv))
    # echo $argv[$idx]

    switch $argv[$idx]
      case -h --help help
        __fixperms_usage > /dev/stderr
        return
      case -v --version version
        echo "v$fixperms_version"
        return
      case -f --files
        set perms_files $argv[(math "$idx + 1")]
        # break
      case -d --directories
        set perms_directories $argv[(math "$idx + 1")]
        # break
    end
    # set $idx (math "$idx + 1")
    # set --erase argv[1]
  end

  # echo "setting permissions for '$target_path': files='$perms_files' directories='$perms_directories'..."

  set fixed_directories (find $target_path -type d ! -perm $perms_directories \
    -exec chmod $perms_directories "{}" \; -exec /bin/echo {} \; | wc -l)

  set -l fixed_files (find $target_path -type f ! -perm $perms_files \
    -exec chmod $perms_files "{}" \; -exec /bin/echo {} \; | wc -l)

  echo "fixed permissions for '$fixed_directories' directories and '$fixed_files' files!"
end
