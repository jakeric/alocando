require 'faraday'

class Pixabay
  # You must define an environment variable ENV['PIXABAY_KEY']
  ROOT_URL = "https://pixabay.com/api/?key=#{ENV['PIXABAY_KEY']}".freeze

  # Default number of images per page. This can be overriden giving the per_page param
  DEFAULT_PER_PAGE = 3

  attr_accessor :width, :height, :page, :per_page

  def initialize(width:, height:, page: 1, per_page: DEFAULT_PER_PAGE)
    @width = width
    @height = height
    @page = page
    @per_page = per_page
  end

  def search(search_term = '')
    @search_term = search_term

    full_url = build_full_url

    response = Faraday.get(full_url)

    return [] unless response.success?

    images_parse(response.body)
  end

  private

  def build_full_url
    uri = Addressable::URI.parse(ROOT_URL)

    uri.query_values = build_full_query(uri.query_values)

    uri.to_s
  end

  def build_full_query(initial_query)
    initial_query.merge(
      image_type: 'photo',
      safesearch: true,
      min_width: @width,
      min_height: @height,
      page: @page,
      per_page: @per_page,
      q: @search_term
    )
  end

  def images_parse(json_text)
    json = JSON.parse(json_text)

    images = json['hits']

    images.map do |image|
      {
        preview: image['previewURL'],
        url: image['webformatURL'],
        height: image['webformatHeight'].to_i,
        width: image['webformatWidth'].to_i
      }
    end
  end
end
