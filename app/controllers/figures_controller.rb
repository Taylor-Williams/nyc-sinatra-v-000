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
    binding.pry
    @figure = Figure.create(name: params[:figure][:name])
    if params[:figure][:titles][:ids]
      @figure.title_ids = params[:figure][:titles][:ids]
    end
    if !params[:figure][:titles][:new].empty?
      @figure.titles << Title.find_or_create_by(name: params[:figure][:titles][:new])
    end
    if !params[:figure][:landmarks].empty?
      params[:figure][:landmarks][:ids] = [] if !params[:figure][:landmarks][:ids]
      if !params[:figure][:landmarks][:names].empty?
        params[:figure][:landmarks][:names].split(",").map!(&:strip).each do |name|
          landmark = Landmark.create(name: name)
          params[:figure][:landmarks][:ids] << landmark.id
        end
      end
      params[:figure][:landmarks][:ids].each do |landmark_id|
        @figure.figure_landmarks.create(landmark_id: landmark_id)
      end
    end
    @figure.save
    redirect :"figures/#{@figure.id}"
  end

  post '/figures/:id/edit' do
    redirect :"figures/#{@figure.id}"
  end
end
