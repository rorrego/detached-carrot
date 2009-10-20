CARROTS_CONFIG = YAML.load_file(File.join(Rails.root, "config", "carrots.yml"))[Rails.env]

class Hash
  # Recursively replace key names that should be symbols with symbols.
  def key_strings_to_symbols!
    r = Hash.new
    self.each_pair do |k,v|
      if (k.kind_of? String)
        r[k.to_sym] = v
      else
        r[k] = v
      end
    end
    return r
  end
end