require 'ostruct'
class Array
  def find(conditions)
    self.select do |item|
      matches = 0
      case item.class.to_s
        when "Hash"
          conditions.each_key{|cond| matches += 1 if item[cond] == conditions[cond] }
        when "OpenStruct"
          conditions.each_key {|cond| matches += 1 if item.send(cond.to_sym) == conditions[cond] }
        when "Array"
          conditions.each_key { |cond| matches += 1 if item.find(cond => conditions[cond]).count > 0 }
      end
      matches == conditions.count
    end
  end

  def first(conditions)
    self.each do |item|
      matches = 0
      conditions.each_key{|cond| matches += 1 if item[cond] == conditions[cond] }
      return item if matches == conditions.count
    end
    return nil
  end
end
