module TeamSpeak3
  module CommandParameter
    def self.encode(value)
      return unless value

      value.gsub!("\\", "\\\\")
      value.gsub!("/", "\/")
      value.gsub!(" ", "\\s")
      value.gsub!("|", "\\p")
      value.gsub!("\a", "\\a")
      value.gsub!("\b", "\\b")
      value.gsub!("\f", "\\f")
      value.gsub!("\n", "\\n")
      value.gsub!("\r", "\\r")
      value.gsub!("\t", "\\t")
      value.gsub!("\v", "\\v")
      value
    end

    def self.decode(value)
      return unless value

      value.gsub!("\\\\", "\\")
      value.gsub!("\/", "/")
      value.gsub!("\\s", " ")
      value.gsub!("\\p", "|")
      value.gsub!("\\a", "\a")
      value.gsub!("\\b", "\b")
      value.gsub!("\\f", "\f")
      value.gsub!("\\n", "\n")
      value.gsub!("\\r", "\r")
      value.gsub!("\\t", "\t")
      value.gsub!("\\v", "\v")
      value
    end
  end
end
