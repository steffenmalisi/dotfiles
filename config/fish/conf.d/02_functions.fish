for dir in $__fish_config_dir/functions/extra/*
  if test -d $dir
    set -gx fish_function_path $fish_function_path $dir
  end
end