require "test_helper"
require "yaml"

class ToSimpleYamlTest < Minitest::Test
  def test_parse
    yaml = {a: {b: {c: 'd'}}}.to_simple_yaml
    assert_equal("a:\n  b:\n    c: d\n", yaml)
  end

  def test_array
    yaml = [1, 2, 3].to_simple_yaml
    assert_equal("- 1\n- 2\n- 3\n", yaml)
  end

  def test_array_nest_array
    yaml = {a: [[1, 2]]}.to_simple_yaml
    assert_equal("a:\n" +
                   "  -\n" +
                   "    - 1\n" +
                   "    - 2\n",
                 yaml)
    yaml = {a: [[[1, 2]]]}.to_simple_yaml
    assert_equal("a:\n" +
                   "  -\n" +
                   "    -\n" +
                   "      - 1\n" +
                   "      - 2\n",
                 yaml)
  end

  def test_array_nest_object
    yaml = [{a: 'b', c: 'd', e: {f: 3}}].to_simple_yaml
    assert_equal("- a: b\n" +
                   "  c: d\n" +
                   "  e:\n" +
                   "    f: 3\n", yaml)
    yaml = [{a: {b: 'c'}}].to_simple_yaml
    assert_equal("- a:\n" +
                   "    b: c\n",
                 yaml)
  end

  def test_array_nest_object_2
    yaml = {a: [{test: :ore}, {test: 1, ore: {kara: {tsutaetai: {kanasimi: 5}}}}]}.to_simple_yaml
    assert_equal("a:\n" +
                   "  - test: ore\n" +
                   "  - test: 1\n" +
                   "    ore:\n" +
                   "      kara:\n" +
                   "        tsutaetai:\n" +
                   "          kanasimi: 5\n",
                 yaml)
  end

  def test_nest_class
    yaml = {model: Model.new(1, 2)}.to_simple_yaml
    assert_equal("model:\n" +
                   "  one: 1\n" +
                   "  two: 2\n", yaml)
    yaml = [Model.new(1, 2)].to_simple_yaml
    assert_equal("- one: 1\n" +
                   "  two: 2\n", yaml)
  end

  def test_no_implement
    assert_raises SimpleYaml::NoImplementError do
      {model: NoImplementModel.new(1, 2)}.to_simple_yaml
    end
  end

  def test_array_object_class
    yaml = {array: [{array: [{model: Model.new(1, 2)}]}]}.to_simple_yaml
    parse = YAML.load(yaml)
    assert_equal(1, parse["array"][0]["array"][0]["model"]["one"])
    assert_equal(2, parse["array"][0]["array"][0]["model"]["two"])
    assert_equal("array:\n" +
                   "  - array:\n" +
                   "    - model:\n" +
                   "        one: 1\n" +
                   "        two: 2\n",
                 yaml)
  end

  def test_nil_hash
    yaml = {one: nil, two: 2}.to_simple_yaml
    assert_equal("two: 2\n", yaml)
  end

  def test_nil_array
    yaml = [nil,2].to_simple_yaml
    assert_equal("- 2\n", yaml)
  end

  def test_boolean
    yaml = {yes: true}.to_simple_yaml
    assert_equal("yes: true\n", yaml)
    yaml = [true, false].to_simple_yaml
    assert_equal("- true\n"+
                   "- false\n", yaml)
  end

  def test_text_start
    yaml = {test: '#test'}.to_simple_yaml
    assert_equal("test: '#test'\n", yaml)
    yaml = ['#test'].to_simple_yaml
    assert_equal("- '#test'\n", yaml)
    yaml = {test: '*test'}.to_simple_yaml
    assert_equal("test: '*test'\n", yaml)
    yaml = ['*test'].to_simple_yaml
    assert_equal("- '*test'\n", yaml)
  end

  def test_key_start
    yaml = {'*test': 'test'}.to_simple_yaml
    assert_equal("'*test': test\n", yaml)
    yaml = ['*test'.to_sym].to_simple_yaml
    assert_equal("- '*test'\n", yaml)
  end

  def test_multiline_text
    yaml = {description: "this text is so long text.\n" +
      "this text is so long text.\n" +
      "this text is so long text.\n" +
      "this text is so long text.\n" +
      "this text is so long text.\n" +
      "this text is so long text.\n" +
      "this text is so long text.\n"
    }.to_simple_yaml
    assert_equal("description: |\n" +
                   "  this text is so long text.\n" +
                   "  this text is so long text.\n" +
                   "  this text is so long text.\n" +
                   "  this text is so long text.\n" +
                   "  this text is so long text.\n" +
                   "  this text is so long text.\n" +
                   "  this text is so long text.\n", yaml)
    yaml = ["this text is so long text.\n" +
              "this text is so long text.\n" +
              "this text is so long text.\n" +
              "this text is so long text.\n" +
              "this text is so long text.\n" +
              "this text is so long text.\n" +
              "this text is so long text.\n"
    ].to_simple_yaml
    assert_equal("- |\n" +
                   "  this text is so long text.\n" +
                   "  this text is so long text.\n" +
                   "  this text is so long text.\n" +
                   "  this text is so long text.\n" +
                   "  this text is so long text.\n" +
                   "  this text is so long text.\n" +
                   "  this text is so long text.\n", yaml)
  end

  def test_one_line_text
    yaml = {text: "text.\n"}.to_simple_yaml
    assert_equal("text: text.\n", yaml)
    yaml = ["text.\n"].to_simple_yaml
    assert_equal("- text.\n", yaml)
  end
end
