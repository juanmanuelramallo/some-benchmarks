# To check how many times realloc has been called run this file using:
#
#Inject:
#   sudo dtrace -q -n 'pid$target::realloc:entry { @ = count(); }' -c "ruby absolute-path-to-this-file"
#
# Map-Join:
#   sudo dtrace -q -n 'pid$target::realloc:entry { @ = count(); }' -c "ruby absolute-path-to-this-file map"
#
# More info about why realloc is more expensive than malloc here https://medium.com/@jraleman/c-programming-language-functions-malloc-calloc-realloc-and-free-61cfc3e45da7#:~:text=It's%20better%20to%20use%20malloc,memory%20block%20on%20the%20heap.&text=int%20*ptr%20%3D%20malloc(10%20*%20sizeof(int))%3B&text=If%20pointer%20passed%20to%20realloc,will%20behave%20exactly%20like%20malloc.

count = 10000

if ARGV[0]
  puts 'map-join'
  count.times do |i|
    Array.new(i, { text: 'text' }).map { |hash| hash[:text] }.join
  end
else
  puts 'inject'
  count.times do |i|
    Array.new(i, { text: 'text' }).inject(String.new) { |memo, hash| memo << hash[:text] }
  end
end
