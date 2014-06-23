require 'spec_helper'

describe SC::API::GroupsController do
  include Rack::Test::Methods

  def body
    JSON.parse(last_response.body)
  end

  def same? e1, e2
    id1 = e1.is_a?(Hash) ? e1['id'] : e1.id.to_s
    id2 = e2.is_a?(Hash) ? e2['id'] : e2.id.to_s
    id1 == id2
  end

  def same! e1, e2
    same?(e1, e2).should be true
  end

  def app
    SC::API::GroupsController
  end

  describe "/" do

    it "should be successful" do
      get "/"
      last_response.status.should be 200
    end

    describe 'filtering' do

      context 'there are no filters' do

        before do
          create :group
          create :group
          get '/'
        end

        it 'should return array of all groups' do
          body.length.should be 2
        end
      end

      context 'there is a keywords filter' do

        before do
          @group = create :group, name: 'foo bar', description: 'bat baz'
        end

        it 'should return an group that matches in the name' do
          get "/?keywords=foo"
          body.length.should be 1
          same!(body.first, @group)
        end

        it ' should return an group that matches in the description' do
          get "/?keywords=baz"
          body.length.should be 1
          same!(body.first, @group)
        end
      end

      context 'there is a range filter' do

        before do
          @group = create :group, range: 'local'
        end

        it 'should return an group that has a matching price' do
          get "/?ranges[]=local"
          body.length.should be 1
          same!(body.first, @group)
        end
      end

      context 'there is a size filter' do

        before do
          @group = create :group, size: '1-10'
        end

        it 'should return an group that has a matching size' do
          get "/?sizes[]=1-10"
          body.length.should be 1
          same!(body.first, @group)
        end
      end

      context 'there are tag filters' do

        before do
          @group = create :group, tags: [ 'foo', 'bar', 'bat' ]
        end

        it 'should return an group with matching requred tag', :vcr do
          get "/?tags[foo]=require"
          body.length.should be 1
          same!(body.first, @group)
        end

        it 'should NOT return an group with matching rejected tag' do
          get "/?tags[foo]=reject"
          body.length.should be 0
        end

        it 'should not return an group with both required and rejected tag' do
          get "/?tags[foo]=require&tags[bar]=reject"
          body.length.should be 0
        end
      end

      context 'there is a geo filter' do

        before do
          @group1 = create :group_with_loc
          @group1.location.lng_lat = [ 0.1, -0.1 ]
          @group1.save
          @group2 = create :group_with_loc
          @group2.location.lng_lat = [ 40.1, -40.1 ]
          @group2.save
        end


        it 'should return an group that fits inside geo query' do
          get "/?geo[]=0.1&geo[]=-0.1&geo[]=1000"
          body.length.should be 1
        end

        it 'should not return an group outside of query' do
          get "/?geo[]=0.1&geo[]=-0.1&geo[]=10"
          body.length.should be 0
        end
      end

      context 'there is a key filter' do

        before do
          @group = create :group_with_loc
          @group.location.country = 'us'
          @group.save
        end

        it 'should return an group that matches basic key/value check' do
          get "/?keys[location.country]=us"
          body.length.should be 1
        end
      end
    end
  end

  describe "/:id" do

    before do
      @group = create :group
      get "/#{@group.id.to_s}"
    end

    it "should be successful" do
      last_response.status.should be 200
    end

    it "should return JSON" do
      last_response.headers['Content-Type'].should match /json/
    end

    describe 'response body' do

      it 'should be the requested group' do
        group = JSON.parse(last_response.body)
        group['id'].should be == @group.id.to_s
      end
    end
  end

  #describe "/:group_id/delete_link/:url_id" do
  #  before do
  #    @group = create :group_with_links
  #    @link = @group.links[0].id
  #    post "/#{@group.id.to_s}/delete_link/#{@link.to_s}"
  #  end

  #  it "should be successful" do
  #    last_response.status.should be 200
  #  end

  #  it "should return the link id" do
  #    link_id = JSON.parse(last_responce.body)
  #    link_id.should eq(@link.id)
  #  end
  #end
end

##=========================================================================##
## This file is part of EagleEye.                                          ##
##                                                                         ##
## EagleEye is Copyright 2014 Volary Foundation and Contributors           ##
##                                                                         ##
## EagleEye is free software: you can redistribute it and/or modify it     ##
## under the terms of the GNU Affero General Public License as published   ##
## by the Free Software Foundation, either version 3 of the License, or    ##
## at your option) any later version.                                      ##
##                                                                         ##
## EagleEye is distributed in the hope that it will be useful, but         ##
## WITHOUT ANY WARRANTY; without even the implied warranty of              ##
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU       ##
## Affero General Public License for more details.                         ##
##                                                                         ##
## You should have received a copy of the GNU Affero General Public        ##
## License along with EagleEye.  If not, see                               ##
## <http://www.gnu.org/licenses/>.                                         ##
##=========================================================================##
