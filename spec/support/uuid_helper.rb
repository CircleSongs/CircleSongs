require 'securerandom'

module UuidHelper
  def self.uuid(key)
    var_name = "@#{key}"
    id = instance_variable_get(var_name)
    if id.nil?
      id = SecureRandom.uuid
      instance_variable_set(var_name, id)
    end
    id
  end
end
