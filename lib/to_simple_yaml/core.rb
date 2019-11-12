class Struct
  def to_simple_yaml(options = {})
    generate_yaml(self, options)
  end
end

class Array
  def to_simple_yaml(options = {})
    generate_yaml(self, options)
  end
end

class Hash
  def to_simple_yaml(options = {})
    generate_yaml(self, options)
  end
end

class Object
  private

  def generate_yaml(obj, indent: 0, array: false)
    if obj.is_a?(Hash)
      yaml = ''
      obj.compact.keys.each_with_index do |key, index|
        array_first = array && index == 0
        array_inline = array && index != 0
        if obj[key].is_a?(String) && obj[key].start_with?('#', '*')
          yaml << template("#{array_first ? '- ' : ''}#{key}: '#{obj[key]}'", array_inline ? indent + 1 : indent)
        elsif obj[key].is_a?(String) || obj[key].is_a?(Numeric) || obj[key].is_a?(TrueClass) || obj[key].is_a?(FalseClass)
          yaml << template("#{array_first ? '- ' : ''}#{key}: #{obj[key]}", array_inline ? indent + 1 : indent)
        elsif obj[key].is_a?(Symbol)
          yaml << template("#{array_first ? '- ' : ''}#{key}: #{obj[key].to_s}", array_inline ? indent + 1 : indent)
        elsif obj[key].is_a?(Array)
          yaml << template("#{array_first ? '- ' : ''}#{key}:", array_inline ? indent + 1 : indent)
          yaml << generate_yaml(obj[key], indent: array_inline ? indent + 2 : indent + 1)
        else
          yaml << template("#{array_first ? '- ' : ''}#{key}:", array_inline ? indent + 1 : indent)
          yaml << generate_yaml(obj[key], indent: array_inline || array_first ? indent + 2 : indent + 1)
        end
      end
      yaml
    elsif obj.is_a?(Array)
      yaml = ''
      obj.compact.each do |value|
        if value.is_a?(String) && value.start_with?('#', '*')
          yaml << template("- '#{value}'", indent)
        elsif value.is_a?(String) || value.is_a?(Numeric) || value.is_a?(TrueClass) || value.is_a?(FalseClass)
          yaml << template("- #{value}", indent)
        elsif value.is_a?(Symbol)
          yaml << template("- #{value.to_s}", indent)
        elsif value.is_a?(Array)
          yaml << template('-', indent)
          yaml << generate_yaml(value, indent: indent + 1)
        else
          yaml << generate_yaml(value, indent: indent, array: true)
        end
      end
      yaml
    elsif obj.is_a?(Struct)
      generate_yaml(Hash[obj.each_pair.to_a], indent: indent, array: array)
    else
      raise SimpleYaml::NoImplementError.new('have no implement to_simple_yaml error')
    end
  end

  def template(value, indent)
    "#{[].fill('  ', 0...indent).join('')}#{value}\n"
  end
end

