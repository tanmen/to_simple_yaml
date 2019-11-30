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
      return template("#{array ? '- ' : ''}{}", indent) if obj.values.empty?

      yaml = ''
      obj.compact.keys.each_with_index do |key, index|
        array_first = array && index == 0
        array_inline = array && index != 0
        if obj[key].is_a?(String) && obj[key].include?("\n")
          sentence = obj[key].split("\n").reject(&:empty?)
          if sentence.size > 1
            yaml << template("#{array_first ? '- ' : ''}#{text(key)}: |", array_inline ? indent + 1 : indent)
            sentence.each {|s| yaml << template(s, array_inline ? indent + 2 : indent + 1)}
          else
            yaml << template("#{array_first ? '- ' : ''}#{text(key)}: #{text(sentence[0])}", array_inline ? indent + 1 : indent)
          end
        elsif obj[key].is_a?(String) || obj[key].is_a?(Symbol) || obj[key].is_a?(Numeric) || obj[key].is_a?(TrueClass) || obj[key].is_a?(FalseClass)
          yaml << template("#{array_first ? '- ' : ''}#{text(key)}: #{text(obj[key])}", array_inline ? indent + 1 : indent)
        elsif obj[key].is_a?(Array)
          yaml << template("#{array_first ? '- ' : ''}#{text(key)}:", array_inline ? indent + 1 : indent)
          yaml << generate_yaml(obj[key], indent: array_inline ? indent + 2 : indent + 1)
        else
          yaml << template("#{array_first ? '- ' : ''}#{text(key)}:", array_inline ? indent + 1 : indent)
          yaml << generate_yaml(obj[key], indent: array_inline || array_first ? indent + 2 : indent + 1)
        end
      end
      yaml
    elsif obj.is_a?(Array)
      return template('[]', indent) if obj.empty?

      yaml = ''
      obj.compact.each do |value|
        if value.is_a?(String) && value.include?("\n")
          sentence = value.split("\n").reject(&:empty?)
          if sentence.size > 1
            yaml << template("- |", indent)
            sentence.each{|s| yaml << template(s, indent + 1)}
          else
            yaml << template("- #{text(sentence[0])}", indent)
          end
        elsif value.is_a?(String) || value.is_a?(Symbol) || value.is_a?(Numeric) || value.is_a?(TrueClass) || value.is_a?(FalseClass)
          yaml << template("- #{text(value)}", indent)
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

  def text(value)
    if value.to_s.start_with?('#', '*', '[', '{')
      "'#{value}'"
    else
      value
    end
  end
end

