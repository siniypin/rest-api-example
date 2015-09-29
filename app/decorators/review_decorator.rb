class ReviewDecorator < Draper::Decorator
  delegate_all

  def all_reviews_link
    Link.new("index", h.api_reviews_url)
  end

  def self_link
    Link.new("self", h.api_review_url(source))
  end

  def as_json(options = nil)
    {:links => self_link.as_json.merge(all_reviews_link.as_json)}.merge source.as_json(options)
  end
end
