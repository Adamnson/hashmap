class Node
  attr_accessor :next, :value

  def initialize
    @next = nil
    @value = nil
  end
end # class Node

class LinkedList
  attr_accessor :head, :tail, :size

  def initialize
    @head = nil
    @tail = nil
    @size = 0
  end

  def prepend(value)
    new_head = Node.new
    if @size.eql?(0)
      @head = new_head
      @head.value = value
      @tail = new_head
    else
      new_head.value = value
      new_head.next = @head
      @head = new_head
    end
    @size += 1
  end

  def append(value)
    return prepend(value) unless size > 0

    new_tail = Node.new
    new_tail.value = value
    new_tail.next = nil
    @tail.next = new_tail
    @tail = new_tail
    @size += 1
  end

  def at(index)
    return nil if index.negative? || index >= size
    return @head if index.zero?
    return @tail if index.eql?(size - 1)

    current = @head
    index.times do
      current = current.next
    end
    current
  end

  def pop
    return nil if size.eql?(0)

    old_tail = @tail
    if size.eql?(1)
      @head = @tail = nil
    else
      new_tail = at(@size - 2)
      new_tail.next = nil
      @tail = new_tail
    end
    @size -= 1
    old_tail
  end

  def contains?(value)
    return false if @size.eql?(0)

    node = @head
    @size.times do
      return true if node.value.eql?(value)

      node = node.next
    end
    false
  end

  def find(value)
    return nil if @size.eql?(0)

    node = @head
    @size.times do |i|
      return i if node.value.eql?(value)

      node = node.next
    end
    nil
  end

  def insert_at(index, value)
    return prepend(value) if index.zero?
    return append(value) if index.eql?(size)
    return nil if index.negative?

    node = @head

    if index > @size
      (index - @size).times do
        node = Node.new
        node.value = nil
        @tail.next = node
        @tail = node
        @size += 1
      end
    else
      (index - 1).times do
        node = node.next
      end
    end

    new_node = Node.new
    new_node.value = value
    new_node.next = node.next
    node.next = new_node
    @size += 1
    nil
  end

  def remove_at(index)
    return nil if index >= @size || index.negative?
    return pop if index.eql?(@size - 1)

    node = @head
    (index - 1).times do
      node = node.next
    end
    removed_node = node.next
    node.next = removed_node.next
    @size -= 1
    nil
  end

  def to_s
    node = @head
    @size.times do |_i|
      print "( #{node.value} )  -> "
      node = node.next
    end
    puts 'nil'
  end
end # class LinkedList

# li = LinkedList.new
# li.append(4)
# li.prepend(2)
# li.append(7)
# li.prepend(0)

# puts "the size is #{li.size}, the head is #{li.head.value}, the tail is #{li.tail.value}"
# puts "the head node is #{li.head}, the tail node is #{li.tail}"
# puts li

# li.size.times do |i|
#   puts "value at #{i} is #{li.at(i).value}"
# end

# puts "contians?(7) #{li.contains?(7)} find(7) #{li.find(7)}"
# puts "contains?(8) #{li.contains?(8)} find(8) #{li.find(8)}"

# puts li.pop.value
# puts li.pop.value
# puts "#{li} size: #{li.size}"
# puts "contians?(7) #{li.contains?(7)}"

# li.insert_at(7, 23)
# li.insert_at(2, 40)
# li.insert_at(3, 20)
# li.insert_at(3, 10)

# puts "#{li} size: #{li.size}"
# puts "contians?(23) #{li.contains?(23)} #{li.find(23)}"

# 3.times do
#   li.remove_at(6)
# end

# li.remove_at(8)
# li.remove_at(7)

# puts "#{li} size: #{li.size}"
# puts "contians?(23) #{li.contains?(23)} #{li.find(23)}"

# li.insert_at(8, 29)
# puts "#{li} size: #{li.size}"

# list = LinkedList.new

# list.append('dog')
# list.append('cat')
# list.append('parrot')
# list.append('hamster')
# list.append('snake')
# list.append('turtle')

# puts list
# reaise IndexError if index.negative? || index >= @buckets.length

class HashMap
  attr_reader :length, :capacity

  @capacity = 0
  @length = 0

  def initialize(size = 11)
    size = is_prime?(size) ? size : prime_greater_than(size)
    @buckets = Array.new(size)
    @capacity = @length = @prime = size

    puts "after init l: #{@length} prime:#{@prime}"
  end

  def update_capacity
    @capacity -= 1
    puts "cap: #{@capacity} load_limit: #{@buckets.length * (1 - 0.8)}"
    return unless @capacity <= @buckets.length * (1 - 0.8)

    puts 'CAPACITY EXPANSION'
    old_buckets = entries
    initialize(@length * 2)
    old_buckets.each do |key, val|
      set(key, val)
    end
  end

  def prime_greater_than(num)
    return num if is_prime?(num)

    prime_greater_than(num + 1)
  end

  def is_prime?(num)
    return false if num < 2

    (Math.sqrt(num) - 2).floor.times do |i|
      return false if (num % (i + 2)).eql?(0)
    end
    true
  end

  def hash(key)
    hash_code = 0

    if key.is_a? String
      key.each_char { |char| hash_code = @prime * hash_code + char.ord }
    elsif key.is_a? Integer
      key.to_s.each_char { |char| hash_code = @prime * hash_code + char.ord }
    end

    hash_code
  end

  def set(key, value)
    index = hash(key) % @length
    if @buckets[index].nil?
      @buckets[index] = LinkedList.new
      @buckets[index].append([key, value])
      update_capacity
    elsif has?(key)
      node = @buckets[index].head
      @buckets[index].size.times do
        if node.value[0].eql?(key)
          node.value[1] = value
          break
        end
        node.next
      end
    else
      @buckets[index].append([key, value])
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

      print " removed #{key}"
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
      puts " clearing #{key}"
    end
    puts 'cleared'
  end

  def show_list # modify to look like entries
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

      node = @buckets[i].head
      @buckets[i].size.times do
        ret_val.push(node.value)
        node.next
      end
    end
    ret_val
  end
end # class HashMap

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
hg.set('amway', 'financial freedom')
puts "keys are #{hg.keys}"
puts "values are #{hg.values}"
puts " current capacity #{hg.capacity} #{hg.show_list}"

hg.clear
puts hg.keys
puts hg.show_list
