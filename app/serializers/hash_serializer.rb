class HashSerializer
  def self.dump(hash)
    hash.to_json
  end

  def self.load(json_string)
    hash = JSON.parse (json_string || "{}")
    return hash.with_indifferent_access
  end
end
