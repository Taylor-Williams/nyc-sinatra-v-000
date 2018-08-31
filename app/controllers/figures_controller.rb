class FiguresController < ApplicationController

  get '/figures' do
    @figures = Figure.all
    erb :'figures/index'
  end

  get '/figures/new' do
    @titles = Title.all
    @landmarks = Landmark.all
    erb :'figures/new'
  end

  get '/figures/:id' do
    @figure = Figure.find(params[:id])
    erb :'figures/show'
  end

  get '/figures/:id/edit' do
    binding.pry
    @figure = Figure.find(params[:id])
    @landmarks = Landmark.all
    @titles = Title.all
    erb :'figures/edit'
  end

  post '/figures' do
    @figure = Figure.create(name: params[:figure][:name])
    if params[:figure][:landmark_ids]
      @figure.landmark_ids = params[:figure][:landmark_ids]
    end
    if !params[:landmark][:name].empty?
      landmark = Landmark.find_or_create_by(name: params[:landmark][:name])
      @figure.landmarks << landmark
    end
    if !params[:title].empty?
      params[:figure][:title_ids] = [] if !params[:figure][:title_ids]
      if !params[:title][:name].empty?
        params[:title][:name].split(",").map!(&:strip).each do |name|
          title = Title.find_or_create_by(name: name)
          params[:figure][:title_ids] << title.id
        end
      end
      params[:figure][:title_ids].each do |title_id|
        @figure.figure_titles.create(title_id: title_id)
      end
    end
    @figure.save
    redirect :"figures/#{@figure.id}"
  end

  post '/figures/:id' do
    @figure = Figure.find(params[:id])
    if !params[:figure][:name].empty?
      @figure.name = params[:figure][:name]
    end
    if params[:figure][:landmark_ids]
      @figure.landmark_ids = params[:figure][:landmark_ids]
    end
    if !params[:landmark][:name].empty?
      landmark = Landmark.find_or_create_by(name: params[:landmark][:name])
      @figure.landmarks << landmark
    end
    if !params[:title].empty?
      params[:figure][:title_ids] = [] if !params[:figure][:title_ids]
      if !params[:title][:name].empty?
        params[:title][:name].split(",").map!(&:strip).each do |name|
          title = Title.find_or_create_by(name: name)
          params[:figure][:title_ids] << title.id
        end
      end
      (@figure.title_ids - params[:figure][:title_ids]).each do |title_id|
        @figure.figure_titles.find_by(title_id: title_id).destroy
      end
      (params[:figure][:title_ids] - @figure.title_ids).each do |title_id|
        @figure.figure_titles.create(title_id: title_id)
      end
    end
    @figure.save
    redirect :"figures/#{@figure.id}"
  end
end
