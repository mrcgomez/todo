require 'sinatra'
require 'mongo'

# connecting to the database
client = Mongo::MongoClient.new # defaults to localhost:27017
db     = client['todo-db']
coll   = db['todo-collection']

# inserting documents
# 10.times { |i| coll.insert({ :count => i+1 }) }

# finding documents
puts "There are #{coll.count} total documents. Here they are:"
coll.find.each { |doc| puts doc.inspect }

# updating documents
coll.update({ :count => 5 }, { :count => 'foobar' })

# removing documents
# coll.remove({ :count => 8 })
# coll.remove

get '/'  do
	@todos = coll.find()
	erb :home
end

get '/new_todo'  do
	coll.insert({name: params[:name]})
	'added!'
end

get '/delete'  do
	coll.remove({_id: BSON::ObjectId(params[:id])})
	redirect '/'
end