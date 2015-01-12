require 'json'

if ARGV[0].nil?
  STDERR.puts "Please, provide the path that should be scanned"
  exit
else
  path = ARGV.join(" ")
end

output = `find #{path} -type f | awk '{print \"\\\"\"$0\"\\\"\"}' | xargs -n 10 -P 2 md5sum`

map = {}
output.each_line { |line|
  
  key = line[0,32]
  value = line[34..-2]
  
  if !map.has_key?(key)
    map[key] = [value]
  else 
    map[key] << value
  end
  
}

duplicates = []

map.each_value { |value|  
  
  if value.length > 1
    duplicates << value
  end
}


puts duplicates.to_json
