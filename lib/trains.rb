class Train
  attr_accessor(:name, :id, :type)

  define_method(:initialize) do |attributes|
    @name = attributes.fetch(:name)
    @id = attributes.fetch(:id)
    @type = attributes.fetch(:type)
  end

  define_singleton_method(:all) do
    returned_trains = DB.exec("SELECT * FROM trains;")
    trains = []
    returned_trains.each() do |train|
      name = train.fetch("name")
      id = train.fetch("id").to_i()
      type = train.fetch("type")
      trains.push(Train.new({:name => name, :id => id, :type => type}))
    end
    trains
  end

  define_method(:==) do |another_train|
    self.name().==(another_train.name()).&(self.id().==(another_train.id())).&(self.type().==(another_train.type()))
  end

  define_method(:save) do
    result = DB.exec("INSERT INTO trains (name, type) VALUES ('#{@name}', '#{@type}') RETURNING id;")
    @id = result.first().fetch("id").to_i()
  end

  define_singleton_method(:find) do |id|
    found_train = nil
    Train.all().each() do |train|
      if train.id().==(id)
        found_train = train
      end
    end
    found_train
  end

end
