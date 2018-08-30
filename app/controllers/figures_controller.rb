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
    erb :'figures/show'
  end

  get '/figures/:id/edit' do
    erb :'figures/edit'
  end

  post '/figures' do
    binding.pry
    redirect :"figures/#{@figure.id}"
  end

  post '/figures/:id/edit' do
    redirect :"figures/#{@figure.id}"
  end
end
