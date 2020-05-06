require 'rails_helper'

describe 'directories routes' do

  it 'should route to directories index' do
    expect(get '/directories').to route_to('directories#index')
  end

  it 'should route to directories create' do
    expect(post '/directories').to route_to('directories#create')
  end

  it 'should route to directories show' do
    expect(get '/directories/1').to route_to('directories#show', id: '1')
  end

  it 'should route to directories update' do
    expect(put '/directories/1').to route_to('directories#update', id: '1')
    expect(patch '/directories/1').to route_to('directories#update', id: '1')
  end

  it 'should route to directories destroy' do
    expect(delete '/directories/1').to route_to('directories#destroy', id: '1')
  end
end