function printcert --wraps='keytool -v -printcert -file' --description 'Prints verbose certificate information'
  keytool -v -printcert -file $argv;
end
