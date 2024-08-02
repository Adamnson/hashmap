require './linked_list'
require './primes'

# class HashMap implements hash data structure
# class variables :
#   @length
#   @capacity
# class methods :
#   update_capcity
#   hash
#   get
#   set
#   has?
#   remove
#   keys
#   values
#   clear
#   show_list
#   entries
#
class HashMap
  attr_reader :length, :capacity

  @capacity = 0
  @length = 0

  def initialize(size = 11)
    size = prime_greater_than(size) unless prime?(size)
    @buckets = Array.new(size)
    @capacity = @length = @prime = size
  end

  def update_capacity
    @capacity -= 1
    return unless @capacity <= @buckets.length * (1 - 0.8)

    old_buckets = entries
    initialize(@length * 2)
    old_buckets.each do |key, val|
      set(key, val)
    end
  end

  def hash(key)
    hash_code = 0

    if key.is_a? String
      key.each_char { |char| hash_code = (@prime * hash_code) + char.ord }
    elsif key.is_a? Integer
      key.to_s.each_char { |char| hash_code = (@prime * hash_code) + char.ord }
    end

    hash_code
  end

  def set(key, value)
    node_val = get(key)
    if node_val.nil?
      index = hash(key) % @length
      if @buckets[index].nil?
        @buckets[index] = LinkedList.new
        @buckets[index].append([key, value])
        update_capacity
      else
        @buckets[index].append([key, value])
      end
    else
      node_val[1] = value
    end
  end

  def get(key)
    index = hash(key) % @length
    return nil if @buckets[index].nil?

    if has?(key)
      node = @buckets[index].head
      @buckets[index].size.times do
        return node.value if node.value[0].eql?(key)

        node.next
      end
    end
    nil
  end

  def has?(key)
    index = hash(key) % @length
    return false if @buckets[index].nil?

    node = @buckets[index].head
    @buckets[index].size.times do |_i|
      return true if node.value[0].eql?(key)

      node.next
    end
    false
  end

  def remove(key)
    index = hash(key) % @length
    return nil if @buckets[index].nil?

    list = @buckets[index]
    list.size.times do |i|
      next unless list.at(i).value[0].eql?(key)

      list.remove_at(i)
      return true
    end
  end

  def keys
    key_arr = []
    @length.times do |i|
      next if @buckets[i].nil?

      node = @buckets[i].head
      @buckets[i].size.times do
        key_arr.push(node.value[0])
        node = node.next
      end
    end
    key_arr
  end

  def values
    val_arr = []
    @length.times do |i|
      next if @buckets[i].nil?

      node = @buckets[i].head
      @buckets[i].size.times do
        val_arr.push(node.value[1])
        node = node.next
      end
    end
    val_arr
  end

  def clear
    keys.each do |key|
      remove(key)
    end
  end

  def show_list
    return nil if @buckets.empty?

    @length.times do |i|
      if @buckets[i].nil?
        puts "Bucket #{i} : empty"
        next
      end
      puts "Bucket #{i} : #{@buckets[i]} "
    end
    nil
  end

  def entries
    return nil if @buckets.empty?

    ret_val = []
    @length.times do |i|
      next if @buckets[i].nil?

      append_list(ret_val, @buckets[i])
    end
    ret_val
  end

  def append_list(ret_val, list)
    node = list.head
    list.size.times do
      ret_val.push(node.value)
      node.next
    end
  end
end

hg = HashMap.new
# capacity expansion occurs three times. the second time calls the third

hg.set('hello', 'hello')
hg.set('Hello', 'Hello')
hg.set('Carlos', 'carlos')
hg.set('Adam', 'adam')
hg.set(58, 'fifty-eight')
hg.set(34, 'vierunddreissig')
hg.set('12', 'bara')
hg.set('gora', 'firangi')
hg.set('saahch', 'ture')

puts "keys are #{hg.keys}"
puts "values are #{hg.values}"
puts " current capacity #{hg.capacity} #{hg.show_list}"

hg.set('emperor', 'Ashoka')
hg.set('chhatrapati', 'Shivaji')
hg.set('Mercedes', 'Benz')
hg.set('Albert', 'Einstein')
hg.set('a.roy', 'god of small things')
hg.set('moby dick', 'whale')
hg.set('money', 'always')
hg.set('grdatne', 'incarnate')

puts "keys are #{hg.keys}"
puts "values are #{hg.values}"
puts " current capacity #{hg.capacity} #{hg.show_list}"

hg.set('apple', 'red')
hg.set('banana', 'yellow')
hg.set('carrot', 'orange')
hg.set('dog', 'brown')
hg.set('elephant', 'gray')
hg.set('frog', 'green')
hg.set('grape', 'purple')
hg.set('hat', 'black')
hg.set('ice cream', 'white')
hg.set('jacket', 'blue')
hg.set('kioe', 'pink')
hg.set('lion', 'golden')
hg.set('moon', 'silver')
hg.set('love', 'motorcycle')
puts "keys are #{hg.keys}"
puts "values are #{hg.values}"
puts " current capacity #{hg.capacity} #{hg.show_list}"

hg.clear
puts "keys are #{hg.keys}"
puts "values are #{hg.values}"
puts hg.show_list
