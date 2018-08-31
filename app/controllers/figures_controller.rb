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
    if params[:figure][:landmarks][:ids]
      @figure.landmark_ids = params[:figure][:landmarks][:ids]
    end
    if !params[:figure][:landmarks][:new].empty?
      landmark = Landmark.find_or_create_by(name: params[:figure][:landmarks][:new])
      @figure.landmarks << landmark
    end
    if !params[:figure][:landmarks].empty?
      params[:figure][:landmarks][:ids] = [] if !params[:figure][:landmarks][:ids]
      if !params[:figure][:landmarks][:new].empty?
        params[:figure][:landmarks][:new].split(",").map!(&:strip).each do |name|
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
