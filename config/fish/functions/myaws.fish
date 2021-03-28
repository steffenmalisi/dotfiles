function myaws
  if test $argv[1] = 'ri'
    aws ec2 describe-instances --filter "Name=tag:Name,Values=$argv[2]" --query "Reservations[].Instances[?State.Name == 'running'].InstanceId[]" --output text
  else
    echo "not implemented yet"
  end
end