class MoviesController < ApplicationController

    def show
      id = params[:id] # retrieve movie ID from URI route
      @movie = Movie.find(id) # look up movie by unique ID
      # will render app/views/movies/show.<extension> by default
    end
  
    def index
      
      @all_ratings = Movie.ratings_avail
      @all_ratings = Movie.mapping_data
      if (request.referrer).nil?
        session.clear
      end
      par_data = params[:ratings]
      par_sort = params[:sort_by]
      unless par_data.nil?
        ratings_val = par_data.keys
      else
        unless (session[:ratings_to_show].nil? )
          ratings_val = JSON.parse(session[:ratings_to_show])
        else
          ratings_val = @all_ratings
        end
      end
      @movies = Movie.where(rating:ratings_val)
      @display_ratings = ratings_val
      if par_sort
        session[:sort_by] = par_sort
        sorting_data = par_sort
      elsif session[:sort_by]
        sorting_data = session[:sort_by]
      end
      if sorting_data.to_s == 'title'
        @movies = Movie.where(rating:ratings_val).order(:title)
        @highlighting = 'title'
      elsif sorting_data.to_s == 'release_date'
        @movies = Movie.where(rating:ratings_val).order(:release_date)
        @highlighting = 'release_date'
      else
        @movies = Movie.where(rating:ratings_val)
      end
      
      session[:ratings_to_show] = JSON.generate(ratings_val)
      session[:ratings] = par_data
      
      if(sorting_data.to_s == 'title')
        @changes = 'bg-warning hilite'
      elsif(sorting_data.to_s == 'release_date')
        @changes = 'bg-warning hilite'
      end
      @sorting = sorting_data
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