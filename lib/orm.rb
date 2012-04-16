require 'ostruct'

# The 'orm' is optional and modifies the Array class with some methods commonly used in orms like DataMapper.
class Array
  # Find an object based on provided conditions
  # Usage:
  # find(Hash)
  # Example:
  #  first_id = find(:id => 1) # Returns an array of all objects in key with id of 1.
  #  all_admins = find(:status => 'admin') # Returns array of all admins.
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
  # Find the first object based on provided conditions
  # Usage:
  # first(Hash)
  # Example:
  #  first_id = first(:id => 1) # Returns first object where id == 1.
  #  first_admin = find(:status => 'admin') # Returns value of first object who's hash key "status" == admin.
  def first(conditions)
    self.each do |item|
      matches = 0
      conditions.each_key{|cond| matches += 1 if item[cond] == conditions[cond] }
      return item if matches == conditions.count
    end
    return nil
  end
end
