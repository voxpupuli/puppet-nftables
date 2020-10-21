require 'yaml'
require 'find'

Find.find("data").grep(/.*\.yaml/).each do |f|
  data = YAML.load_file(f)
  abort "Hiera file \"#{f}\" must contain a hash if it exists" unless data.class == Hash
  data.each do | key, value |
    if key.is_a? String
      key.split("::").each do | component |
        abort "Malformed namespaced key \"#{key}\" in file \"#{f}\" found" if
          component.include?(':') or component.empty?
      end
    else
      abort "Malformed yaml key (not a string): \"#{key}\""
    end
  end
end
