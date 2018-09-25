class PairedEntry
  include Comparable
  attr_accessor :value
  attr_accessor :index

  def initialize(index:, value:)
    @index = index
    @value = value
  end

  def <=>(other)
    @value <=> other.value
  end

  def to_s
    "(i:#{@index}, v:#{@value})"
  end
end

# via https://gist.github.com/aspyct/3433278
def mergesort(arr)
  return arr if arr.empty? || arr.length == 1
  
  # divide
  midpoint = arr.count / 2
  part_a = mergesort(arr.slice(0, midpoint))
  part_b = mergesort(arr.slice(midpoint, arr.length - midpoint))

  # conquer
  res = []
  offset_a = 0
  offset_b = 0
  while offset_a < part_a.length && offset_b < part_b.length
    if part_a[offset_a] < part_b[offset_b]
      res << part_a[offset_a]
      offset_a += 1
    else
      res << part_b[offset_b]
      offset_b += 1
    end
  end

  # get remaining elements from (at most) one array
  while offset_a != part_a.length
    res << part_a[offset_a]
    offset_a += 1
  end
  
  while offset_b != part_b.length
    res << part_b[offset_b]
    offset_b += 1
  end

  res
end

def binary_search(arr, val)
  candidate = arr.length/2
  return -1 if arr.empty?
  return arr[candidate] if val == arr[candidate].value
  arr[candidate].value > val ? binary_search(arr.slice(0, arr.length/2), val) : binary_search(arr.slice(arr.length/2, arr.length/2), val)
end

num = 2
50.times do 
  start = Time.now
  # Make the input array
  arr = []
  num.times do |x|
    arr << rand(1000000000)
  end
  # Make an array b such that the elements of b are the form (x, y), where arr[x]=y
  b = arr.each_with_index.map { |val, ind| PairedEntry.new(index: ind, value: val) }

  # Using mergesort, sort array b
  b = mergesort(b)

  # Now, since we are trying to find arr[i] - 2018 = arr[j], use binary search on each element of b
  ans = -1

  source_pair = nil
  b.each do |el|
    source_pair = el
    ans = binary_search(b, el.value - 2018)
    break if ans.class == PairedEntry
  end

  num = num * 2
  next unless ans.class == PairedEntry
  puts "Found pair! N = #{num}"
  puts "Answer Pair: #{source_pair}, #{ans}"
  puts "Value in original array: #{arr[source_pair.index]}, #{arr[ans.index]}"
  puts "Time taken = #{Time.now - start}"
  puts
end