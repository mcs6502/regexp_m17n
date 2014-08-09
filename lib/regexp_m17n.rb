module RegexpM17N
  @@regexp = /^.+$/

  def self.non_empty?(str)
    !str.nil? && non_empty_str?(str)
  end

  def self.non_empty_str?(str)
    enc = str.encoding
    if enc.dummy? # cannot create regexps for dummy encodings, so encode the string instead
      @@regexp =~ str.encode(@@regexp.encoding)
    else # otherwise create use an encoding-specific method that will use its own regexp
      unless enc.respond_to?(:non_empty_str?)
        regexp = Regexp.new(@@regexp.source.encode(enc))
        enc.instance_eval do
          define_singleton_method(:non_empty_str?) do |str|
            regexp =~ str
          end
        end
      end
      enc.non_empty_str?(str)
    end
  end
end