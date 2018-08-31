class LandmarksController < ApplicationController

  get '/landmarks' do
    @landmarks = Landmark.all
    erb :'landmarks/index'
  end

  get '/landmarks/new' do
    @titles = Title.all
    @figures = Figure.all
    erb :'landmarks/new'
  end

  get '/landmarks/:id' do
    @landmark = Landmark.find(params[:id])
    erb :'landmarks/show'
  end

  get '/landmarks/:id/edit' do
    @landmark = Landmark.find(params[:id])
    @figures = Figure.all
    @titles = Title.all
    erb :'landmarks/edit'
  end

  post '/landmarks' do
    @landmark = Landmark.create(name: params[:landmark][:name])
    if params[:landmark][:landmark_ids]
      @landmark.figure_ids = params[:landmark][:figure_ids]
    end
    if !params[:figure][:name].empty?
      figure = Figure.find_or_create_by(name: params[:figure][:name])
      @landmark.figures << figure
    end
    if !params[:title].empty?
      params[:landmark][:title_ids] = [] if !params[:landmark][:title_ids]
      if !params[:title][:name].empty?
        params[:title][:name].split(",").map!(&:strip).each do |name|
          title = Title.find_or_create_by(name: name)
          params[:landmark][:title_ids] << title.id
        end
      end
      params[:landmark][:title_ids].each do |title_id|
        @landmark.landmark_titles.create(title_id: title_id)
      end
    end
    @landmark.save
    redirect :"landmarks/#{@landmark.id}"
  end

  post '/landmarks/:id' do
    @landmark = Landmark.find(params[:id])
    if !params[:landmark][:name].empty?
      @landmark.name = params[:landmark][:name]
    end
    if params[:landmark][:figure_ids]
      @landmark.figure_ids = params[:landmark][:figure_ids]
    end
    if !params[:figure][:name].empty?
      figure = Figure.find_or_create_by(name: params[:figure][:name])
      @landmark.figures << figure
    end
    if !params[:title].empty?
      params[:landmark][:title_ids] = [] if !params[:landmark][:title_ids]
      if !params[:title][:name].empty?
        params[:title][:name].split(",").map!(&:strip).each do |name|
          title = Title.find_or_create_by(name: name)
          params[:landmark][:title_ids] << title.id
        end
      end
      (@landmark.title_ids - params[:landmark][:title_ids]).each do |title_id|
        @landmark.landmark_titles.find_by(title_id: title_id).destroy
      end
      (params[:landmark][:title_ids] - landmarke.title_ids).each do |title_id|
        @landmark.landmark_titles.create(title_id: title_id)
      end
    end
    @landmark.save
    redirect :"landmarks/#{@landmark.id}"
  end

end
