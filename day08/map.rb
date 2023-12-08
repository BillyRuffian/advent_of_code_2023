lines = File.readlines('input.txt', chomp: true)

directions = lines.shift.chars.cycle
lines.shift

L = 0
R = 1

map = lines.map do |line|
  start, left, right = line.scan(/\w{3}/)
  [start, [left, right]]
end.to_h

# part 1

# iter = 0
# node = 'AAA'
# loop do
#   choices = map[node]
#   node = choices[Object.const_get(directions.next.to_sym)]
#   iter += 1
#   break if node == 'ZZZ'
# end

# puts iter

# Part 2

# OK, so clearly not a bruce-force one

# iter = 0
# loop do
#   puts iter if iter % 1_000_000 == 0
#   direction = directions.next.to_sym
#   nodes.map! do |n| 
#     choices = map[n]
#     choices[Object.const_get(direction)]
#   end

#   iter += 1
#   break if nodes.all? { |n| n.end_with?('Z') }
# end

# pp iter

# Let's try again

# Maybe lowest common multiple?
# Get the individual path lengths and
# assuming they're constant with each iter (😳)

nodes = map.keys.select { |n| n.end_with?('A') }
path_lengths = nodes.map do |n|
  iter = 0 
  node = n
  loop do 
    choices = map[node]
    node = choices[Object.const_get(directions.next.to_sym)]
    iter += 1
    break if node.end_with?('Z')
  end
  iter
end

pp path_lengths.reduce(&:lcm)
#  ah yeah, that's it, sneeeeeaky instructions