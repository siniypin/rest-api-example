class ReviewCollectionDecorator < Draper::CollectionDecorator
  def self_link
    Link.new("self", h.api_reviews_url)
  end

  def next_link
    Link.new("next", h.api_reviews_url(page: 2)) # NOTE: should be dynamic param, should also provide back link, etc.
  end

  def as_json(options = nil)
    {links: self_link.as_json.merge(next_link.as_json)}.merge(embedded: decorated_collection.as_json(options))
  end
end
