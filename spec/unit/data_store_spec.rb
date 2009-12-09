require File.expand_path("../../spec_helper", __FILE__)

describe "Friendly::DataStore" do
  before do
    @users     = DatasetFake.new(:insert => 42)
    @db        = DatabaseFake.new("users" => @users)
    @datastore = Friendly::DataStore.new(@db)
    @klass     = stub(:table_name => "users")
  end

  describe "inserting data" do
    before do
      @return = @datastore.insert(@klass, :name => "Stewie")
    end

    it "inserts it in to the table in the datastore" do
      @users.inserts.length.should == 1
      @users.inserts.should include(:name => "Stewie")
    end

    it "returns the id from the dataset" do
      @return.should == 42
    end
  end

  describe "retrieving all based on where conditions" do
    before do
      @users.where = {{:name => "Stewie"} => stub(:map => [{:id => 1}])}
      @return = @datastore.all(@klass, :name => "Stewie")
    end

    it "gets the data from the dataset for the klass and makes it an arary" do
      @return.should == [{:id => 1}]
    end
  end

  describe "retrieving first with conditions" do
    before do
      @users.first = {{:id => 1} => {:id => 1}}
      @return = @datastore.first(@klass, :id => 1)
    end

    it "gets the first object matching the conditions from the dataset" do
      @return.should == {:id => 1}
    end
  end

  describe "updating data" do
    before do
      @filtered    = DatasetFake.new(:update => true)
      @users.where = {{:id => 1} => @filtered}
      @return = @datastore.update(@klass, 1, :name => "Peter")
    end

    it "filter the dataset by id and update the filtered row" do
      @filtered.updates.length.should == 1
      @filtered.updates.should include(:name => "Peter")
    end
  end

  describe "deleting data" do
    before do
      @filtered = stub
      @filtered.stubs(:delete)
      @users.where = {{:id => 1} => @filtered}
      @datastore.delete(@klass, 1)
    end

    it "filters the dataset by id and deletes" do
      @filtered.should have_received(:delete)
    end
  end
end

