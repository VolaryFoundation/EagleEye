
require 'spec_helper'

describe Group do

  before do
    @group = build :group
  end

  describe 'name' do

    it 'should require a name' do
      @group.name = nil
      @group.should_not be_valid
    end

    it 'should not have a unique name' do
      @group.save
      group = build :group, name: @group.name
      group.should be_valid
    end
  end

  describe 'size' do

    it 'should allow size ot be nil' do
      @group.size = nil
      @group.should be_valid
    end

    it 'should have a size that eqauls spcific options' do
      @group.size = 'something wrong'
      @group.should_not be_valid
    end
  end

  describe 'range' do

    it 'should have require a range' do
      @group.range = nil
      @group.should_not be_valid
    end

    it 'should be invalid if range is not in options' do
      @group.range = 'something wrong'
      @group.should_not be_valid
    end
  end

  describe 'status' do

    it "should have a default value of pending" do
      @group.status.should be == 'pending'
    end

    it 'should require a status' do
      @group.status = nil
      @group.should_not be_valid
    end

    it "should be invalid if an non-option is passed in" do
      @group.status = 'something wrong'
      @group.should_not be_valid
    end
  end

  describe 'location' do
    it 'should be able to have a location' do
      org = build :group_with_loc
      org.should be_valid
    end
  end

  describe 'link' do
    it 'should be able to have a link' do
      org = build :group_with_links
      org.should be_valid
    end
  end

  describe '.keywordize' do

    it 'should format a string as an array of keywords' do
      keywords = Group.keywordize('foo BAR')
      keywords.should be == [ 'foo', 'bar' ]
    end
  end

  describe '.generate_keywords' do

    it 'should assign keywordized name and description as .keywords array' do
      group = create :group, name: 'foo bar', description: 'bat baz'
      group.keywords.should include('foo', 'bar', 'bat', 'baz')
    end
  end

  describe 'claim a group' do

    before do
      @user = build(:user)
    end

    it 'should set pedding user when group is claimed' do
      @group.claim_group(@user)
      @group.pending_user.should eq(@user)
    end

    it 'should be able to approve a claim' do
      @group.claim_group(@user)
      @group.respond_to_claim('approve')
      @group.user.should eq(@user)
    end

    it 'should be able to reject a claim' do
      @group.claim_group(@user)
      @group.respond_to_claim('reject')
      @group.user.should be_nil
      @group.pending_user.should be_nil
    end

  end

  describe '.search' do

    before do
      @query = Group.build_query({
        keywords: 'Foo Bar',
        sizes: [ '1-10' ],
        ranges: [ 'local' ],
        tags: { a: 'require', b: 'reject', c: '' },
        geo: [ 0.1, -0.1, 1000 ],
        keys: { a: 1, b: 2 }
      })
    end

    describe 'keywords filter' do

      it "should include formatted array of keywords in query" do
        @query[:keywords].should be == { :$in => [ 'foo', 'bar' ] }
      end
    end

    describe 'sizes filter' do

      it 'should include sizes as part of $in array' do
        @query[:size].should be == { :$in => [ '1-10' ] }
      end
    end

    describe 'ranges filter' do

      it 'should include ranges as part of $in array' do
        @query[:range].should be == { :$in => [ 'local' ] }
      end
    end

    describe 'tags filters' do

      it 'shoudl show required and rejected tags' do
        @query[:tags].should be == { :$in => [ 'a' ], :$nin => [ 'b' ] }
      end
    end

    describe 'geo filter' do

      it 'should include complex geo query' do
        @query[:'location.lng_lat'].should be == { :$near => { :$geometry => { type: 'Point', coordinates: [ 0.1, -0.1 ] } }, :$maxDistance => 0.15696123057604772 }
      end
    end

    describe 'keys filter' do

      it 'should build query correctly' do
        @query[:a].should be 1
        @query[:b].should be 2
      end
    end

    describe 'url' do
      describe 'add' do
        it "should add a unquie link" do
          @group.links.count.should eq(0)
          @group.links << build(:link)
          @group.links.count.should eq(1)
        end
      end
      describe 'remove' do
        it 'should remove a link' do
          group = build :group_with_links
          link = group.links[0]
          count = group.links.count
          count.should > (0)
          group.links.delete_if{|l| l.id == link.id}
          group.links.count.should eq(count - 1)
        end
      end

    end
  end
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
