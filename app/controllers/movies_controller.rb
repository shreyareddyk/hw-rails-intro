class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
  @path = 'PATH_INFO'
    if request.env[@path] == '/' 
      session.clear
    end

    @allratings = Movie.all_ratings
    showRatings = session[:ratings_to_show].nil?
    queryParamsByRating = params[:ratings]
    
    ratings = queryParamsByRating.nil? ? (showRatings  ? @allratings : JSON.parse(session[:ratings_to_show])) : queryParamsByRating.keys
    
    @queryParam = params[:sort_by]
    @querySession = session[:sort_by]
    
    if @queryParam
      @querySession = @queryParam
      sort = @queryParam
    elsif @querySession
      sort = @querySession
    end      
      
    
    @ratings_to_show = ratings
    
    if sort == "title" 
      @movies = Movie.with_ratings(ratings).order(:title)
      
    elsif sort == "release_date"
      @movies = Movie.with_ratings(ratings).order(:release_date)
     
    else
      @movies = Movie.with_ratings(ratings)
    end
    
    @ratingsJson = JSON.generate(ratings)
    
    session[:ratings_to_show] = @ratingsJson
    
    session[:ratings] = params[:ratings]
    
    @sort_by = sort
    
    
      
  end
  

  
  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end