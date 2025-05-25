# bin/js_commenter.rb

# Learning/refershing process wiht comments

# Get the first command-line argument, which should be a path to the file
file_path = ARGV[0]

# If no file path is provided, exit the program with an error message
abort("No file path provided") unless file_path

# Convert the provided path to an absolute path (handles relative paths, symlinks, etc.)
absolute_path = File.expand_path(file_path)

# Get the current working directory, which we treat as the "project root"
project_root = Dir.pwd

# Calculate the path to the file relative to the project root directory
# For example, if project_root is "/Users/you/myproject"
# and absolute_path is "/Users/you/myproject/app/file.js"
# then relative_path will be "app/file.js"
relative_path = absolute_path.sub("#{project_root}/", "")

# Read all the lines from the target file into an array
# Each element of the array is a line in the file
lines = File.readlines(file_path)

# Construct the comment line that will be added at the top of the file
# It will look like: "// app/file.js"
comment_line = "// #{relative_path}\n"

# Check if the first line already includes a comment with the relative path
# The regex matches lines starting with "//" followed by the same relative path
# `Regexp.escape` ensures that special characters (like dots or slashes) in the path
# are treated as literal characters in the regex
unless lines[0]&.match(/^\/\/\s*#{Regexp.escape(relative_path)}\s*$/)
  # If the comment isn't found, add it as the first line
  lines.unshift(comment_line)

  # Write all the lines (with the comment added at the top) back into the file
  File.write(file_path, lines.join)

  # Print confirmation to the console
  puts "Inserted comment into #{file_path}"
else
  # If the comment is already there, let the user know
  puts "Comment already exists in #{file_path}"
end
