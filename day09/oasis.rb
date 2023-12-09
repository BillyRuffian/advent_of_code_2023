lines = File.readlines('input.txt', chomp: true).map { |l| l.split.map(&:to_i) } 

def deltarize(histories)
  deltas = histories.map do |h|
    values = [h]
    row = h
    loop do 
      delta = row.each_cons(2).with_object([]) { |(first, second), memo| memo << second - first}
      values << delta
      row = delta
      break if delta.all? { |n| n.zero? }
    end
    values
  end  
end

def predict(samples)
  samples.map do |l|
    loop do
      l.unshift(l.shift(2).sum)
      break if l.count == 1
    end
    l.first
  end
end

# Part 1

latest_samples = deltarize(lines).map { |d| d.map(&:last).reverse }
predictions = predict(latest_samples)

pp predictions.sum

# part 2

# I was expecting something sneaky for part 2
# but it's just more of the same
# I should fix the above to make it extract and predict in the same loop
# but a sore head this morning

def extrapolate(samples)
  samples.map do |l|
    loop do
      first, second = l.shift(2)
      l.unshift(second - first)
      break if l.count == 1
    end
    l.first
  end
end

earliest_samples = deltarize(lines).map { |d| d.map(&:first).reverse }
extrapolations = extrapolate(earliest_samples).sum

pp extrapolations