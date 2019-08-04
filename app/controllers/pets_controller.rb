class PetsController < ApplicationController

  get '/pets' do
    @pets = Pet.all
    erb :'/pets/index' 
  end

  get '/pets/new' do 
    @owners = Owner.all
    erb :'/pets/new'
  end

  post '/pets' do 
    @pet = Pet.new(name: params[:name]) 
    if params[:owner_name].empty?
      @owner = Owner.find_by_id(params[:owner_id].first)
    else
      @owner = Owner.new(name: params[:owner_name])
    end 
    
    @owner.pets << @pet
    @owner.save

    redirect to "pets/#{@pet.id}"
  end

  get '/pets/:id/edit' do
  
    @pet = Pet.find_by_id(params[:id])
    @owners = Owner.all
    erb :'/pets/edit'
  end

  get '/pets/:id' do 
    @pet = Pet.find(params[:id])
    erb :'/pets/show'
  end

  patch '/pets/:id' do 
    @pet = Pet.find_by_id(params[:id])

    #if a new owner is present, over write the existing owner id in the params hash to the new owner id so when we do the update below, it'll add the new owner as the owner of the pet. 
    if !params[:owner][:name].empty?
      @owner = Owner.create(params[:owner])
      params[:pet][:owner_id] = @owner.id
    end

    @pet.update(params[:pet])

    redirect to "pets/#{@pet.id}"
  end
end