class MovieApiService
  def self.conn
    Faraday.new(url: "https://api.themoviedb.org") do |faraday|
      faraday.params[:api_key] = ENV['MOVIE_DB_API_KEY']
    end
  end

  def self.parse_data(response)
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.top_rated_movies
    page = 1
    top_movies = []

    2.times do
      response = conn.get("/3/movie/top_rated") do |movie|
        movie.params[:page] = page
      end

      movies = parse_data(response)

      top_movies.concat(movies[:results])
      page+=1
    end
    top_movies
  end

  def self.movie_search(query)
    titles = []
    page_number = 0

    2.times do
      page_number += 1
      response = conn.get("/3/search/movie?&page=#{page_number}") do |req|
        req.params[:query] = query
      end

      title_data = JSON.parse(response.body, symbolize_names: true)

      titles << title_data[:results]
    end

    titles.flatten
  end
end