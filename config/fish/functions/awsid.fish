function awsid --wraps='aws sts get-caller-identity' --description 'Get AWS caller identity'
  aws sts get-caller-identity $argv;
end
