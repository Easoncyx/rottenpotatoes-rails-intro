class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # used by checkbox
    @all_ratings = Movie.distinct.pluck(:rating)#ratings arr
    # SELECT DISTINCT rating FROM Movie
    @selected_ratings = []
    redirect_flag = false
    sort_by = ""

    # the first time use params[:sort] store it into the session
    if params[:sort]
      sort_by = params[:sort]
      session[:sort] = sort_by
    elsif session[:sort]
      sort_by = session[:sort]
      redirect_flag = true
    else
      sort_by = nil
    end

    if params[:ratings]
      @selected_ratings = params[:ratings].keys
      session[:ratings] = params[:ratings]
    elsif session[:ratings]
      @selected_ratings = session[:ratings].keys
      redirect_flag = true
    else
      @selected_ratings = Movie.distinct.pluck(:rating)
    end

=begin
    if !sort_by and !rating_by
      @movies = Movie.all
      @selected_ratings = Movie.distinct.pluck(:rating)
      return
    end

    if params[:sort]
      if rating_by
        @movies = Movie.find_by_rating(rating_by.keys).order(sort_by)
        @selected_ratings = rating_by.keys
      else
        @movies = Movie.order(sort_by)
        @selected_ratings = Movie.distinct.pluck(:rating)
      end
    else # params[:rating_by]
      if sort_by
        @movies = Movie.find_by_rating(rating_by.keys).order(sort_by)
        @selected_ratings = rating_by.keys
      else
        @movies = Movie.find_by_rating(rating_by.keys)
        @selected_ratings = rating_by.keys
      end
    end
=end
    if sort_by == 'title'
       @css_title = 'hilite'
    elsif sort_by == 'release_date'
       @css_release_date = 'hilite'
    end
    if redirect_flag
      # flash.keep
      redirect_to movies_path(sort: sort_by, ratings: session[:ratings])
    else
      @movies = Movie.find_by_rating(@selected_ratings).order(sort_by)
    end
end

  def new
    # @movie = Movie.new
    # default: render 'new' template
  end

  def create
    # debugger
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

end
