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
    erb :'figures/edit'
  end

  post '/figures' do
    @figure = Figure.create(name: params[:figure][:name])
    if params[:figure][:landmarks][:ids]
      @figure.landmark_ids = params[:figure][:landmarks][:ids]
    end
    if !params[:figure][:landmarks][:new].empty?
      landmark = Landmark.find_or_create_by(name: params[:figure][:landmarks][:new])
      @figure.landmarks << landmark
    end
    if !params[:figure][:titles].empty?
      params[:figure][:titles][:ids] = [] if !params[:figure][:titles][:ids]
      if !params[:figure][:titles][:new].empty?
        params[:figure][:titles][:new].split(",").map!(&:strip).each do |name|
          title = Title.find_or_create_by(name: name)
          params[:figure][:titles][:ids] << title.id
        end
      end
      params[:figure][:titles][:ids].each do |title_id|
        @figure.figure_titles.create(title_id: title_id)
      end
    end
    @figure.save
    redirect :"figures/#{@figure.id}"
  end

  post '/figures/:id/edit' do
    @figure = Figure.create(name: params[:figure][:name])
    if params[:figure][:landmarks][:ids]
      @figure.landmark_ids = params[:figure][:landmarks][:ids]
    end
    if !params[:figure][:landmarks][:new].empty?
      landmark = Landmark.find_or_create_by(name: params[:figure][:landmarks][:new])
      @figure.landmarks << landmark
    end
    if !params[:figure][:titles].empty?
      params[:figure][:titles][:ids] = [] if !params[:figure][:titles][:ids]
      if !params[:figure][:titles][:new].empty?
        params[:figure][:titles][:new].split(",").map!(&:strip).each do |name|
          title = Title.find_or_create_by(name: name)
          params[:figure][:titles][:ids] << title.id
        end
      end
      (@figure.genre_ids - params[:figure][:titles][:ids]).each do |title_id|
        @figure.figure_titles.find_by(title_id: title_id).destroy
      end
      (params[:figure][:titles][:ids] - @figure.title_ids).each do |title_id|
        @figure.figure_titles.create(title_id: title_id)
      end
    end
    @figure.save
    redirect :"figures/#{@figure.id}"
  end
end
