lines = File.readlines('input.txt', chomp: true)

# Brute force -- don't hate me

# Part 1

times_and_distances = lines.map { |l| l.split.drop(1).map(&:to_i) }.then { |(t,d)| t.zip(d) }

ways_to_win = -> (time, distance) { (1..time).map {|t| t * (time - t) > distance ? 1 : 0 }.sum }

pp times_and_distances.map { |(t, d)| ways_to_win.(t,d) }.inject(&:*)

# Part 2

times_and_distances = lines.map { |l| l.split.drop(1).join.to_i }

pp ways_to_win.(*times_and_distances)