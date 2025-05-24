# bin/rb_commenter.rb 


file_path = ARGV[0]
abort("No file path provided") unless file_path

# Convert to relative path from project root
absolute_path = File.expand_path(file_path)
project_root = Dir.pwd
relative_path = absolute_path.sub("#{project_root}/", "")

# Read file content
lines = File.readlines(file_path)

# Only add comment if it’s not already present
unless lines[0]&.match(/#.*#{Regexp.escape(relative_path)}.*/)
  comment_line = "# #{relative_path}\n"
  lines.unshift(comment_line)
  File.write(file_path, lines.join)
  puts "Inserted comment into #{file_path}"
else
  puts "Comment already exists in #{file_path}"
end