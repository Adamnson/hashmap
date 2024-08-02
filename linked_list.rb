require 'pry-byebug'

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
    @head = @tail = nil
    @size = 0
  end

  def prepend(value)
    new_head = Node.new
    if @size.zero?
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

  def append(value = nil)
    return prepend(value) unless size.positive?

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

    if index > @size
      (index - @size).times { append }
    else
      node = at(index - 1)
      new_node = Node.new
      new_node.value = value
      new_node.next = node.next
      node.next = new_node
      @size += 1
      nil
    end
  end

  def remove_at(index)
    return nil if index >= @size || index.negative?
    return remove_head if index.zero?
    return pop if index.eql?(@size - 1)

    node = @head
    (index - 1).times { node.next }

    removed_node = node.next
    node.next = removed_node.next
    @size -= 1
    nil
  end

  def remove_head
    node = @head

    if @head.eql?(@tail)
      @head = nil
      @tail = nil
      @size = 0
      return
    end

    @head = node.next
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

li = LinkedList.new
# puts "the size is #{li.size}, the head is #{li.head.value}, the tail is #{li.tail.value}"
# puts "the head node is #{li.head}, the tail node is #{li.tail}"
puts li

puts 'ADDING ELEMENTS IN PROGRESS'
li.append(4)
puts "the size is #{li.size}, the head is #{li.head.value}, the tail is #{li.tail.value}"
puts "the head node is #{li.head}, the tail node is #{li.tail}"
puts li
li.prepend(2)
li.append(7)
li.prepend(0)

puts "the size is #{li.size}, the head is #{li.head.value}, the tail is #{li.tail.value}"
puts "the head node is #{li.head}, the tail node is #{li.tail}"
puts li

li.size.times do |i|
  puts "value at #{i} is #{li.at(i).value}"
end

# puts "contians?(7) #{li.contains?(7)} find(7) #{li.find(7)}"
# puts "contains?(8) #{li.contains?(8)} find(8) #{li.find(8)}"

# puts li.pop.value
# puts li.pop.value
# puts "#{li} size: #{li.size}"
# puts "contians?(7) #{li.contains?(7)}"

li.insert_at(7, 23)
li.insert_at(2, 40)
li.insert_at(3, 20)
li.insert_at(3, 10)

puts "#{li} size: #{li.size}"
puts "contians?(23) #{li.contains?(23)} #{li.find(23)}"

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
