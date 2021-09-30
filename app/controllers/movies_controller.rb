class MoviesController < ApplicationController

    def show
      id = params[:id] # retrieve movie ID from URI route
      @movie = Movie.find(id) # look up movie by unique ID
      # will render app/views/movies/show.<extension> by default
    end
  
    def index
      #@movies = Movie.all
      # @movies = Movie.all
      #if params[:sort_by].to_s == 'title'
      #  @title_sorting = 'hilite'
      #  @movies = Movie.all.order(params[:sort_by])
      #elsif params[:sort_by].to_s == 'release_date'
      #  @releasedate_sort = 'hilite'
      #  @movies = Movie.all.order(params[:sort_by])
      #else
      #  @movies = Movie.all
      #end
      #@movies = Movie.all
      @all_ratings = Movie.ratings_avail
      
      unless params[:ratings].nil?
        ratings_val = params[:ratings].keys
      else
        ratings_val = @all_ratings
      end
      @movies = Movie.where(rating:ratings_val)
      @display_ratings = ratings_val
      if params[:sort_by].to_s == 'title'
        @movies = Movie.where(rating:ratings_val).order(:title)
        @title_sorting = 'hilite'
      elsif params[:sort_by].to_s == 'release_date'
        @movies = Movie.where(rating:ratings_val).order(:release_date)
        @releasedate_sort = 'hilite'
      else
        @movies = Movie.where(rating:ratings_val)
      end
      session[:ratings_to_show] = JSON.generate(ratings_val)
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