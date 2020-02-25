# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Message.destroy_all
Fullfilment.destroy_all
Request.destroy_all
User.destroy_all

ActiveRecord::Base.connection.reset_pk_sequence!('users')
ActiveRecord::Base.connection.reset_pk_sequence!('requests')
ActiveRecord::Base.connection.reset_pk_sequence!('messages')
ActiveRecord::Base.connection.reset_pk_sequence!('fullfilments')

json = ActiveSupport::JSON.decode(File.read('./db/seed.json'))

json["users"].each do |u|
    # puts u.as_json
    user = User.new({
        firstName: u["firstName"],
        lastName: u["lastName"],  
        email: u["email"],  
        password: u["password"]  
    })
    user.save!
    
    path="./db/seed_assets/portraits/"
    filename=u["picture"] 
    user.picture.attach(io: File.open(path + filename), filename: filename, content_type: 'image/jpeg')
end
puts "-------------------------------------------"
puts "Created " + User.all.count.to_s + " users."
puts "-------------------------------------------"

json["requests"].each do |r|
    request=Request.new(r)
    request.save!
end
puts "Created " + Request.all.count.to_s + " requests."
puts "-------------------------------------------"

# json["fullfilments"].each do |f|
#     fullfilment=Fullfilment.new(f)
#     fullfilment.save!
# end
# puts "Created " + Fullfilment.all.count.to_s + " fullfilments."
# puts "-------------------------------------------"

# json["messages"].each do |m|
#     message=Message.new(m)
#     message.save!
# end
# puts "Created " + Message.all.count.to_s + " messages."
# puts "-------------------------------------------"