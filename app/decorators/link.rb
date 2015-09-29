class Link < Struct.new(:rel, :href)
  def as_json
    {rel => {href: href}}
  end
end
