class LandmarksController < ApplicationController
  
  get '/landmarks' do
    @landmarks = landmark.all
    erb :'landmarks/index'
  end

  get '/landmarks/new' do
    @titles = Title.all
    @landmarks = Landmark.all
    erb :'landmarks/new'
  end

  get '/landmarks/:id' do
    @landmark = landmark.find(params[:id])
    erb :'landmarks/show'
  end

  get '/landmarks/:id/edit' do
    @landmark = landmark.find(params[:id])
    @landmarks = Landmark.all
    @titles = Title.all
    erb :'landmarks/edit'
  end

  post '/landmarks' do
    @landmark = landmark.create(name: params[:landmark][:name])
    if params[:landmark][:landmark_ids]
      @landmark.landmark_ids = params[:landmark][:landmark_ids]
    end
    if !params[:landmark][:name].empty?
      landmark = Landmark.find_or_create_by(name: params[:landmark][:name])
      @landmark.landmarks << landmark
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
    @landmark = landmark.find(params[:id])
    if !params[:landmark][:name].empty?
      @landmark.name = params[:landmark][:name]
    end
    if params[:landmark][:landmark_ids]
      @landmark.landmark_ids = params[:landmark][:landmark_ids]
    end
    if !params[:landmark][:name].empty?
      landmark = Landmark.find_or_create_by(name: params[:landmark][:name])
      @landmark.landmarks << landmark
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
