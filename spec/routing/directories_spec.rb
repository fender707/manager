require 'rails_helper'

describe 'directories routes' do

  it 'should route to directories index' do
    expect(get '/directories').to route_to('directories#index')
  end

  it 'should route to directories show' do
    expect(get '/directories/1').to route_to('directories#show', id: '1')
  end
end