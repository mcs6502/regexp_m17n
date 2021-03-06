# encoding: utf-8
require 'minitest/autorun'
require_relative '../lib/regexp_m17n'

class RegexpTest < MiniTest::Unit::TestCase
  def test_non_empty_string
    Encoding.list.each do |enc|
      begin
        str = '.'.encode(enc)
      rescue Encoding::ConverterNotFoundError
        next
      end
      assert(RegexpM17N.non_empty?(str))
    end
  end

  def test_non_empty_nil
    assert(!RegexpM17N.non_empty?(nil))
  end

  def test_non_empty_string_using_all_code_converters_we_could_find
    Encoding.list.each do |enc|
      str = encode('.', enc)
      if str
        assert(RegexpM17N.non_empty?(str))
      else
        puts "No code converter for #{enc}"
      end
    end

    # Run through all encodings once again to verify that the non_empty? method works for multiple invocations.
    Encoding.list.each do |enc|
      str = encode('.', enc)
      if str
        # non-dummy encodings should have been primed during the first pass
        assert(enc.dummy? || enc.respond_to?(:non_empty_str?))

        assert(RegexpM17N.non_empty?(str))
        assert(RegexpM17N.non_empty?(str))
      end
    end
  end

  def test_empty_string_using_all_code_converters_we_could_find
    Encoding.list.each do |enc|
      str = encode('', enc)
      if str
        assert(!RegexpM17N.non_empty?(str))
        assert(!RegexpM17N.non_empty?(str))
      end
    end
  end

  def encode(str, enc)
    begin
      str.encode(enc)
    rescue Encoding::ConverterNotFoundError => e
      nil
    end
  end
end
