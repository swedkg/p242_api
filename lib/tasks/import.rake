namespace :import do
  desc "import requests"
  task requests: :environment do
    list = JSON.parse(File.read('./lib/assets/requests.json'))
    list.each do |request|
      Request.create(request.to_h)
    end
  end
  
  desc "import users"
  task users: :environment do
    list = JSON.parse(File.read('./lib/assets/users.json'))
    list.each do |user|
    User.create(user.to_h)
    end
  end

end
