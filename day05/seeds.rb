require 'pry'

def chunk_file
  File.read('input.txt')
      .split("\n\n")
end

def initial_seeds(line)
  line.scan(/(\d+)/).flatten.map(&:to_i)
end

def build_map(map, chunk)
  lines = chunk.split("\n")
  from_type, to_type = lines.shift.scan(/(\w+)-to-(\w+)/).flatten.map(&:to_sym)
  
  map[from_type] = {} unless map[from_type]

  lines.each do |line|
    values = line.split.map(&:to_i)
    dest_range_start, source_range_start, range_length = values

    map[from_type][(source_range_start..source_range_start+range_length)] = (dest_range_start..dest_range_start+range_length)
  end
end

def lookup(value, map, keys=map.keys, result=[value])
  key = keys.shift
  source_range, dest_range = map[key].find { |source_range, dest_range| source_range.include?(value) }

  lookup = if source_range
            offset = value - source_range.first
            dest_range.first + offset
          else
            value
          end

  result << lookup

  if keys.empty?
    result
  else 
    lookup(lookup, map, keys, result)
  end
end

data_chunks = chunk_file
initial_seeds = initial_seeds(data_chunks.shift)

map = {}
data_chunks.each{ |chunk| build_map(map, chunk) }

# Part 1

details = initial_seeds.map do |seed|
   %i[seed soil fertilizer water light temp humidity location].zip(lookup(seed,map)).to_h
end


pp details.min_by { |h| h[:location] }

# Part 2
# Let's go from the locations
# brute force from 0 upwards
# but invert the map so the function above
# will do the heavy lifting


seed_ranges = initial_seeds.each_slice(2).with_object([]) { |(start, range), memo| memo << (start..start+range) }

closest_locations = map[map.keys.last].values.sort_by { |r| r.first }
furthest_location = closest_locations.last.last
reverse_map = map.clone 
reverse_map.each { |k, v|  reverse_map[k] = v.invert }


(0..furthest_location).each do |loc|
    puts "at #{loc}" if loc % 1_000_000 == 0
    seed = lookup(loc, reverse_map, map.keys.reverse).last
    hit = seed_ranges.find { |seed_range| seed_range.include?(seed) }
    if hit 
      puts "Location #{loc} hit #{hit}"
      return
    end
end